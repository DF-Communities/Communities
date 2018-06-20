global class DF_Mail_ChampCloseSession_Batcher implements Database.Batchable<SObject>, Database.Stateful, Schedulable{

/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Email to converted Champions who have not closed information Session in 14 days
                        of event date, sent by RSO
***********************************************************************************************/

   public string query;
  
   public Id OW = Mail_Utils.getOrgWideEmail();
   public string templateName{get;set;}
   public Integer days {get;set;}
   
        global void execute( SchedulableContext SC )
        {
          // batch run 
          DF_Mail_ChampCloseSession_Batcher batch = new DF_Mail_ChampCloseSession_Batcher();
          batch.days = -14;
          Database.executeBatch( batch, 1 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
          Date dt = System.today().addDays( days );
          Date d =date.newinstance(dT.year(), dT.month(), dT.day());
          
          Id rt = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);

          system.debug('++date returned++'+d);
          system.debug('++recordtype returned++'+rt); 
            String query = 
                'Select Id,' +
                'Portal_Contact__c' +
                ' From ' +
                'DF_Contact__c ' +
                'Where RecordtypeId=: rt '+
                'and Type_of_Champion__c excludes (\'VIP\')' +
                'and Status__c = \'' + DF_Utils.STATUS_CONVERTED +'\' ' +             
                'and id in '+
                '('+
                'select Session_Organiser__c from DF_Event__c where RecordType.DeveloperName = \'' + DF_Utils.RT_FRIENDS_SESSION +'\' ' +  
                'and Event_Status__c not in(\'Cancelled\',\'Completed\',\'Closed\')'+
                'and Event_Date__c =: d '+
                ')';
       
                
                
    
            system.debug('+++Query+++'+ query);

            return Database.getQueryLocator(query);
        
        }

        global void execute(Database.BatchableContext BC, List<SObject> scope)
        {
         
         List<Messaging.SingleEmailMessage> lisEmails = new List<Messaging.SingleEmailMessage>();

         for ( sObject s : scope ) {                   
           DF_Contact__c  con = (DF_Contact__c)s;           
           Map<String, EmailTemplate> mapTemp= Mail_Utils.getemailTemplateMap();
           templateName= (mapTemp.get(templatename).DeveloperName);
           lisEmails.add(Mail_Utils.getTemplatedEmail(templateName, con.Portal_Contact__c, con.id, OW, true, null));
          }

          if ( lisEmails.size() > 0 ) { Messaging.sendEmail(lisEmails); }

        }


        global void finish(Database.BatchableContext BC)
        {
          // do something interesting
        }
  }