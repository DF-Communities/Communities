global class DF_Mail_ActivateChamp_Batcher implements Database.Batchable<SObject>, Database.Stateful, Schedulable

 // Email to converted Champions who have not entered their code yet, sent by RSO, trigger is 2 weeks after training.

    {
   public string query;
  // public static final String VF_CHAMPCODENOTENTERED = 'TEREF04activatechampacc';
   public Id OW = Mail_Utils.getOrgWideEmail();
   public string templateName;
   public integer days;
   
        global void execute( SchedulableContext SC )
        {
          // batch run 
         DF_Mail_ActivateChamp_Batcher batch = new DF_Mail_ActivateChamp_Batcher();
          Database.executeBatch( batch, 1 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
            Date dt = System.today().addDays( days );
            Date d =date.newinstance(dT.year(), dT.month(), dT.day());
           system.debug('+++Date+++'+ d);
           
            String query = 
                'Select Id, ' +
                'DF_Event__r.name ,' +
                'DF_Contact__c'+
                ' From ' +
                'DF_Eventattendee__c ' +
                ' Where ' +
                'EventAttendeeStatus__c = \'' + DF_Utils.ATTENDEE_STATUS_ATTENDED+'\''   +
                ' and DF_Contact__c in '+
                '( select id from DF_Contact__c '+
                ' Where '+
                ' Code_Verefied__c = False '+
                'and Status__c = \'' + DF_Utils.STATUS_CONVERTED +'\'' +
                ' and Type_of_Champion__c excludes (\'VIP\')' +
                ')' +
                'and DF_Event__c  in'+
                ' ( select id from DF_Event__c'+
                ' Where '+                
                ' RecordType.DeveloperName =  \'' + DF_Utils.RT_CHAMPION_COURSE+'\'' +
                ' and Event_Date__c =:d )' ;
    
            system.debug('+++Query+++'+ query);

            return Database.getQueryLocator(query);
        }

        global void execute(Database.BatchableContext BC, List<SObject> scope) {
        
            Set<Id> ContactIdSet = new Set<Id>();  
            for ( sObject s : scope ) {                
              DF_Eventattendee__c  att = (DF_Eventattendee__c)s;
              ContactIdSet.add(att .DF_Contact__c);          
            }
          
            List<Messaging.SingleEmailMessage> lisEmails = new List<Messaging.SingleEmailMessage>();

            List <DF_Contact__c> liscon = [select id,Portal_Contact__c from DF_Contact__c where id in:ContactIdSet];
            for (DF_Contact__c con :liscon){
                     
              Map<String, EmailTemplate> mapTemp= Mail_Utils.getemailTemplateMap();
              templateName= (mapTemp.get(DF_Mail_Utils.VF_ACTIVATE_CHAMP).DeveloperName);
              lisEmails.add(Mail_Utils.getTemplatedEmail(templateName, con.Portal_Contact__c, con.id, OW, true, null));
           
             }
           
             if ( lisEmails.size() > 0 ) { Messaging.sendEmail(lisEmails); }


        }
        

        global void finish(Database.BatchableContext BC)
        {
          // do something interesting
        }
    }