public class DF_Mail_PopulateSurveyURL {

   public String something {get; set;}
   public ID dfcontactID{get; set;}
   
   public DF_EventAttendee__c Attendees{
    get{
    system.debug('++DFContact ID '+ dfcontactID);
    List <DF_EventAttendee__c> attendees ;
    DF_EventAttendee__c attendee;
    system.debug('++survey url++'+dfcontactID);
    attendees= [select Id,DF_Event__r.RSO__r.Survey_URL__c  from DF_EventAttendee__c where DF_Contact__c =: dfcontactID  and EventAttendeeStatus__c = 'Attended'  limit 1];
     if(attendees.size()>0){
    
    attendee = attendees[0];
    }
    return attendee;}
    set;
    }
  
    
}