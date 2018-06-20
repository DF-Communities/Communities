/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBChampionCreateEditSession.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBChampionCreateEditSession class.
 *                  This is used to create a new training session, or edit an existing one.
 *               
 *  Modification History
 *  Date            Who         Description 
 *  09/04/2014      CSL         Added new Event_End_Date_Time__c field and functionality          
*******************************************************************************************/
public without sharing class WEBChampionCreateEditSession extends DF_WEBC_ControllerBase {
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

    public final String MESSAGE_ERROR = 'The data entered contains errors. Please ensure all highlighted fields have been entered correctly.';
    public final String ALERT_ERROR_CLASS = 'alert-danger';

    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    
    public String sessionNameError {get;set;}
    public String dateError {get;set;}
    public String visibleOnSiteError {get;set;}
    public String timeError {get; set;}
    public String numberOfPlacesError {get;set;}
    public String descriptionError {get;set;}
    public String addressError {get;set;}
    public String townCityError {get;set;}
    public String countyError {get;set;}
    public String postcodeError {get;set;}
    public String statusError {get; set;}
    public String sessiontypeError {get;set;}
    public String footballTeamError {get;set;}
    
    public String startTimeHour {get;set;}
    public String startTimeMinutes {get;set;}
    public String endTimeHour {get;set;}
    public String endTimeMinutes {get;set;}
    public boolean wheelChairAccessible {get; set;}
    public boolean visibleOnSite {get; set;}
    public String visibleOnSiteVal {get; set;}
    public string sessiontype {get;set;}
    public string footballTeam {get;set;}
    public string timeMessage {get;set;}
    public Map<integer, String> monthMap {get; set;}
    public Map<String, integer> monthTextMap {get; set;}
    
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
    public Date eventDate {get;set;}
    public String oldStatus {get; set;}
    public decimal oldNumberOfPlaces {get; set;}

    public Boolean isChampion {get;set;}
    public boolean isChampionConverted {get; set;}

    public Id currentSession {get;set;}

    public DF_Event__c event {
        get {
            if (event == null)
                event = new DF_Event__c();

            return event;
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


    //Constructor
    public WEBChampionCreateEditSession() {
        monthMap = buildMonthMap();
        monthTextMap = buildMonthTextMap();
        isChampion = WEBController.isChampion;
        isChampionConverted = WEBController.isChampionConverted;
        
        //eventDateStr = formatdate(date.today());
        //eventDate = date.today();

        currentSession = ApexPages.currentPage().getParameters().get('eventId');

        if (currentSession != null) {
            System.debug('*** Found Event Parameter ' + currentSession);
                
            event = [SELECT Id, Name, Event_Description__c, Event_Status__c, Event_Date_Time__c, Street__c, City__c, County__c, Postcode__c, Number_of_Places__c, 
                        Session_Organiser__c,Type_of_session__c, Wheel_Chair_Access__c, Public_Event__c, Event_End_Date_Time__c, Number_of_Attendee_Records__c, Football_Team__c
                        FROM DF_Event__c
                        WHERE Id = :currentSession];
            
            eventDate = event.Event_Date_Time__c.date();
            eventDateStr = formatdate(event.Event_Date_Time__c.date());
            wheelChairAccessible = event.Wheel_Chair_Access__c;
            visibleOnSite = event.Public_Event__c;
            visibleOnSiteVal = (visibleOnSite ? '1' : '0');
            oldStatus = event.Event_Status__c;
            oldNumberOfPlaces = event.Number_of_Places__c;
            sessiontype = event.Type_of_session__c ;
            footballTeam = event.Football_Team__c;
            
            if (event != null) {
                Integer h = event.Event_Date_Time__c.hour();
                Integer m = event.Event_Date_Time__c.minute();
                
                Integer endH = event.Event_End_Date_Time__c.hour();
                Integer endM = event.Event_End_Date_Time__c.minute();
                
                system.debug('*** -- end Time at start is : ' + endH + ' : ' + endM + ' -- ***');

                String hour;
                if (h<10) hour='0'+h; else hour=''+h;
                startTimeHour = hour;
                
                String endHour;
                if (endH<10) endHour = '0'+endH; else endHour = ''+endH;
                endTimeHour = endHour;

                String min;
                if (m<10) min='0'+m; else min=''+m;
                startTimeMinutes = min;
                
                String endMin;
                if (endM<10) endMin='0'+endM; else endMin=''+endM;
                endTimeMinutes = endMin;
                
                system.debug('*** -- end Time is : ' + endTimeHour + ' : ' + endTimeMinutes + ' -- ***');
                
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
        for (Integer i=0; i<24 ;i++) {
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

    
    //Method called to save the session information
    public PageReference saveSession() {
        
        // Reset default values
        Boolean isSuccess = true;
        
        sessionNameError = null;
        dateError = null;
        timeError = null;
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
       
        // Validation

        DateTime eventStart;
        DateTime eventEnd;

        eventDate = stringToDate(eventDateStr);
        
        if (String.isBlank(event.Name)) {
            sessionNameError = SESSION_NAME_REQUIRED;
            isSuccess = false;
        }

        if (eventDate == null) {
            dateError = DATE_REQUIRED;
            isSuccess = false;
             
          //  eventDate = Date.today(); // for easy check time
        }
        
       
        if(eventdate!=null){
        eventStart = datetime.newInstance(eventDate.year(), eventDate.month(), eventDate.day(), integer.valueOf(startTimeHour), integer.valueOf(startTimeMinutes),0); 
        eventEnd = datetime.newInstance(eventDate.year(), eventDate.month(), eventDate.day(), integer.valueOf(endTimeHour), integer.valueOf(endTimeMinutes),0);
         
        }
           if (integer.valueOf(startTimeHour) == 0 &&
               integer.valueOf(startTimeMinutes) == 0 &&
               integer.valueOf(endTimeHour) == 0 &&
               integer.valueOf(endTimeMinutes) == 0) {
                timeError = EMPTY_TIME_ERROR;
                isSuccess = false;
                
            }
        
        
            if (eventEnd < eventStart) {
                timeError = END_TIME_ERROR;
                isSuccess = false; 
                
            }

            
    
            //Feb 2016. Request to allow events in the past
            /*    
             if (eventDate!=null && eventStart < system.now()) {
                 dateError = DATE_ERROR;
                 isSuccess = false;  
            }
            */
            

        if (visibleOnSiteVal == null) {
            visibleOnSiteError = VISIBLE_ON_SITE_REQUIRED;
            isSuccess = false;
        }

        if (event.Event_Status__c == null) {

            if ( event.id==null ) { 
                
                event.Event_Status__c = STATUS_AVAILABLE; 
                
                } else {
                
                statusError = STATUS_REQUIRED;
                isSuccess = false;

            }

        }

        if (event.Number_of_Places__c == null || event.Number_of_Places__c <= 0) {
            numberOfPlacesError = EMPTY_FIELD_VALUE_MSG;
            isSuccess = false;
        }

        if (String.isBlank(event.Event_Description__c)) {
            descriptionError = DESCRIPTION_REQUIRED;
            isSuccess = false;
        }

        if (String.isBlank(event.Street__c)) {
            addressError = ADDRESS_REQUIRED;
            isSuccess = false;
        }

        if (String.isBlank(event.City__c)) {
            townCityError = TOWN_CITY_REQUIRED;
            isSuccess = false;
        }

       /* if (String.isBlank(event.County__c)) {
            countyError = COUNTY_REQUIRED;
            isSuccess = false;
        }*/

        if (String.isBlank(event.Postcode__c)) {
            postcodeError = POSTCODE_REQUIRED;
            isSuccess = false;
        }
        
         if ( sessiontype == 'none') {
            sessiontypeError = SESSIONTYPE_REQUIRED;
            isSuccess = false;
        }
        
        if ( sessiontype == '#TeamDementiaFriends - Football Campaign' && footballTeam == 'none') {
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
                List<DF_Contact__c> contacts = [SELECT Id FROM DF_Contact__c WHERE Portal_Contact__c = :WEBController.thisUser.ContactId LIMIT 1];
                
                if (!contacts.isEmpty())
                    event.Session_Organiser__c = contacts[0].Id;

                event.Event_Date_Time__c = datetime.newInstance(eventDate.year(), eventDate.month(), eventDate.day(), integer.valueOf(startTimeHour), integer.valueOf(startTimeMinutes),0);
                event.Event_End_Date_Time__c = datetime.newInstance(eventDate.year(), eventDate.month(), eventDate.day(), integer.valueOf(endTimeHour), integer.valueOf(endTimeMinutes),0);
              
                
                //New date instance as String, with T:...Z in the string for time
                //e.g. 2012-11-15 T03:31.00.000Z
                
                TimeZone tz = UserInfo.getTimeZone();
                integer offSet = tz.getOffset(DateTime.now());
                system.debug('*** -- offSet = ' + offSet + ' -- ***');
                system.debug('*** -- Display Name = ' + tz.getDisplayName() + ' -- ***');
                //System.debug('Display name: ' + tz.getDisplayName());
                //System.debug('ID: ' + tz.getID());
                //System.debug('Offset: ' + tz.getOffset(DateTime.now()));
                //System.debug('String format: ' + tz.toString());
                integer offSetHour = offSet/1000/60/60;
                system.debug('*** -- integer offSet = ' + offSetHour + ' -- ***');
                
                /*
                String sYear = String.valueOf(eventDate.year());
                String sMonth = String.valueOf(eventDate.month());
                String sDay = String.valueOf(eventDate.day());
                integer adjustedHour = integer.valueOf(startTimeHour) + offSetHour;
                String sHour = String.valueOf(adjustedHour);
                String sMin = startTimeMinutes;
                String sDateTime = sYear + '-' + sMonth + '-' + sDay + ' ' + sHour + ':' + sMin + ':00';  
                event.Event_Date_Time__c = dateTime.valueOfGMT(sDateTime);
                
                String eYear = String.valueOf(eventDate.year());
                String eMonth = String.valueOf(eventDate.month());
                String eDay = String.valueOf(eventDate.day());
                integer adjustedHour1 = integer.valueOf(endTimeHour) + offSetHour;
                String eHour = String.valueOf(adjustedHour1);
                String eMin = endTimeMinutes;
                String eDateTime = eYear + '-' + eMonth + '-' + eDay + ' ' + eHour + ':' + eMin + ':00';  
                event.Event_End_Date_Time__c = dateTime.valueOfGMT(eDateTime);
                */
                //boolean flags
                system.debug('*** -- wheelchairAccess = ' + wheelChairAccessible + ' -- ***');
                system.debug('*** -- visibleOnSite = ' + visibleOnSite + ' -- ***');
                event.Wheel_Chair_Access__c = (wheelChairAccessible == null ? false : wheelChairAccessible);
                visibleOnSite = ((visibleOnSiteVal == null || visibleOnSiteVal == '0') ? false : true);
                event.Public_Event__c = (visibleOnSiteVal == null ? false : visibleOnSite);
                event.Available_On_Website__c = (visibleOnSiteVal == null ? false : visibleOnSite);
                event.Type_of_Session__c = sessiontype;

                event.Football_Team__c = '';
                if ( sessionType == '#TeamDementiaFriends - Football Campaign') {
                     event.Football_Team__c = footballTeam;
                }


                System.debug('*** Saving Event Record');
                upsert event;
                PageReference pr = page.WEBChampion;
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


  
}