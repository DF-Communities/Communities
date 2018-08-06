public without sharing class WEBSession extends WEBController {
    
    public final String ID_PARAM = 'Id';
    public final String RT_AWARENESS_SESSION = 'Dementia_Friend_Awareness_Session';
    public final String RT_CHAMPION_TRAINING = 'Champion_Training_Course';
    public final String RT_REGISTRATION = 'Registration';
    public final String RT_DEMENTIA_FRIEND = 'Dementia_Friend';
    public final String RT_DEMENTIA_FRIEND_CHAMPION = 'Dementia_Friend_Champion';
    public final String SAVED_SEARCH_TYPE_SESSION = 'Session';
    public final String SAVED_SEARCH_TYPE_TRAINING = 'Training';    
    public final String STATUS_AVAILABLE = 'Available';
    public final String MATCHED_WITH_CHAMP = 'Matched with champion';
    public final String STATUS_FULL = 'Full';
    public final String STATUS_COMPLETED = 'Completed';
    public final String STATUS_CANCELLED = 'Cancelled';
    public List<EventWrapper> eventList {get;set;}  
    public Map<Id, EventWrapper> eventMap {get; set;}
    public EventWrapper selectedEvent {get; set;}
    public integer placesLeft {get; set;}
    public boolean isLoggedIn {get; set;}
    public Map<String, RecordType> recordTypeMap {get; set;}
    public Map<String, RecordType> contactRecordTypeMap {get; set;}
    public String searchPostCode {get; set;}
    public String searchRange {get; set;}
    public boolean isChampion {get; set;}
    public boolean isChampionConverted {get; set;}
    public boolean isFriend {get; set;}
    public boolean isFriendConverted {get; set;}
    public boolean isRegistered {get; set;}
    public boolean isAlreadyBooked {get; set;}
    public boolean hasOtherBooking {get; set;}
    public boolean eventClosed {get; set;}
    public DF_EventAttendee__c attendanceRecord {get; set;}
    public DF_Contact__c loggedInDFContact {get; set;}
    public User loggedInUser {get; set;}
    public Saved_Search__c savedSearch {get; set;}
    public boolean showUnavailable {get; set;}
    //Fields for the Save Search
    public String saveSearchEmail {get; set;}
    public String saveSearchPostcode {get; set;}
    public String saveSearchRange {get; set;}
    public Integer tempNumber {get; set;}
    public String sessId {get; set;}

    // RS 17-May-2014 New fields for pagination   
    public Integer noOfRecords {get;set;}
   //google tracking 

   public String userType{get;set;}

    public Integer recordsPerPage {
        get {
            if (recordsPerPage == null)
                recordsPerPage = 10;
            return recordsPerPage;
        }
        set;
    }
    public Integer startRecord {
        get {
            if (startRecord == null)
                startRecord = 0;
            return startRecord;
        }
        set;
    }
    public PageReference nextPage() {
        startRecord += recordsPerPage;
        if (startRecord > noOfRecords)
            startRecord = startRecord - recordsPerPage;
        return applyFilter();
    }
    public PageReference previousPage() {
        startRecord = startRecord - recordsPerPage;
        if (startRecord < 0)
            startRecord = 0;
        return applyFilter();
    }  
    public PageReference changeRecordsPerPage() {
        startRecord = 0;
        return applyFilter();
    }
    // RS

    public boolean showSuccess {
        get {
            if (showSuccess == null){
                showSuccess = false;
            }
            return showSuccess;
        }
        set;
    }

    public Page_Snippet__c saveSearchSnippet {
        get {
            if (saveSearchSnippet == null){
                saveSearchSnippet = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'savesearchsnippet' LIMIT 1];
            }
            return saveSearchSnippet;
        }
        set ;
    }
    //Change-00988 06/07/2016
    public string noRecords = 'Sorry, there are currently no Sessions matching that criteria - please amend your search. Alternatively you can become a Dementia Friend by watching our online video ';
    public string noRecordsText {get;set;}
    //Change-01013
    
        
    public WEBSession(){

        // RS 17-May-2014 Initialise Variables
        showUnavailable = FALSE;
        searchPostCode = '';
        searchRange = '';
        
        // RS

        sessId = UserInfo.getSessionId();

        //Get record types
        tempNumber = 5;
        recordTypeMap = new Map<String, RecordType>();
        contactRecordTypeMap = new Map<String, RecordType>();
        
        system.debug('*** -- Into Constructor -- ***');
        for (RecordType rt : [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Event__c']){
            recordTypeMap.put(rt.DeveloperName, rt);
        }
        system.debug('*** -- Got DF_Event__c record types -- ***');
        
        for (RecordType rt : [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Contact__c']){
            contactRecordTypeMap.put(rt.DeveloperName, rt);
        }
        
        system.debug('*** -- Got record types -- ***');
        isRegistered = false;
        isFriend = false;
        isFriendConverted = false;
        isChampion = false;
        isChampionConverted = false;
        isLoggedIn = false;
        hasOtherBooking = false;
        eventClosed = false;
        system.debug('*** -- Checked for Logged In -- ***');
        if (WEBController.isLoggedIn){
                isLoggedIn = true;
                loggedInUser = [select u.Id, u.ContactId from User u where u.Id = :UserInfo.getUserId() LIMIT 1];
                loggedInDFContact = [Select d.Portal_Contact__c, d.Id, d.RecordTypeId, d.Session_Code_Verified__c, d.Code_Verefied__c From DF_Contact__c d where d.Portal_Contact__c = :loggedInUser.ContactId LIMIT 1];
                
                if (loggedInDFContact != null){
                    RecordType rtRegistration = contactRecordTypeMap.get(RT_REGISTRATION);
                    RecordType rtFriend = contactRecordTypeMap.get(RT_DEMENTIA_FRIEND);
                    RecordType rtChampion = contactRecordTypeMap.get(RT_DEMENTIA_FRIEND_CHAMPION);
                    
                    isFriend = WEBConversionClass.isFriend(loggedInUser.ContactId);
                    isFriendConverted = WEBConversionClass.isFriendConverted(loggedInUser.ContactId);
                    isChampion = WEBConversionClass.isChampion(loggedInUser.ContactId);            
                    isChampionConverted = WEBConversionClass.isChampionConverted(loggedInUser.ContactId);      
                    //google tracking QP-2 used on webSessiondetails page  
                    userType =(isFriend==true?'df_standard':'df_champion');
                    List<DF_EventAttendee__c> dfeAttendeeList = new List<DF_EventAttendee__c>();
                    dfeAttendeeList = [select d.Id from DF_EventAttendee__c d where d.DF_Contact__c = :loggedInDFContact.Id and d.DF_Event__r.RecordTypeId = :recordTypeMap.get(RT_AWARENESS_SESSION).Id];
                    if (dfeAttendeeList.size() > 0){
                        hasOtherBooking = true;
                    }
                }
        }
        
        eventList = new List<EventWrapper>();
        eventMap = new Map<Id, EventWrapper>();
        
        //This will be changed for the WEBTraining code - see other Record Types above
        String rtId = recordTypeMap.get(RT_AWARENESS_SESSION).Id;
        system.debug('*** -- Build Event List -- ***');
        
        // RS 17-May-2014 Count the records first
        List<DF_Event__c> eventCount = [Select Id,
                                (Select Name, DF_Contact__c, DF_Event__c From DF_EventAttendees__r) 
                                From DF_Event__c d 
                                where d.Public_Event__c = true 
                                and d.RecordTypeId = :rtId
                                and d.Event_Date_Time__c >= today
                                //and (d.Event_Status__c = :STATUS_AVAILABLE or d.Event_Status__c = :STATUS_COMPLETED)
                                and 
                                ( (d.Requested_Info_Session__c = false and d.Event_Status__c = :STATUS_AVAILABLE) or
                                  (d.Requested_Info_Session__c = true and d.Request_Status__c = :MATCHED_WITH_CHAMP)
                                )
                                ORDER BY d.Event_Date_Time__c ASC];

        noOfRecords = eventCount.size();
        eventCount.clear(); 
        // RS

        //2014-04-14 : CSL : We need to change the WHERE clause from Available_on_Website = true to Public_Event = true
        // RS 17-May-2017 Added LIMIT and OFFSET
        for (DF_Event__c dfe : [Select d.Wheel_Chair_Access__c, d.Total_Session_Hours__c, d.Street__c, d.Session_Organiser__c, d.RecordType_Name__c, d.RecordTypeId, d.Public_Event__c, d.Postcode__c, 
                                d.Number_of_Places__c, d.Number_of_Attendees__c, d.Number_of_Attendee_Records__c, d.Name, d.Location__c, d.Id, d.Event_Status__c, d.Event_Ext_Id__c, d.Event_Description__c, d.Event_Date_Time__c, 
                                d.Event_End_Date_Time__c, d.County__c, d.Country__c, d.Comments__c, d.City__c, d.Available_On_Website__c, d.Session_Organiser__r.Name,
                                (Select Name, DF_Contact__c, DF_Event__c From DF_EventAttendees__r) 
                                From DF_Event__c d where d.Public_Event__c = true 
                                and d.RecordTypeId = :rtId
                                and d.Event_Date_Time__c >=:system.now()
                                //and (d.Event_Status__c = :STATUS_AVAILABLE or d.Event_Status__c = :STATUS_COMPLETED)
                                and 
                                ( (d.Requested_Info_Session__c = false and d.Event_Status__c = :STATUS_AVAILABLE) or
                                  (d.Requested_Info_Session__c = true and d.Request_Status__c = :MATCHED_WITH_CHAMP)
                                )
                                ORDER BY d.Event_Date_Time__c ASC
                                LIMIT :recordsPerPage 
                                OFFSET :startRecord]){
                                    //system.debug('*** -- ' + dfe.Id + ' Event Date Time = ' + dfe.Event_Date_Time__c + ' -- ***');
                                    eventList.add(new EventWrapper(dfe));
                                    eventMap.put(dfe.Id, new EventWrapper(dfe));
        }
        
        system.debug('*** -- Do we have a Page Parameter -- ***');
        
        if (ApexPages.currentPage().getParameters().get(ID_PARAM) != null){
            system.debug('*** -- Get current page parameter -- ***');
            system.debug('*** -- page param = ' + ApexPages.currentPage().getParameters().get(ID_PARAM) + ' -- ***');
            selectedEvent = eventMap.get(ApexPages.currentPage().getParameters().get(ID_PARAM));
            //system.debug('*** -- selectedEvent = ' + selectedEvent.theEvent.Id + ' -- ***');
            //2014-05-21 : CSL : The number of places now needs to be calculated differently, NOT looking at Number_of_Attendees__c
            if (selectedEvent != null){
                
                if (selectedEvent.theEvent.Number_of_Places__c != null){
                    integer attendees = selectedEvent.theEvent.DF_EventAttendees__r.size();
                    system.debug('*** -- attendees = ' + attendees + ' -- ***');
                    //integer attendees = (selectedEvent.theEvent.Number_of_Attendees__c == null ? 0 : integer.valueOf(selectedEvent.theEvent.Number_of_Attendees__c));
                    placesLeft = integer.valueOf(selectedEvent.theEvent.Number_of_Places__c) - attendees;
                    system.debug('*** -- placesLeft = ' + placesLeft + ' -- ***');
                }
                system.debug('*** -- Are we logged in -- ***');
                if (isLoggedIn){
                    system.debug('*** -- Logged In -- ***');
                    if (isFriend){
                        system.debug('*** -- isFriend -- ***');
                        for (DF_EventAttendee__c attendee : selectedEvent.theEvent.DF_EventAttendees__r){
                            if (attendee.DF_Contact__c == loggedInDFContact.Id){
                                system.debug('*** -- isAlreadyBooked -- ***');
                                isAlreadyBooked = true;
                                hasOtherBooking = false;
                                attendanceRecord = attendee;
                                break;
                            }   
                        }
                    }
                }
            }else {
                //We have to allow for Completed / Full events to be viewed
                DF_Event__c nonAvailableEvent = [Select d.Wheel_Chair_Access__c, d.Total_Session_Hours__c, d.Street__c, d.Session_Organiser__c, d.RecordType_Name__c, d.RecordTypeId, d.Public_Event__c, d.Postcode__c, 
                                                d.Number_of_Places__c, d.Number_of_Attendees__c, d.Number_of_Attendee_Records__c, d.Name, d.Location__c, d.Id, d.Event_Status__c, d.Event_Ext_Id__c, d.Event_Description__c, d.Event_Date_Time__c, 
                                                d.Event_End_Date_Time__c, d.County__c, d.Country__c, d.Comments__c, d.City__c, d.Available_On_Website__c, d.Session_Organiser__r.Name,
                                                (Select Name, DF_Contact__c, DF_Event__c From DF_EventAttendees__r) 
                                                From DF_Event__c d where d.Id = :ApexPages.currentPage().getParameters().get(ID_PARAM) LIMIT 1];
                                                
                if (nonAvailableEvent != null){
                    system.debug('*** -- Found nonAvailableEvent -- ***');
                    if (!STATUS_AVAILABLE.equalsIgnoreCase(nonAvailableEvent.Event_Status__c)){
                        eventClosed = true;
                    }
                    // RS 17-May-2014 DF_LIVE54
                    if (nonAvailableEvent.Number_of_Places__c != null){
                        //integer attendees = nonAvailableEvent.DF_EventAttendees__r.size();
                        integer attendees = (nonAvailableEvent.Number_of_Attendee_Records__c == null ? 0 : integer.valueOf(nonAvailableEvent.Number_of_Attendee_Records__c));
                        system.debug('*** -- attendees = ' + attendees + ' -- ***');
                        //integer attendees = (selectedEvent.theEvent.Number_of_Attendees__c == null ? 0 : integer.valueOf(selectedEvent.theEvent.Number_of_Attendees__c));
                        placesLeft = integer.valueOf(nonAvailableEvent.Number_of_Places__c) - attendees;
                        system.debug('*** -- placesLeft = ' + placesLeft + ' -- ***');
                    }
                    // RS DF_LIVE54
                    system.debug('*** -- About to wrap the event -- ***');
                    selectedEvent = new EventWrapper(nonAvailableEvent);
                }
                if (selectedEvent != null){
                     if (isLoggedIn){
                        system.debug('*** -- Logged In -- ***');
                        if (isFriend){
                            system.debug('*** -- isFriend -- ***');
                            for (DF_EventAttendee__c attendee : selectedEvent.theEvent.DF_EventAttendees__r){
                                if (attendee.DF_Contact__c == loggedInDFContact.Id){
                                    system.debug('*** -- isAlreadyBooked -- ***');
                                    isAlreadyBooked = true;
                                    hasOtherBooking = false;
                                    attendanceRecord = attendee;
                                    break;
                                }   
                            }
                        }
                    }
                }
                                                
            }
        }
        
        system.debug('*** -- isLoggedIn = ' + isLoggedIn + ' -- ***');
        system.debug('*** -- isFriend = ' + isFriend + ' -- ***');
        system.debug('*** -- eventClosed = ' + eventClosed + ' -- ***');
        
    }
    
    public PageReference saveSearch(){
        system.debug('*** -- Calling saveSearch -- ***');
        
        PageReference pageRef;
        
        saveSearchRange = searchRange;
        saveSearchPostcode = searchPostCode;
        
        savedSearch = new Saved_Search__c();
        savedSearch.Type__c = SAVED_SEARCH_TYPE_SESSION;
        savedSearch.Email__c = saveSearchEmail;
        savedSearch.Post_Code__c = saveSearchPostcode;
        savedSearch.Range__c = double.valueOf(saveSearchRange);
        
        insert savedSearch;
        
        showSuccess = true;
        saveSearchEmail = '';
        saveSearchRange = '';
        saveSearchPostcode = '';
        searchRange = '';
        searchPostCode = '';
        
        return null;
    }
    
    public PageReference bookOnSession(){
        //2014-05-21 : CSL : This method now no longer needs to increase the 
        //Number_of_Attendees__c field, as this is a field used by the Champions
        //to report on their own sessions.
        //This will also need a change to calculate the number of places left, to display on the web site
        system.debug('*** -- Calling bookOnSession -- ***');
        isAlreadyBooked =true;
        PageReference pageRef;
        
        DF_EventAttendee__c attendanceRecord = new DF_EventAttendee__c();
        attendanceRecord.DF_Contact__c = loggedInDFContact.Id;
        attendanceRecord.DF_Event__c = selectedEvent.theEvent.Id;
        
        system.debug('*** -- Insert record -- ***');
        
        insert attendanceRecord;
        
        
        
        
        //2014-05-21 : CSL : This code is no longer needed
        /*
        if (selectedEvent.theEvent.Number_of_Attendees__c == null){
            selectedEvent.theEvent.Number_of_Attendees__c = 0;
        }
        
        if (selectedEvent.theEvent.Number_of_Attendees__c == selectedEvent.theEvent.Number_of_Places__c){
            //Do we want to save this record?
            
        }else if (selectedEvent.theEvent.Number_of_Attendees__c < selectedEvent.theEvent.Number_of_Places__c){
            selectedEvent.theEvent.Number_of_Attendees__c = selectedEvent.theEvent.Number_of_Attendees__c + 1;  
        }
        
        
        update selectedEvent.theEvent;
        */      
        pageRef = Page.WEBFriend;
        pageRef.getParameters().put('bs','true');
        //google tracking QP-3
        pageRef.getParameters().put('info_session_booked','true');
        pageRef.setRedirect(true);
        
        return pageRef;    
    }
    
    public PageReference removeFromSession(){
        system.debug('*** -- Calling removeFromSession -- ***');
        
        PageReference pageRef;
        
        system.debug('*** -- Delete the record -- ***');
        delete attendanceRecord;
        
        //2014-05-21 : CSL : As in the bookOnSession method, this code is no longer needed
        /*
        if (selectedEvent.theEvent != null){
            if (selectedEvent.theEvent.Number_of_Attendees__c == null || selectedEvent.theEvent.Number_of_Attendees__c == 0){
                selectedEvent.theEvent.Number_of_Attendees__c = 0;
            }else {
                if (selectedEvent.theEvent.Number_of_Attendees__c == null){
                    selectedEvent.theEvent.Number_of_Attendees__c = 0;
                }
                selectedEvent.theEvent.Number_of_Attendees__c = selectedEvent.theEvent.Number_of_Attendees__c -1;   
            }
            update selectedEvent.theEvent;
            
        }else {
            system.debug('*** -- No Selected Event -- ***');
        }
        */      
        pageRef = Page.WEBFriend;
        pageRef.getParameters().put('ub','true');
        pageRef.setRedirect(true);
        
        return pageRef;    
    }  
    
    public PageReference applyFilter(){
        
        noRecordsText='';
        String rtId = recordTypeMap.get(RT_AWARENESS_SESSION).Id;
        String queryString = 'Select d.Wheel_Chair_Access__c, d.Total_Session_Hours__c, d.Street__c, d.Session_Organiser__c, d.RecordType_Name__c, d.RecordTypeId, d.Public_Event__c, d.Postcode__c, ';
        queryString += 'd.Number_of_Places__c, d.Number_of_Attendees__c, d.Name, d.Location__c, d.Id, d.Event_Status__c, d.Event_Ext_Id__c, d.Event_Description__c, d.Event_End_Date_Time__c, d.Event_Date_Time__c, d.County__c, d.Country__c, d.Comments__c, ';
        queryString += 'd.City__c, d.Available_On_Website__c, d.Session_Organiser__r.Name From DF_Event__c d where d.Public_Event__c = true and d.RecordTypeId = :rtId ';
        DateTime dt = System.now();

        system.debug('*** -- queryString part 1= ' + queryString + ' -- ***');

        // RS 17-May-2014 Limit to dates after today
        queryString += 'and d.Event_Date_Time__c >= :dt ';
        
        if (showUnavailable){
            queryString += 'and d.Event_Status__c != :STATUS_CANCELLED '; 
        }else {
            queryString += 'and ( (d.Requested_Info_Session__c = false and d.Event_Status__c = :STATUS_AVAILABLE) or (d.Requested_Info_Session__c = true and d.Request_Status__c = :MATCHED_WITH_CHAMP) ) '; 
        }
        
        //searchPostCode = 'CH35AN';
        searchRange = String.valueOf(tempNumber);
        
        //2014-04-29 : CSL : We don't need to check for Range, we cannot use Range if Postcode is empty
        //if (searchPostCode != null && searchRange != null){
        
        integer searchRangeMiles;
        Map<String, String> latLongMap;
        if (searchPostCode != null && searchPostCode != ''){
            latLongMap = getLatLong(searchPostCode);
            system.debug('*** -- LAT = ' + latLongMap.get('LAT') + ' -- ***');
            system.debug('*** -- LAT = ' + latLongMap.get('LON') + ' -- ***');
            system.debug('*** -- searchRange = ' + searchRange + ' -- ***');
            if (latLongMap.size() > 0){
                //searchRange = '10';
                searchRangeMiles = integer.valueOf(searchRange);
                queryString += 'and DISTANCE(d.Location_Geographic_Details__c, GEOLOCATION('+ latLongMap.get('LAT') + ',' + latLongMap.get('LON') + '), \'mi\') < ' + searchRangeMiles + ' ';
                queryString += 'ORDER BY DISTANCE(d.Location_Geographic_Details__c, GEOLOCATION('+ latLongMap.get('LAT') + ',' + latLongMap.get('LON') + '), \'mi\')';
                queryString += ', d.Event_Date_Time__c ASC';
            }
            
        } else {
            queryString += 'ORDER BY d.Event_Date_Time__c ASC';
        }
        
        //TODO : Include this Order By clause
        //queryString += 'ORDER BY DISTANCE(searchPostCode, GEOLOCATION(37.775,-122.418), \'mi\')';
        
        // RS 17-May-2014 Run the query first to find out how many records there are
        List<DF_Event__c> searchList = new List<DF_Event__c>();
        //system.debug('*** -- LAT = ' + latLongMap.get('LAT') + ' -- ***');
        //system.debug('*** -- LON = ' + latLongMap.get('LON') + ' -- ***');
        //system.debug('*** -- searchRangeMiles = ' + searchRangeMiles + ' -- ***');
        //system.debug('*** -- About to run query COUNT : ' + queryString + ' -- ***');
        searchList = Database.query(queryString);
        noOfRecords = searchList.size();
        // RS
        // RS 17-May-2014 Add the LIMT and OFFSET clauses to try and stop the view state issues
        queryString += ' LIMIT ' + recordsPerPage + ' OFFSET ' + startRecord; 
        // RS

        system.debug('*** -- About to run query : ' + queryString + ' -- ***');
        searchList = Database.query(queryString);
        if(searchList.size()<=0){
            
            noRecordsText= noRecords;
        }
        eventList.clear();
        eventMap.clear();
        
        //eventList = new List<EventWrapper>();
        //eventMap = new Map<Id, EventWrapper>();
        
        if (searchList.size() > 0){
            for (DF_Event__c dfe : searchList){
                eventList.add(new EventWrapper(dfe));
                eventMap.put(dfe.Id, new EventWrapper(dfe));
            }
            
        }
        system.debug('*** -- eventList.size() = ' + eventList.size() + ' -- ***');
        searchList.clear();
        return null;
        
    }
    
    public class EventWrapper {
        public Map<integer, String> monthMap {get; set;}
        public DF_Event__c theEvent {get; set;}
        public String eventMonth {get; set;}
        public String eventDay {get; set;}
        public String eventTime {get; set;}
        public String eventHour {get; set;}
        public String eventMin {get; set;}
        public String eventEndTime {get; set;}
        public String eventEndHour {get; set;}
        public String eventEndMin {get; set;}
        public String wheelchairAccess {get; set;}
        public String eventDayOfWeek {get; set;}
        public String street {get; set;}

        public EventWrapper(DF_Event__c e){
            monthMap = new Map<integer, String>();
            monthMap.put(1,'Jan');
            monthMap.put(2,'Feb');
            monthMap.put(3,'Mar');
            monthMap.put(4,'Apr');
            monthMap.put(5,'May');
            monthMap.put(6,'Jun');
            monthMap.put(7,'Jul');
            monthMap.put(8,'Aug');
            monthMap.put(9,'Sep');
            monthMap.put(10,'Oct');
            monthMap.put(11,'Nov');
            monthMap.put(12,'Dec');
            try {
          
                theEvent = e;
                eventMonth = monthMap.get(e.Event_Date_Time__c.month());
                wheelchairAccess = (e.Wheel_Chair_Access__c ? 'Yes' : 'No');
                eventDay = String.valueOf(e.Event_Date_Time__c.day());
                if(e.Street__c!=null && e.Street__c.contains(',')){
                    street=  e.Street__c.substring(e.Street__c.lastIndexOf(',')+1,e.Street__c.length());
                }
                else{
                    street=  e.Street__c;
                }
                DateTime eventStartDateTime = dateTime.newInstanceGMT(e.Event_Date_Time__c.year(), e.Event_Date_Time__c.month(), e.Event_Date_Time__c.day(), e.Event_Date_Time__c.hour(), e.Event_Date_Time__c.minute(), 0);
                //String eDT = e.Event_Date_Time__c.format('yyyy-MM-dd HH:mm:ss');
                //Datetime eventStartDateTime = Datetime.valueOf(eDT );  
                
                //system.debug('*** -- eventStartDateTime for ' + e.Id + ' = ' + eventStartDateTime + ' -- ***');
                //String strHour = '0' + String.valueOf(e.Event_Date_Time__c.hour());
                //String strMin = '0' + String.valueOf(e.Event_Date_Time__c.minute());
                String strHour = '0' + String.valueOf(e.Event_Date_Time__c.hour());
                String strMin = '0' + String.valueOf(e.Event_Date_Time__c.minute());
                eventDayOfWeek = eventStartDateTime.format('EEEE');
                //eventTime = strHour.right(2) + String.valueOf(e.Event_Date_Time__c.minute());
                eventTime = strHour.right(2) + ':' + strMin.right(2);
                eventHour = strHour.right(2);
                eventMin = strMin.right(2);
                
                //String strEndHour = '0' + String.valueOf(e.Event_Date_Time__c.hour());
                //String strEndMin = '0' + String.valueOf(e.Event_Date_Time__c.minute());
                String strEndHour = '0' + String.valueOf(e.Event_End_Date_Time__c.hour());
                String strEndMin = '0' + String.valueOf(e.Event_End_Date_Time__c.minute());
                eventEndTime = strEndHour.right(2) + ':' + strEndMin.right(2);
                eventEndHour = strEndHour.right(2);
                eventEndMin = strEndMin.right(2);
                
                if (e.Event_End_Date_Time__c != null){
                    DateTime eventEndDateTime = dateTime.newInstanceGMT(e.Event_End_Date_Time__c.year(), e.Event_End_Date_Time__c.month(), e.Event_End_Date_Time__c.day(), e.Event_End_Date_Time__c.hour(), e.Event_End_Date_Time__c.minute(), 0);
                   // String eEndDT = e.Event_End_Date_Time__c.format('yyyy-MM-dd HH:mm:ss');
                   // Datetime eventEndDateTime = Datetime.valueOf(eEndDT );
                   //BST changes 
                    strEndHour = '0' + String.valueOf(e.Event_End_Date_Time__c.hour());
                    strEndMin = '0' + String.valueOf(e.Event_End_Date_Time__c.minute());
                    //strEndHour = '0' + String.valueOf(e.Event_End_Date_Time__c.hour());
                    //strEndMin = '0' + String.valueOf(e.Event_End_Date_Time__c.minute());
                    eventEndTime = strEndHour.right(2) + ':' + strEndMin.right(2);
                    eventEndHour = strEndHour.right(2);
                    eventEndMin = strEndMin.right(2);   
                }
            }catch (Exception ex){
                system.debug('*** -- Error in EventWrapper Constructor -- ***');
                system.debug('*** -- Exception : ' + ex + ' -- ***');
            }
        }
    }
    
    //2014-03-05 : SM : This code will use the Google API to get the Geolocation for the supplied postcode.
        public Map<String, String> getLatLong(String inPostCode){
            Map<String, String> latLongMap = new Map<String, String>();
            boolean foundLat = false;
            boolean foundLon = false;  
            // create an address string
            String address = '';
            //2014-06-19 : CSL : Adding in the 'UK' qualifier, so that town searches work in the UK
            if (inPostCode != null)
                //address += inPostCode +',UK, ';
                address += inPostCode +', ';
                
            address = EncodingUtil.urlEncode(address, 'UTF-8');
                
            // build callout
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
            req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCt8-YgkPglTjv7i7hWe01-M3JUZF1VshM&address='+address+'&sensor=false&region=uk');
            req.setMethod('GET');
            req.setTimeout(60000);
          
            try{  
                // callout
               system.debug('*** -- Request http test ' + req + ' -- ***');
                HttpResponse res = h.send(req);
                system.debug('*** -- response http test ' + res + ' -- ***');
                // parse coordinates from response
                system.debug('*** -- resposnse get body method ' + res.getBody() + ' -- ***');
                JSONParser parser = JSON.createParser(res.getBody());
                double lat = null;
                double lon = null;
                while (parser.nextToken() != null) {
                    if (foundLat && foundLon) break;
                    //if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                    //  system.debug('*** -- currentToken = ' + parser.getCurrentToken() + ' and it is ' + parser.getText() + ' -- ***');   
                    //}
                    
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'location')){
                           parser.nextToken(); // object start
                           while (parser.nextToken() != JSONToken.END_OBJECT){
                               String txt = parser.getText();
                               parser.nextToken();
                               if (txt == 'lat'){
                                   lat = parser.getDoubleValue();
                                   foundLat = true;
                               }else if (txt == 'lng'){
                                   lon = parser.getDoubleValue();
                                   foundLon = true;
                               }
                           }
                        
                    }
                }
                
                 system.debug('*** -- test address lat' + lat + ' -- ***');
                 system.debug('*** -- test address long' + lon + ' -- ***');
                // update coordinates if we get back 
                if (lat != null){
                    latLongMap.put('LAT',lat.format());
                    latLongMap.put('LON',lon.format());
                }    
               
            } catch (Exception e) {
                //Error handling?
            }
            
            return latLongMap;   
        }
    public testmethod static void TestWEBSession()
    {
      
     
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Profile p1 = [SELECT Id FROM profile WHERE name='DF HVCP'];
        Page_Snippet__c  pagesnipp=new Page_Snippet__c(Body_Text__c='SampleText',Unique_Name__c='savesearchsnippet');
          
         Account acc=new  Account(Name='Acme');
        Insert acc;
        Contact c=new Contact(LastName='SampleContact');
        c.accountId = acc.Id;
        c.email = 'test12@gmail.com';
        c.firstName = 'firstName';
        c.lastName = 'lastName';
        insert(c);
        Contact c1 = new Contact(LastName='SampleContact4');
        c1.accountId = acc.Id;
        c1.email = 'test412@gmail.com';
        c1.firstName = 'firstName4';
        c1.lastName = 'lastName4';
        insert(c1);
        RecordType rt = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Event__c' and r.DeveloperName='Dementia_Friend_Awareness_Session'];
        
        
        RecordType rt12 = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Contact__c' and Name='Dementia Friend'] ;
        
        RecordType rt13 = [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SobjectType = 'DF_Contact__c' and Name='Dementia Friend Champion'] ;

        DF_Contact__c dfc = new DF_Contact__c(Name='testname',First_Name__c='testfirsname',Last_Name__c='testlastname',Portal_Contact__c=c.id,Recordtypeid=rt12.id, Email__c = 'testfirstname.testlastname@myemail.com');
        insert dfc;
        
        DF_Contact__c dfc1 = new DF_Contact__c(Name='testname',First_Name__c='testfirsname1',Last_Name__c='testlastname1',Portal_Contact__c=c.id,Recordtypeid=rt13.id, Email__c = 'testfirstname1.testlastname1@myemail.com');
        
        insert dfc1;
        
        List<DF_Event__c> dfEventList = new List<DF_Event__c>();
        DateTime endDateTime = system.now().addDays(1);
        DF_Event__c devent=new DF_Event__c(Event_Date_Time__c = system.now().addDays(1),Event_End_Date_Time__c=endDateTime.addHours(3),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=33,Number_of_Attendees__c=4,Name='samlpla Name',Location__c='Sample Location',Event_Status__c='Available',Event_Ext_Id__c=5495);
        insert devent;
        
        DF_Event__c  devent1=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(2),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name',Location__c='Sample Location',Event_Ext_Id__c=5491);
        dfEventList.add(devent1);
        DF_Event__c  devent2=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(3),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street1',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name1',Location__c='Sample Location2',Event_Ext_Id__c=5492);
        dfEventList.add(devent2);
        
         DF_Event__c  devent3=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(1),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name2',Location__c='Sample Location',Event_Ext_Id__c=5493);
        dfEventList.add(devent3);
        DF_Event__c  devent4=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(4),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name2',Location__c='Sample Location',Event_Ext_Id__c=5496);
        dfEventList.add(devent4);
        DF_Event__c  devent5=new DF_Event__c(Event_Date_Time__c =system.now().addMonths(5),Wheel_Chair_Access__c=true,Total_Session_Hours__c=2,Street__c='sample street',Session_Organiser__c=dfc.id,Available_On_Website__c=true,RecordTypeid=rt.id,Public_Event__c=true,Postcode__c='2324',Number_of_Places__c=4,Number_of_Attendees__c=33,Name='samlpla Name2',Location__c='Sample Location',Event_Ext_Id__c=5497);
        dfEventList.add(devent5);
        
        //insert devent;
        //insert dfEventList;
        
        system.debug('*** -- Test Select -- ***');
        List<DF_Event__c> testList = new List<DF_Event__c>();
        /*testList = [Select d.Id, (Select Name, DF_Contact__c, DF_Event__c From DF_EventAttendees__r) 
                                From DF_Event__c d where d.Public_Event__c = true 
                                and d.RecordTypeId = :rt.Id
                                and d.Event_Date_Time__c >= today
                                //and (d.Event_Status__c = :STATUS_AVAILABLE or d.Event_Status__c = :STATUS_COMPLETED)
                                and d.Event_Status__c = 'Available'
                                ORDER BY d.Event_Date_Time__c ASC];
        
        testList = [Select d.Wheel_Chair_Access__c, d.Total_Session_Hours__c, d.Street__c, d.Session_Organiser__c, d.RecordType_Name__c, d.RecordTypeId, d.Public_Event__c, d.Postcode__c, 
                                d.Number_of_Places__c, d.Number_of_Attendees__c, d.Name, d.Location__c, d.Id, d.Event_Status__c, d.Event_Ext_Id__c, d.Event_Description__c, d.Event_Date_Time__c, 
                                d.Event_End_Date_Time__c, d.County__c, d.Country__c, d.Comments__c, d.City__c, d.Available_On_Website__c, d.Session_Organiser__r.Name,
                                (Select Name, DF_Contact__c, DF_Event__c From DF_EventAttendees__r) 
                                From DF_Event__c d where d.Public_Event__c = true];
                                
        system.debug('*** -- testList size = ' + testList.size() + ' -- ***');
        if (testList.size() > 0){
            system.debug('*** -- test Event - ' + testList[0] + ' -- ***');
        }
        */
        
        DF_EventAttendee__c DevAtten=new DF_EventAttendee__c(DF_Contact__c=dfc.id,DF_Event__c=devent.id);
        insert DevAtten;
      //  DF_EventAttendee__c DevAtten1=new DF_EventAttendee__c(DF_Contact__c=dfc.id,DF_Event__c=devent.id);
       // insert DevAtten1;
     //   DF_EventAttendee__c DevAtten3=new DF_EventAttendee__c(DF_Contact__c=dfc.id,DF_Event__c=devent.id);
        system.debug('*** -- Page Id Parameter in TEST class = ' + devent.Id + ' -- ***');
        PageReference pageRef = Page.WEBSessionDetails;
        pageRef.getParameters().put('Id',devent.id);
        test.setCurrentPage(pageRef);
        //ApexPages.currentPage().getParameters().put('Id',devent.id);  

        Saved_Search__c ss=new Saved_Search__c(Type__c='Session',Email__c='sampleemail@gmail.com',Post_Code__c='3434',Range__c=564);   
       // insert ss;
        User u1 = new User();
         u1.username =  'Advavabd@acmecorp.com';
         u1.email = 'Sampleemail@gmail.com';
         u1.lastName = 'lastName';
         u1.firstName = 'FirstName';
         String alias = 'advanchgi';
         //Alias must be 8 characters or less
         if(alias.length() > 8) {
            alias = alias.substring(0, 8);
         }
         u1.alias = alias;
         u1.languagelocalekey = 'en_US';
         u1.localesidkey = 'en_US';
         u1.emailEncodingKey = 'UTF-8';
         u1.timeZoneSidKey = 'America/Los_Angeles';
         u1.profileId = p1.Id;
         u1.contactId = c.Id;
         insert u1;  
         
       test.startTest(); 
       System.runAs(u1)
       {
          //  WEBController  webcon=new WEBController();
          //  webcon.loginRedirect();
            WEBSession  websee=new WEBSession();
            websee.searchRange = string.valueof(ss.Range__c);
            websee.saveSearch();
            
            websee.selectedEvent = new WEBSession.EventWrapper(devent);
                        
            websee.bookOnSession();
           // DevAtten.DF_Event__c = devent1.id;
           // update DevAtten ;
           // websee.removeFromSession();
           websee.showUnavailable = false;
           
            websee.applyFilter();
            websee.attendanceRecord = DevAtten;
            websee.removeFromSession();

          //  websee.attendanceRecord();
           // websee.EventWrapper webeven = new websee.EventWrapper();
        }  
        test.stopTest();
       
    }    

}