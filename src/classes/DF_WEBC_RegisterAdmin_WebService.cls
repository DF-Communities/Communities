/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : Web Service Register a subscriber to the newsletter
 *  Author  : Gary Grant
 *  Date    : 16/02/2015
 *  Version : 1.0
 *
 *  Description:    Web Service - registers a new user as a newsletter subscriber
                    also used in the first stage of the Register Friend process
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
@RestResource(urlMapping = '/friend/register-admin/*')
global without sharing class DF_WEBC_RegisterAdmin_WebService {

     @HttpPost      
     global static ResponseHolder doPost(DataHolder data) {
        
        
        system.debug('Web Service - new Business : ' + UserInfo.getUserId());
        
        try {
                    
                ResponseHolder responseHolder = handlePost(data);
                return responseHolder;
                

        } catch (Exception x) {

          system.debug ('Subscribing new Business Error:' + data.emailAddress);            
          ResponseHolder responseHolder = new ResponseHolder();
          responseHolder.returnCode = 0;
          responseHolder.standardErrorMsg = x.getMessage();  
          return responseHolder;
        }

    }
    
    private static ResponseHolder handlePost(DataHolder data)
    {

      ResponseHolder responseHolder = new ResponseHolder();
      RestResponse resp = RestContext.response;
      
     /* Validate the data */
     if ( !isRegistrationDataOK(data, responseHolder) ) {
        
            system.debug ('Subscribing new Business: data is no good');
            responseHolder.returnCode = 0;
            responseHolder.standardErrorMsg = 'Please complete all the required fields';  
            return responseHolder;              
      }
      
      system.debug ('Subscribing new User Data is OK :' + data.emailAddress);

      if (!isRecaptchaOK(data.recaptcha_challenge, data.recaptcha_response, responseHolder) ) {
            responseHolder.returnCode = 0;
            responseHolder.standardErrorMsg = WEBC_RecaptchaHandler.RECAPTCHA_VALIDATION_FAILED;  
            return responseHolder;
      }
      
      system.debug ('Subscribing new User Recaptcha is Ok :' + data.emailAddress);

      WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');

      /* Check to see if there is a DF Contact for this email address */
      Partner_Organisation__c porg = null;      
      
      /* TODO Think about using Email Domain for uniqueness... */ 
      List<Partner_Organisation__c> lisPorgs =[select id, Name, Account__c from Partner_Organisation__c where Name=:data.orgName LIMIT 1];
      
      if ( lisPorgs.isEmpty() ) {
            
        system.debug ('New Admin User : creating Org');             
        porg = new Partner_Organisation__c();
                  
        //porg.Email_Domain__c = data.emailDomain; REMOVED FROM REGISTRATION TO SIMPLIFY THE PROCESS **********************
        porg.Name = data.orgName;          
        porg.Number_of_Employees__c = data.employees;
        porg.Admin_User_Name__c = data.userName;
        
        Account acct = getAccount(porg, community.getCustomSetting('Default_Account_Owner_Id'), data);
        porg.Account__c = acct.id;
        
        system.debug ('New Admin User : Created and Set Account Id');                
        
        insert porg;
        system.debug ('New Admin User : Inserted Org' + porg.id);
        
        Contact contact = getOrgAdminContact(acct, porg, data);
        system.debug ('New Admin User : created Contact');
        
        /* Send the email verification email */
        //String sUserName = community.getOrgAdminUserName(porg.Admin_User_Name__c, porg.Email_Domain__c);
        // UPDATE : User Name displayed to the user does not contain the .admin@OrgEmailDomain extension
        community.sendOrgAdminVerificationRequest(contact, porg.id, porg.Name, data.userName, data.password);
        system.debug ('New Admin User : Sent Verfication Email');
        
        responseHolder = new ResponseHolder(porg);
        responseHolder.returnCode = 1;
    
        return responseHolder;
      
      } else {
        
            system.debug ('Subscribing new Business: Business already exists');
            responseHolder = new ResponseHolder();
            responseHolder.returnCode = 0;
            responseHolder.standardErrorMsg = 'A partner organisation with this name already exists';  
            return responseHolder;
        
      }
    
    }

    private static boolean isRegistrationDataOK(DataHolder data, ResponseHolder responseHolder)
    {

        system.debug('WEBC_RegisterAdmin_Loggin : Entering isRegistrationDataOK');
        
        boolean isOK = true;        
        system.debug('WEBC_RegisterAdmin_Loggin : Starting Tests');

        if ( data.userName == null || data.userName.length() == 0 ) {
            responseHolder.userNameError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            isOK=false;
        }

        if ( data.userName != null || data.userName.length() > 0 ) {

            Pattern uNamePattern = Pattern.compile('(^[a-zA-Z0-9]*$)');
            Matcher uNameMatcher = uNamePattern.matcher(data.UserName);
            if ( !uNameMatcher.matches() ) {
                responseHolder.userNameError = 'Please use numnbers and letter, no spaces and no @';
                isOK=false;
            }
        }        

        if ( data.orgName == null || data.orgName.length() == 0 ) {
            responseHolder.orgNameError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            isOK=false;
        }

        try {

            Partner_Organisation__c porgDup = [select id from Partner_Organisation__c where name = : data.orgName limit 1];
            responseHolder.orgNameError = 'An organisation with this name is already registered';
            isOK=false;

        } catch (Exception x) {

            system.debug('No duplicate org found in DF Org registration');
        }

        try {

            // User Names must be unique across the entire implementation, without distinguishing email domain or organisation
            // This is because the business felt using a classic SF style user name was too complex
            Partner_Organisation__c OrgDup = [select id from Partner_Organisation__c where Admin_User_Name__c =:data.userName limit 1];
            responseHolder.userNameError = 'Sorry. This user name is already taken by another organisation. Please try another.';
            isOK=false;          

        } catch (Exception x) {

          system.debug('No duplicate admin user name found in DF Org registration');
        
        }

        try {

            // User Names must be unique across the entire implementation, without distinguishing email domain or organisation
            // This is because the business felt using a classic SF style user name was too complex
            WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');
            String sUserName = community.getOrgAdminUserName(data.userName, null);
            User userDup = [select id from User where UserName =:sUserName limit 1];
            responseHolder.userNameError = 'Sorry. This user name is taken already. Please try another.';
            isOK=false;          

        } catch (Exception x) {

          system.debug('No duplicate user name found in DF Org registration');
        
        }

        if ( data.postCode == null || data.postCode.length() == 0 ) {
            responseHolder.postCodeError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            isOK=false;
        }
        
        system.debug('WEBC_RegisterAdmin_Loggin : Tests postCode '+ isOK);
        
        if ( (data.city.length() == 0) && (responseHolder.county.length() == 0) ) {
            responseHolder.cityError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            isOK=false;
        }
        
        system.debug('WEBC_RegisterAdmin_Loggin : Tests city / county '+ isOK);
        
        if ( data.country == null || data.country.length() == 0  ) {
            responseHolder.countryError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            isOK=false;
        }

         if ( data.telephone == null || data.telephone.length() == 0 ) {
            responseHolder.telephoneError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            isOK=false;
        }
        
        if ( data.telephone != null && data.telephone.trim().length() == 11 ) {
            
            // Pattern matcher on phone format - must be alpha and numeric and 8 chrs or more 
            
               if ( !WEBC_CommunityWrapper.isPhoneOK(data.telephone) ) {
                    responseHolder.telephoneError = DF_Utils.INVALID_PHONE_MSG;
                    isOK=false;
                    system.debug('WEBC_RegisterAdmin_Loggin : invalid telephone number '+ isOK);
               } 
         }
        
        
        system.debug('WEBC_RegisterAdmin_Loggin : Tests name '+ isOK);
        
        
        if ( data.emailAddress == null || data.emailAddress.trim().length() == 0 ){

            responseHolder.emailAddressError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            isOK=false;

        }

        system.debug('WEBC_RegisterAdmin_Loggin : Tests Email '+ isOK);
        
        if ( data.emailAddress != data.emailAddress2 ){

            responseHolder.emailAddressError = DF_Utils.EMAILS_DO_NOT_MATCH_MSG;
            isOK=false;

        }
        
        
        system.debug('WEBC_RegisterAdmin_Loggin : Tests email match '+ isOK);
        
        if ( data.emailAddress != null && data.emailAddress.trim().length() > 0 ) {
            
                if ( !WEBC_CommunityWrapper.isEmailAddressOK(data.emailAddress) ) {
                    responseHolder.emailAddressError = DF_Utils.INVALID_EMAIL_ADDRESS;
                    isOK=false;
                }
            
        }
        
        system.debug('WEBC_RegisterAdmin_Loggin : Tests email format '+ isOK);
        
        if ( data.password == null || data.password.trim().length() == 0 ){

            responseHolder.passwordError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            isOK=false;
            system.debug('WEBC_RegisterAdmin_Loggin : empty password '+ isOK);

        }
        
        if ( data.password != null && data.password.trim().length() >0 ) {
            
           if ( !WEBC_CommunityWrapper.isPasswordOK(data.password) ) {
                responseHolder.passwordError = DF_Utils.BAD_PASSWORD_MSG;
                isOK=false;
                system.debug('WEBC_RegisterAdmin_Loggin : short password '+ isOK);
           }
             
        }
        
        system.debug('WEBC_RegisterAdmin_Loggin : Tests password '+ isOK);     
                
                
        if ( !isOK ) {
            responseHolder.standardErrorMsg = DF_Utils.STANDARD_ERROR_MSG;    
        }

        system.debug('WEBC_RegisterAdmin_Loggin : All Tests '+ isOK);
        return isOK;        
                
    }
    
    private static String getOrgAdminUserName(DataHolder data)
    {

        return data.userName + '.admin@' + data.emailDomain;

    }

    
    private static boolean isRecaptchaOK(String recaptcha_challenge, String recaptcha_response, ResponseHolder responseHolder)
    {

        try {
            system.debug('WEBC_RegisterAdmin_Loggin :' + recaptcha_challenge);
            system.debug('WEBC_RegisterAdmin_Loggin :' + recaptcha_response);
            system.debug('WEBC_RegisterAdmin_Loggin :' + remoteHost); 
    
            /* Reset these values here because the challenge and response will be set after the page has loaded by the JS code */
            WEBC_RecaptchaHandler recaptchaHandler = new WEBC_RecaptchaHandler(recaptcha_challenge, recaptcha_response, remoteHost);
            if ( !recaptchaHandler.verify() ){
    
                responseHolder.standardErrorMsg = DF_Utils.STANDARD_ERROR_MSG;
                responseHolder.reCAPTCHAError = WEBC_RecaptchaHandler.RECAPTCHA_VALIDATION_FAILED;
                return false;
            }
    
            return true;
        } catch (Exception x) {
            
            system.debug('WEBC_RegisterAdmin_Loggin : ' + x.getMessage());     
            return false;
        }

    }
    
  /* Get or create an account to associate with this Partner Organisation
     The owner must be set to a user with an approrpiate role in the hierarchy
     otherwise the CreatePortalUser action will fail (it uses the account in the registration process)
  */   
    private static Account getAccount(Partner_Organisation__c porg, String ownerId, DataHolder data) {
        
        try {
            
            Account acct = [select Id, Name from Account where name = :porg.Name];
            return acct;                        
            
        } catch (Exception x) {
            
            Account acct = new Account();
            acct.Name = porg.Name;
            acct.OwnerId = ownerId;
        
            acct.ShippingStreet = data.street;
            acct.ShippingState = data.county;
            acct.ShippingCity = data.city;
            acct.ShippingCountry = data.country;
            acct.ShippingPostalCode = data.postCode;

            insert acct;            
            return acct;            
            
        }       
        
    }
 
    private static Contact getOrgAdminContact(Account acct, Partner_Organisation__c porg, DataHolder data) {
        
        String recordTypeId = DF_Utils.getContactRecordTypeId(DF_Utils.RT_ORG_ADMIN);        
        Contact contact = null;
        
        try {

            /* Double check the contact does not already exist */           
            contact = [select id, Name, Email from Contact where RecordTypeId =:RecordTypeId and Email =:data.emailAddress];                    

        } catch (Exception x) {
            
            system.debug('Creating new Dementia Friends Admin Contact ');
            contact = new Contact();
            contact.AccountId = acct.id;
            contact.Email = data.emailAddress;
            contact.FirstName = data.firstName;
            contact.LastName = data.lastName;
            contact.RecordTypeId = recordTypeId; 
            contact.Newsletters__c = data.newsletter;
            
            insert contact;
            
        }
        
        return contact;
        
    }



    global class DataHolder extends Holder
    {
        
        public String recaptcha_challenge;
        public String recaptcha_response;    

        public String emailAddress2; 
        public String password2;                                    

    }

    /* The object returned in the JSON */
    global class ResponseHolder extends Holder
    {

        Integer returnCode;
        String message = '';
        String standardErrorMsg = '';
        String reCAPTCHAError = '';
        String firstNameError = '';
        String lastNameError = '';
        String orgNameError = '';
        String emailAddressError = '';
        String passwordError = '';
        String employeesError = '';
        String telephoneError = '';
        String userNameError = '';
        String emailDomainError = '';

        String postCodeError = '';
        String streetError = '';
        String cityError = '';
        String countyError = '';
        String countryError = '';

        public ResponseHolder()
        {

        }

        public ResponseHolder(Partner_Organisation__c porg)
        {
            orgName = porg.Name;
            employees = porg.Number_of_Employees__c;
            emailDomain = porg.Email_Domain__c;


        } 

    }


    global abstract class Holder
    {
        public String orgName = '';
        public String firstName = '';
        public String lastName = '';
        public String emailAddress = '';
        public String password = '';
        public String employees = '';
        public String telephone = '';
        public String userName = '';
        public String emailDomain = '';

        public String postCode = '';
        public String street = '';
        public String city = '';
        public String county = '';
        public String country = '';
        public Boolean newsletter = false;

    }
    
    private static String remoteHost { 
        
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
 
            RestRequest req = RestContext.request;           
            Map<String, String> hdrs = req.headers;   
            if (hdrs.get('x-original-remote-addr')!= null)        
                ret =  hdrs.get('x-original-remote-addr');        
            else if (hdrs.get('X-Salesforce-SIP')!= null)        
               ret =  hdrs.get('X-Salesforce-SIP');        
            return ret;        
        }
    }    

  @TestVisible 
  private class MyException extends Exception {}
    
}