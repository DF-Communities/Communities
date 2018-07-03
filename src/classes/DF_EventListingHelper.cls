/*
* Class to assist with the DF Community pages
* where the information sessions are shown for
* Dem Friends and Dem Champions
*/
public class DF_EventListingHelper {
    
    private static final String SESSION_RT = 'Dementia_Friend_Awareness_Session';
    private static final String STATUS_AVAILABLE = 'Available';
    private static final List<String> VALID_UPCOMING_STATUS_REQ_SESSION = new List<String>{'Waiting for approval', 'Open - waiting for champion','Matched with champion'};
    private static final String EVENT_STATUS_UNSUCCESSFUL = 'Cancelled';
    private static final List<String> REQUEST_STATUS_UNSUCCESSFUL = new List<String>{'Withdrawn','Unsuccessful'};
    private static final String STATUS_COMPLETED = 'Completed';
    private static final String STATUS_FULL = 'Full';
    private static String sdt = Datetime.now().format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getDisplayName());
    private static Datetime dt = Datetime.valueOf(sdt);
    

    public static Map<String, List<DF_Event__c>> getDeliveredSessions(Id dfcId) {
    	// Delivered sessions are a combination of created sessions and champ-hosted requested sessions
    	Map<String, List<DF_Event__c>> deliveredSessionMap = new Map<String, List<DF_Event__c>>();
        Map<String, List<DF_Event__c>> createdSessionsMap = getCreatedSessions(dfcId);
        Map<String, List<DF_Event__c>> requestedSessionsMap = getRequestedSessions(true, false, dfcId);
        
        List<DF_Event__c> combinedListFeedback = new List<DF_Event__c>();
        combinedListFeedback.addAll(createdSessionsMap.get('eventsAwaitingFeedback'));
        System.debug('combinedList: ' + combinedListFeedback);
        combinedListFeedback.addAll(requestedSessionsMap.get('eventsAwaitingFeedback'));
        System.debug('combinedList: ' + combinedListFeedback);
        deliveredSessionMap.put('eventsAwaitingFeedback', combinedListFeedback);
        
        List<DF_Event__c> combinedListUpcoming = new List<DF_Event__c>();
        combinedListUpcoming.addAll(createdSessionsMap.get('upcomingEvents'));
        combinedListUpcoming.addAll(requestedSessionsMap.get('upcomingEvents'));
        deliveredSessionMap.put('upcomingEvents', combinedListUpcoming);
                   
        List<DF_Event__c> combinedListPast = new List<DF_Event__c>();
        combinedListPast.addAll(createdSessionsMap.get('pastEvents'));
        combinedListPast.addAll(requestedSessionsMap.get('pastEvents'));
        deliveredSessionMap.put('pastEvents', combinedListPast);
        
        return deliveredSessionMap;
    }
    
        public static Map<String, List<DF_Event__c>> getRequestedSessions(Boolean isChamp, Boolean isChampAndRequester, Id dfcId) {
        
        // Initialize the event lists
        Map<String,List<DF_Event__c>> sessionsMap = new Map<String, List<DF_Event__c>>();
        sessionsMap.put('eventsAwaitingFeedback', new List<DF_Event__c>());
        sessionsMap.put('upcomingEvents', new List<DF_Event__c>());
        sessionsMap.put('pastEvents', new List<DF_Event__c>());
        List<DF_Event__c> sessionsList = new List<DF_Event__c>();
        
        if(isChamp && isChampAndRequester) {
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Event_Status__c != :EVENT_STATUS_UNSUCCESSFUL 
                            AND Request_Status__c NOT IN :REQUEST_STATUS_UNSUCCESSFUL 
                            AND Session_Requester__c = :dfcId
                            AND Host_Feedback_Submitted__c = false
                            AND Event_End_Date_Time__c <= :dt 
                            AND RecordTypeId = :DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            AND Requested_Info_Session__c = true
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('eventsAwaitingFeedback', sessionsList);
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Session_Requester__c = :dfcId
                            AND Requested_Info_Session__c = true
                            AND Request_Status__c IN :VALID_UPCOMING_STATUS_REQ_SESSION 
                            AND Event_End_Date_Time__c >: dt 
                            AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('upcomingEvents', sessionsList);
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Session_Requester__c = :dfcId 
                            AND Host_Feedback_Submitted__c = true
                            AND Event_End_Date_Time__c <:dt 
                            AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            AND Requested_Info_Session__c = true
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('pastEvents', sessionsList);
            
        } else if(isChamp && !isChampAndRequester) {
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Event_Status__c != :EVENT_STATUS_UNSUCCESSFUL 
                            AND Request_Status__c NOT IN :REQUEST_STATUS_UNSUCCESSFUL 
                            AND Session_Organiser__c = :dfcId
                            AND Champion_Feedback_Submitted__c = false
                            AND Event_End_Date_Time__c <= :dt 
                            AND RecordTypeId = :DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            AND Requested_Info_Session__c = true
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('eventsAwaitingFeedback', sessionsList);
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Session_Organiser__c = :dfcId 
                            AND Request_Status__c = 'Matched with champion'
                            AND Event_End_Date_Time__c >: dt 
                            AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            AND Requested_Info_Session__c = true
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('upcomingEvents', sessionsList);
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Session_Organiser__c = :dfcId 
                            AND Champion_Feedback_Submitted__c = true
                            AND Event_Status__c = :STATUS_COMPLETED
                            AND Event_End_Date_Time__c <:dt 
                            AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            AND Requested_Info_Session__c = true
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('pastEvents', sessionsList);
        } else {
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c,
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Event_Status__c != :EVENT_STATUS_UNSUCCESSFUL
                            AND Host_Feedback_Submitted__c = false
                            AND Session_Requester__c = :dfcId
                            AND Event_End_Date_Time__c <: dt 
                            AND (Number_of_Attendees__c = null OR Number_of_Attendees__c = 0) 
                            And RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('eventsAwaitingFeedback', sessionsList);
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Session_Requester__c = :dfcId
                            AND Request_Status__c IN :VALID_UPCOMING_STATUS_REQ_SESSION 
                            AND Event_End_Date_Time__c >: dt 
                            AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('upcomingEvents', sessionsList);
            
            sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                            Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                            Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                            Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                            FROM DF_Event__c 
                            WHERE Session_Requester__c = :dfcId
                            AND Host_Feedback_Submitted__c = true
                            AND Event_End_Date_Time__c <:dt 
                            AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                            ORDER BY Event_Date_Time__c DESC];
            sessionsMap.put('pastEvents', sessionsList);
            
        }
        
        System.debug('sessionsMap: ' + sessionsMap);
        return sessionsMap;
    }
    
    
    
    public static Map<String, List<DF_Event__c>> getCreatedSessions(Id dfcId) {
        
        // Initialize the event lists
        Map<String,List<DF_Event__c>> sessionsMap = new Map<String, List<DF_Event__c>>();
        sessionsMap.put('eventsAwaitingFeedback', new List<DF_Event__c>());
        sessionsMap.put('upcomingEvents', new List<DF_Event__c>());
        sessionsMap.put('pastEvents', new List<DF_Event__c>());
        List<DF_Event__c> sessionsList = new List<DF_Event__c>();
        
        sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                        Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                        Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                        Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                        FROM DF_Event__c 
                        WHERE Event_Status__c != :EVENT_STATUS_UNSUCCESSFUL
                        AND (Number_of_Attendees__c = 0 OR Number_of_Attendees__c = null) 
                        AND Requested_Info_Session__c = false
                        AND Session_Organiser__c = :dfcId
                        AND Event_End_Date_Time__c <=: dt 
                        AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                        ORDER BY Event_Date_Time__c DESC];
        sessionsMap.put('eventsAwaitingFeedback', sessionsList);
        
        sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                        Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                        Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                        Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                        FROM DF_Event__c 
                        WHERE Session_Organiser__c = :dfcId 
                        AND Requested_Info_Session__c = false
                        AND Event_End_Date_Time__c >: dt 
                        AND Event_Status__c = :STATUS_AVAILABLE 
                        AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                        ORDER BY Event_Date_Time__c DESC];
        sessionsMap.put('upcomingEvents', sessionsList);
        
        sessionsList = [SELECT Id, Name, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Attendees__c, Number_of_Attendee_Records__c, Number_of_Places__c, 
                        Request_Status__c, Event_Status__c, Session_Organiser_Firstname__c, Session_Organiser_Lastname__c, Session_Organiser__r.Contact_Number__c, Session_Requester__c,
                        Requested_Info_Session__c, Preference_1_Date__c, Preference_1_Period__c, Preference_2_Date__c, Preference_2_Period__c, Preference_3_Date__c, Preference_3_Period__c,
                        Champion_Feedback_Submitted__c, Host_Feedback_Submitted__c
                        FROM DF_Event__c 
                        WHERE Session_Organiser__c = :dfcId
                        AND Requested_Info_Session__c = false
                        AND Event_Status__c = :STATUS_COMPLETED
                        AND Number_of_Attendees__c != 0 
                        AND Number_of_Attendees__c != null
                        AND Event_End_Date_Time__c <:dt 
                        AND RecordTypeId = : DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT) 
                        ORDER BY Event_Date_Time__c DESC];
        sessionsMap.put('pastEvents', sessionsList);
        
        System.debug('sessionsMap: ' + sessionsMap);
        return sessionsMap;
    }
    
}