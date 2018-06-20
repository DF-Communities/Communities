global class DF_Mail_ChampNoSessions_Batcher implements Database.Batchable<SObject>, Database.Stateful, Schedulable{


  /*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            31-07-2015
     * @description      Email to converted Champions who have entered their code and not run an 
     Information Session for 2 months from their last Session sent by RSO   
***********************************************************************************************/
   public string query;
  
   public Id OW = Mail_Utils.getOrgWideEmail();
   public string templateName{get;set;}
   public integer days{get;set;}
   public String newStatus {get;set;}
   
   
        global void execute( SchedulableContext SC )
        {
          // batch run 
          DF_Mail_ChampNoSessions_Batcher batch = new DF_Mail_ChampNoSessions_Batcher();
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
                'Latest_Friends_Session_Date__c != null '+
                'and  Code_Verefied__c = True '+
                'and Status__c = \'' + DF_Utils.STATUS_CONVERTED +'\'' + 
                'and Type_of_Champion__c excludes (\'VIP\')' +            
                'and id in '+
                '('+
                'select Session_Organiser__c from DF_Event__c where RecordType.DeveloperName = \'' + DF_Utils.RT_FRIENDS_SESSION +'\'' + 
                'and Event_Date__c =: d '+
                'and Is_Last_Event__c = True '+                
                ')';
                
                
    
            system.debug('+++Query+++'+ query); 

            return Database.getQueryLocator(query);
        }

        global void execute(Database.BatchableContext BC, List<SObject> scope)
        {
           
           Map<String, EmailTemplate> mapTemp= Mail_Utils.getemailTemplateMap();
           templateName= (mapTemp.get(templatename).DeveloperName);                        
           
           List<DF_Contact__c> dfconstatus = new List <DF_Contact__c>();
           List<Messaging.SingleEmailMessage> lisEmails = new List<Messaging.SingleEmailMessage>();
                  
          for ( sObject s : scope ) {        
          
            DF_Contact__c  con = (DF_Contact__c)s;           
            lisEmails.add(Mail_Utils.getTemplatedEmail(templateName, con.Portal_Contact__c, con.id, OW, true, null));
          
            if ( newStatus!=null ) {                
                con.Status__c =newStatus;
                dfconstatus.add(con);                
            }
          
          }
          
          if ( dfconstatus.size()>0 ) { update dfconstatus; }
          if ( lisEmails.size() > 0 ) { Messaging.sendEmail(lisEmails); }

        }

        global void finish(Database.BatchableContext BC)
        {
          // do something interesting
        }
    }