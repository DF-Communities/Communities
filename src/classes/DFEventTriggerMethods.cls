/*
* 2014-03-23 : CSL : This class holds methods called from the DF_Event__c trigger.
*/

public without sharing class DFEventTriggerMethods extends DF_WEBC_RegisterBase_Handler {
    
    private static final Set<String> OPEN_REQUEST_STATUSES = new Set<String>{'Waiting for approval', 'Open - waiting for champion'};
    
    public class  DFEventTriggerException extends Exception{}
    
    public static final String CHAMPION_RT = 'Champion_Training_Course';
    public static final String SESSION_RT = 'Dementia_Friend_Awareness_Session';
    public static final String STATUS_CANCELLED = 'Cancelled';
    public static final String STATUS_NOSHOW = 'No Show';
    public static final String STATUS_ATTENDED = 'Attended';
    public static final String VF_CHAMPION_TRAINING_BOOKED = 'DF_Champion_Training_Booked_HTML';
    public static final String VF_CHAMPION_TRAINING_UNREGISTERED = 'DF_Champion_Training_Unregistered_HTML';
    public static final String VF_FRIEND_SESSION_BOOKING_CONFIRMED = 'DF_Friend_Session_Booking_Confirmed_HTML';
    public static final String VF_FRIEND_SESSION_CANCELLED = 'DF_Friend_Session_Cancelled_HTML';
    public static final String VF_NEW_ATTENDEE_ON_SESSION = 'DF_New_Attendee_On_Session_HTML';
    public static final String VF_NEW_INFORMATION_SESSIONS = 'VF_New_Information_Sessions';
    public static final String VF_SESSION_ATTENDEE_CANCELLATION = 'DF_Session_Attendee_Cancellation_HTML';
    public static final String VF_UPDATED_SESSION_INFORMATION = 'DF_Updated_Session_Information_HTML';
    public static final String EVENT_STATUS_UNSUCCESSFUL = 'Cancelled';
    public static final List<String> REQUEST_STATUS_UNSUCCESSFUL = new List<String>{'Withdrawn','Unsuccessful'};
    
    
    private static String sdt = Datetime.now().format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getDisplayName());
    private static Datetime dt = Datetime.valueOf(sdt);
    
    
    public static final String REQUESTED_INFO_SESSION_FIELDS = 'SELECT Id, RecordType_Name__c, Available_On_Website__c, Number_Of_Champions_Attended__c, ' +
        'RecordTypeId, Session_Organiser__c, City__c, Country__c, County__c, Name, Event_Date__c, ' +
        'Event_Date_Time__c, Event_Description__c, Event_End_Date__c, Event_End_Date_Time__c, Event_Status__c, ' + 
        'Hearing_loop_available__c, Number_Of_Attendee_Records__c, Number_of_Attendees__c, ' + 
        'Number_of_Places__c, Partner_Organisation__c, Postcode__c, Public_Event__c, ' + 
        'Request_Status__c, Street__c, Type_of_session__c, Wheel_Chair_Access__c, ' + 
        'Preference_1_Period__c, Preference_1_Date__c, Preference_1_Time__c, ' + 
        'Preference_2_Period__c, Preference_2_Date__c, Preference_2_Time__c, ' +
        'Preference_3_Period__c, Preference_3_Date__c, Preference_3_Time__c, ' +
        'Location_Geographic_Details__c, Session_Requester_Name__c, Session_Requester_Email__c ';
    
    public static Map<String, EmailTemplate> emailTemplateMap {get; set;}
    
    public static boolean isFutureRunning=false;
    
    //This method will send emails to all registered people if a DF_Event__c is CANCELLED or UPDATED
    public static void sendEmailNotifications(List<DF_Event__c> inEvents, Map<Id, DF_Event__c> oldEvents){
        
        
        emailTemplateMap = new Map<String, EmailTemplate>();
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for (EmailTemplate e : [select e.Id, e.DeveloperName from EmailTemplate e where e.IsActive = true and e.TemplateType = 'visualforce']){
            system.debug('*** -- Putting ' + e.DeveloperName + ' with ' + e.Id + ' -- ***');
            emailTemplateMap.put(e.DeveloperName, e);
        }
        
        
        // Map<Id, RecordType> rtMap = new Map<Id, RecordType>();
        Map<Id, DF_Event__c> dfEventMap = new Map<Id, DF_Event__c>();
        Set<Id> dfEventIdSet = new Set<Id>();
        
        /*   for (RecordType rt : [select r.Id, r.DeveloperName from RecordType r where r.SObjectType = 'DF_Event__c' and r.IsActive = true]){
rtMap.put(rt.Id, rt);
}*/
        
        for (DF_Event__c dfe : inEvents){
            dfEventIdSet.add(dfe.Id);
        }
        
        for (DF_Event__c dfe : [Select d.Id, d.Name, d.Event_Status__c, d.RecordTypeId, d.City__c, d.Comments__c, d.Country__c, d.County__c, d.Event_Date_Time__c, d.Event_Description__c, d.Location__c, d.Postcode__c,     
                                d.Session_Organiser__c, d.Session_Organiser__r.Name, d.Street__c, d.Total_Session_Hours__c, d.Wheel_Chair_Access__c, 
                                (Select Id, Name, DF_Contact__c, DF_Contact__r.Portal_Contact__c, DF_Contact__r.First_Name__c, DF_Contact__r.Last_Name__c, DF_Event__c, EventAttendeeStatus__c From DF_EventAttendees__r) 
                                From DF_Event__c d where d.Id in :dfEventIdSet]){
                                    dfEventMap.put(dfe.Id, dfe);
                                }
        
        //We now can process all DF_Events__c, and see if they are cancelled, or just updated
        for (DF_Event__c dfe : inEvents){
            DF_Event__c processEvent = dfEventMap.get(dfe.Id);
            DF_Event__c oldEvent = oldEvents.get(dfe.Id);
            boolean eventUpdated = false;
            DateTime dateTimeToday = system.now();
            
            if (STATUS_CANCELLED.equalsIgnoreCase(processEvent.Event_Status__c) && SESSION_RT.equalsIgnoreCase(DF_Utils.getDfEventRecordTypeIdMap().get(processEvent.RecordTypeId).DeveloperName)){
                
                if (processEvent.Event_Date_Time__c.getTime() >= dateTimeToday.getTime()){
                    cancelEvent(processEvent);
                }   
            }else if (SESSION_RT.equalsIgnoreCase(DF_Utils.getDfEventRecordTypeIdMap().get(processEvent.RecordTypeId).DeveloperName)) {
                //Event is not cancelled, so we need to check all fields to see if anything has changed
                if (oldEvent != null && processEvent.Event_Date_Time__c>= dateTimeToday){
                    if (processEvent.City__c != oldEvent.City__c) eventUpdated = true;
                    if (processEvent.Comments__c != oldEvent.Comments__c) eventUpdated = true;
                    if (processEvent.Country__c != oldEvent.Country__c) eventUpdated = true;
                    if (processEvent.County__c != oldEvent.County__c) eventUpdated = true;
                    if (processEvent.Event_Date_Time__c != oldEvent.Event_Date_Time__c) eventUpdated = true;
                    if (processEvent.Event_Description__c != oldEvent.Event_Description__c) eventUpdated = true;
                    if (processEvent.Location__c != oldEvent.Location__c) eventUpdated = true;
                    if (processEvent.Postcode__c != oldEvent.Postcode__c) eventUpdated = true;
                    if (processEvent.Session_Organiser__c != oldEvent.Session_Organiser__c) eventUpdated = true;
                    if (processEvent.Street__c != oldEvent.Street__c) eventUpdated = true;
                    if (processEvent.Total_Session_Hours__c != oldEvent.Total_Session_Hours__c) eventUpdated = true;
                    if (processEvent.Wheel_Chair_Access__c != oldEvent.Wheel_Chair_Access__c) eventUpdated = true;
                    
                    if (eventUpdated){
                        changedEvent(processEvent);
                    }
                }
            }   
        }
    }
    
    public static void cancelEvent(DF_Event__c inEvent){
        
        String ORG_WIDE_EMAIL_ADDRESS_ID = WEBC_CommunityWrapper.getOrgWideEmailId('DF');        
        String stubUrl = WEBC_CommunityWrapper.getCustomSetting('Stub_Url', 'DF');         
        
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        List<DF_EventAttendee__c> dfeSaveList = new List<DF_EventAttendee__c>();
        
        for (DF_EventAttendee__c dfe : inEvent.DF_EventAttendees__r){
            if (dfe.DF_Contact__r.Portal_Contact__c != null){
                
                
                String sDate = inEvent.Event_Date_Time__c.format('d MMMM YYYY');
                Map<String, String> mapValues = new Map<String, String>();
                mapValues.put('contact.First_Name__c', dfe.DF_Contact__r.First_Name__c);
                mapValues.put('contact.Last_Name__c', dfe.DF_Contact__r.Last_Name__c);
                mapValues.put('sessionLink', stubUrl + 'WebSession');
                mapValues.put('event.Session_Organiser__r.Name', inEvent.Session_Organiser__r.Name);
                mapValues.put('event.Event_Date_Time__c', sDate);
                
                Messaging.SingleEmailMessage sme = Mail_Utils.getEmailWithData(VF_FRIEND_SESSION_CANCELLED, 
                                                                               dfe.DF_Contact__r.Portal_Contact__c, 
                                                                               dfe.id, 
                                                                               ORG_WIDE_EMAIL_ADDRESS_ID, 
                                                                               false, 
                                                                               null, 
                                                                               mapValues);
                
                emailsToSend.add(sme);
                
            }
            
            if (!STATUS_ATTENDED.equalsIgnoreCase(dfe.EventAttendeeStatus__c) && 
                !STATUS_NOSHOW.equalsIgnoreCase(dfe.EventAttendeeStatus__c) &&
                !STATUS_CANCELLED.equalsIgnoreCase(dfe.EventAttendeeStatus__c)){
                    dfe.EventAttendeeStatus__c = STATUS_CANCELLED;
                    dfeSaveList.add(dfe);       
                }
        }
        
        if (emailsToSend.size() > 0){
            Messaging.sendEmail(emailsToSend);
        }
        
        if (dfeSaveList.size() > 0){
            update dfeSaveList;
        }
    }
    
    private static void changedEvent(DF_Event__c inEvent){
        
        String ORG_WIDE_EMAIL_ADDRESS_ID = WEBC_CommunityWrapper.getOrgWideEmailId('DF');       
        String stubUrl = WEBC_CommunityWrapper.getCustomSetting('Stub_Url', 'DF');     
        
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        for (DF_EventAttendee__c dfe : inEvent.DF_EventAttendees__r){
            if (dfe.DF_Contact__r.Portal_Contact__c != null){
                
                String sDate = inEvent.Event_Date_Time__c.format('d MMMM YYYY');
                Map<String, String> mapValues = new Map<String, String>();
                mapValues.put('contact.First_Name__c', dfe.DF_Contact__r.First_Name__c);
                mapValues.put('contact.Last_Name__c', dfe.DF_Contact__r.Last_Name__c);
                mapValues.put('sessionLink', stubUrl + 'WebSessionDetails?id=' + inEvent.id);
                mapValues.put('event.Event_Date_Time__c', sDate);
                mapValues.put('event.Location__c', inEvent.Location__c);                                            
                mapValues.put('event.Street__c', inEvent.Street__c);                                            
                mapValues.put('event.City__c', inEvent.City__c);                                            
                mapValues.put('event.County__c', inEvent.County__c);                                            
                mapValues.put('event.Postcode__c', inEvent.Postcode__c);   
                
                mapValues.put('event.Session_Organiser__r.Name', inEvent.Session_Organiser__r.Name);
                
                Messaging.SingleEmailMessage sme = Mail_Utils.getEmailWithData(VF_UPDATED_SESSION_INFORMATION, 
                                                                               dfe.DF_Contact__r.Portal_Contact__c, 
                                                                               dfe.id, 
                                                                               ORG_WIDE_EMAIL_ADDRESS_ID, 
                                                                               false, 
                                                                               null, 
                                                                               mapValues);
                
                emailsToSend.add(sme);
            }
        }
        
        if (emailsToSend.size() > 0){
            Messaging.sendEmail(emailsToSend);
        }
    }
    
    @future (callout=true)  // future method needed to run callouts from Triggers
    static public void sendEmailToMembers(set<id> dfEventIds){
        
        FutureHandler.setIsFutureRunning(true);
        
        map<id,DF_Event__c> dfEventMap=new map<id,DF_Event__c>([select id,Name,Event_Date_Time__c,Available_On_Website__c,Location_Geographic_Details__Latitude__s,Location_Geographic_Details__Longitude__s,Postcode__c 
                                                                from DF_Event__c where id IN :dfEventIds]);
        DF_Event__c sDFEvent;
        
        if(dfEventMap!=null && dfEventMap.size() > 0)
            sDFEvent=dfEventMap.values().get(0);
        
        String address='';
        if (sDFEvent != null){ 
            if(sDFEvent.Postcode__c!=null){
                address=sDFEvent.Postcode__c;
            }
            if((address!=null || address!='')){
                
                address = EncodingUtil.urlEncode(address, 'UTF-8');
                
                try{  
                    
                    if(sDFEvent.Location_Geographic_Details__Latitude__s==null && 
                       sDFEvent.Location_Geographic_Details__Longitude__s==null){
                           
                           Http h = new Http();
                           HttpRequest req = new HttpRequest();
                           req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCt8-YgkPglTjv7i7hWe01-M3JUZF1VshM&address='+address+'&sensor=false');
                           req.setMethod('GET');
                           req.setTimeout(60000);
                           
                           system.debug('Request http test'+req);
                           HttpResponse res = h.send(req);
                           system.debug('response http test'+res);
                           // parse coordinates from response
                           system.debug('resposnse get body method'+res.getBody());
                           JSONParser parser = JSON.createParser(res.getBody());
                           double lat = null;
                           double lon = null;
                           
                           while(parser.nextToken() != null){
                               if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                                   (parser.getText() == 'location')){
                                       parser.nextToken(); // object start
                                       while (parser.nextToken() != JSONToken.END_OBJECT){
                                           String txt = parser.getText();
                                           parser.nextToken();
                                           if (txt == 'lat')
                                               lat = parser.getDoubleValue();
                                           else if (txt == 'lng')
                                               lon = parser.getDoubleValue();
                                       }
                                       
                                   }
                           }
                           
                           system.debug('test address lat'+lat);
                           system.debug('test address long'+lon);
                           // update coordinates if we get back 
                           if (lat != null && lon!=null){
                               sDFEvent.Location_Geographic_Details__Latitude__s = lat;
                               sDFEvent.Location_Geographic_Details__Longitude__s = lon;
                               update sDFEvent;        
                           }    
                       }
                    
                    map<id,Saved_Search__c> savedSearchMap=new map<id,Saved_Search__c>
                        ([select id,Email__c,Geolocation__Latitude__s,Geolocation__Longitude__s,Post_Code__c,Range__c,Sent_Mail__c,Type__c from Saved_Search__c where Sent_Mail__c=False ]); 
                    
                    set<String> emailList=new set<String>();
                    list<Saved_Search__c> distanceList= new list<Saved_Search__c>();
                    for(Saved_Search__c sSavedSearch:savedSearchMap.values()){
                        
                        if(sSavedSearch.Geolocation__Latitude__s!=null && 
                           sSavedSearch.Geolocation__Longitude__s!=null && 
                           sDFEvent.Location_Geographic_Details__Latitude__s!=null && 
                           sDFEvent.Location_Geographic_Details__Longitude__s!=null){
                               
                               Double distanceVal=calculateDistance(Double.valueOf(sSavedSearch.Geolocation__Latitude__s),
                                                                    Double.valueOf(sSavedSearch.Geolocation__Longitude__s),
                                                                    Double.valueOf(sDFEvent.Location_Geographic_Details__Latitude__s),
                                                                    Double.valueOf(sDFEvent.Location_Geographic_Details__Longitude__s));
                               
                               System.debug('**** : '+distanceVal);
                               
                               if(distanceVal<=sSavedSearch.Range__c)
                               {
                                   if(!(emailList.contains(sSavedSearch.Email__c)))
                                   {
                                       emailList.add(sSavedSearch.Email__c);//Store the email list
                                       distanceList.add(sSavedSearch);
                                   }
                               } 
                               
                           }
                        
                    }//for ends
                    
                    list<string> FinalEmaillist = new list<string>();
                    FinalEmaillist.addAll(emailList);
                    System.debug('$$$$ : '+FinalEmaillist);
                    
                    //Send the emails to FinalEmaillist
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(FinalEmaillist);
                    mail.saveAsActivity = false;
                    mail.setSubject('Dementia Friend Awareness Session');
                    mail.setPlainTextBody('Hi ,According to your search ,The Event ' +sDFEvent.Name + ' is going to happen at '+sDFEvent.Postcode__c + ' postal area on '+sDFEvent.Event_Date_Time__c+ '. ' );
                    
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                    //change the email sent flag to sent
                    list<Saved_Search__c> emailsentlist= new list<Saved_Search__c>();
                    
                    for(Saved_Search__c savedsearch: distanceList)  
                    {
                        savedsearch.Sent_Mail__c = True;
                        emailsentlist.add(savedsearch); 
                    }//for ends
                    
                    update emailsentlist;//updates the records that recieved mail
                    
                }//try ends 
                
                catch (Exception e) {
                }
                
            }//address if ends
        }
    }//Method ends
    
    private static Double EARTH_RADIUS = 3963.167;//6371.00; // Radius in Kilometers default
    
    public static Double calculateDistance(Double lat1, Double lon1, Double lat2,   Double lon2){
        Double Radius = DFEventTriggerMethods.EARTH_RADIUS; //6371.00;
        Double dLat = DFEventTriggerMethods.toRadians(lat2-lat1);
        Double dLon = DFEventTriggerMethods.toRadians(lon2-lon1);            
        Double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(DFEventTriggerMethods.toRadians(lat1)) *   Math.cos(DFEventTriggerMethods.toRadians(lat2)) *
            Math.sin(dLon/2) * Math.sin(dLon/2);
        Double c = 2 * Math.asin(Math.sqrt(a));
        return Radius * c;        
    }
    
    public static Double toRadians(Double degree){
        // Value degree * Pi/180
        Double res = degree * 3.1415926 / 180;
        return res;  
    }
    
    @AuraEnabled
    public static Boolean submitEventFeedback(DF_Event__c dfEvent) {
        
        System.debug('In submitEventFeedback APEX');
        //DF_Event__c dfEvent = (DF_Event__c)JSON.serialize(dfEventAsStr);
        System.debug('dfEvent: ' + dfEvent);
        
        if (dfEvent.Champion_Feedback_Submitted__c || ( dfEvent.Number_of_Attendees__c != null && dfEvent.Number_of_Attendees__c > 0)) {
        	dfEvent.Event_Status__c = 'Completed';
        	dfEvent.Request_Status__c = 'Completed';
        }
        
        Database.SaveResult dsr = Database.update(dfEvent, true);
        if(dsr.isSuccess()) {
            return true;
        } else {
            System.debug(dsr.getErrors());
            return false;
        }
    }
    
    @AuraEnabled
    public static Map<String,String> createInfoSessionReqRecords(DF_Contact__c formContactData, 
                                                                 Demographic_information__c formDemographicData, 
                                                                 DF_Event__c formEventData, 
                                                                 Map<String,Boolean> formGdprPrefs,
                                                                 String dfContactId,
                                                                 String newUserPassword) 
        
    {
        System.debug('formGdprPrefs: '+formGdprPrefs);
        Map<String,Boolean> formGdprPrefObj = formGdprPrefs;
        System.debug('formGdprPrefs: '+formGdprPrefs.get('Email_Optin__c'));
        System.debug('We are in the createInfoSessionReqRecords');
        Map<String, String> outputMap = new Map<String, String>();
        
        // Create a savepoint so we can rollback if any of the three DML object inserts fail
        Boolean isRollbackRequired = false;
        Boolean isCommUserCreated = false;
        Savepoint sp = Database.setSavepoint(); 
        
        // First try to create the DF_Contact__c record (anonymous form submission) 
        // unless a contact Id has been provided (from submission from community)
        if(dfContactId=='' || dfContactId==null || dfContactId=='undefined') { // IS CONTACT AND COMMUNITY USER CREATION REQUIRED?
            formContactData.put('Created_As_Type__c', 'Info Session Requester'); 
            
            Database.SaveResult dfContactDsr;
            dfContactDsr = Database.insert(formContactData);
            if(dfContactDsr.isSuccess()){
                isCommUserCreated = true;
                dfContactId = dfContactDsr.getId();
                System.debug('=== DF Contact (' + dfContactId + ') created');
                outputMap.put('dfContactId', dfContactId);
                
                System.debug('formContactData: ' + formContactData);
                System.debug('formContactData.Email: ' + formContactData.Email__c);
                // Now create the Demographic_Information__c record from contact. NOTE: Cannot get portal contact Id from DF Contact as legacy code does this by future methods
                List<Contact> contactObj = [SELECT Id 
                                            FROM Contact
                                            WHERE Email =:formContactData.Email__c]; //get the Id of the Contact record that was created and use it to lnk the demographic record
                
                System.debug('contactObj: ' + contactObj);
                Id contactId = null;
                if(contactObj.size() != 1) {
                    isRollbackRequired = true;
                    throw new DFEventTriggerException('No portal contact was created from the dfContact creation process');
                } else {
                    contactId = contactObj[0].Id;
                }
                
                System.debug('Will associated Demographic record to the standard CONTACT sObject ID: ' + contactId);
                formDemographicData.Contact__c = contactId;
                
                Database.SaveResult demographicDsr;
                demographicDsr = Database.insert(formDemographicData);
                if(demographicDsr.isSuccess()){
                    System.debug('=== Demographic info created'); 
                    outputMap.put('dfContactDemographicId', demographicDsr.getId());
                } else {
                    isRollbackRequired = true;
                    throw new DFEventTriggerException(JSON.serialize(demographicDsr));
                    
                }
                
                // Now create the Indiivual record
                System.debug('Attempting to deserialize the Individual Object: ' + formGdprPrefs);
                
                /*GDPR gdprPref = new GDPR(Email_Optin__c = formGdprPrefs.get('Email_Optin__c'), 
                                         Phone_Optin__c = formGdprPrefs.get('Phone_Optin__c'), 
                                         SMS_Optin__c = formGdprPrefs.get('SMS_Optin__c'),
                                         Social_Media_Optin__c = formGdprPrefs.get('Social_Media_Optin__c'), 
                                         Post_Optout__c = formGdprPrefs.get('Post_Optout__c'));*/
                
                //Map<String, Boolean> formGdprPrefObj = (Map<String, Boolean>)JSON.deserialize(formGdprPrefs, Map<String, Boolean>.class);
                System.debug('formGdprPrefObj: '+formGdprPrefObj);
                System.debug('formGdprPrefObj.get: '+formGdprPrefObj.get('Email_Optin__c'));
                
                GDPR gdprPref = new GDPR(formGdprPrefObj.get('Email_Optin__c'), 
                                         formGdprPrefObj.get('Phone_Optin__c'), 
                                         formGdprPrefObj.get('SMS_Optin__c'),
                                         formGdprPrefObj.get('Social_Media_Optin__c'), 
                                         formGdprPrefObj.get('Post_Optout__c'));
                    
                gdprPref.populateIndvData(contactObj[0]);
                
                System.debug('Created individual instance of: ' + gdprPref);
    
            } else {
                isRollbackRequired = true;
                throw new DFEventTriggerException(JSON.serialize(dfContactDsr));
            }
        }     
        
        // Now create the DF_Event__c record
        
        // Get the default user
        Community_Settings__c[] defaultOrganiser = [SELECT Name, Value__c 
                                                    FROM Community_Settings__c
                                                    WHERE Name='DF_Placeholder_InfoSessionOrganiser'];
        Id placeholderOrganiserId;
        if(defaultOrganiser.size() == 0) {
            throw new DFEventTriggerException('Please create the DF_Placeholder_InfoSessionOrganiser setting in Community_Settings__c');
        } else {
            placeholderOrganiserId = defaultOrganiser[0].Value__c;
        }
        
        Database.SaveResult eventDsr = null;
        if(!isRollbackRequired) {
            System.debug('Attempting event creation');
            Id rtId = [SELECT Id
                       FROM RecordType
                       WHERE Name = 'Dementia Friend Information Session' ].Id;
            
            System.debug('rtId is: ' + rtId);
            formEventData.RecordTypeId = rtId;
            formEventData.Session_Requester__c = dfContactId;
            formEventData.Session_Organiser__c = placeholderOrganiserId; // The session organiser must be the friend initially
            
            // This is a hidden setting so bring attention to this easily overlooked property
            try{
                DF_Contact__c df = [SELECT Id FROM DF_Contact__c  WHERE Id = :placeholderOrganiserId]; 
            } catch(Exception e) {
                throw new DFEventTriggerException('Please set the Community custom settings, specifically the DF_Placeholder_InfoSessionOrganiser setting');
            }
            
            System.debug('Set most default values');
            formEventData.Request_Status__c = 'Waiting for approval';
            formEventData.Event_Status__c = 'Not Live / Approved';
            formEventData.Requested_Info_Session__c = true;
            System.debug('eventData to insert: ' + formEventData);
            eventDsr = Database.insert(formEventData, true);
            if(eventDsr.isSuccess()){
                System.debug('=== DF Event info created');
                outputMap.put('dfEventId', eventDsr.getId());
            } else {
                System.debug('=== DF Event insert errors: ' + eventDsr.getErrors());
                
                throw new DFEventTriggerException(JSON.serialize(eventDsr.getErrors()));
                
                isRollbackRequired = true;
                
            }
        }
        
        if(isRollbackRequired) {
            Database.rollback( sp );
        }
        
        System.debug('dsr.getErrors(): ' + !eventDsr.getErrors().isEmpty());
        if(!eventDsr.getErrors().isEmpty()) {
            outputMap.put('errors', JSON.serialize(eventDsr.getErrors()));
        } else if(eventDsr.isSuccess()) {
            // Send out the new user verification email (can only be performed after the savepoint)
            System.debug('Getting infoSessionObj about to get event id');
            System.debug('eventId: ' + outputMap.get('dfEventId'));
            DF_Contact__c requesterDetails = [SELECT Id, Name, Email__c, First_Name__c
                                              FROM DF_Contact__c
                                              WHERE Id = :dfContactId];
            System.debug('requesterDetails: ' + requesterDetails);
            if(isCommUserCreated) {
                String toAddress = requesterDetails.Email__c;
                String name = requesterDetails.First_Name__c;
                Contact contact=  DF_Utils.getContactRecordForDfcId(dfContactId); 
                String startPage = '/user-home';
                string var = '?cp=true';
                string startUrl='/change-password'+var;          
                
                new DF_Pure360_Email_Handler().sendAnonymousSessionRequestUserVerification(toAddress, name, contact, newUserPassword, startPage);
            } else if(!isCommUserCreated) {
                // Send out the session request confirmation email for logged in, existing community users
                new DF_Pure360_Email_Handler().sendFriendConfirmationOfNewInfoSessionRequest(requesterDetails.Email__c, requesterDetails.First_Name__c);  
            }
            
            // Send out the notification email to the DF admin shared mailbox
            new DF_Pure360_Email_Handler().sendAdminsNewSessionRequestNotification(outputMap.get('dfEventId'));  
        }
        return outputMap;
    }
    
    @AuraEnabled
    public static DF_Event__c getEventInfo(String eventId) {
        
        List<DF_Event__c> event = [SELECT Id, Name, Comments__c, Number_of_Attendees__c, Partner_Organisation__c  
                                   FROM DF_Event__c
                                   WHERE Id = :eventId];
        if(event.size()==1) {
            return event[0];
        } else {
            throw new DFEventTriggerException('Event with this ID could not be retrieved from Salesforce');
        }
    }
    
    @AuraEnabled
    public static ActiveUserInfo getSiteUserInfo(String userId, String eventId) {
        
        
        System.debug('userId: ' + userId);
        List<DF_Contact__c> siteUserData  = [SELECT c.Id, c.Portal_User__c, c.Portal_Contact__c, 
                                             c.Location__Latitude__s, c.Location__Longitude__s,
                                             c.Info_Session_Search_Radius__c, 
                                             c.Portal_User__r.Profile.UserLicense.Name,
                                             c.Record_Type_Name__c, c.Blocked_due_to_excessive_req_sessions__c,
                                             c.Admin_block_from_requesting_info_session__c, c.Partner_Organisation_ID__c, c.Partner_Organisation_ID__r.Name,
                                             (SELECT po.Id, po.Name, po.Partner_Organisation__c, po.Partner_Organisation__r.Name FROM PO_Administrators__r po),
                                             (SELECT ev.Id, ev.Name, ev.Session_Requester__c, ev.Champion_Feedback_Submitted__c, ev.Partner_Organisation__c,
                                                     ev.Host_Feedback_Submitted__c, ev.Requested_Info_Session__c, ev.Number_of_Attendees__c 
                                             FROM DF_Events__r ev  WHERE 
                                             (ev.Id =:eventId ) OR (
                                             ((ev.Requested_Info_Session__c = true AND ev.Request_Status__c NOT IN :REQUEST_STATUS_UNSUCCESSFUL ) OR (ev.Event_Status__c != :EVENT_STATUS_UNSUCCESSFUL) )  AND 
                                             (ev.Number_of_Attendees__c = null OR ev.Number_of_Attendees__c <= 0) AND
                                             (ev.Event_End_Date_Time__c <: dt AND ev.RecordTypeId = :DF_Utils.getsObjectRecordTypeId('DF_Event__c',SESSION_RT))
                                             ))
                                             FROM DF_Contact__c c
                                             WHERE c.Portal_User__c = :userId];
        
        List<DF_Event__c> existingEventData = new List<DF_Event__c>();
        Integer noRequestedEventsOpen = 0;
        if( String.isNotEmpty(eventId)) {
            existingEventData = [SELECT Session_Organiser__c, Session_Requester__c, Requested_Info_Session__c,
                                 Host_Feedback_Submitted__c, Champion_Feedback_Submitted__c, Number_of_Attendees__c,
                                 Partner_Organisation__c
                                 FROM DF_Event__c
                                 WHERE Id = :eventId];
            
            noRequestedEventsOpen = [SELECT Count() FROM DF_Event__c 
                                     WHERE Requested_Info_Session__c = true
                                     AND Request_Status__c IN :OPEN_REQUEST_STATUSES];
        } 
        
        Boolean isSfdcUser = false;
        System.debug('siteUserData: ' +siteUserData);
        if(siteUserData.size() != 1) {
            // The ID of the current user does not have corresponding Community Portal User. Therefore it is most likely an internal Salesforce user (DF Admin)
            isSfdcUser = true;
        } else {
            // Check none of the fields are null
            if(siteUserData[0].Location__Latitude__s ==null || siteUserData[0].Location__Longitude__s==null){
                if(siteUserData[0].Record_Type_Name__c == 'Dementia Champion') {
                    throw new DFEventTriggerException('Missing geo data for DF Contact');
                } 
                
            } else if(siteUserData[0].Info_Session_Search_Radius__c == null) {
                //throw new DFEventTriggerException('Missing search radius for DF Contact');
                // Always set the default to 10 miles unless a DF Champ has explicitly set it to otherwise
                siteUserData[0].Info_Session_Search_Radius__c = 10;
            }
        }
        
        
        // Create the output map
        ActiveUserInfo userInfo = new ActiveUserInfo(); 
        userInfo.userId = (isSfdcUser) ? userId : siteUserData[0].Portal_User__c;
        userInfo.portalContactId = (isSfdcUser) ? 'null' : siteUserData[0].Portal_Contact__c;
        userInfo.dfContactId = (isSfdcUser) ? 'null' : siteUserData[0].Id;
        
        userInfo.isChampion = (isSfdcUser) ? false : ((siteUserData[0].Record_Type_Name__c == 'Dementia Friend Champion') ? true : false);
            
            System.debug('isSfdcUser: ' + isSfdcUser);
        userInfo.tooManyOpenRequests = (isSfdcUser) ? false : siteUserData[0].Blocked_due_to_excessive_req_sessions__c;
        userInfo.blockSessionRequests = (isSfdcUser) ? false : siteUserData[0].Admin_block_from_requesting_info_session__c;
        userInfo.numExistingRequests = (isSfdcUser) ? 0 : noRequestedEventsOpen;

        if(siteUserData.size() > 0) {
            
        if(siteUserData[0].Record_Type_Name__c == 'Dementia Friend Champion') { //'All miles' is set to an arbitratily large value (i.e. 1000000)
            userInfo.eventSearchRadius = (isSfdcUser) ? 10000000 : Integer.valueOf(siteUserData[0].Info_Session_Search_Radius__c);
            userInfo.dfContactLat = (isSfdcUser) ? 0.0 : siteUserData[0].Location__Latitude__s;
            userInfo.dfContactLng = (isSfdcUser) ? 0.0 : siteUserData[0].Location__Longitude__s;
        }
        
        String userType = (isSfdcUser) ? 'Salesforce' : siteUserData[0].Portal_User__r.Profile.UserLicense.Name;
        userInfo.userType = userType; // Friend, champion or Salesforce (DF Admin) user
        
        if(userType=='Customer Community Login') {
            
            List<Id> associatedPartnerOrgs = new List<Id>();
            userInfo.partnerOrgList = new List<PartnerOrg>();
            if(!siteUserData[0].PO_Administrators__r.isEmpty()) {
                //userInfo.partnerOrgList = new List<PartnerOrg>();
                // User is attributed to a DF Org
                System.debug('Detected one or more partner orgs');
                for(PO_Administrator__c po : siteUserData[0].PO_Administrators__r) {
                    System.debug('Partner admin: ' + po.Name);
                    associatedPartnerOrgs.add(po.Id);
                    if (siteUserData[0].Partner_Organisation_ID__c != po.Partner_Organisation__c) {
                    	userInfo.partnerOrgList.add( new PartnerOrg(po));
                    }
                }
            }
            if (siteUserData[0].Partner_Organisation_ID__c != null && 
            				!siteUserData[0].Partner_Organisation_ID__r.Name.startsWithIgnoreCase('*General Public')) {
            	userInfo.partnerOrgList.add( new PartnerOrg(siteUserData[0].Partner_Organisation_ID__r));
            }
        }
        
        
        if( existingEventData != null && !existingEventData.isEmpty() ) {
           /* if(existingEventData.size() == 0) {
                throw new DFEventTriggerException('Error retrieving event corresponding to the supplied eventId');
                return null;
            }*/
            System.debug('Requester lookup as: ' + existingEventData[0].Session_Requester__c);
            System.debug('dfContact lookup as: ' + userInfo.dfContactId);
            userInfo.isRequester = (existingEventData[0].Session_Requester__c == userInfo.dfContactId) ? true : false;
            userInfo.isChampFdbackSubmitted = existingEventData[0].Champion_Feedback_Submitted__c ;
            userInfo.isHostFdbackSubmitted = existingEventData[0].Host_Feedback_Submitted__c;
            userInfo.isRequestedSession = existingEventData[0].Requested_Info_Session__c;

        }else {
            if (String.isNotEmpty(eventId))
            userInfo.isRequester = true;
        }

        UserInfo.unReportedEvents = new List<DFEvent>(); 
        for(DF_Event__c ev : siteUserData[0].DF_Events__r) {
            UserInfo.unReportedEvents.add( new DFEvent(ev, userInfo.dfContactId));
        }
        } else {
            if(!Test.isRunningTest()){
                throw new DFEventTriggerException('No site user data was returned');
            }
        }
        return userInfo;
    }
    
    public class ActiveUserInfo {
        @AuraEnabled public String userId {get;set;} 
        @AuraEnabled public String portalContactId {get;set;} 
        @AuraEnabled public String dfContactId {get;set;} 
        @AuraEnabled public Integer eventSearchRadius {get;set;} 
        @AuraEnabled public Decimal dfContactLng {get;set;} 
        @AuraEnabled public Decimal dfContactLat {get;set;} 
        @AuraEnabled List<String> partnerOrgs {get;set;}
        @AuraEnabled List<PartnerOrg> partnerOrgList {get;set;} 
        @AuraEnabled List<DFEvent> unReportedEvents {get;set;} 
        @AuraEnabled String userType {get;set;}
        @AuraEnabled Boolean isChampion {get;set;}
        @AuraEnabled Boolean isRequester {get;set;}
        @AuraEnabled Boolean isRequestedSession {get;set;}
        @AuraEnabled Boolean isChampFdbackSubmitted {get;set;}
        @AuraEnabled Boolean isHostFdbackSubmitted {get;set;}
        @AuraEnabled Integer numExistingRequests {get;set;}
        @AuraEnabled Boolean blockSessionRequests {get;set;}
        @AuraEnabled Boolean tooManyOpenRequests {get;set;}
        
    }
    
    public class PartnerOrg {
        @AuraEnabled public String name {get;set;} 
        @AuraEnabled public String recordId {get;set;} 
        
        public PartnerOrg(Partner_Organisation__c po) {
        	this.name = po.Name;
            this.recordId = po.Id;
        }
        public PartnerOrg(PO_Administrator__c po) {
        	this.name = po.Partner_Organisation__r.Name;
            this.recordId = po.Partner_Organisation__c;
        }
    }
    
    public class DFEvent {
        @AuraEnabled public String name {get;set;} 
        @AuraEnabled public String recordId {get;set;} 
        @AuraEnabled public String partnerOrgId {get;set;}
        @AuraEnabled public Decimal nbrOfAttendees {get;set;}
        @AuraEnabled Boolean isRequester {get;set;}
        @AuraEnabled Boolean isRequestedSession {get;set;}
        @AuraEnabled Boolean isChampFdbackSubmitted {get;set;}
        @AuraEnabled Boolean isHostFdbackSubmitted {get;set;}
        @AuraEnabled Boolean isFirstSubmission {get;set;}
        
        public DFEvent(DF_Event__c ev, Id requesterId) {
            this.name = ev.name;
            this.recordId = ev.id;
            this.partnerOrgId = ev.Partner_Organisation__c;
            this.nbrOfAttendees = ev.Number_of_Attendees__c;
            this.isRequester = (ev.Session_Requester__c == requesterId) ? true : false; //depricated
            this.isChampFdbackSubmitted = ev.Champion_Feedback_Submitted__c ;
            this.isHostFdbackSubmitted = ev.Host_Feedback_Submitted__c;
            this.isRequestedSession = ev.Requested_Info_Session__c;
            this.isFirstSubmission = (ev.Number_of_Attendees__c  == null || ev.Number_of_Attendees__c <= 0);
        }
    }
    
    @AuraEnabled
    public static Boolean updateInfoSession(Id dfEventId, String eventDateStr,
                                            String eventStartTime, String eventEndTime,
                                            Id championId) 
    {        
        DF_Event__c eventToUpdate = [SELECT Event_End_Date__c, Event_End_Date_Time__c, Trainer__c,
                                     Session_Organiser__c, Event_Status__c, Request_Status__c
                                     FROM DF_Event__c
                                     WHERE Id = :dfEventId];
        if (eventToUpdate.Request_Status__c != 'Open - waiting for champion') {
        	throw new DFEventTriggerException('Event has already assigned to someone. Please contact the administrator.');
        }
        eventToUpdate.Event_Date_Time__c = Datetime.valueOf(eventDateStr + ' ' + eventStartTime + ':00');
        eventToUpdate.Event_End_Date_Time__c = Datetime.valueOf(eventDateStr + ' ' + eventEndTime + ':00');                                    
        eventToUpdate.Session_Organiser__c = championId;
        eventToUpdate.Trainer__c  = championId;
        eventToUpdate.Event_Status__c = 'Available';
        eventToUpdate.Request_Status__c = 'Matched with champion';           
        Database.SaveResult dsr = Database.update(eventToUpdate);   
        if(dsr.isSuccess()){
            return true;
        } else {
            return false;
        }   
    }
    
    @AuraEnabled
    public static Map<String, String> getEnvironmentDomains() {
        
        Map<String, String> valueMap = new Map<String, String>();
        
        // Get domains for insertion in javascript postMessage() API calls (overcomes cross-domain policy)
        String communityUrl = [SELECT Value__c 
                               FROM Community_Settings__c
                               WHERE Name='DF_Stub_Url'].Value__c;
        
        List<String> globalSettingCsNames = new List<String>{'DF_VisualforceOriginHostDomain','DF_LightningOriginHostDomain'};
            List<Community_Settings__c> originHosts = [SELECT Name, Value__c 
                                                       FROM Community_Settings__c 
                                                       WHERE Name IN :globalSettingCsNames];
        
        for(Community_Settings__c setting : originHosts) {
            
            if(setting.Name == 'DF_VisualforceOriginHostDomain') {
                valueMap.put('vfCmpOriginDomain',setting.Value__c);
            } else if(setting.Name == 'DF_LightningOriginHostDomain') {
                valueMap.put('ltngCmpOriginDomain',setting.Value__c);
            }
        }
        
        valueMap.put('communityDomain',communityUrl.split('https://')[1]);
        
        return valueMap;
    }
    
    @AuraEnabled
    public static String getEventSessionViewDetails(String eventId) {
    	
        System.debug('eventId: ' + eventId);
        String queryStr = REQUESTED_INFO_SESSION_FIELDS + ' FROM DF_Event__c WHERE ID = :eventId';
        System.debug('queryStr: ' + queryStr);
        List<DF_Event__c> event = Database.query(queryStr); 
        
        if(event.size() != 1) {
            throw new DFEventTriggerException('Event could not be found. Please contact the administrator.');
        } 
        return JSON.serialize(event[0]);
    }
    
    @AuraEnabled
    public static String searchRequestedSessions(Integer searchRadius, Id dfContactId, Decimal dfContactLat, 
                                                 Decimal dfContactLng, String fromDateStr, String toDateStr, 
                                                 String sessionType, Decimal pageNumber, Decimal recordsToDisplay) 
    {
        
        /*
         * Date calculations have offsets applied to the days as the 
         * logical operators that can be used in SOQL are limited to "<" and ">"
        */
        Date toDate = null;
        Date fromDate = null;
        if(fromDateStr!=null){
            List<String> dateElements = fromDateStr.split('-');
            fromDate = Date.valueOf(fromDateStr);
            //fromDate = fromDate.addDays(-1);
        }
        
        if(toDateStr!=null){
            List<String> dateElements = toDateStr.split('-');
            toDate = Date.valueOf(toDateStr);
           // toDate = toDate.addDays(1);
        }
        
        
        // Format the input parameters
        // TODO required?
        System.debug('In searchRequestedSessions');
        System.debug('In searchRadiusStr: ' + searchRadius);
        System.debug('In fromDate: ' + fromDate);
        System.debug('In toDate: ' + toDate);
        System.debug('In sessionType: ' + sessionType);
        System.debug('In pageNumber: ' + pageNumber);
        System.debug('In recordsToDisplay: ' + recordsToDisplay);
        
        
        Integer offset = Integer.valueOf((Integer.valueOf(pageNumber) - 1) * recordsToDisplay);
        // create a instance of wrapper class.
        ReqSessionPagerWrapper obj =  new ReqSessionPagerWrapper();
        // set the pageSize,Page(Number), total records and accounts List(using OFFSET)   
        obj.pageSize = Integer.valueOf(recordsToDisplay);
        obj.page = Integer.valueOf(pageNumber);
        
        String countBaseQuery = 'SELECT count() FROM DF_Event__c ';
        
        String commonFilter =  'WHERE RecordType_Name__c = \'Dementia Friend Information Session\' ' +
            'AND Session_Requester__c != \'' + dfContactId + '\' ' + 
            'AND Request_Status__c = \'Open - waiting for champion\' ';  
        String dateAndSessionTypeFilters = '';
        
        if (fromDate != null && toDate != null) {
            dateAndSessionTypeFilters += 'AND ( (Preference_1_Date__c != null AND Preference_1_Date__c >= :fromDate AND Preference_1_Date__c <= :toDate) OR ' +
            								   '(Preference_2_Date__c != null AND Preference_2_Date__c >= :fromDate AND Preference_2_Date__c <= :toDate) OR ' + 
            								   '(Preference_3_Date__c != null AND Preference_3_Date__c >= :fromDate AND Preference_3_Date__c <= :toDate) ) ';
        }
        
        
        if (sessionType != '') {
            dateAndSessionTypeFilters += 'AND Type_of_session__c = \'' + sessionType + '\'';
        }
        
        String distQuery = '';
        if(dfContactLat != null && dfContactLng != null && searchRadius != null) {
            distQuery += ' AND DISTANCE(Location_Geographic_Details__c, GEOLOCATION(' + dfContactLat + ', ' + dfContactLng + '),\'mi\') < ' + searchRadius + ' ' ; 
        }
        
        String recordMaxLimit = '';
        if(dateAndSessionTypeFilters == '') {
            //If no filters are applied apply the max record retuened limit
            recordMaxLimit += ' LIMIT 10000';
        }
        
        String completeCountQuery = countBaseQuery + commonFilter + dateAndSessionTypeFilters + distQuery + recordMaxLimit;
        System.debug('Final count query: ' + completeCountQuery);
        Integer numEventsFound = Database.countQuery(completeCountQuery);
        System.debug('numEventsFound: ' + numEventsFound);
        obj.total = numEventsFound;
        
        String recordFieldsBaseQuery = REQUESTED_INFO_SESSION_FIELDS + ' FROM DF_Event__c ';

        // Order the results based on search parameters
        String recordOrdering = '';
        if(fromDate != null || toDate != null || sessionType != null) {
            recordOrdering += 'ORDER BY Event_Date__c ';
        } else if(dfContactLat != null && dfContactLng != null) {
            recordOrdering += 'ORDER BY DISTANCE(Location_Geographic_Details__c, GEOLOCATION(' + dfContactLat + ', ' + dfContactLng + '),\'mi\') ';
        }
        
        String resultsOffSet = '';
        if(offset != 0) {
            resultsOffSet += ' OFFSET ' + offset;
        }        
        
        // Modify the limit statement to show the number of records per page
        if(recordsToDisplay > 0) {
            recordMaxLimit = ' LIMIT ' + Integer.valueOf(recordsToDisplay); 
        }
        
        String completeRecordQuery = recordFieldsBaseQuery  + commonFilter + dateAndSessionTypeFilters + distQuery + recordOrdering + recordMaxLimit + resultsOffSet;
        System.debug('Full search query is: ' + completeRecordQuery);
        obj.events = Database.query(completeRecordQuery);
        System.debug('Returning obj: ' + obj);
                
        return JSON.serialize(obj);
        
    } 
    
    // create a wrapper class with @AuraEnabled Properties    
    public class ReqSessionPagerWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public List<DF_Event__c> events {get;set;}
    }
    
    /*
* Get parner orgs that the given DF Contact is a member of
*/
    @AuraEnabled
    public static List<Map<String, String>> getPartnerOrgs(Id dfContactId) {
        
        List<Map<String,String>> memberOrgsMapList = new List<Map<String,String>>();
        List<PO_Administrator__c> memberOrgs = [SELECT DF_Contact__c, Partner_Organisation__c, Partner_Organisation__r.Name  
                                                FROM PO_Administrator__c 
                                                WHERE DF_Contact__c = :dfContactId];
        
        for(PO_Administrator__c po : memberOrgs) {
            
            Map<String,String> valueMap = new Map<String,String>();
            valueMap.put('Name', po.Partner_Organisation__r.Name);
            valueMap.put('Id', po.Partner_Organisation__c);
            memberOrgsMapList.add(valueMap);
            
        }
        
        return memberOrgsMapList;
        
    }
    
}