/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Component WEBChampionContactDetails.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the VF Component WEBChampionDetails
 *               
 *  Modification History
 *  Date            Who         Description 
                   
*******************************************************************************************/
public without sharing class WEBChampionContactDetailsClass extends DF_WEBC_ControllerBase{

    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public static final String REQUIRED_FIELD_MSG_END = ' is required';

    public Datetime courseDate{get;set;}
    public Datetime courseEndDate{get;set;}
    public String courseDetails{get;set;}
    public String courseStreet{get;set;}
    public String courseCity{get;set;}
    public String courseCounty{get;set;}
    public String courseCountry{get;set;}
    public String coursePostcode{get;set;}
    public String firstName{get;set;}
    public String lastName{get;set;}
    public String address1{get;set;}
    public String address2{get;set;}
    public String town_City{get;set;}
    public String county{get;set;}
    public String postCode{get;set;}
    public String EventId{get;set;}

    public List<DF_Contact__c> contacts {get;set;}
    public List<DF_Event__c> events {get;set;}
    public DF_Event__c courseObj {get;set;}
    
    public Boolean displayThankyoupage{get;set;}
    public Boolean displayFormPage{get;set;}

    public Boolean isError {get; set;}
    public String firstNameError {get; set;}
    public String lastNameError {get; set;}
    public String address1Error {get; set;}
    public String townCityError {get; set;}
    public String countyError {get; set;}
    public String postCodeError {get; set;}
    
    public User thisUser {
        get {
            return WEBController.thisUser;
        }
        set;
    }

    //Constructor
    public WEBChampionContactDetailsClass(){
        EventId = ApexPages.currentPage().getParameters().get('event');
        displayThankyoupage = false;
        displayFormPage = true;
        if (EventId != null){
            getEventInformation();
        }
        getContactInformation();

        isError = false;
        firstNameError = null;
        lastNameError = null;
        address1Error = null;
        townCityError = null;
        countyError = null;
        postCodeError = null;
        
    }
    
    private String buildErrorMsgTxt(String field) {
        return field + REQUIRED_FIELD_MSG_END;
    }
    
    
    //Returns the event information for the selected event
    public void getEventInformation(){
        events = new List<DF_Event__c>();
        events = [SELECT Id, Event_Date_Time__c, Event_End_Date_Time__c, Street__c, Postcode__c, City__c, Country__c, County__c, Location__c, Number_of_Attendees__c, Number_of_Places__c 
                  FROM DF_Event__c 
                  WHERE Id=:EventId LIMIT 1];
        
        if (events.size() > 0){
            for (DF_Event__c dfevents:events){
                courseDetails = dfevents.Location__c;
                courseDate = dfevents.Event_Date_Time__c;
                courseEndDate = dfevents.Event_End_Date_Time__c;
                courseStreet = dfevents.Street__c;
                courseCity = dfevents.City__c;
                courseCounty = dfevents.County__c;
                courseCountry = dfevents.Country__c;
                coursePostcode = dfevents.Postcode__c;
                // Save the object for field output on VF component
                courseObj = dfevents;
            }
        }
    }
    
    //Returns contact information for the logged in contact
    public void getContactInformation() {
        contacts = new List<DF_Contact__c>();
        contacts = [SELECT Id, First_Name__c,Last_Name__c,Street__c,City__c,Country__c,County__c,Postcode__c,Portal_Contact__r.Id FROM DF_Contact__c WHERE Portal_Contact__r.Id = :WEBController.thisUser.ContactId LIMIT 1];
        
        if (contacts.size() > 0){
            for (DF_Contact__c dfcontact:contacts){
                firstName = dfcontact.First_Name__c;
                lastName = dfcontact.Last_Name__c;
                address1 = dfcontact.Street__c;
                //address2 = dfcontact.Street__c;
                town_City = dfcontact.City__c;
                county = dfcontact.County__c;
                postCode = dfcontact.Postcode__c;
            }
        }
    }

    //Submits the event booking form
    public PageReference submitForm() {
        isError = false;
        firstNameError = null;
        lastNameError = null;
        address1Error = null;
        townCityError = null;
        countyError = null;
        postCodeError = null;

        DF_Event__c selectedEvent = events[0];
        if (contacts.size() > 0) {
            for (DF_Contact__c dfcontact : contacts){

                if (String.isBlank(firstName)) {
                    isError = true;
                    firstNameError = buildErrorMsgTxt('First Name');
                }

                if (String.isBlank(lastName)) {
                    isError = true;
                    lastNameError = buildErrorMsgTxt('Last Name');
                }

                if (String.isBlank(address1)) {
                    isError = true;
                    address1Error = buildErrorMsgTxt('Address');
                }

                if (String.isBlank(town_City)) {
                    isError = true;
                    townCityError = buildErrorMsgTxt('Town or City');
                }

                if (String.isBlank(county) && String.isBlank(town_City)) {
                    isError = true;
                    countyError = buildErrorMsgTxt('County');
                }

                if (String.isBlank(postCode)) {
                    isError = true;
                    postCodeError = buildErrorMsgTxt('Postcode');
                }

                if (isError) {
                    return null;
                }

                 dfcontact.First_Name__c = firstName;
                 dfcontact.Last_Name__c = lastName;
                 dfcontact.Street__c = address1;
                 //dfcontact.Street__c = address2;
                 dfcontact.City__c = town_City;
                 dfcontact.County__c = county;
                 dfcontact.Postcode__c = postCode;
            }   
            try {
                update contacts;
            }   
            catch(System.DmlException e) {
                system.debug('We have found an DML Exception please check the following error : '+e);
            }
            
            //Now we need to create the Event Attendee record
             DF_EventAttendee__c attendanceRecord = new DF_EventAttendee__c();
            attendanceRecord.DF_Contact__c = contacts[0].Id;
            attendanceRecord.DF_Event__c = events[0].Id;
            
            system.debug('*** -- Insert record -- ***');
            
            insert attendanceRecord;
            
            /* Alz - 27/01/2015 This code is not required. Numbers are tracked with Roll up Summary fields 
            
            if (selectedEvent.Number_of_Attendees__c == null){
                selectedEvent.Number_of_Attendees__c = 0;
            }
            
            if (selectedEvent.Number_of_Attendees__c == selectedEvent.Number_of_Places__c){
                //Do we want to save this record?
                
            }else if (selectedEvent.Number_of_Attendees__c < selectedEvent.Number_of_Places__c){
                selectedEvent.Number_of_Attendees__c = selectedEvent.Number_of_Attendees__c + 1;    
            }
                       
            
            update selectedEvent;
            */
            
        }
        displayThankyoupage = true;
        displayFormPage = false;
        //google tracking QP-7
        return new PageReference('/user-home?champion_induction_session_booked=true');
    }

}