Global class DF_Mail_NeverRunSession_Batcher implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

/*    
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            31-07-2015
     * @description     Email to converted Champions who have entered their code and there is no record of them running a session, 
                        TODO sent by RSO one month after training. 
***********************************************************************************************/

   public string query;
   public Id OW = Mail_Utils.getOrgWideEmail(); 
   public string templateName {get;set;}
   public Integer days {get;set;}
   
    
        global void execute( SchedulableContext SC )
        {
          // batch run 
          DF_Mail_NeverRunSession_Batcher batch = new DF_Mail_NeverRunSession_Batcher();
          Database.executeBatch( batch, 1 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
          Date dt = System.today().addDays( days );
          Date d =date.newinstance(dT.year(), dT.month(), dT.day());
          system.debug('++date returned++'+d);
           
            String query = 
                'Select Id, ' +
                'Portal_Contact__c' +
                ' From ' +
                'DF_Contact__c ' +
                ' Where ' +
                'Type_of_Champion__c excludes (\'VIP\')' +
                'and Status__c = \'' + DF_Utils.STATUS_CONVERTED +'\'' +             
                'and Latest_Friends_Session_Date__c = null '+
                'and Date_of_Champion_Training__c =: d '+
                'and Date_of_Champion_Training__c != null' ;
                
                
    
            system.debug('+++Query+++'+ query);

            return Database.getQueryLocator(query);
        }


        global void execute(Database.BatchableContext BC, List<SObject> scope)
        {
        
          List<DF_Contact__c> dfcon = new List <DF_Contact__c>();
          List<DF_Contact__c> listoUpdate = new List <DF_Contact__c>();
          Map<String, EmailTemplate> mapTemp= Mail_Utils.getemailTemplateMap();
          
          templateName= (mapTemp.get(templateName).DeveloperName);  
          List<Messaging.SingleEmailMessage> lisEmails = new List<Messaging.SingleEmailMessage>();                 
          
          for ( sObject s : scope ) {
             DF_Contact__c  c = (DF_Contact__c)s;           
             dfcon.add(c);
          }
             
          for (DF_Contact__c con:dfcon){
             
            system.debug('+++batch executing+++'+ con.id);
            lisEmails.add(Mail_Utils.getTemplatedEmail(templateName, con.Portal_Contact__c, con.id, OW, true, null));           
            if(days==-120){

              con.Status__c = 'Retired';
              listoUpdate.add(con);
            }
          }
          
          if ( lisEmails.size() > 0 ) { Messaging.sendEmail(lisEmails); }
          if ( listoUpdate.size()>0 ) { update listoUpdate;}

        }


        global void finish(Database.BatchableContext BC)
        {
          // do something interesting
        }
    }