/******************************************************************************************
*  Alzheimer's Society
*  
*  Purpose : Base Controller Class for Remote Action Controller Class
*  Author  : Gary Grant
*  Date    : 17/11/2015
*  Version : 
*
*  Description :  Remote Action base class for handling registration of new Dementia Friends
*                 This class should be extended by individual remote actions that control
*                 registration of the various types of Dementia Friend     
*
*               
*  Modification History
*  Date            Who         Description 
*  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
global virtual class DF_WEBC_RegisterBase_Handler {
    
    Boolean TRUE_VALUES_UPDATE_INDV_ONLY = true;
    protected DF_Contact__c dfc;
    protected ResponseHolder responseHolder;
    protected DataHolder data;
    
    public class RegisterBaseException extends Exception{}
    
    public DF_WEBC_RegisterBase_Handler() {            
        
    }
    
    public DF_WEBC_RegisterBase_Handler(String sJson) {        
        init(sJson);
    }
    
    protected void init(String sJson) {
		System.debug('*** sJson is: ' + sJson);
        data = (DataHolder)JSON.deserialize(sJson, DataHolder.class);  
        System.debug('*** data is: ' + data);
        responseHolder = new ResponseHolder();   
    }
    
    public virtual ResponseHolder handleJson() { 
        doHandleForm();
        return responseHolder;
    }
    
    protected virtual boolean isRequestVerification() {
        return true;
    }
    
    protected virtual void doHandleForm()
    {
        System.debug('In resgisterbase handler dohandle form');
        if ( !validate() ) { 
            System.debug('DF_WEBC_RegisterBase_Handler : validation failed');    
            return; 
        }        
        
        if ( !handleExistingUser() ) { return; }
        
        doRegistration();
        doPostRegistration();
        sendVerificationRequest();
        
        responseHolder.copyDfc(dfc);
        responseHolder.returnCode = 1;
        return;
    }
    
    protected virtual Boolean validate() {
        
        if ( !isRecaptchaOK() ) {            
            
            system.debug('DF_WEBC_RegisterBase_Handler : isRecaptchaOk Failed');
            responseHolder.returnCode = 0;
            return false;
            
        }
        
        if ( !isRegistrationDataOK() ) {
            
            system.debug('DF_WEBC_RegisterBase_Handler : isRegistrationDataOk Failed');
            responseHolder.returnCode = 0; 
            return false;
            
        }
        
        return true;
        
    }
    
    protected virtual boolean doRegistration() {
        
        dfc = DF_Utils.getDFContactForEmail(data.emailAddress);
        if ( dfc == null ) { 
            
            dfc = new DF_Contact__c();                          
            
            /* Only update the email address if this is a new Record */ 
            dfc.Email__c = data.emailAddress.toLowerCase();
            dfc.Created_As_Type__c = getCreatedAsValue();
            
        }
        
        dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(getRecordTypeName());
        dfc.Status__c = DF_Utils.STATUS_PROSPECTIVE;
        System.debug('Data structure to pass to populateData: ' + JSON.serialize(data));
        populateData();
        return true;
        
    }
    
    protected virtual Boolean handleExistingUser() {
        
        List<User> users = [select id from User where UserName =: data.emailAddress limit 1];
        
        if ( users.size() > 0 ) {
            
            responseHolder.standardErrorMsg = DF_Utils.USER_ALREADY_EXISTS_MSG;
            responseHolder.returnCode = 0;
            system.debug('DF_WEBC_RegisterBase_Handler : dfc RT not OK ');
            return false;
            
        }               
        
        return true;
        
    }
    
    protected virtual void sendVerificationRequest() {
        
        if ( !isRequestVerification() ) { return; }
        
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');                 
        Contact contact=  DF_Utils.getContactRecordForDfcId(dfc.id);  
        
        /* April 2017 : Switch to sending email with Pure360 */
        //community.sendVerificationRequest(contact, data.password, getStartUrl(), getEmailTemplateName());
        
        String sVerifyUrl = community.getVerifyUrl(contact, data.password, getStartUrl());        
        sendVerificationRequestAsync(contact.Email, sVerifyUrl, contact.FirstName, data.password, dfc.id, getStartUrl(), getPureEmailTemplateName(), getEmailTemplateName());        
        system.debug('DF_WEBC_RegisterBase_Handler : user registered');
        
    }
    
    /*If this callout fails, the user will get the standard email from Salesforce */
    @future(callout=true)
    private static void sendVerificationRequestAsync(String email, String sVerifyUrl, String sName, String password, String dfcId, String startUrl, String pureTemplateName, String templateName) {
        
        Contact contact=  DF_Utils.getContactRecordForDfcId(dfcId);  
        Task t = new Task();
        t.WhoId = contact.id;
        t.WhatId = dfcId;
        t.Subject = 'Pure 360 Email Verification';
        t.Status = 'Completed';
        t.Priority = 'Normal';
        t.ActivityDate = System.Today();
        
        boolean bOK = true;
        
        system.debug('DF_WEBC_RegisterBase_Handler : user registered');
        DF_Pure360_Email_Handler handler = new DF_Pure360_Email_Handler();
        if ( !handler.sendVerificationRequest(email, sVerifyUrl, sName, pureTemplateName) ) {            
            
            bOK = false;
            WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');                 
            community.sendVerificationRequest(contact, password, startUrl, templateName);
            
        }
        
        if ( bOK ) { insert t; } 
        
    }
    
    protected virtual void doPostRegistration() {
        
        return;
    }
    
    
    protected virtual void populateData() {

        populateBaseData();
        populateExtendedData();
        Database.UpsertResult dsr = Database.upsert(dfc, true);
        if(dsr.isSuccess()) {
            populateDgData();
            populateIndvData();
        } else {
            throw new RegisterBaseException('Contact could not be created correctly');
        }
        
    }
    
    protected virtual boolean isRegistrationDataOK() {
        
        boolean b = isBaseRegistrationDataOK();
        if (!b) return b;
        
        return isExtendedRegistrationDataOK();    
        
    }
    
    @TestVisible
    protected virtual boolean isExtendedRegistrationDataOK() {
        
        return true;
    }
    
    protected virtual boolean isBirthDateOK(Integer months) {
        
        
        boolean b = true;
        
        if ( data.birthDate == null || data.birthDate.length() == 0 ) {
            
            responseHolder.birthDateError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
            
        } else {
            
            Date dt = getDate(data.birthDate);
            
            if ( dt == null ) {
                
                responseHolder.birthDateError = 'Birth Date is invalid format (DD/MM/YYY)';
                b = false;
                
            } else { 
                
                Date dtNow = Date.Today();      
                Integer m = dt.monthsBetween(dtNow);
                system.debug('Register Champion : Months ' + m);
                
                if ( m < months ) {
                    
                    responseHolder.birthDateError = DF_Utils.AGE_MSG;
                    b=false;
                }
                
                if ( m == months && dt.day() > dtNow.Day()) {
                    
                    responseHolder.birthDateError = DF_Utils.AGE_MSG;
                    b=false;
                    
                }
                
                
            }
            
        }  
        
        return b;
        
    }
    
    protected virtual boolean isBaseRegistrationDataOK() {
        
        boolean b = true;        
        system.debug('DF_WEBC_RegisterBase_Handler : Starting Tests');
        
        if ( 'NULL'.equalsIgnoreCase(data.title) ){
            responseHolder.titleError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }
        
        if ( data.firstName == null || data.firstName.length() == 0 ) {
            responseHolder.firstNameError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }
        
        system.debug('DF_WEBC_RegisterBase_Handler : Tests firstName '+ b);
        
        if ( data.lastName == null || data.lastName.length() == 0 ) {
            responseHolder.lastNameError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }
        
        
        if ( data.postCode == null || data.postCode.length() == 0 ) {
            responseHolder.postCodeError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }
        
        system.debug('DF_WEBC_RegisterBase_Handler : Tests postCode '+ b);
        
        if ( (data.city.length() == 0) && (data.county.length() == 0) ) {
            responseHolder.cityError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }
        
        system.debug('DF_WEBC_RegisterBase_Handler : Tests city / county '+ b);
        
        if ( data.country == null || data.country.length() == 0  ) {
            responseHolder.countryError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }
        
        system.debug('DF_WEBC_RegisterBase_Handler : Tests country '+ b);
        
        if ( data.telephone == null || data.telephone.length() == 0 ) {
            responseHolder.telephoneError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }
        
        
        if ( data.emailAddress == null || data.emailAddress.trim().length() == 0 ){
            
            responseHolder.emailAddressError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
            
        }
        
        system.debug('DF_WEBC_RegisterBase_Handler : Tests Email '+ b);
        
        if ( data.emailAddress != data.emailAddress2 ){
            
            responseHolder.emailAddressError = DF_Utils.EMAILS_DO_NOT_MATCH_MSG;
            b=false;
            
        }
        
        
        system.debug('DF_WEBC_RegisterBase_Handler : Tests email match '+ b);
        
        if ( data.emailAddress != null && data.emailAddress.trim().length() > 0 ) {
            
            if ( !WEBC_CommunityWrapper.isEmailAddressOK(data.emailAddress) ) {
                responseHolder.emailAddressError = DF_Utils.INVALID_EMAIL_ADDRESS;
                b=false;
            }
            
        }
        
        system.debug('DF_WEBC_RegisterBase_Handler : Tests email format '+ b);
        
        if ( data.password == null || data.password.trim().length() == 0 ){
            
            responseHolder.passwordError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
            system.debug('DF_WEBC_RegisterBase_Handler : empty password '+ b);
            
        }
        
        if ( data.password != null && data.password.trim().length() >0 ) {
            
            if ( !WEBC_CommunityWrapper.isPasswordOK(data.password) ) {
                responseHolder.passwordError = DF_Utils.BAD_PASSWORD_MSG;
                b=false;
                system.debug('DF_WEBC_RegisterBase_Handler : short password '+ b);
            }
            
        }
        
        
        system.debug('DF_WEBC_RegisterBase_Handler : Tests password '+ b);     
        
        
        if ( !b ) {
            responseHolder.standardErrorMsg = DF_Utils.STANDARD_ERROR_MSG;    
        }
        
        system.debug('DF_WEBC_RegisterBase_Handler : All Tests '+ b);
        return b;        
        
    }
    
    protected virtual boolean isRecaptchaOK()
    {
        
        system.debug('DF_WEBC_RegisterBase_Recaptcha challenge : ' + data.recaptcha_challenge);
        system.debug('DF_WEBC_RegisterBase_Recaptcha response  : ' + data.recaptcha_response);
        system.debug('DF_WEBC_RegisterBase_Recaptcha : ' + data.remoteHost);
        
        /* Reset these values here because the challenge and response will be set after the page has loaded by the JS code */
        /* March 2018
WEBC_RecaptchaHandler recaptchaHandler = new WEBC_RecaptchaHandler(data.recaptcha_challenge, data.recaptcha_response, data.remoteHost);
*/
        String secret = DF_WEBC_Recaptcha2Handler.captchaSecret;
        system.debug('DF_WEBC_RegisterBase_Recaptcha secret :' + secret);
        
        WEBC_Recaptcha2Handler recaptchaHandler = new WEBC_Recaptcha2Handler(secret,data.recaptcha_response);
        if ( !recaptchaHandler.verify() ){
            
            responseHolder.standardErrorMsg = DF_Utils.STANDARD_ERROR_MSG;
            responseHolder.reCAPTCHAError = WEBC_Recaptcha2Handler.RECAPTCHA_VALIDATION_FAILED;
            return true; // Query: Always returns true?
        }
        
        return true;
        
    }
    
    /* This is the data passed in via the POST */
    global class DataHolder extends Holder
    {
        // This can be extended to hold more than just the form data;
        public String emailAddress2;
        public String password2;        
        
        public String recaptcha_challenge;
        public String recaptcha_response;    
        
        public Boolean isSimpleUpdate = false;           
        public Boolean doRecaptcha = true;   
        
        public String action;     
        public String inviteData;
        public String inviteId;
        public String communityCountry;
        
        public Boolean gdprEmailOptIn;
        public Boolean gdprPhoneOptIn;
        public Boolean gdprSmsOptIn;
        public Boolean gdprSocialOptIn;
        public Boolean gdprPostOptOut;
        
    }
    
    global class ResponseHolder extends Holder
    {
        // This can be extended to hold more than just the response data;
        
        public Integer returnCode;
        public String message;
        public String redirectUrl;
        
        public String standardErrorMsg ='';
        public String titleError = '';
        public String titleOtherError = '';
        public String firstNameError = '';
        public String lastNameError = '';
        public String birthDateError = '';
        
        public String postCodeError = '';
        public String streetError = '';
        public String cityError = '';
        public String countyError = '';
        public String countryError = '';
        
        public String telephoneError = '';
        public String emailAddressError = '';
        public String passwordError = '';
        public String password2Error = '';
        
        public String reCAPTCHAError = '';
        public String orgPostCodeError = '';
        public String orgStreetError = '';
        public String orgCityError = '';
        public String orgCountyError = '';
        public String orgCountryError = '';
        public String orgTelephoneError = '';
        public String orgNameError = '';
        public String employeesError = '';
        public String sectorError ='';
        public String sectorOtherError ='';
        public String footballTeamError = '';
        
        
        global void copyDfc(DF_Contact__c dfc) {
            
            userid = dfc.id;
            title = dfc.title__c;
            lastName = dfc.Last_Name__c;
            firstName = dfc.First_Name__c;
            emailAddress = dfc.Email__c;
            telephone = dfc.Contact_Number__c;
            postCode = dfc.postCode__c;
            street = dfc.street__c;
            city = dfc.city__c;
            county = dfc.county__c;
            country = dfc.country__c;
            newsLetter = dfc.Newsletters__c;
            
        }
        
        global ResponseHolder(DF_Contact__c dfc)
        {
            copyDfc(dfc);
            
        } 
        
        global ResponseHolder()
        {
            newsLetter = false;
        }
    }
    
    /* The object returned in the JSON */
    global virtual class Holder
    {
        public String userid;
        public String title;
        public String firstName;
        public String lastName;
        public String birthDate;
        public String emailAddress;
        public String telephone;
        public boolean newsLetter;
        public String postCode;
        public String street;
        public String city;
        public String county;
        public String country;
        public String password;
        public boolean packRequest;
        public String gender;
        public String ethnicGroup;
        public String ethnicOther;
        public String proximity;
        public String remoteHost;
        public String orgName; 
        public String employees;           
        public String orgStreet;
        public String orgCounty;
        public String orgCity;
        public String orgCountry;
        public String orgPostCode;
        public String orgTelephone;
        public String sector;
        public String sectorOther;
        public boolean champnewsletter;
        public string whychampion;
        public string footballTeam; 
        public string videoType;
        public Holder()
        {     
            
        }
        
    }
    
    protected Date getDate(String sDateString) {
        
        if ( sDateString == null || sDateString == '' ) { return null; }
        
        try { 
            
            String[] parts = sDateString.split('/');
            Date dt = null;
            dt = Date.newInstance(Integer.valueOf(parts[2]),Integer.valueOf(parts[1]),Integer.valueOf(parts[0]));       
            return dt;
            
        } catch (Exception x) {
            
            return null; 
            
        }
        
    }
    
    
    public String remoteHost { 
        
        get { 
            
            String ret = '127.0.0.1';
            
            try {
                
                Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
                
                if (hdrs.get('x-original-remote-addr')!= null)        
                    ret =  hdrs.get('x-original-remote-addr');        
                
                else if (hdrs.get('X-Salesforce-SIP')!= null)        
                    ret =  hdrs.get('X-Salesforce-SIP');                        
                
            } catch (exception e) {
                
            }
            
            return ret;        
            
        }
        
    } 
    
    @TestVisible
    protected virtual String getPureEmailTemplateName() {
        
        return DF_Pure360_Email_Handler.MESSAGE_VERIFY_STANDARD;
        
    }
    
    /* Extend these Methods for different classes of Friend */
    @TestVisible
    protected virtual String getEmailTemplateName() {
        
        return 'Verification_Request';
        
    }
    
    @TestVisible
    protected virtual String getRecordTypeName() { 
        
        return DF_Utils.RT_FRIEND;
        
    }
    
    @TestVisible
    protected virtual String getCreatedAsValue() {
        
        return 'Friend';
        
    }
    
    @TestVisible
    protected virtual String getStartUrl() {
        
        return WEBC_CommunityWrapper.COMMUNITY_USER_HOME;
        
    }
    
    @TestVisible
    protected virtual void populateExtendedData() {
        
        dfc.BirthDate__c = getDate(data.birthDate);
        
    }
    
    @TestVisible
    protected virtual void populateBaseData() {
        
        dfc.Title__c = data.title;
        dfc.Name = data.firstName + ' ' + data.lastName;
        dfc.First_Name__c = data.firstName;
        dfc.Last_Name__c = data.lastName;
        dfc.Contact_Number__c = data.telephone;
        dfc.Postcode__c = data.postCode;
        dfc.Street__c = data.street;
        dfc.City__c = data.city;
        dfc.County__c = data.county;
        dfc.Country__c = data.country;
        dfc.Country_Picklist__c = data.country;
        dfc.Newsletters__c = data.newsletter;    
        
    }
    
    @TestVisible
    protected virtual void populateDgData() {
        
        // Contact contact = DF_Utils.getContactRecord(dfc); 
        Contact contact = DF_Utils.getContactRecordForDfcId(dfc.id); 
        if (contact==null) { contact = new Contact(); }
        if(data.ethnicGroup==null && data.ethnicOther==null && data.proximity==null){return;}
        // only one demo record can linked with dfcontact 
        
        Demographic_information__c dg = new Demographic_information__c();
        
        List<Demographic_information__c > lis = [select id, Ethnic_Group__c,Ethnic_Group_Other__c,Contact__c,Proximity_to_dementia__c
                                                 from Demographic_Information__c 
                                                 where   Contact__c =: contact.id                                               
                                                 
                                                 limit 1 ];
        
        if ( lis.isEmpty() ) {
            
            
            dg.contact__c = contact.id;
            dg.Ethnic_Group__c = (data.ethnicGroup!='NULL' ? data.ethnicGroup :'');
            dg.Ethnic_Group_Other__c= data.ethnicOther;
            dg.Proximity_to_dementia__c= data.proximity;
            
            insert dg;        
            
        }  else {        
            dg =lis[0];
            dg.Ethnic_Group__c = (data.ethnicGroup!='NULL' ? data.ethnicGroup :'');
            dg.Ethnic_Group_Other__c= data.ethnicOther;
            dg.Proximity_to_dementia__c= data.proximity;
            upsert dg; 
            
        }          
    }
    
    @TestVisible
    protected virtual void populateIndvData() {
		System.debug('In populateIndvData of RegisterBase class with data: ' + data);
        Contact contact = DF_Utils.getContactRecordForDfcId(dfc.id); 
        if (contact==null) { throw new RegisterBaseException('No contact was found to associate an Individual record against'); }
        
        GDPR gdprInst = new GDPR(data.gdprEmailOptIn, data.gdprPhoneOptIn, data.gdprSmsOptIn, data.gdprSocialOptIn, data.gdprPostOptOut);
        gdprInst.populateIndvData(contact);
        System.debug(gdprInst);
    }
    
}