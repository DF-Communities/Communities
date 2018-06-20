public without sharing class GetTrainingCourseDetail {

   
    public Id DFContactId { get; set; }
    
    
    public List<DF_EventAttendee__c> eventdetails{
    get{
    system.debug('++DFContact ID '+ dfcontactID);
    List<DF_EventAttendee__c> event ;
    system.debug('++survey url++'+dfcontactID);
    event= [select Id,DF_Event__r.name,DF_Event__r.Event_Date_Time__c  from DF_EventAttendee__c where DF_Contact__c =: dfcontactID  and EventAttendeeStatus__c not in ( 'Attended','Cancelled') 
    and event_record_type__c = 'Champion_Training_Course' limit 1];
    return event;}
    set;
    }
    
}