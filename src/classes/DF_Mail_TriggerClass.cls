public with sharing class DF_Mail_TriggerClass {

 
  public static void EmailTriggers(List<DF_EventAttendee__c> inRecords){
   
   
  
    Map<Id, RecordType> rtMap = new Map<Id, RecordType>();
    Set<Id> dfEventIdSet = new Set<Id>();
    Set<Id> dfContactIdSet = new Set<Id>();
    Integer mailDuplicate;
    Id OW = Mail_Utils.getOrgWideEmail();
    string templateName;
    Id rtChamp=DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
    
    Map<String, EmailTemplate> mapTemplate= Mail_Utils.getEmailTemplateMap();

    for (DF_EventAttendee__c dfe : inRecords){
        dfEventIdSet.add(dfe.DF_Event__c);
        dfContactIdSet.add(dfe.DF_Contact__c);      
    }
    
    
    //Map<Id, DF_Event__c> dfEventMap = new Map<Id, DF_Event__c>([select d.Id, d.RecordTypeId, d.Event_Date_Time__c, d.Event_Status__c, d.Number_of_Attendees__c,d.Session_Organiser__c, d.Session_Organiser__r.Name, d.Session_Organiser__r.Portal_Contact__c from DF_Event__c d where d.Id in :dfEventIdSet]);
    Map<Id, DF_Contact__c> dfContactMap = new Map<Id, DF_Contact__c>([select d.Id,d.Type_of_Champion__c,d.name, d.Portal_Contact__c,d.Status__c,d.RecordtypeId from DF_Contact__c d where RecordtypeId =:rtChamp  and d.Id in :dfContactIdSet]);
  
    List<Task> lisTasks = [select whatid,id,DFC_email_tracker__c from Task where DFC_email_tracker__c !=null and whatid in:dfContactIdSet];
    
    //We need to loop through each DF_EventAttendee__c record and work out which emails need to be sent
    List<Messaging.SingleEmailMessage> lisToSend = new List<Messaging.SingleEmailMessage>();
    for (DF_EventAttendee__c dfe : inRecords){
    
      System.debug('all keys in the contactmap: ' + dfContactMap.keySet());
      
    //  DF_Event__c event = dfEventMap.get(dfe.DF_Event__c);
      DF_Contact__c con = dfContactMap.get(dfe.DF_Contact__c);
    
       system.debug('**********dfContactMap.size()**'+dfContactMap.size());  
      // system.debug('**********dfEventMap**'+dfEventMap.size()); 
       system.debug('**********contact return**'+ con);  
       system.debug('**********champ email sent**'+  mailDuplicate);  
       system.debug('**********event attendee status**'+dfe.EventAttendeeStatus__c);    
       
     
     if ( con == null ){ continue; } 
      
     system.debug('**********contact status**'+ con.Status__c);
            
     if(con.status__c== DF_Utils.STATUS_CONVERTED &&  dfe.EventAttendeeStatus__c == DF_Utils.ATTENDEE_STATUS_ATTENDED ) {
       /*
         1. Welcome email sent to new converted Champions (containing Champ code and RSO welcome) sent by RSO, triggered when event attendee list is updated in Salesforce.  
        TODO  Need to include the link to Champions survey based on RSO Area (CRM development work)
        TODO  Need to decide how codes are sent to Champions.  From our meeting we decided that a new field would be added to the �Update attendee status� area which would include a picklist/drop down of the different codes available to new Champions.  Admin can then select the code which appears in the email.
      */
      system.debug('**********enter check***');  

      if( !DF_Mail_Utils.isDuplicateEmail(con, Df_Mail_Utils.DF_WELCOME_EMAIL, lisTasks) ) {                 

           templateName= (mapTemplate.get(DF_Mail_Utils.VF_CHAMPION_WELCOME).DeveloperName);
           lisToSend.add(Mail_Utils.getTemplatedEmail(templateName, con.Portal_Contact__c, con.Id, OW, true, null));

      }     


    }
     
    if(con.Type_of_Champion__c<>null && con.Type_of_Champion__c.contains( DF_Utils.CHAMPION_TYPE_SUPER) ){
      /*
        Offer to be a Super Champ email to converted �Super� champions after completion of training, 
        triggered by event list update, sent from trainer. Should still receive email 1 to introduce them to their RSO.
      */
      
       system.debug('**********not already sent TEREF02***'); 
      
       if( !DF_Mail_Utils.isDuplicateEmail(con , Df_Mail_Utils.DF_SUPERCHAMP_EMAIL, lisTasks) ){       
       
          templateName= (mapTemplate.get(DF_Mail_Utils.VF_SUPER_CHAMPION).DeveloperName);
          lisToSend.add(Mail_Utils.getTemplatedEmail(templateName, con.Portal_Contact__c, con.Id, OW, true, null));       
       
       }
     
    }
     
     if(con.status__c == DF_Utils.STATUS_PROSPECTIVE &&  dfe.EventAttendeeStatus__c == DF_Utils.ATTENDEE_STATUS_NOSHOW  ){
     
        // Email to prospective Champions who have booked on training but not attended, sent by the Administrator
      
        if( !DF_Mail_Utils.isDuplicateEmail(con , Df_Mail_Utils.DF_PROSNOTATTENDED_EMAIL, lisTasks) ){
         
          system.debug('**********not already sent TEREF03***');       
          templateName= (mapTemplate.get(DF_Mail_Utils.VF_TRAINING_NOTATTENDED).DeveloperName);
          lisToSend.add(Mail_Utils.getTemplatedEmail(templateName, con.Portal_Contact__c, con.Id, OW, true, null));         
        
        }
     
     
     }
     
  
   }
  
   Messaging.sendEmail(lisToSend);

  
  } 

}