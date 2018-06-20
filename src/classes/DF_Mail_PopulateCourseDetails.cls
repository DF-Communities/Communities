public with sharing class DF_Mail_PopulateCourseDetails {

   public ID dfcontactID{get; set;}
   public Double offset{get; set;}

  
   public DF_EventAttendee__c CourseDetails{
    get{
    system.debug('++DFContact ID '+ dfcontactID);
    List <DF_EventAttendee__c> events ;
    DF_EventAttendee__c event;
    Date dt = System.today().addDays(2);
    Date d  = date.newinstance(dT.year(), dT.month(), dT.day());
        
    Id rt =  DF_Utils.getDfEventRecordTypeId(DF_Utils.RT_CHAMPION_COURSE);
    events= [select DF_Event__r.name,DF_Event__r.Event_Date_Time__c,DF_Event__r.Event_End_Date_Time__c,DF_Event__r.Street__c,DF_Event__r.City__c,DF_Event__r.Postcode__c,DF_Event__r.County__c   from DF_EventAttendee__c where DF_Contact__c =: dfcontactID  
    and EventAttendeeStatus__c = null  and DF_event__c in (select id from DF_Event__c where recordtypeid=:rt and Event_date__c =:d and Event_Status__c in ('Available','Full') )order by DF_Event__r.Event_Date__c desc limit 1];
    if(events.size()>0){
    
    event = (DF_EventAttendee__c)events[0];
    
    // This should set the course time using an offet relevant for the time of the course
    TimeZone tz = UserInfo.getTimeZone();
    offset =     tz.getOffset(event.DF_Event__r.Event_End_Date_Time__c) / (1000 * 3600 * 24.0);
    //offset = DF_Utils.offset;
    
    }
    return event;}
    set;
    }
  
    
}