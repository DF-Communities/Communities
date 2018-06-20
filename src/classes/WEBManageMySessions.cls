/******************************************************************************************
*  Cloud Symphony
*  
*  Purpose : APEX controller class for VF Page WEBManageMySessions.
*  Author  : CSL
*  Date    : 27-02-2014
*  Version : 1.0
*
*  Description:    Apex Class controller for the WEBManageMySessions page.
*               
*  Modification History
*  Date            Who         Description 
*    09/01         LV          added nonOfFriends variable
*******************************************************************************************/
public without sharing class WEBManageMySessions extends DF_WEBC_ControllerBase {
    
    /*public final String STATUS_AVAILABLE = 'Available';
public final String STATUS_CANCELLED = 'Cancelled';
public final String STATUS_FULL = 'Full';
public static final String SESSION_RT = 'Dementia_Friend_Awareness_Session'; // TODO REM<OVE*/
    public string noOfFriends {get;set;}
    
    public List<DF_Event__c> upcomingRequestedEvents {
        get {
            if (upcomingRequestedEvents == null)
                upcomingRequestedEvents = new List<DF_EVENT__c>();
            
            return upcomingRequestedEvents;
        }
        set;
    }
    
    public List<DF_Event__c> pastRequestedEvents {
        get {
            if (pastRequestedEvents == null)
                pastRequestedEvents = new List<DF_EVENT__c>();
            
            return pastRequestedEvents;
        }
        set;
    }
    
    public List<DF_Event__c> requestedEventsRequiringFeedback {
        get {
            if (requestedEventsRequiringFeedback == null)
                requestedEventsRequiringFeedback = new List<DF_EVENT__c>();
            
            return requestedEventsRequiringFeedback;
        }
        set;
    }
    
    public List<DF_Event__c> unapprovedRequestedEvents {
        get {
            if (unapprovedRequestedEvents == null)
                unapprovedRequestedEvents = new List<DF_EVENT__c>();
            
            return unapprovedRequestedEvents;
        }
        set;
    }
    
    public List<DF_Event__c> upcomingCreatedEvents {
        get {
            if (upcomingCreatedEvents == null)
                upcomingCreatedEvents = new List<DF_EVENT__c>();
            
            return upcomingCreatedEvents;
        }
        set;
    }
    
    public List<DF_Event__c> pastCreatedEvents {
        get {
            if (pastCreatedEvents == null)
                pastCreatedEvents = new List<DF_EVENT__c>();
            
            return pastCreatedEvents;
        }
        set;
    }
    
    public List<DF_Event__c> createdEventsRequiringFeedback {
        get {
            if (createdEventsRequiringFeedback == null)
                createdEventsRequiringFeedback = new List<DF_EVENT__c>();
            
            return createdEventsRequiringFeedback;
        }
        set;
    }
    
    /*public Integer noUpcomingCreatedEvents {get;set;}
    public Integer noPastCreatedEvents {get;set;}
    public Integer noCreatedEventsRequiringFeedback {get;set;}
    public Integer noUpcomingRequestedEvents {get;set;}
    public Integer noPastRequestedEvents {get;set;}
    public Integer noRequestedEventsRequiringFeedback {get;set;}*/
    
    public Boolean isChampion {get;set;}
    public Boolean isChampionConverted {get; set;}
    public Boolean isChampionRetired {get; set;}
    public Boolean isChampionHiatus {get; set;}
    public Boolean isSessionRequester {get; set;}
    public Id placeholderOrganiserId {get; set;}
    public Boolean hasRequestedSessions {get;set;}
    
    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}
    public Boolean infoSessionUpdated {get;set;}
    
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
    public Boolean sessionDropped {get;set;}
    
    //Constructor
    public WEBManageMySessions() {
               
        isChampion = DF_Utils.isChampion(currentDfc);
        isChampionConverted = DF_Utils.isChampionConverted(currentDfc);
        isChampionRetired= DF_Utils.isChampionRetired(currentDfc);
        isChampionHiatus = DF_Utils.isChampionHiatus(currentDfc);
        
        placeholderOrganiserId = [SELECT Name, Value__c 
                                  FROM Community_Settings__c 
                                  WHERE Name = 'DF_Placeholder_InfoSessionOrganiser'].Value__c;
        
        offset = DF_Utils.offset;
        
        // +++ URL PARAMETER INTERPRETATION FOR CHAMPIONS +++
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
        
        if (ApexPages.currentPage().getParameters().get('eventshare') != null){
            noOfFriends = ApexPages.currentPage().getParameters().get('eventshare');    
        }
        
        // +++ EVENT SELECTIONS FOR CHAMPIONS +++
        if (currentDfc != null && isChampion) {
            Map<String,List<DF_Event__c>> champCreatedSessionMap = DF_EventListingHelper.getCreatedSessions(currentDfc.Id);
            createdEventsRequiringFeedback = champCreatedSessionMap.get('eventsAwaitingFeedback');
            upcomingCreatedEvents = champCreatedSessionMap.get('upcomingEvents');
            pastCreatedEvents = champCreatedSessionMap.get('pastEvents');
                
            Map<String,List<DF_Event__c>> champRequestedSessionMap = DF_EventListingHelper.getRequestedSessions(true, true, currentDfc.Id);
            requestedEventsRequiringFeedback = champRequestedSessionMap.get('eventsAwaitingFeedback');
            upcomingRequestedEvents = champRequestedSessionMap.get('upcomingEvents');
            pastRequestedEvents = champRequestedSessionMap.get('pastEvents');
        } 
        
        // Determine if the champ has requested sessions
        if((requestedEventsRequiringFeedback.size() + upcomingRequestedEvents.size() + pastRequestedEvents.size()) > 0){
            hasRequestedSessions = true;
        } else {
            hasRequestedSessions = false;
        }
        
    }
}