/******************************************************************************************
*  Cloud Symphony
*  
*  Purpose : APEX controller class for VF Page WEBCreateEditSession.
*  Author  : CSL
*  Date    : 27-02-2014f
*  Version : 1.0
*
*  Description:    Apex Class controller for the WEBCreateEditSession class.
*                  This is used to create a new training session, or edit an existing one.
*               
*  Modification History
*  Date            Who         Description 
*  09/04/2014      CSL         Added new Event_End_Date_Time__c field and functionality          
*******************************************************************************************/
public without sharing class WEBCreateEditSession extends DF_WEBC_ControllerBase {
    public final String SESSION_NAME_REQUIRED = 'Session Name is required';
    public final String DATE_REQUIRED = 'Date is required';
    public final String VISIBLE_ON_SITE_REQUIRED = 'Please select "Yes" or "No"';
    public final String STATUS_REQUIRED = 'Status is required';
    public final String END_TIME_ERROR = 'End Time must be after Start Time';
    public final String DATE_ERROR = 'Session Start Date cannot be in the past';
    public final String EMPTY_TIME_ERROR = 'Start time and End time is required';
    public final String DESCRIPTION_REQUIRED = 'Description is required';
    public final String ADDRESS_REQUIRED = 'Address is required';
    public final String TOWN_CITY_REQUIRED = 'Town or City is required';
    public final String COUNTY_REQUIRED = 'County is required';
    public final String POSTCODE_REQUIRED = 'Postcode is required';
    public final String SESSIONTYPE_REQUIRED = '    Type of Session is required';
    
    
    public final String STATUS_CLOSED = 'Closed';
    public final String STATUS_COMPLETED = 'Completed';
    public final String STATUS_AVAILABLE = 'Available';
    public final String STATUS_FULL = 'Full';
    public final String STATUS_CANCELLED = 'Cancelled';
    
    public String MESSAGE_ERROR = 'The data entered contains errors. Please ensure all highlighted fields have been entered correctly.';
    public final String ALERT_ERROR_CLASS = 'alert-danger';
    
    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty or less than ten';
    public final String INVALID_PLACES_VALUE_MSG = 'Number of people attending from your group is required and can\'t be empty or less than ten';
    
    public String sessionNameError {get;set;}
    public String dateError {get;set;}
    public String dateErrorPref1 {get;set;}
    public String dateErrorPref2 {get;set;}
    public String dateErrorPref3 {get;set;}
    public String visibleOnSiteError {get;set;}
    public String timeError {get; set;}
    public String timeErrorPref1 {get; set;}
    public String timeErrorPref2 {get; set;}
    public String timeErrorPref3 {get; set;}
    public String numberOfPlacesError {get;set;}
    public String descriptionError {get;set;}
    public String addressError {get;set;}
    public String townCityError {get;set;}
    public String countyError {get;set;}
    public String postcodeError {get;set;}
    public String statusError {get; set;}
    public String sessiontypeError {get;set;}
    public String footballTeamError {get;set;}
    public String sessionError {get;set;}
    
    public String startTimeHour {get;set;}
    public String startTimeHourPref1 {get;set;}
    public String startTimeHourPref2 {get;set;}
    public String startTimeHourPref3 {get;set;}
    public String startTimeMinutes {get;set;}
    public String startTimeMinutesPref1 {get;set;}
    public String startTimeMinutesPref2 {get;set;}
    public String startTimeMinutesPref3 {get;set;}
    public String endTimeHour {get;set;}
    public String endTimeHourPref1 {get;set;}
    public String endTimeHourPref2 {get;set;}
    public String endTimeHourPref3 {get;set;}
    public String endTimeMinutes {get;set;}
    public String endTimeMinutesPref1 {get;set;}
    public String endTimeMinutesPref2 {get;set;}
    public String endTimeMinutesPref3 {get;set;}
    public String eventPeriodPref1 {get;set;}
    public String eventPeriodPref2 {get;set;}
    public String eventPeriodPref3 {get;set;}
    
    public Integer noPublicSpaces {get;set;}
    public boolean wheelChairAccessible {get; set;}
    public Boolean hearingLoopAvailable {get;set;}
    public boolean visibleOnSite {get; set;}
    public String visibleOnSiteVal {get; set;}
    public string sessiontype {get;set;}
    public string footballTeam {get;set;}
    
    public Map<integer, String> monthMap {get; set;}
    public Map<String, integer> monthTextMap {get; set;}
    public Boolean isOrgChampion {get;set;}
    public Boolean isOrgAdmin {get;set;}
    public DF_Contact__c dfc {get;set;}
    public Boolean ispartnerSession {get;set;}
    public string selectedPartner {get;set;}
    public String partnerError {get;set;}
    public String sessionComments {get;set;}
    public Boolean champSignedUpToSession {get;set;}
    public Boolean userIsSessionRequester {get;set;}
    public String periodRequiringTimeDef {get;set;}
    public Integer noPublicPlaces {get;set;}
    
    public List<SelectOption> partnerList {
        get {
            
            if (partnerList == null)
                partnerList = new List<SelectOption>();
            
            return partnerList;
            
        }
        
        set;
        
    }
    public Integer partnerListSize {
        
        get {
            
            return partnerList.size();
            
        }
        
        set;
        
    }
    
    public List<SelectOption> sessionPeriodOptions {
        get {
            if (sessionPeriodOptions ==  null){
                
                sessionPeriodOptions = FormUtils.getPicklistSelectOptions(new DF_Event__c(),'Preference_1_Period__c');
            }
            return sessionPeriodOptions;
        }
        set;
    }
    
    public List<SelectOption> visibleOptions {
        get {
            if (visibleOptions ==  null){
                visibleOptions = new List<SelectOption>();
                visibleOptions.add(new SelectOption('1','Yes'));
                visibleOptions.add(new SelectOption('0','No'));
            }
            return visibleOptions;
        }
        set;
    }
    
    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}
    
    
    public String eventDateStr{get;set;}
    public String eventDateStrPref1{get;set;}
    public String eventDateStrPref2{get;set;}
    public String eventDateStrPref3{get;set;}
    public Date eventDate {get;set;}
    public Date eventDatePref1 {get;set;}
    public Date eventDatePref2 {get;set;}
    public Date eventDatePref3 {get;set;}
    public String oldStatus {get; set;}
    public decimal oldNumberOfPlaces {get; set;}
    
    public Boolean isChampion {get;set;}
    public boolean isChampionConverted {get; set;}
    public Boolean isRequestedSession {get;set;}
    
    public String eventDescription {
        get{
            if(eventDescription == null) {
                eventDescription = event.Event_Description__c;
            }
            return eventDescription;
        }
        set;
    }
    
    public Id currentSession {get;set;}
    
    public DF_Event__c event {
        get {
            if (event == null)
                event = new DF_Event__c();
            
            return event;
        }
        set;
    }
    
    public DF_Event__c eventReadOnly {
        get {
            if (eventReadOnly == null)
                eventReadOnly = new DF_Event__c();
            
            return eventReadOnly;
        }
        set;
    }
    
    //Helper methods to return Page Snippet text to display on the form
    public Page_Snippet__c totalFriendsSnippet {
        get {
            if (totalFriendsSnippet == null){
                totalFriendsSnippet = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'DementiaFriendsTotalSnippet' LIMIT 1];
            }
            return totalFriendsSnippet;
        }
        set ;
    }
    
    public Page_Snippet__c createSessionNameHelp {
        get {
            if (createSessionNameHelp == null){
                createSessionNameHelp = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'CreateSessionNameHelp' LIMIT 1];
            }
            return createSessionNameHelp;
        }
        set ;
    }
    
    public Page_Snippet__c CreateSessionDateHelp {
        get {
            if (CreateSessionDateHelp == null){
                CreateSessionDateHelp = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'CreateSessionDateHelp' LIMIT 1];
            }
            return CreateSessionDateHelp;
        }
        set ;
    }
    public Page_Snippet__c CreateSessionVisibleHelp {
        get {
            if (CreateSessionVisibleHelp == null){
                CreateSessionVisibleHelp = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'CreateSessionVisibleHelp' LIMIT 1];
            }
            return CreateSessionVisibleHelp;
        }
        set ;
    }
    public Page_Snippet__c CreateSessionStatusHelp {
        get {
            if (CreateSessionStatusHelp == null){
                CreateSessionStatusHelp = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'CreateSessionStatusHelp' LIMIT 1];
            }
            return CreateSessionStatusHelp;
        }
        set ;
    }
    
    public Page_Snippet__c CreateSessionPlacesHelp {
        get {
            if (CreateSessionPlacesHelp == null){
                CreateSessionPlacesHelp = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'CreateSessionPlacesHelp' LIMIT 1];
            }
            return CreateSessionPlacesHelp;
        }
        set ;
    }
    public Page_Snippet__c CreateSessionDescriptionHelp {
        get {
            if (CreateSessionDescriptionHelp == null){
                CreateSessionDescriptionHelp = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'CreateSessionDescriptionHelp' LIMIT 1];
            }
            return CreateSessionDescriptionHelp;
        }
        set ;
    }
    public Page_Snippet__c CreateSessionWheelchairHelp {
        get {
            if (CreateSessionWheelchairHelp == null){
                CreateSessionWheelchairHelp = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'CreateSessionWheelchairHelp' LIMIT 1];
            }
            return CreateSessionWheelchairHelp;
        }
        set ;
    }
    
    public Page_Snippet__c CreateSessionLocationHelp {
        get {
            if (CreateSessionLocationHelp == null){
                CreateSessionLocationHelp = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'CreateSessionLocationHelp' LIMIT 1];
            }
            return CreateSessionLocationHelp;
        }
        set ;
    }
    public List<selectoption> getSessionTypeOptions()
    {           
        list<selectoption> options = new list<selectoption>();
        options.add(new selectoption('none','--Select--'));            
        try 
        {               
            
            Schema.DescribeFieldResult fieldResult = DF_Event__c.Type_of_session__c.getDescribe();
            
            list<schema.picklistentry> values = fieldResult.getPickListValues();               
            for (Schema.PicklistEntry a : values) 
            {     
                
                options.add(new SelectOption(a.value,a.label));
            }
            
            
            
        }  
        catch (Exception e) 
        {             
            ApexPages.addMessages(e);           
        }
        system.debug('## Product Name Options'+ options);          
        return options; 
    }
    
    public Boolean periodSelectEventPref1{get;set;}
    public void periodSelectEventPref1() {
        System.debug('RUN FROM THE SELECT LIST');
        periodSelectEventPref1 = true;
    }
    
    public List<selectoption> getFootballTeamOptions()
    {           
        list<selectoption> options = new list<selectoption>();
        options.add(new selectoption('none','--Select--'));            
        try 
        {               
            
            Schema.DescribeFieldResult fieldResult = DF_Event__c.Football_Team__c.getDescribe();
            
            list<schema.picklistentry> values = fieldResult.getPickListValues();               
            for (Schema.PicklistEntry a : values) 
            {     
                
                options.add(new SelectOption(a.value,a.label));
            }
            
            
            
        }  
        catch (Exception e) 
        {             
            ApexPages.addMessages(e);           
        }
        system.debug('## Football Team Options'+ options);          
        return options; 
    }
    
    public Integer noOfAttendees {get;set;}
    
    public String preference {get;set;}
    public Boolean showTimeDefPref1 {get;set;}
    
    public void hideSectionOnChange()
    {
        System.debug('In hide section method');
        showTimeDefPref1 = true;
    }
    
    //Constructor
    public WEBCreateEditSession() {
        
        periodRequiringTimeDef = 'Specific time (hh:mm)';
        showTimeDefPref1 = false;
        
        monthMap = buildMonthMap();
        monthTextMap = buildMonthTextMap();
        //isChampion = WEBController.isChampion;
        //isChampionConverted = WEBController.isChampionConverted;
        System.debug('currentdfc.Type_Of_Champion__c: ' +  currentdfc.Type_Of_Champion__c);
        System.debug('isChampion: ' +  currentdfc.Type_Of_Champion__c != '');
        isChampion = (currentdfc.Type_Of_Champion__c != '' && currentdfc.Type_Of_Champion__c != null);
        isChampionConverted = currentdfc.Status__c == 'Converted';
        
        //list with duplicate partner name
        List<SelectOption> partnerOrgList = new List<SelectOption> (); 
        //create a unique partner list to select
        Set<SelectOption> partnerSet =new Set <SelectOption> ();
        dfc = (currentdfc!=null? currentdfc:new DF_Contact__c());
        partnerError='';
        isPartnerSession=False;
        selectedPartner = 'none';
        //eventDateStr = formatdate(date.today());
        //eventDate = date.today();
        isOrgChampion = (dfc.Partner_Organisation_Id__c != null && !dfc.Partner_Organisation_Id__r.Internal_purpose__c ? true: false);
        List<po_administrator__c> poadminlis = new List<po_administrator__c> ();
        poadminlis =[select name,Partner_Organisation__c,Partner_Organisation__r.Name from po_administrator__c where df_contact__c =:dfc.id and Status__c = 'Registered'];
        
        if(poadminlis.size()>0) { isOrgAdmin = true ;}
        for(po_administrator__c po : poadminlis){
            
            system.debug('partner admin'+po);
            if(po!=null && po.Partner_Organisation__c !=null ){
                
                partnerOrgList.add(new SelectOption(po.Partner_Organisation__c,po.Partner_Organisation__r.Name));
                
            }
        }
        
        
        if(isOrgChampion){             
            
            partnerOrgList.add(new SelectOption(dfc.Partner_Organisation_Id__c,dfc.Partner_Organisation_Id__r.Name));
        }
        
        //adding to a set make a unique list
        if(partnerOrgList.size()>0){
            partnerSet.addAll(partnerOrgList);         
        }
        //unique partner list
        partnerList.addAll(partnerSet);
        currentSession = ApexPages.currentPage().getParameters().get('eventId');
        System.debug('currentSession identiifed as: ' + currentSession);
        if (currentSession != null) {
            System.debug('*** Found Event Parameter ' + currentSession);
            
            event = [SELECT Id, Name, Event_Description__c, Event_Status__c, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Places__c, 
                     Session_Organiser__c,Type_of_session__c, Wheel_Chair_Access__c, Public_Event__c, Event_End_Date_Time__c, Number_of_Attendee_Records__c, 
                     Football_Team__c, Requested_Info_Session__c, Request_Status__c, Session_Requester__c, Session_Requester_Name__c, Session_Requester_Email__c,
                     Private_Places__c, Public_Places__c, Hearing_loop_available__c, Session_Organiser_Email__c,
                     Preference_1_Date__c, Preference_1_Period__c, Preference_1_Time__c,
                     Preference_2_Date__c, Preference_2_Period__c, Preference_2_Time__c,
                     Preference_3_Date__c, Preference_3_Period__c, Preference_3_Time__c
                     FROM DF_Event__c
                     WHERE Id = :currentSession];
            
            eventReadOnly = [SELECT Id, Requested_Info_Session__c, Session_Requester_Name__c, Session_Requester_Email__c, Session_Organiser_Email__c
                             FROM DF_Event__c
                             WHERE Id = :currentSession];
            
            if(event.Requested_Info_Session__c && event.Request_Status__c=='Matched with champion') {
                champSignedUpToSession = true;
            }  
            userIsSessionRequester = (dfc.Id == event.Session_Requester__c) ? true : false;
            isRequestedSession = event.Requested_Info_Session__c;
            
            eventDate = event.Event_Date_Time__c.date();
            eventDatePref1 = event.Preference_1_Date__c;
            eventDatePref2 = event.Preference_2_Date__c;
            eventDatePref3 = event.Preference_3_Date__c;
            eventDateStr = (event.Event_Date_Time__c != null) ? formatdate(event.Event_Date_Time__c.date()) : '';
            eventDateStrPref1 = (event.Preference_1_Date__c != null) ? formatdate(event.Preference_1_Date__c) : '';
            eventDateStrPref2 = (event.Preference_2_Date__c != null) ? formatdate(event.Preference_2_Date__c) : '';
            eventDateStrPref3 = (event.Preference_3_Date__c != null) ? formatdate(event.Preference_3_Date__c) : '';
            wheelChairAccessible = event.Wheel_Chair_Access__c;
            hearingLoopAvailable = event.Hearing_loop_available__c;
            visibleOnSite = event.Public_Event__c;
            visibleOnSiteVal = (visibleOnSite ? '1' : '0');
            oldStatus = event.Event_Status__c;
            oldNumberOfPlaces = event.Number_of_Places__c;
            sessiontype = event.Type_of_session__c ;
            footballTeam = event.Football_Team__c;
            noPublicPlaces = Integer.valueOf(event.Public_Places__c);
            
            eventPeriodPref1 = event.Preference_1_Period__c;
            eventPeriodPref2 = event.Preference_2_Period__c;
            eventPeriodPref3 = event.Preference_3_Period__c;
            
            if (event != null) {
                
                Integer h = event.Event_Date_Time__c.hour();
                Integer m = event.Event_Date_Time__c.minute();
                Integer h1 = (event.Preference_1_Time__c != null) ? Integer.valueOf(event.Preference_1_Time__c.split(':')[0]) : null;
                Integer m1 = (event.Preference_1_Time__c != null) ? Integer.valueOf(event.Preference_1_Time__c.split(':')[1]) : null;
                Integer h2 = (event.Preference_2_Time__c != null) ? Integer.valueOf(event.Preference_2_Time__c.split(':')[0]) : null;
                Integer m2 = (event.Preference_2_Time__c != null) ? Integer.valueOf(event.Preference_2_Time__c.split(':')[1]) : null;
                Integer h3 = (event.Preference_3_Time__c != null) ? Integer.valueOf(event.Preference_3_Time__c.split(':')[0]) : null;
                Integer m3 = (event.Preference_3_Time__c != null) ? Integer.valueOf(event.Preference_3_Time__c.split(':')[1]) : null;
                
                Integer endH = event.Event_End_Date_Time__c.hour();
                Integer endM = event.Event_End_Date_Time__c.minute(); 
                Integer endH1 = (event.Preference_1_Time__c != null) ? Integer.valueOf(event.Preference_1_Time__c.split(':')[0]) + 1 : null;
                Integer endM1 = (event.Preference_1_Time__c != null) ? Integer.valueOf(event.Preference_1_Time__c.split(':')[0]) : null;
                Integer endH2 = (event.Preference_2_Time__c != null) ? Integer.valueOf(event.Preference_2_Time__c.split(':')[0]) + 1 : null;
                Integer endM2 = (event.Preference_2_Time__c != null) ? Integer.valueOf(event.Preference_2_Time__c.split(':')[0]) : null;
                Integer endH3 = (event.Preference_3_Time__c != null) ? Integer.valueOf(event.Preference_3_Time__c.split(':')[0]) + 1 : null;
                Integer endM3 = (event.Preference_3_Time__c != null) ? Integer.valueOf(event.Preference_3_Time__c.split(':')[0]) : null;
                
                system.debug('*** -- end Time at start is : ' + endH + ' : ' + endM + ' -- ***');
                system.debug('*** -- end Time at start is : ' + endH1 + ' : ' + endM1 + ' -- ***');
                system.debug('*** -- end Time at start is : ' + endH2 + ' : ' + endM2 + ' -- ***');
                system.debug('*** -- end Time at start is : ' + endH2 + ' : ' + endM3 + ' -- ***');
                
                String hour;
                if (h<10) hour='0'+h; else hour=''+h;
                startTimeHour = hour;
                String hour1;
                if (h1<10) hour1='0'+h1; else hour1=''+h1;
                startTimeHourPref1 = hour1;
                String hour2;
                if (h2<10) hour2='0'+h2; else hour2=''+h2;
                startTimeHourPref2 = hour2;
                String hour3;
                if (h3<10) hour3='0'+h3; else hour3=''+h3;
                startTimeHourPref3 = hour3;
                
                String endHour;
                if (endH<10) endHour = '0'+endH; else endHour = ''+endH;
                endTimeHour = endHour;
                String endHour1;
                if (endH1<10) endHour1 = '0'+endH1; else endHour1 = ''+endH1;
                endTimeHourPref1 = endHour1;
                String endHour2;
                if (endH2<10) endHour2 = '0'+endH2; else endHour2 = ''+endH2;
                endTimeHourPref2 = endHour2;
                String endHour3;
                if (endH3<10) endHour3 = '0'+endH3; else endHour3 = ''+endH3;
                endTimeHourPref3 = endHour3;
                
                String min;
                if (m<10) min='0'+m; else min=''+m;
                startTimeMinutes = min;
                String min1;
                if (m1<10) min1='0'+m1; else min1=''+m1;
                startTimeMinutesPref1 = min1;
                String min2;
                if (m2<10) min2='0'+m2; else min2=''+m2;
                startTimeMinutesPref2 = min2;
                String min3;
                if (m3<10) min3='0'+m3; else min3=''+m3;
                startTimeMinutesPref3 = min3;
                
                String endMin;
                if (endM<10) endMin='0'+endM; else endMin=''+endM;
                endTimeMinutes = endMin;
                String endMin1;
                if (endM1<10) endMin1='0'+endM1; else endMin1=''+endM1;
                endTimeMinutesPref1 = endMin1;
                String endMin2;
                if (endM2<10) endMin2='0'+endM2; else endMin2=''+endM2;
                endTimeMinutesPref2 = endMin2;
                String endMin3;
                if (endM3<10) endMin3='0'+endM3; else endMin3=''+endM3;
                endTimeMinutesPref3 = endMin3;
                
                system.debug('*** -- end Time is : ' + endTimeHour + ' : ' + endTimeMinutes + ' -- ***');
                system.debug('*** -- end Time is : ' + endTimeHourPref1 + ' : ' + endTimeMinutesPref1 + ' -- ***');
                system.debug('*** -- end Time is : ' + endTimeHourPref2 + ' : ' + endTimeMinutesPref2 + ' -- ***');
                system.debug('*** -- end Time is : ' + endTimeHourPref3 + ' : ' + endTimeMinutesPref3 + ' -- ***');
                
            }
        }
    }
    
    public List<SelectOption> getEventStatusOptions() {
        Map<String, String> helpTextMap = new Map<String, String>();
        helpTextMap.put(STATUS_AVAILABLE, 'People can sign up to session');
        if ( String.isNotBlank(currentSession) ) {
            // for editing only
            helpTextMap.put(STATUS_CANCELLED, 'Session has been cancelled');
            helpTextMap.put(STATUS_FULL, 'Session has no spaces left');
        }
        
        Schema.sObjectType sobject_type = DF_Event__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Event_Status__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        
        for (Schema.PicklistEntry a: pick_list_values) {
            if ( helpTextMap.containsKey(a.getLabel()) ) {
                options.add(new SelectOption(a.getValue(), a.getLabel() + ' - ' + helpTextMap.get(a.getLabel())));
            }
        }
        return options;
    }
    
    public List<SelectOption> getTimeHour() {
        List<selectOption> timeHour = new List<SelectOption>();
        for (Integer i=7; i<20 ;i++) {
            if (i<10)
                timeHour.add(new selectOption('0' + i, '0' + i));
            else
                timeHour.add(new selectOption(''+i,''+i));
        }
        return timeHour;
    }
    
    public List<SelectOption> getTimeMinute() {
        List<selectOption> timeMinute = new List<SelectOption>();
        for (Integer i=0; i<60 ;i=i+5) {
            if (i<10)
                timeMinute.add(new selectOption('0' + i, '0' + i));
            else
                timeMinute.add(new selectOption(''+i,''+i));
        }
        return timeMinute;
    }
    
    
    // Method called for a champion to block a session
    public PageReference championDropSession() {
        
        Boolean success = true;
        Datetime now = Datetime.now();
        Integer daysBeforeEvent = Integer.valueOf((event.Event_Date_Time__c.getTime() - now.getTime())/1000/60/60/24);
        if(daysBeforeEvent >= 7) {
            event.Request_Status__c = 'Open - waiting for champion';
        } else if(daysBeforeEvent < 7) {
            event.Request_Status__c = 'Unsuccessful';
            event.Event_Status__c = 'Cancelled';
        }
        event.Session_Organiser__c = CommunityUtils.getDfCommunityPlaceholderContactId();
        update event;
        
        // Return to the previous page
        return new PageReference('/WEBChampionManageMySessions?sessionDropped=true');
        
    }
    
    //Method called to save the session information
    public PageReference saveSession() {
        
        // Reset default values
        Boolean isSuccess = true;
        
        sessionNameError = null;
        dateError = null;
        timeError = null;
        timeErrorPref1 = null;
        timeErrorPref2 = null;
        timeErrorPref3 = null;
        visibleOnSiteError = null;
        statusError = null;
        numberOfPlacesError = null;
        descriptionError = null;
        addressError = null;
        townCityError = null;
        countyError = null;
        postcodeError = null;
        sessiontypeError ='';
        footballTeamError = '';
        MESSAGE_ERROR = null;
        // Validation
        
        DateTime eventStart;
        DateTime eventStartPref1 = null;
        DateTime eventStartPref2 = null;
        DateTime eventStartPref3 = null;
        DateTime eventEnd;
        DateTime eventEndPref1 = null;
        DateTime eventEndPref2 = null;
        DateTime eventEndPref3 = null;        
        
        eventDate = stringToDate(eventDateStr);
        eventDatePref1 = stringToDate(eventDateStrPref1);
        eventDatePref2 = stringToDate(eventDateStrPref2);
        eventDatePref3 = stringToDate(eventDateStrPref3);
        
        System.debug('isSuccess1: ' + isSuccess);
        
        if (String.isBlank(event.Name)) {
            sessionNameError = SESSION_NAME_REQUIRED;
            isSuccess = false;
        }
        
        if (eventDate == null) {
            dateError = DATE_REQUIRED;
            isSuccess = false;
            //  eventDate = Date.today(); // for easy check time
        }

        if(!event.Requested_Info_Session__c) {
            if(eventDate == null) {
                dateError = DATE_REQUIRED;
                isSuccess = false;    
            }
            if(eventdate!=null && startTimeHour!=null && startTimeMinutes!=null && endTimeHour!=null && endTimeMinutes!=null){
                eventStart = datetime.newInstance(eventDate.year(), eventDate.month(), eventDate.day(), integer.valueOf(startTimeHour), integer.valueOf(startTimeMinutes),0); 
                eventEnd = datetime.newInstance(eventDate.year(), eventDate.month(), eventDate.day(), integer.valueOf(endTimeHour), integer.valueOf(endTimeMinutes),0);
            } else {
                dateError = DATE_REQUIRED;
                isSuccess = false;    
            }
        } else {
            
            if(eventDatePref1 == null && eventDatePref2 == null && eventDatePref3 == null) {
                dateError = DATE_REQUIRED;
                isSuccess = false;    
            }
            
            System.debug('Pref1: ' + eventDatePref1 + startTimeHourPref1  + startTimeMinutesPref1 + endTimeHourPref1 + endTimeMinutesPref1);
            if(eventDatePref1!=null) { // Pref1 timing entry detected 
                if(startTimeHourPref1!='null' && startTimeMinutesPref1!='null' && endTimeHourPref1!='null' && endTimeMinutesPref1!='null'){
                    eventStartPref1 = datetime.newInstance(eventDatePref1.year(), eventDatePref1.month(), eventDatePref1.day(), integer.valueOf(startTimeHourPref1), integer.valueOf(startTimeMinutesPref1),0); 
                } else {
                    eventStartPref1 = datetime.newInstance(eventDatePref1.year(), eventDatePref1.month(), eventDatePref1.day());
                }
            }
            System.debug('Pref2: ' + eventDatePref2 + startTimeHourPref2  + startTimeMinutesPref2 + endTimeHourPref2 + endTimeMinutesPref2);
            if(eventDatePref2!=null) { // Pref2 timing entry detected
                System.debug(startTimeHourPref2 == 'null');
                if(startTimeHourPref2!='null' && startTimeMinutesPref2!='null' && endTimeHourPref2!='null' && endTimeMinutesPref2!='null'){
                    eventStartPref2 = datetime.newInstance(eventDatePref2.year(), eventDatePref2.month(), eventDatePref2.day(), integer.valueOf(startTimeHourPref2), integer.valueOf(startTimeMinutesPref2),0); 
                } else {
                    eventStartPref2 = datetime.newInstance(eventDatePref2.year(), eventDatePref2.month(), eventDatePref2.day());
                }
            }
            System.debug('Pref3: ' + eventDatePref3 + startTimeHourPref3  + startTimeMinutesPref3 + endTimeHourPref3 + endTimeMinutesPref3);
            if(eventDatePref3!=null) { // Pref3 timing entry detected
                if(startTimeHourPref3!='null' && startTimeMinutesPref3!='null' && endTimeHourPref3!='null' && endTimeMinutesPref3!='null'){
                    eventStartPref3 = datetime.newInstance(eventDatePref3.year(), eventDatePref3.month(), eventDatePref3.day(), integer.valueOf(startTimeHourPref3), integer.valueOf(startTimeMinutesPref3),0); 
                } else {
                    eventStartPref3 = datetime.newInstance(eventDatePref3.year(), eventDatePref3.month(), eventDatePref3.day());
                }
            }
        }
        
        if (eventEnd < eventStart) {
            timeError = END_TIME_ERROR;
            isSuccess = false;  
        }

        if(eventDateStrPref1 != null) {    
            if(eventPeriodPref1 == 'Specific time (hh:mm)') {
                if(startTimeHourPref1 == null || startTimeMinutesPref1 == null) {
                    timeErrorPref1 = END_TIME_ERROR;
                    isSuccess = false; 
                }
            }
            if (eventEndPref1 < eventStartPref1) {
                timeErrorPref1 = END_TIME_ERROR;
                isSuccess = false;  
            }
        }
        
        if(eventDateStrPref2 != null) {    
            if(eventPeriodPref2 == 'Specific time (hh:mm)') {
                if(startTimeHourPref2 == null || startTimeMinutesPref2 == null) {
                    timeErrorPref2 = END_TIME_ERROR;
                    isSuccess = false; 
                }
            }
            if (eventEndPref2 < eventStartPref2) {
                timeErrorPref2 = END_TIME_ERROR;
                isSuccess = false;  
            }
        }
        
        if(eventDateStrPref3 != null) {    
            if(eventPeriodPref3 == 'Specific time (hh:mm)') {
                if(startTimeHourPref3 == null || startTimeMinutesPref3 == null) {
                    timeErrorPref3 = END_TIME_ERROR;
                    isSuccess = false; 
                }
            }
            if (eventEndPref3 < eventStartPref3) {
                timeErrorPref3 = END_TIME_ERROR;
                isSuccess = false;  
            }
        }
        
        if (visibleOnSiteVal == null) {
            visibleOnSiteError = VISIBLE_ON_SITE_REQUIRED;
            isSuccess = false;
        }

        if (event.Event_Status__c == null && !event.Requested_Info_Session__c) {
            
            if ( event.id==null ) { 
                
                event.Event_Status__c = STATUS_AVAILABLE; 
                
            } else {
                
                statusError = STATUS_REQUIRED;
                isSuccess = false;
                
            }
        }
		System.debug('+++ +++ ++++ event.Private_Places__c: ' + event.Private_Places__c);
        if (event.Private_Places__c == null || event.Private_Places__c < 10) {
            numberOfPlacesError = EMPTY_FIELD_VALUE_MSG;
            isSuccess = false;
        }
		
        // Handle public / private sessions
        System.debug('No public places: ' + noPublicPlaces + ' ' + (noPublicPlaces == 0));
        System.debug('No public places event.Public_Places__c: ' + event.Public_Places__c + ' ' + (Integer.valueOf(event.Public_Places__c) != 0));
        if(noPublicPlaces != 0 && !event.Public_Event__c) {
			event.Public_Event__c = true;            
        } else if(noPublicPlaces == 0 && event.Public_Event__c) {
			event.Public_Event__c = false;            
        }
        event.Public_Places__c = noPublicPlaces;
        System.debug('IS the session set as public?: ' + event.Public_Event__c);
        
        if (event.Requested_Info_Session__c && (event.Private_Places__c == null || event.Private_Places__c < 10)) {
            System.debug('In error for private places');
            MESSAGE_ERROR = INVALID_PLACES_VALUE_MSG;
            isSuccess = false;
        }
        
        if (String.isBlank(event.Event_Description__c) && !isRequestedSession) { // Description not required in requested session
            descriptionError = DESCRIPTION_REQUIRED;
            MESSAGE_ERROR = DESCRIPTION_REQUIRED;
            isSuccess = false;
        }

        if (String.isBlank(event.Street__c)) {
            addressError = ADDRESS_REQUIRED;
            MESSAGE_ERROR = ADDRESS_REQUIRED;
            isSuccess = false;
        }

        if (String.isBlank(event.City__c)) {
            townCityError = TOWN_CITY_REQUIRED;
            MESSAGE_ERROR = TOWN_CITY_REQUIRED;
            isSuccess = false;
        }
        
        if (String.isBlank(event.Postcode__c)) {
            postcodeError = POSTCODE_REQUIRED;
            MESSAGE_ERROR = POSTCODE_REQUIRED;
            isSuccess = false;
        }
        
        if ( sessiontype == 'none') {
            sessiontypeError = SESSIONTYPE_REQUIRED;
            MESSAGE_ERROR = SESSIONTYPE_REQUIRED;
            isSuccess = false;
        }
        
        if ( sessiontype == '#TeamDementiaFriends - Football Campaign' 
            && footballTeam == 'none' && !isRequestedSession) {
            footballTeamError = 'Please select a team';
            isSuccess = false;
        }
        
        if (currentSession != null) {
            if (event.Number_of_Places__c < event.Number_of_Attendee_Records__c) {
                numberOfPlacesError = 'There are already ' + event.Number_of_Attendee_Records__c + ' people booked on the event. Please ensure the number of spaces is ' + event.Number_of_Attendee_Records__c + ' or higher.';
                isSuccess = false;
            }
            if (STATUS_FULL.equalsIgnoreCase(oldStatus) && STATUS_AVAILABLE.equalsIgnoreCase(event.Event_Status__c)) {
                if (event.Number_of_Attendee_Records__c == event.Number_of_Places__c) {
                    statusError = 'You cannot change this session to "Available" unless you increase the number of places as it is currently fully booked.';
                    event.Event_Status__c = STATUS_FULL;
                    isSuccess = false;
                }
            } else if (STATUS_AVAILABLE.equalsIgnoreCase(oldStatus) && STATUS_FULL.equalsIgnoreCase(event.Event_Status__c)) {
                if (event.Number_of_Places__c > event.Number_of_Attendee_Records__c) {
                    statusError = 'You cannot change this session to "Full" with places still available.  Please set the number of places to ' + event.Number_of_Attendee_Records__c + ' to mark this session as "Full"';
                    event.Event_Status__c = STATUS_AVAILABLE;
                    isSuccess = false;
                }
            }
        }
        
        if (isSuccess) {
            try {
                List<DF_Contact__c> contacts = [SELECT Id FROM DF_Contact__c 
                                                WHERE Portal_Contact__c = :WEBController.thisUser.ContactId 
                                                LIMIT 1];
                
                if (!contacts.isEmpty()) {
                    if(!event.Requested_Info_Session__c) {
                        event.Session_Organiser__c = contacts[0].Id; 
                    } else {

                    }
                }
                
                if(event.Preference_1_Date__c != null) {
                	event.Preference_1_Period__c = eventPeriodPref1;
                    if(eventPeriodPref1 == 'Specific time (hh:mm)'){
                    	event.Preference_1_Time__c = startTimeHourPref1 + ':' + startTimeMinutesPref1;
                    }
                }
                if(event.Preference_2_Date__c != null) {
                	event.Preference_2_Period__c = eventPeriodPref2;
                    if(eventPeriodPref2 == 'Specific time (hh:mm)'){
                    	event.Preference_2_Time__c = startTimeHourPref2 + ':' + startTimeMinutesPref2;
                    }
                }
                if(event.Preference_3_Date__c != null) {
                	event.Preference_3_Period__c = eventPeriodPref3;
                    if(eventPeriodPref3 == 'Specific time (hh:mm)'){
                    	event.Preference_3_Time__c = startTimeHourPref3 + ':' + startTimeMinutesPref3;
                    }
                }
                // NO NEED TO CHANGE EVENT DATE AS THIS WILL BE SET DURING THE CHAMP SIGNUP
                //event.Event_Date_Time__c = datetime.newInstance(eventDate.year(), eventDate.month(), eventDate.day(), integer.valueOf(startTimeHourPref1), integer.valueOf(startTimeMinutesPref1),0);
                //event.Event_End_Date_Time__c = datetime.newInstance(eventDate.year(), eventDate.month(), eventDate.day(), integer.valueOf(endTimeHourPref1), integer.valueOf(endTimeMinutesPref1),0);

                //New date instance as String, with T:...Z in the string for time
                //e.g. 2012-11-15 T03:31.00.000Z
                
                TimeZone tz = UserInfo.getTimeZone();
                integer offSet = tz.getOffset(DateTime.now());
                integer offSetHour = offSet/1000/60/60;
                //boolean flags
                event.Wheel_Chair_Access__c = (wheelChairAccessible == null ? false : wheelChairAccessible);
                event.Hearing_loop_available__c = (hearingLoopAvailable == null ? false : hearingLoopAvailable);
                visibleOnSite = ((visibleOnSiteVal == null || visibleOnSiteVal == '0') ? false : true);
                //event.Public_Event__c = (visibleOnSiteVal == null ? false : visibleOnSite);
                event.Available_On_Website__c = (visibleOnSiteVal == null ? false : visibleOnSite);
                event.Type_of_Session__c = sessiontype;
                
                event.Football_Team__c = '';
                if ( sessionType == '#TeamDementiaFriends - Football Campaign') {
                    event.Football_Team__c = footballTeam;
                }
                
                System.debug('*** Saving Event Record');
                System.debug('*** Event Record is: ' + event);
                Database.upsertResult dsr = Database.upsert(event, true);
                if(!dsr.isSuccess()) {
                    System.debug(dsr.getErrors());
                }
                
                PageReference pr = null;
                System.debug('isChampion: ' +  isChampion);
                if(isChampion){
                    pr = new PageReference('/WEBChampionManageMySessions?infoSessionUpdated=true');
                } else {
                    pr = new PageReference('/WEBFriend?infoSessionUpdated=true');
                }
                //google tracking QP-8
                pr.getParameters().put('info_session_created','true');
                return pr;
                
            } catch (Exception e) {
                System.debug('*** Saving Event Record Exception ' + e.getMessage());
                
                messageArea = e.getMessage();
                messageAreaClass = ALERT_ERROR_CLASS;
            }
        } else {
            messageArea = MESSAGE_ERROR;
            messageAreaClass = ALERT_ERROR_CLASS;
        }
        
        return null;
    }
    
    public PageReference withdrawSession() {
    	PageReference targetPage = null;
        event.Event_Status__c = 'Cancelled';
        event.Request_Status__c = 'Withdrawn';
        Database.SaveResult dsr = Database.update(event, true);
        if(dsr.isSuccess()) {
            System.debug('Update Successful');
            if(isChampion) {
                targetPage = new PageReference('/WEBChampion?confirmWithdrawal=true');
            } else {
                targetPage = new PageReference('/WEBFriend?confirmWithdrawal=true');
            }
            return targetPage;
        } else {
            
            Database.Error[] errors = dsr.getErrors();
            String errMsg = '';
            for(Database.Error e : errors) {
                errMsg += e.getMessage();
            }
            System.debug('ERR: ' + errMsg);
            sessionError = errMsg;
                return null;
        }
        
    }
    
    //Helper method 
    public Date stringToDate(String s) {
        if (String.isBlank(s)) {
            return null;
        }
        try {
            String[] stringDate;
            integer y, d, m;
            if (s.indexOf(' ') > 0) {
                stringDate = s.split(' ');
                d = Integer.valueOf(stringDate[0]);
                m = monthTextMap.get(stringDate[1]);
                y = Integer.valueOf(stringDate[2]);
            } else if (s.indexOf('-') > 0) {
                stringDate = s.split('-');
                //2011-02-27
                y =  Integer.valueOf(stringDate[0]);
                m = Integer.valueOf(stringDate[1]);
                d = Integer.valueOf(stringDate[2]); 
            } else {
                stringDate = s.split('/');
                //31/3/2014
                d = Integer.valueOf(stringDate[0]);
                m = Integer.valueOf(stringDate[1]);
                y = Integer.valueOf(stringDate[2]);             
            }
            return date.newInstance(y,m,d);
        } catch(Exception e) {
            return null;
        }
    }
    
    //Helper method
    public string formatdate(Date datess){
        //String newdate = ''+ datess.year() + '-' + datess.month() + '-' + datess.day();
        //String newdate = ''+ datess.day() + '/' + datess.month() + '/' + datess.year();
        String newDate = '' + datess.day() + ' '  + monthMap.get(datess.month()) + ' ' + datess.year();
        return newdate;
    }
    
    public Map<integer, String> buildMonthMap(){
        Map<integer, String> mthMap = new Map<integer, String>();
        mthMap.put(1,'Jan');
        mthMap.put(2,'Feb');
        mthMap.put(3,'Mar');
        mthMap.put(4,'Apr');
        mthMap.put(5,'May');
        mthMap.put(6,'Jun');
        mthMap.put(7,'Jul');
        mthMap.put(8,'Aug');
        mthMap.put(9,'Sep');
        mthMap.put(10,'Oct');
        mthMap.put(11,'Nov');
        mthMap.put(12,'Dec');
        
        return mthMap;
    }
    
    public Map<String, integer> buildMonthTextMap(){
        Map<String, integer> mthMap = new Map<String, integer>();
        mthMap.put('Jan',1);
        mthMap.put('Feb',2);
        mthMap.put('Mar',3);
        mthMap.put('Apr',4);
        mthMap.put('May',5);
        mthMap.put('Jun',6);
        mthMap.put('Jul',7);
        mthMap.put('Aug',8);
        mthMap.put('Sep',9);
        mthMap.put('Oct',10);
        mthMap.put('Nov',11);
        mthMap.put('Dec',12);
        
        return mthMap;
    }
    
    public Boolean controlTimeVisibility() {
        System.debug('Pref is: ');
        //controlTimeVisibiliyPref1
        return true;
    }
    
    
}