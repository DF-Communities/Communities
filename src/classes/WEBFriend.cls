/******************************************************************************************
*  Cloud Symphony
*  
*  Purpose : APEX class for the WEBFriend VF Page
*            
*  Author  : CSL
*  Date    : 27-02-2014 
*  Version : 1.0
*
*  Description:    WEBFriend class holds methods and properties used in the
*                  WEBFriend VF Page   
*               
*  Modification History
*  Date            Who         Description 
*  March 2015      Gary        hasWatchedVideo          
*******************************************************************************************/
public without sharing class WEBFriend extends DF_WEBC_ControllerBase {
    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    
    public final String REGISTER = 'Register for an Information Session';
    public final String REGISTERED = 'You have registered for a Dementia Friend session';
    public final String SESSION_CODE = 'Enter your Session Code :';
    public final String SESSION_CODE_ENTERED = 'You have entered your Session Code';
    public final String ACTION = 'Tell us about your action';
    public final String ACTION_ENTERED = 'You\'ve created an action';
    public final String RT_CHAMPION_COURSE = 'Champion_Training_Course';
    public final String RT_FRIENDSHIP_SESSION = 'Dementia_Friend_Awareness_Session';
    public final String ALERT_ERROR_CLASS = 'alert-danger';
    public final String INVALID_FRIEND_CODE = 'The Friends\' code you entered was not recognised. Please try again.';
    
    public final String SUCCESSFULLY_CONVERTED = 'You have successfully converted to a Dementia Friend.';
    public boolean orgRegisterSuccess {get;set;}
    public static Boolean showInfoSessionRequestForm {get;set;}
    
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
            
    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}
    
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
    
    public User thisUser {
        get {
            return WEBController.thisUser; 
        }
        set;
    }
    
    public List<DF_Contact_Inbound_Change__c> contactDetailsChanged {
        get {
            if (contactDetailsChanged == null){
                contactDetailsChanged = new List<DF_Contact_Inbound_Change__c>();
            }
            return contactDetailsChanged;
        }
        set;
    }
    
    public String sessionCode {get;set;}
    public String sessionCodeError {get;set;}
    
    public Boolean isMember {get;set;}
    public Boolean isFriend {get;set;}
    public Boolean isDigitalFriend {get;set;}
    public Boolean isFriendConverted {get; set;}
        
    public boolean isSession {get; set;}
    public boolean isTraining {get; set;}
    
    public Boolean hasActions {get;set;}
    public Boolean hasRegisteredForSession {get;set;}
    public Boolean hasSessionCode {get;set;}
    
    public String registerText {get;set;}
    public String sessionCodeText {get;set;}
    public String actionText {get;set;}
    
    public Boolean registeredAsFriend {get;set;}
    public Boolean showViewDetailsButton {get; set;}
    public boolean showSaveConfirmation {get; set;}
    public boolean showUnbookedConfirmation {get; set;}
    public boolean showbookedConfirmation {get; set;}
    public Boolean showChangeDetailsPrompt {get; set;}
    
    public String showActionText {get; set;}
    public boolean showAction {get; set;}
    
   
    
    public List<DF_EventAttendee__c> events {get; set;}
    public List<Action__c> actions {get; set;}
    public Action__c theAction {get; set;}
    public DF_Contact__c dfc{get;set;}
    public Map<Id, RecordType> rtMap {get; set;}
    public Map<String, RecordType> rtMapByName {get; set;}
    
    public PageReference registerCode() {
        
        messageArea = null;
        messageAreaClass = null;
        PageReference pr;
        pr= Page.WEBFriend;
        pr.setRedirect(true);
        
        if (sessionCode.length() == 0) {
            messageArea = INVALID_FRIEND_CODE;
            messageAreaClass = ALERT_ERROR_CLASS;
            return null;
        }
        
        if (sessionCode != WEBGlobalSettings.friendConvertCode) {
            
            messageArea = INVALID_FRIEND_CODE;
            messageAreaClass = ALERT_ERROR_CLASS;
            return null;
            
        }
        
        String sConvertMessage = dfcW.confirmFriend(sessionCode);
        
        if (sConvertMessage==null){ 
            
            currentDfc = DF_Utils.getDFContactForUser(UserInfo.getUserId()); 
            dfcW = new DF_Contact_Wrapper(currentDfc);
                        isFriend = TRUE;
            isFriendConverted = TRUE;
            hasSessionCode = TRUE;
            hasRegisteredForSession = TRUE;
            pr.getParameters().put('session_code_submitted','true');
            return pr;
            
            
        }   else {
            
            messageArea = sConvertMessage;
            messageAreaClass = ALERT_ERROR_CLASS;
            return null;
            
        }
        
        return null;
    }
    
    
    
    public PageReference convertToChampion(){
        
        
        if ( dfcW.convertToChampion() ) {
            
            PageReference pr = Page.WEBChampion;
            pr.getParameters().put('nr','true');
            return pr;
            
        }
        return null;  
    }
    
    /* March 2015 */
    public Boolean hasWatchedVideo {get;set;}
    public Boolean confirmWithdrawal {get;set;}
    public Boolean fdBackSubmitted {get;set;}
    public Boolean infoSessionUpdated {get;set;}
    public Id placeholderOrganiserId {get;set;}

    
    public WEBFriend() {
        hasActions = FALSE;
        hasRegisteredForSession = FALSE;
        hasSessionCode = FALSE;
        isTraining = false;
        isSession = false;
        showSaveConfirmation = false;
        showUnbookedConfirmation = false;
        showbookedConfirmation = false;
        showAction = false;
        orgRegisterSuccess = false;
        isFriend = TRUE;
        isFriendConverted = FALSE;
        hasWatchedVideo = false;
        
        sessionCodeError = '';
        
        registerText = REGISTER;
        sessionCodeText = SESSION_CODE;
        actionText = ACTION;
        
        registeredAsFriend = FALSE;
        
        placeholderOrganiserId = [SELECT Name, Value__c 
                                  FROM Community_Settings__c 
                                  WHERE Name = 'DF_Placeholder_InfoSessionOrganiser'].Value__c;
        
        if (ApexPages.currentPage().getParameters().get('eventshare') != null){
            
            noOfFriends = ApexPages.currentPage().getParameters().get('eventshare');    
            
        }
        
        if (ApexPages.currentPage().getParameters().get('ds') != null){
            showSaveConfirmation = true;
        }else {
            showSaveConfirmation = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('ub') != null){
            showUnbookedConfirmation = true;
        }else {
            showUnbookedConfirmation = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('sa') != null){
            showAction = true;
        }else {
            showAction = false;
        }
        if (ApexPages.currentPage().getParameters().get('bs') != null){
            showbookedConfirmation = true;
        }else {
            showbookedConfirmation = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('org-registered') != null){
            system.debug('URL Parameter'+ApexPages.currentPage().getParameters().get('org-registered'));
            if (!DFP_Utils.isExistingAdminbyOrgName(currentDfc.Email__c,ApexPages.currentPage().getParameters().get('org-registered'))){
                orgRegisterSuccess = true; 
            }
        }
        
        if (ApexPages.currentPage().getParameters().get('session_code_submitted') != null){
            registeredAsFriend = true;
        }else {
            registeredAsFriend = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('confirmWithdrawal') == 'true') {
            confirmWithdrawal = true;
        } else {
            confirmWithdrawal = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('infoSessionUpdated') == 'true') {
            infoSessionUpdated = true;
        } else {
            infoSessionUpdated = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('fdBackSubmitted') == 'true') {
            fdBackSubmitted = true;
        } else {
            fdBackSubmitted = false;
        }
        
        
        // Are we converting back to a Friend from a Champion using the Parameter 'convertBack'
        String convertBackToFriend = ApexPages.currentPage().getParameters().get('convertBack');
        
        if (convertBackToFriend != null && convertBackToFriend.equalsIgnoreCase('TRUE')) {
            messageArea = SUCCESSFULLY_CONVERTED;
            messageAreaClass = 'alert-success';
            //Boolean isSuccess = WEBConversionClass.convertChampionToFriend(thisUser.contactId, WEBGlobalSettings.friendConvertCode);
        }

        if(currentdfc != null) {
            
            hasWatchedVideo = currentDfc.Has_Watched_Video__c;
            system.debug('Friend watched video ' + hasWatchedVideo);
            
            
            contactDetailsChanged = [select id 
                                     from DF_Contact_Inbound_Change__c 
                                     where Related_DF_Contact__c=:currentdfc.id];

            if(contactDetailsChanged.size()>0 ){
                
                showChangeDetailsPrompt = true;
            }
            
            rtMapByName = new Map<String, RecordType>();
            rtMap = new Map<Id, RecordType>();
            for (RecordType r : [select r.Id, r.DeveloperName from RecordType r where r.SobjectType = 'DF_Event__c' and r.IsActive = true]){
                rtMap.put(r.Id, r);
                rtMapByName.put(r.DeveloperName, r);
            }
            
            // Get Actions for the Friend
            //2014-03-10 : SM : Creating this list in the header of the class, as we need to be able to see it on the page
            actions = DF_Utils.dfActions(currentdfc);
            if (!actions.isEmpty()) {
                hasActions = TRUE;
                actionText = ACTION_ENTERED;
                theAction = actions[0];
                showActionText = theAction.Action__c;
            }
            
            //2014-03-10 : SM : Creating this list in the header of the class, as we need to be able to see it on the page
            system.debug('*** -- Get Events -- ***');
            RecordType friendRT = rtMapByName.get(RT_FRIENDSHIP_SESSION);
            //2014-005-18 : A user CAN be booked on more than one event, so I need to take off the LIMIT 1 argument
            
            //events = [SELECT Id, DF_Event__r.Event_Date_Time__c, DF_Event__r.City__c, DF_Event__r.Postcode__c, DF_Event__r.Number_of_Attendees__c, DF_Event__r.RecordTypeId 
            //          FROM DF_EventAttendee__C WHERE DF_Contact__r.Portal_Contact__c = :thisUser.ContactId
            //          and  DF_Event__r.RecordTypeId = :friendRT.Id LIMIT 1];
            events = [SELECT Id, DF_Event__r.Event_Date_Time__c, DF_Event__r.City__c, DF_Event__r.Postcode__c, DF_Event__r.Number_of_Attendees__c, DF_Event__r.RecordTypeId 
                      FROM DF_EventAttendee__C 
                      WHERE DF_Contact__r.Portal_Contact__c = :thisUser.ContactId
                      and  DF_Event__r.RecordTypeId = :friendRT.Id];      
            
            dfc =[select id,birthdate__c from DF_Contact__c where id=:currentdfc.id limit 1];
            
            system.debug('*** -- events.size() = ' + events.size() + ' -- ***');
            
            
            if (!events.isEmpty()) {
                //TODO : We may need to address this code if people can book on more than one Session
                //In the mean time we will assume they can only book on one
                hasRegisteredForSession = TRUE;
                registerText = REGISTERED;
                DF_EventAttendee__c event = events[0];
                showViewDetailsButton = true;
                //2014-05-18 : CSL : As we now need to be able to unbook from sessions in the past, this next line
                //needs to be commented out so they 'View Details' button is always visible
                //if (event.DF_Event__r.Event_Date_Time__c < Date.today()) showViewDetailsButton = false; 
                if (RT_CHAMPION_COURSE.equalsIgnoreCase(rtMap.get(event.DF_Event__r.RecordTypeId).DeveloperName)){
                    isTraining = true;
                }else {
                    isSession = true;
                }
                //2014-03-27 : SM : We cannot assume that just because the date has passed on the event, that they have a Session Code
                //if (event.DF_Event__r.Event_Date_Time__c < Date.today())
                //    hasSessionCode = TRUE;
            }
            
            // GG May 2015
            if ( currentDfc !=null ) {
                isDigitalFriend = currentDfc.Created_As_Type__c == 'Digital Friend';
            }
            
            if ( dfcW.isFriend ) {
                isFriend = TRUE;
            }
            
            if ( dfcW.isFriendConverted ){
                isFriendConverted = TRUE;
                hasSessionCode = TRUE;
                hasRegisteredForSession = (!events.isEmpty());
                registerText = REGISTERED;
                sessionCodeText = SESSION_CODE_ENTERED;
            }
            
            
            system.debug('*** -- isFriend = ' + isFriend + ' -- ***');
            system.debug('*** -- isFriendConverted = ' + isFriendConverted + ' -- ***');
        } else {
            system.debug('*** -- ANONYMOUS USER DETECTED (EXPECTED FOR PUBLIC INFO SESSION REQUEST) -- ***');
        }
    
        offset = DF_Utils.offset;
        
        Map<String,List<DF_Event__c>> champRequestedSessionMap = DF_EventListingHelper.getRequestedSessions(false, false, currentDfc.Id);
            requestedEventsRequiringFeedback = champRequestedSessionMap.get('eventsAwaitingFeedback');
            upcomingRequestedEvents = champRequestedSessionMap.get('upcomingEvents');
            pastRequestedEvents = champRequestedSessionMap.get('pastEvents');

    }
    
}