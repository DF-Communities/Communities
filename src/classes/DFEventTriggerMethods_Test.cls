@isTest

public class DFEventTriggerMethods_Test{
    
    @testSetup static void setup() {
        // Create the test data once and then run all methods on the dataset
        DF_DataFactory_Test.getTestData();  
        
    }
    
    static testmethod void coverageMethod(){
        
        DF_Event__c Dc = [SELECT Id, Event_Status__c, (select Id from DF_EventAttendees__r) FROM DF_Event__C WHERE Name = 'Test Friends Session' LIMIT 1];
        System.assertEquals(dc.DF_EventAttendees__r.isEmpty(), false, 'no attendees');
        Map<Id, DF_Event__c> oldEvents = new Map<Id, DF_Event__c>();
        List<DF_Event__c> lis = new List<DF_Event__c>();
        test.starttest();
       // DC.Event_Status__c='Cancelled';   
        oldEvents.put(Dc.id,dc);
        update Dc;   
        lis.add(Dc);
        
        // DFEventTriggerMethods df = new DFEventTriggerMethods();
        DFEventTriggerMethods.sendEmailNotifications(lis,oldEvents);
    }
    
    static testmethod void sendCancellationEmails(){
        
        DF_Event__c Dc = [SELECT Id, Event_Status__c FROM DF_Event__C WHERE Name = 'Test Friends Session' LIMIT 1];
        Map<Id, DF_Event__c> oldEvents = new Map<Id, DF_Event__c>();
        List<DF_Event__c> lis = new List<DF_Event__c>();
        test.starttest();
        DC.Event_Status__c='Cancelled';   
        DC.Event_Date_Time__c=Datetime.now().addDays(20);
        DC.Event_End_Date_Time__c=Datetime.now().addDays(21);
        oldEvents.put(Dc.id,dc);
        update Dc;   
        lis.add(Dc);
        
        // DFEventTriggerMethods df = new DFEventTriggerMethods();
        DFEventTriggerMethods.cancelEvent(Dc);
    }
        
        static testmethod void getEventInfo(){
        
        DF_Event__c Dc = [SELECT Id, Event_Status__c FROM DF_Event__C WHERE Name = 'Test Champion Training' LIMIT 1];
        Map<Id, DF_Event__c> oldEvents = new Map<Id, DF_Event__c>();
        List<DF_Event__c> lis = new List<DF_Event__c>();
        test.starttest();
        DC.Event_Status__c='Cancelled';   
        DC.Event_Date_Time__c=Datetime.now().addDays(20);
        DC.Event_End_Date_Time__c=Datetime.now().addDays(21);
        oldEvents.put(Dc.id,dc);
        update Dc;   
        lis.add(Dc);
        
        // DFEventTriggerMethods df = new DFEventTriggerMethods();
        DFEventTriggerMethods.getEventInfo(Dc.Id);
    } 
    
    static testmethod void getUserSiteInfo(){
        
        DF_Event__c Dc = [SELECT Id, Event_Status__c FROM DF_Event__C WHERE Name = 'Test Champion Training' LIMIT 1];
        Map<Id, DF_Event__c> oldEvents = new Map<Id, DF_Event__c>();
        List<DF_Event__c> lis = new List<DF_Event__c>();
        test.starttest();
        DC.Event_Status__c='Completed'; 
        DC.Requested_Info_Session__c = true;
        DC.Event_Date_Time__c=Datetime.now().addDays(20);
        DC.Event_End_Date_Time__c=Datetime.now().addDays(21);
        oldEvents.put(Dc.id,dc);
        update Dc;   
        lis.add(Dc);
        
        //Profile testProfile = [SELECT Id FROM Profile WHERE Name='DF HVCP'];
        User u = [SELECT Id 
                  FROM User 
                  WHERE UserName = 'light.admin@df_organisation.com'
                  LIMIT 1];
        
        System.debug('????: ' + u);
        
        // DFEventTriggerMethods df = new DFEventTriggerMethods();
        System.runAs(u) {
        	DFEventTriggerMethods.getSiteUserInfo(u.Id, Dc.Id);
        }
    } 
    
    static testmethod void sendEmailToMembers(){
        
        DF_Event__c Dc = [SELECT Id, Event_Status__c FROM DF_Event__C WHERE Name = 'Test Champion Training' LIMIT 1];
        Map<Id, DF_Event__c> oldEvents = new Map<Id, DF_Event__c>();
        List<DF_Event__c> lis = new List<DF_Event__c>();
        test.starttest();
        DC.Event_Status__c='Cancelled';   
        DC.Event_Date_Time__c=Datetime.now().addDays(20);
        DC.Event_End_Date_Time__c=Datetime.now().addDays(21);
        oldEvents.put(Dc.id,dc);
        update Dc;   
        lis.add(Dc);
        
        // DFEventTriggerMethods df = new DFEventTriggerMethods();
        DFEventTriggerMethods.sendEmailToMembers(new Set<Id>{Dc.Id});
    }
    
    static testmethod void calculateDistance() {
    	DFEventTriggerMethods.calculateDistance((Double)54.25, (Double)0.12454, (Double)56.54, (Double)0.356);
    }
    
    static testmethod void submitEventFeedback_success() {
        
        System.debug('All events: ' + [SELECT Id FROM DF_Event__c]);
        System.debug('All events requested: ' + [SELECT Id FROM DF_Event__c WHERE Requested_Info_Session__c = true]);
        Test.starttest();
        List<DF_Event__c> testEvnt = [SELECT Id, Champion_Feedback_Submitted__c, Number_of_Attendees__c, Event_Status__c, Request_Status__c FROM DF_Event__c WHERE Requested_Info_Session__c = true];
        System.debug('All events requested in test are now: ' + testEvnt.size());
        DFEventTriggerMethods.submitEventFeedback(testEvnt[0]);
    }
    
    
    static testmethod void requestAnonInfoSession_success() {     
        
        DF_Event__c formEventData = new DF_Event__c();
        DF_Contact__c formContactData = new DF_Contact__c();
        Demographic_information__c formDemographicData = new Demographic_information__c();
        
        Id defaultOrganiserId = [SELECT Id FROM DF_Contact__c WHERE Email__c = 'tobeconfirmed@mailinator.com'].Id;
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend_Champion' AND SObjectType = 'DF_Contact__c'].Id;
        
        // Get Champ Id
        //Id requesterId = [SELECT Id FROM DF_Contact__c][0].Id;
        formContactData.RecordTypeId =  rtId;
        formContactData.First_Name__c = 'Unknown';
        formContactData.Last_Name__c = 'User';
        formContactData.Title__c = 'Mr';
        formContactData.Name='new'+' ' +'user';
        formContactData.Contact_Number__c = '02085182934';
        formContactData.Email__c = 'test.anonuser@myemail.com';
        formContactData.Postcode__c = 'EC3N 2AE'; // Address is important for proximity seach in requested info sessions
        formContactData.Street__c = '43-44 Crutched Friars';
        formContactData.City__c = 'London';
        formContactData.County__c = 'London';
        formContactData.Country__c = 'United Kingdom';
        formContactData.Newsletters__c = true;
        
        // Instantiate but do not commit request info session objects
        Date dToday = system.today();
        formEventData.RecordTypeId = rtId;
        formEventData.name = 'Test Request Session';
        formEventData.Postcode__c = 'EC3N 2AE';
        formEventData.City__c = 'London';
        formEventData.Street__c = '44 Crutched Friars';
        formEventData.Requested_Info_Session__c = true;
        formEventData.Event_Date_Time__c = dToday.addDays(2);
        formEventData.Event_End_Date_Time__c = dToday.addDays(2);
        formEventData.Preference_1_Date__c = dToday.addDays(2); 
        formEventData.Preference_1_Period__c = 'Afternoon (12pm-5pm)'; 
        formEventData.Preference_2_Date__c = dToday.addDays(7); 
        formEventData.Preference_2_Period__c = 'Morning (7am-12pm)'; 
        formEventData.Preference_3_Date__c = dToday.addDays(20); 
        formEventData.Preference_3_Period__c = 'Specific time (hh:mm)'; 
        formEventData.Preference_3_Time__c = '16:30'; 
        formEventData.Session_Organiser__c = defaultOrganiserId;
        //formEventData.Session_Requester__c = requesterId;
        
        //di.Contact__c = requesterId;
        //formDemographicData.Email_Opt_in__c = true;
        formDemographicData.Ethnic_Group__c = 'Asian/Asian British – Indian';
        //formDemographicData.Post_Opt_out__c = true;
        formDemographicData.Proximity_to_dementia__c = 'Family or Friend,Carer';
        
        Map<String,Boolean> formGdprPrefs = new Map<String, Boolean>();
        formGdprPrefs.put('Email_Optin__c', false);
        formGdprPrefs.put('SMS_Optin__c', true);
        formGdprPrefs.put('Phone_Optin__c', false);
        formGdprPrefs.put('Social_Media_Optin__c', true);
        formGdprPrefs.put('Post_Optout__c', true);
        
        String newUserPassword = 'unitTesting12';
        
        System.debug('requestAnonInfoSession_success: ' + newUserPassword);
        System.debug('formContactData: ' + formContactData);
        
        Test.startTest();
        Map<String,String> createdEvnts = DFEventTriggerMethods.createInfoSessionReqRecords(formContactData, 
                                                                                            formDemographicData, 
                                                                                            formEventData, 
                                                                                            formGdprPrefs,
                                                                                            null,
                                                                                            newUserPassword);
        Test.stopTest();
    }
    
    static testmethod void requestKnownUserInfoSession_success() {     
        
        DF_Event__c formEventData = new DF_Event__c();
        DF_Contact__c formContactData = new DF_Contact__c();
        Demographic_information__c formDemographicData = new Demographic_information__c();
        
        Id defaultOrganiserId = [SELECT Id FROM DF_Contact__c WHERE Email__c = 'tobeconfirmed@mailinator.com'].Id;
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend_Champion' AND SObjectType = 'DF_Contact__c'].Id;
        
        // Get Champ Id
        //Id requesterId = [SELECT Id FROM DF_Contact__c][0].Id;
        formContactData.RecordTypeId = rtId;
        formContactData.First_Name__c = 'UAT';
        formContactData.Last_Name__c = 'KnownUser';
        formContactData.Title__c = 'Mr';
        formContactData.Name='UAT'+' ' +'KnownUser';
        formContactData.Contact_Number__c = '02012280434';
        formContactData.Email__c = 'test.knwonuser@myemail.com';
        formContactData.Postcode__c = 'EC3N 2AE'; // Address is important for proximity seach in requested info sessions
        formContactData.Street__c = '43-44 Crutched Friars';
        formContactData.City__c = 'London';
        formContactData.County__c = 'London';
        formContactData.Country__c = 'United Kingdom';
        formContactData.Newsletters__c = true;
        
        // Instantiate but do not commit request info session objects
        Date dToday = system.today();
        formEventData.RecordTypeId = rtId;
        formEventData.name = 'Known user req event';
        formEventData.Postcode__c = 'EC3N 2AE';
        formEventData.City__c = 'London';
        formEventData.Street__c = '44 Crutched Friars';
        formEventData.Requested_Info_Session__c = true;
        formEventData.Event_Date_Time__c = dToday.addDays(2);
        formEventData.Event_End_Date_Time__c = dToday.addDays(2);
        formEventData.Preference_1_Date__c = dToday.addDays(2); 
        formEventData.Preference_1_Period__c = 'Afternoon (12pm-5pm)'; 
        formEventData.Preference_2_Date__c = dToday.addDays(7); 
        formEventData.Preference_2_Period__c = 'Morning (7am-12pm)'; 
        formEventData.Preference_3_Date__c = dToday.addDays(20); 
        formEventData.Preference_3_Period__c = 'Specific time (hh:mm)'; 
        formEventData.Preference_3_Time__c = '16:30'; 
        formEventData.Session_Organiser__c = defaultOrganiserId;
        //formEventData.Session_Requester__c = requesterId;
        
        //di.Contact__c = requesterId;
        //formDemographicData.Email_Opt_in__c = true;
        formDemographicData.Ethnic_Group__c = 'Asian/Asian British – Indian';
        //formDemographicData.Post_Opt_out__c = true;
        formDemographicData.Proximity_to_dementia__c = 'Family or Friend,Carer';
                
        Database.saveResult dsr = Database.insert(formContactData, true);
        Id dfContactId = dsr.getId();
        
        Map<String,Boolean> formGdprPrefs = new Map<String, Boolean>();
        formGdprPrefs.put('Email_Optin__c', false);
        formGdprPrefs.put('SMS_Optin__c', true);
        formGdprPrefs.put('Phone_Optin__c', false);
        formGdprPrefs.put('Social_Media_Optin__c', true);
        formGdprPrefs.put('Post_Optout__c', true);
        
        Test.startTest();
        Map<String,String> createdEvnts = DFEventTriggerMethods.createInfoSessionReqRecords(null, 
                                                                                            formDemographicData, 
                                                                                            formEventData,
                                                                                            formGdprPrefs,
                                                                                            dfContactId,
                                                                                            null);
        Test.stopTest();
    }
    
    static testmethod void retrieveCurrentUserAndEventDetails_success() {
        
        Map<Id, DF_Event__c> allTestEvts = new Map<Id, DF_Event__c>([SELECT Id, Session_Requester__c FROM DF_Event__c]);
        System.debug('allTestEvts.keySet(): ' + allTestEvts.keySet());
        
        List<DF_Contact__c> contacts = [SELECT Id, Portal_User__c, Portal_User__r.Id 
                                        FROM DF_Contact__c 
                                        WHERE Id IN :allTestEvts.keySet()
                                        AND Portal_User__c != ''];
        System.debug('contacts: ' + contacts);
        
        Id selectedUserId;
        if(contacts.size() != 0) {
            selectedUserId = contacts[0].Portal_User__r.Id;
        } else {
            selectedUserId =[SELECT Id FROM User LIMIT 1].Id;
        }
        
        List<DF_Event__c> selectedEvent = [SELECT Id, Session_Requester__c 
                                           FROM DF_Event__c
                                           WHERE Session_Requester__c = :selectedUserId];
        
        Id selectedEventId;
        if(selectedEvent.size() != 1) {
            selectedEventId = [SELECT Id FROM DF_Event__c LIMIT 1].Id;
        } else {
            selectedEventId = selectedEvent[0].Session_Requester__c;
        }
        
        // DFEventTriggerMethods.getSiteUserInfo(selectedUserId, selectedEventId);
    }
    
    static testmethod void updateRequestedEvent_success() {
        Id defaultOrganiserId = [SELECT Id FROM DF_Contact__c WHERE Email__c = 'tobeconfirmed@mailinator.com' limit 1].Id;
        
        DF_Event__c dfEvent = [SELECT Id, Session_Organiser__c, Request_Status__c 
                               FROM DF_Event__c 
                               WHERE Requested_Info_Session__c = true LIMIT 1];
        Id dfEventId = dfEvent.Id;
        System.assertEquals(dfEvent.Session_Organiser__c, defaultOrganiserId, 'must have session default organiser. ' );
        System.assertEquals(dfEvent.Request_Status__c, 'Open - waiting for champion' , 'must have Open - waiting for champion status. ' );
        String eventDateStr = '2050-01-01'; // yyyy-MM-dd
        String eventStartTime = '09:00';
        String eventEndTime = '10:00';
        Id championId = [SELECT Session_Requester__c FROM DF_Event__c WHERE Requested_Info_Session__c = true LIMIT 1].Session_Requester__c;
        DFEventTriggerMethods.updateInfoSession(dfEventId, 
                                                eventDateStr,
                                                eventStartTime, 
                                                eventEndTime,
                                                championId); 
    }
    
    static testmethod void getEnvironmentDetails_success() {
        DFEventTriggerMethods.getEnvironmentDomains();
    }
    
    static testmethod void getEventSessionViewDetails_success() {
        Id eventId = [SELECT Id FROM DF_Event__c WHERE Requested_Info_Session__c = true LIMIT 1].Id;
        DFEventTriggerMethods.getEventSessionViewDetails(eventId);
    }
    
    static testmethod void searchRequestedSessions_success() {
        
        Integer searchRadius = 50;
        DF_Contact__c dfContact = [SELECT Id, Location__latitude__s, Location__longitude__s 
                                   FROM DF_Contact__c 
                                   WHERE Postcode__c = 'EC3N 2AE' 
                                   LIMIT 1];
        
        Decimal dfContactLat = dfContact.Location__latitude__s;
        Decimal dfContactLng = dfContact.Location__longitude__s;
        String fromDateStr = '2000-01-01';
        String toDateStr = '3000-01-01'; 
        String sessionType = '';
        Decimal pageNumber = 1;
        Decimal recordsToDisplay = 5;
        DFEventTriggerMethods.searchRequestedSessions(searchRadius, dfContact.Id, dfContactLat, 
                                                      dfContactLng, fromDateStr, toDateStr, 
                                                      sessionType, pageNumber, recordsToDisplay);
    }
    
    static testmethod void getPartnerOrgs_success() {
        
        Id dfContactId = [SELECT Id FROM DF_Contact__c WHERE Email__c =: 'test.testcontact2@myemail.com' LIMIT 1].Id;
        DFEventTriggerMethods.getPartnerOrgs(dfContactId);
    }
}