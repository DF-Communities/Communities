Global class DF_Mail_CourseReminder implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     automated email to everyone who has booked on Champions training 48 hours before the course starts
***********************************************************************************************/

   public string query;
  
   public Id OW = Mail_Utils.getOrgWideEmail();
   public string templateName { get;set;}
   
        global void execute( SchedulableContext SC ) 
        {
          // batch run 
          DF_Mail_CourseReminder batch = new DF_Mail_CourseReminder();
          batch.templatename = DF_Mail_Utils.VF_DFC_COURSE_REMINDER;
          Database.executeBatch( batch, 1 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
          Date dt= System.today().addDays(2);
          Date d =date.newinstance(dT.year(), dT.month(), dT.day());
          
          Id rt =  DF_Utils.getDfEventRecordTypeId(DF_Utils.RT_CHAMPION_COURSE);
          
           
            String query = 
                'Select DF_Contact__r.Id, ' +
                'DF_Contact__r.Portal_Contact__c,' +
                'DF_Contact__c ' +
                ' From ' +
                'DF_EventAttendee__c ' +
                'Where EventAttendeeStatus__c = null ' +
                ' and  DF_Event__c in  '+
                ' ( Select id from DF_Event__c '+
                ' where RecordtypeId =: rt '+
                ' and Event_Status__c in (\'Available\',\'Full\')' +             
                ' and Event_Date__C = : d )';
                
                
    
            system.debug('+++Query+++'+ query);

            return Database.getQueryLocator(query);
        }

        global void execute(Database.BatchableContext BC, List<SObject> scope) {
        
          set<Id> dfContactId =new Set <Id>();
          List<DF_Contact__c> dfcon = new List <DF_Contact__c>();
        
          Map<String, EmailTemplate> mapTemp= Mail_Utils.getemailTemplateMap();
          templateName= (mapTemp.get(templateName).DeveloperName);                   
          List<Messaging.SingleEmailMessage> lisEmails = new List<Messaging.SingleEmailMessage>();

          for ( sObject s : scope ) {
            DF_EventAttendee__c  eAtt = (DF_EventAttendee__c)s;           
            dfContactId.add(eAtt.DF_Contact__c);          
          }
           
          dfcon = [ select id , Portal_Contact__c from DF_Contact__c where id IN : dfContactId ];
           
          for ( DF_Contact__c con : dfcon){
           
             lisEmails.add(Mail_Utils.getTemplatedEmail(templateName, con.Portal_Contact__c, con.id, OW, true, null));
           
           }

           if ( lisEmails.size() > 0 ) { Messaging.sendEmail(lisEmails); }

        }
        
        global void finish(Database.BatchableContext BC)
        
        {
          // do something interesting
        }
    }