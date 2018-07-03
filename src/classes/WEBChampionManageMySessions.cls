/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBChampionManageMySessions.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBChampionManageMySessions page.
 *               
 *  Modification History
 *  Date            Who         Description 
 *    09/01         LV          added nonOfFriends variable
*******************************************************************************************/
public without sharing class WEBChampionManageMySessions extends DF_WEBC_ControllerBase {
    
    public final String STATUS_AVAILABLE = 'Available';
    public final String STATUS_CANCELLED = 'Cancelled';
    public final String STATUS_FULL = 'Full';
    public static final String SESSION_RT = 'Dementia_Friend_Awareness_Session';

    public string noOfFriends {get;set;}
    public List<DF_Event__c> upcomingEvents {
        get {
            if (upcomingEvents == null)
                upcomingEvents = new List<DF_EVENT__c>();
            
            return upcomingEvents;
        }
        set;
    }

    public List<DF_Event__c> pastEvents {
        get {
            if (pastEvents == null)
                pastEvents = new List<DF_EVENT__c>();
            
            return pastEvents;
        }
        set;
    }

    public List<DF_Event__c> eventsRequiringFeedback {
        get {
            if (eventsRequiringFeedback == null)
                eventsRequiringFeedback = new List<DF_EVENT__c>();
            
            return eventsRequiringFeedback;
        }
        set;
    }
        
    public List<DF_Event__c> unapprovedEvents {
        get {
            if (unapprovedEvents == null)
                unapprovedEvents = new List<DF_EVENT__c>();
            
            return unapprovedEvents;
        }
        set;
    }

    public Integer noUpcomingEvents {get;set;}
    public Integer noPastEvents {get;set;}
    public Integer noEventsRequiringFeedback {get;set;}
    
    

    public Boolean isChampion {get;set;}
    public Boolean isChampionConverted {get; set;}
    public Boolean isChampionRetired {get; set;}
    public Boolean isChampionHiatus {get; set;}
    
    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}
    public Boolean infoSessionUpdated {get;set;}
    public Boolean sessionDropped {get;set;}

    public Page_Snippet__c totalFriendsSnippet {
        get {
            if (totalFriendsSnippet == null){
                totalFriendsSnippet = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'DementiaFriendsTotalSnippet' LIMIT 1];
            }
            return totalFriendsSnippet;
        }
        set ;
    }
    
     public Double offset {get; set;}
     
    
    //Constructor
    public WEBChampionManageMySessions() {

        System.debug('*** WEBChampionManageMySessions : Checking User');

        isChampion = DF_Utils.isChampion(currentDfc);
        isChampionConverted = DF_Utils.isChampionConverted(currentDfc);
        isChampionRetired= DF_Utils.isChampionRetired(currentDfc);
        isChampionHiatus = DF_Utils.isChampionHiatus(currentDfc);
        
        if (ApexPages.currentPage().getParameters().get('infoSessionUpdated') == 'true') {
            infoSessionUpdated = true;
        } else {
            infoSessionUpdated = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('sessionDropped') == 'true') {
            sessionDropped = true;
        } else {
            sessionDropped = false;
        }
        
        noPastEvents = 0;
        noUpcomingEvents = 0;
        noEventsRequiringFeedback = 0;
        offset = DF_Utils.offset;
        System.debug('*** WEBChampionManageMySessions : User Champion ' + isChampion);
		
        
        if (currentDfc != null && isChampion) {
            // +++ EVENT SELECTIONS FOR CHAMPIONS +++

            String sdt = Datetime.now().format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getDisplayName());
            Datetime dt = Datetime.valueOf(sdt);
            eventsRequiringFeedback = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c 
                                       FROM DF_Event__c 
                                       WHERE Event_Status__c != 'Cancelled' 
                                       AND Session_Organiser__c = : currentDfc.Id 
                                       AND Event_End_Date_Time__c <: dt 
                                       AND (Number_of_Attendees__c = null OR Number_of_Attendees__c = 0) 
                                       And RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                                       ORDER BY Event_Date_Time__c DESC];
            
            upcomingEvents = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c 
                              FROM DF_Event__c 
                              WHERE Session_Organiser__c = :currentDfc.Id 
                              AND Event_End_Date_Time__c >=: dt 
                              AND Event_Status__c != :STATUS_CANCELLED 
                              AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                              ORDER BY Event_Date_Time__c DESC];
            
            pastEvents = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c 
                          FROM DF_Event__c 
                          WHERE Session_Organiser__c = :currentDfc.Id 
                          AND Event_End_Date_Time__c <:dt 
                          AND Number_of_Attendees__c > 0 
                          AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                          ORDER BY Event_Date_Time__c DESC];
        
        } else if (currentDfc != null && !isChampion) {
            // +++ EVENT SELECTIONS FOR FRIENDS +++

            String sdt = Datetime.now().format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getDisplayName());
            Datetime dt = Datetime.valueOf(sdt);
            unapprovedEvents = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c 
                                FROM DF_Event__c 
                                WHERE Event_Status__c != 'Not Live / Approved' 
                                AND Session_Requester__c = : currentDfc.Id 
                                AND Event_End_Date_Time__c <: dt 
                                And RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                                ORDER BY Event_Date_Time__c DESC];
            
            eventsRequiringFeedback = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c 
                                       FROM DF_Event__c 
                                       WHERE Event_Status__c != 'Cancelled' 
                                       AND Session_Requester__c = : currentDfc.Id 
                                       AND Event_End_Date_Time__c <: dt 
                                       AND (Number_of_Attendees__c = null OR Number_of_Attendees__c = 0) 
                                       And RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                                       ORDER BY Event_Date_Time__c DESC];
            
            upcomingEvents = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c 
                              FROM DF_Event__c 
                              WHERE Session_Requester__c = :currentDfc.Id 
                              AND Event_End_Date_Time__c >=: dt 
                              AND Event_Status__c != :STATUS_CANCELLED 
                              AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                              ORDER BY Event_Date_Time__c DESC];
            
            pastEvents = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c 
                          FROM DF_Event__c 
                          WHERE Session_Requester__c = :currentDfc.Id 
                          AND Event_End_Date_Time__c <:dt 
                          AND Number_of_Attendees__c > 0 
                          AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                          ORDER BY Event_Date_Time__c DESC];
        }

        if (eventsRequiringFeedback != null){
            noEventsRequiringFeedback = eventsRequiringFeedback.size();
        }
        
        if (pastEvents != null){
            noPastEvents = pastEvents.size();
        }
        
        if (upcomingEvents != null) {
            noUpcomingEvents = upcomingEvents.size();
        }

        if (ApexPages.currentPage().getParameters().get('eventshare') != null){
        
            noOfFriends = ApexPages.currentPage().getParameters().get('eventshare');    
        
        }
    }
}