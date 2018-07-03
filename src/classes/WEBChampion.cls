/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBChampion.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class that looks after the WEBChampion VF Page.
 *                  This class determins what to render for the Champion on the Champion Dashboard
 *                  based on different flags etc.
 *               
 *  Modification History
 *  Date            Who         Description 
 *  27/05/2014      CSL         New code to enable 'You have sessions to be reported on' prompt     
 *  03/11/2015      LV          hasWatchedVideo
*******************************************************************************************/
public without sharing class WEBChampion extends DF_WEBC_ControllerBase {
    
    public final String CHAMPION_CODE = 'Register Champions\' code';
    public final String CHAMPION_CODE_ENTERED = 'Registered Champions\' code';
    public final String INVALID_CHAMPION_CODE = 'The Champions\' code you entered was not recognised. Please try again.';
    public final String ALERT_ERROR_CLASS = 'alert-danger';
    public final String STATUS_CANCELLED = 'Cancelled';
    public final String ACTION = 'Tell us about your action';
    public final String ACTION_ENTERED = 'You\'ve created an action';
    public boolean hasActions {get;set;}
    public String actionText {get;set;}
    public List<Action__c> actions {get; set;}
    public String showActionText {get; set;}
    public boolean showAction {get; set;}
    public Action__c theAction {get; set;}
    public boolean message {get;set;}
    public boolean orgRegisterSuccess {get;set;}
    public static final String SESSION_RT = 'Dementia_Friend_Awareness_Session';
    public List<Push_Notifications__c> champMessages{get;set;}
    public String pushMId {get;set;}
    public List<DF_Event__c> upcomingEvents {
        get {
            if (upcomingEvents == null){
                upcomingEvents = new List<DF_Event__c>();
            }
            return upcomingEvents;
        }
        set;
    }
    
    public List<DF_Event__c> eventsRequiringFeedback {
        get {
            if (eventsRequiringFeedback == null){
                eventsRequiringFeedback = new List<DF_Event__c>();
            }
            return eventsRequiringFeedback;
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

    public Boolean isChampion {get;set;}
    public Boolean isSuperChampion {get;set;}
    public Boolean isBlockedFromInfoSessions {get;set;}
    public Boolean isChampionConverted {get; set;}
    public Boolean isChampionRetired { get; set; }
    public Boolean isChampionProspective { get; set; }
    public Boolean isChampionDeclined { get; set; }
    public Boolean isChampionSuspended { get; set; }
    public Boolean isChampionHiatus { get; set; }
    public Boolean registeredAsChampion {get;set;}
    public Boolean newChampionRegistration {get; set;}
    public Boolean showReportingPrompt {get; set;}
    public Boolean showChangeDetailsPrompt {get; set;}
    public Boolean showActionShare {get; set;}
    public Boolean isChampionVerified{get; set;}
    public String championCode {get;set;}
    public String championCodeError {get;set;}
    public String championCodeText {get;set;}

    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}

    public Integer sessionCount {get;set;}
    public Integer friendCount {get;set;}
    public Integer friendActionCount {get;set;}
    
    public boolean isTraining {get; set;}
    public boolean isSession {get; set;}
    
    public boolean showViewDetailsButton {get; set;}
    public boolean showSaveConfirmation {get; set;}
    
    public Map<Id, RecordType> rtMap {get; set;}
    public Map<String, RecordType> rtMapByName {get; set;}
    
    public List<DF_EventAttendee__c> myTraining {get; set;}
    public boolean isExchangeBlocked {get; set;}
    
    
    
   /* public PageReference registerCode() {
        
        messageArea = null;
        messageAreaClass = null;
        championCodeError = '';
        
        if (championCode.length() == 0) {
        
            messageArea = INVALID_CHAMPION_CODE;
            messageAreaClass = ALERT_ERROR_CLASS;
            return null;
        
        }
        
        system.debug('*** -- Registering code ' + championCode + ' -- ***');
            
        String sConvertMessage = dfcW.confirmChampion(championCode);

        if ( sConvertMessage == null) {

            registeredAsChampion = true;
            currentDfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());            
            dfcW = new DF_Contact_Wrapper(currentDfc);
            isChampion = true;
            isChampionConverted = true;
            isChampionVerified = true;
            isChampionProspective = false;
            
        } else {
                messageArea = sConvertMessage;
                messageAreaClass = ALERT_ERROR_CLASS;
                return null;
        }
        
        return null;

    }*/

    public PageReference convertBackToFriend() {
        

        if ( dfcW.convertToFriend() ) {

            PageReference pr = Page.WEBFriend;
            pr.getParameters().put('convertBack', 'TRUE');
            return pr;

        }

        return null;

        /*
        system.debug('*** -- Into convertBackToFriend -- ***');
        Boolean isSuccess = WEBConversionClass.convertChampionToFriend(currentContact.Id, WEBGlobalSettings.friendConvertCode);
        system.debug('*** -- Conversion returned : ' + isSuccess + ' -- ***');

        if (isSuccess) {
            PageReference pr = Page.WEBFriend;
            pr.getParameters().put('convertBack', 'TRUE');
            return pr;
        }
        else
            return null;
        */

    
    }

    /* 03/11/2015 */
    public Boolean hasWatchedVideo {get;set;}
    public Boolean confirmWithdrawal {get;set;}
    public Boolean sessionDropped {get;set;}
    public Boolean fdBackSubmitted {get;set;}

    public WEBChampion() {
        
        system.debug('*** -- Into WEBChampion Constructor -- ***');
        
        sessionCount = 0;
        hasActions = FALSE;
        friendCount = 0;
        friendActionCount = 0;        
        registeredAsChampion = FALSE;
        newChampionRegistration = false;
        showAction = false;
        actionText = ACTION;
        isSession = false;
        isTraining = false; 
        orgRegisterSuccess = false ;    
        showReportingPrompt = false;
        showActionShare = false;
        if(currentDfc.Type_of_Champion__c != null) {
            isSuperChampion = (currentDfc.Type_of_Champion__c.contains('Super')) ? true : false;
        } else {
            isSuperChampion = false;
        }
        isBlockedFromInfoSessions = currentDfc.Blocked_due_to_excessive_req_sessions__c || currentDfc.Admin_block_from_requesting_info_session__c
            						|| currentDfc.Status__c == 'Prospective' 
                                    || currentDfc.Status__c == 'Suspended' || currentDfc.Status__c == 'Declined'
                                    || currentDfc.Status__c == 'Retired' || currentDfc.Status__c == 'On Hiatus/Resting';
        
        if (ApexPages.currentPage().getParameters().get('nr') != null){
            newChampionRegistration = true; 
        }
        
        if (ApexPages.currentPage().getParameters().get('rc') != null){
            registeredAsChampion = true;    
        }
        
        System.debug('?????: ' + ApexPages.currentPage().getParameters().get('confirmWithdrawal'));
        if (ApexPages.currentPage().getParameters().get('confirmWithdrawal') == 'true') {
            confirmWithdrawal = true;
        } else {
            confirmWithdrawal = false;
        }
        
        System.debug('?????: ' + ApexPages.currentPage().getParameters().get('sessionDropped'));
        if (ApexPages.currentPage().getParameters().get('sessionDropped') == 'true') {
            sessionDropped = true;
        } else {
            sessionDropped = false;
        }

       if (ApexPages.currentPage().getParameters().get('action_created') != null || ApexPages.currentPage().getParameters().get('action_updated')!=null){
        
            showActionShare = true;    
        
        }
        
        if (ApexPages.currentPage().getParameters().get('ds') != null){
            showSaveConfirmation = true;
        } else {
            showSaveConfirmation = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('fdBackSubmitted') == 'true') {
            fdBackSubmitted = true;
        } else {
            fdBackSubmitted = false;
        }
        
        if (ApexPages.currentPage().getParameters().get('org-registered') != null){
        system.debug('URL Parameter'+ApexPages.currentPage().getParameters().get('org-registered'));
          if (!DFP_Utils.isExistingAdminbyOrgName(currentDfc.Email__c,ApexPages.currentPage().getParameters().get('org-registered'))){
            orgRegisterSuccess = true; 
          }
        }
        
        champMessages = new List<Push_Notifications__c>();
        
        for(Push_Notifications__c pn : [select Message__c,Id from Push_Notifications__c where DF_Contact__c=:currentdfc.Id and Status__c = 'Unread']){
            champMessages.add(pn);

        }
        

        if ( currentDfc == null ) { return; }

        isChampion = DF_Utils.isChampion(currentDfc);
        isChampionConverted = DF_Utils.isChampionConverted(currentDfc);
        isChampionRetired = DF_Utils.isChampionRetired(currentDfc);
        isChampionProspective = DF_Utils.isChampionProspective(currentDfc);
        isChampionDeclined = DF_Utils.isChampionDeclined(currentDfc);
        isChampionSuspended = DF_Utils.isChampionSuspended(currentDfc);
        isChampionHiatus = DF_Utils.isChampionHiatus(currentDfc);
        ischampionVerified = DF_Utils.isChampionVerified(currentDfc);
        friendCount = currentDfc.Total_No_of_Friends_Created__c.intValue(); // #ISS - 1482
        isExchangeBlocked = currentDfc.Block_champion_exchange_access__c;
        
        actions = DF_Utils.dfActions(currentdfc);
        if (!actions.isEmpty()) {
            hasActions = TRUE;
            actionText = ACTION_ENTERED;
            theAction = actions[0];
            showActionText = theAction.Action__c;
        }
        
        hasWatchedVideo = (currentDfc.Digital_Friend_Signup_Time__c != null );
        system.debug('champion watched video ' + hasWatchedVideo);
        /* Events organised by this DFC */
        String sdt = Datetime.now().format('yyyy-MM-dd HH:mm:ss', 'Europe/London');
        Datetime dt = Datetime.valueOf(sdt);

        upcomingEvents = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Places__c, Number_of_Attendee_Records__c, Requested_Info_Session__c 
                          FROM DF_Event__c 
                          WHERE Session_Organiser__c = :currentDfc.Id 
                          AND Event_End_Date_Time__c >=: dt 
                          AND Requested_Info_Session__c = false
                          AND Event_Status__c != :STATUS_CANCELLED 
                          AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT)  
                          LIMIT 20];
        
        eventsRequiringFeedback = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Places__c, Requested_Info_Session__c 
                                   FROM DF_Event__c 
                                   WHERE Session_Organiser__c = :currentDfc.Id 
                                   AND Event_End_Date_Time__c <: dt AND (Number_of_Attendees__c = null 
                                                                         OR Number_of_Attendees__c = 0) 
                                   AND Event_Status__c != :STATUS_CANCELLED 
                                   AND  RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT)  LIMIT 10];
        contactDetailsChanged = [SELECT id 
                                 FROM DF_Contact_Inbound_Change__c 
                                 WHERE Related_DF_Contact__c=:currentdfc.id];
        
        if (eventsRequiringFeedback.size() > 0 && isChampionConverted ) {
            showReportingPrompt = true;
        }
        if(contactDetailsChanged.size()>0 ){
            
            showChangeDetailsPrompt = true;
        }

        List<DF_Event__c> events = [SELECT Id 
                                    FROM DF_Event__c 
                                    WHERE Session_Organiser__c = :currentDfc.id 
                                    AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                                    AND Event_Status__c ='Completed' 
                                    LIMIT 1000];

        if (events != null && !events.isEmpty()) {
            sessionCount = events.size();
        }
        
        system.debug('WEBChampion isChampion = ' + isChampion);
        system.debug('WEBChampion isChampionConverted = ' + isChampionConverted);

        myTraining = new List<DF_EventAttendee__c>();
        
        String championCourseRT = DF_Utils.getDfEventRecordTypeId(DF_Utils.RT_CHAMPION_COURSE);
                //championCodeText = CHAMPION_CODE;
        
                myTraining = [SELECT Id, DF_Event__r.Event_Date_Time__c, DF_Event__r.City__c, DF_Event__r.Postcode__c, DF_Event__r.Number_of_Attendees__c, DF_Event__r.RecordTypeId 
                            FROM DF_EventAttendee__C WHERE DF_Contact__c = :currentDfc.Id
                            and DF_Event__r.RecordTypeId = :championCourseRT LIMIT 1];
        
                if (!myTraining.isEmpty()){
            
                    isTraining = true;
                    isSession = false;
                    showViewDetailsButton = true;
            
                }
        
        

        system.debug('WEBChampion Champion Code Text ' + championCodeText);

        List<DF_EventAttendee__c> myEventContacts = [SELECT DF_Contact__r.Id FROM DF_EventAttendee__c WHERE DF_Event__c = :events LIMIT 1000];

        List<Id> myEventContactsId = new List<Id>();
        
        if (myEventContacts != null && !myEventContacts.isEmpty()) {
        
            for (DF_EventAttendee__c att : myEventContacts) {
                myEventContactsId.add(att.DF_Contact__r.Id);
            }

            List<Action__c> myEventContactsActions = [SELECT Id FROM Action__c WHERE DF_Contact__r.Id = :myEventContactsId LIMIT 1000];
    
            if (myEventContactsActions != null && !myEventContactsActions.isEmpty())
                friendActionCount = myEventContactsActions.size();
        }
    }

    
   


}