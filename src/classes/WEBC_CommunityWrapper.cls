/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : A wrapper class with useful utilities for managing communities
 *  Author  : Gary Grant
 *  Date    : 10 Feb 2015
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 
                            
*******************************************************************************************/ 


public class WEBC_CommunityWrapper {

    public final static String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public final static String PASSWORDS_DO_NO_MATCH_MSG = 'Passwords did not match';
    public final static String PASSWORD_WRONG_LENGTH_MSG = 'Password must be at least 8 characters';
    public final static String PASSWORD_NO_NUMBERS_MSG = 'Passwords must be a mix of numbers and letters';
    
    public String profileId {get;private set;}
    public String accountId {get;private set;}
    public String stubUrl {get;private set;}
    public String siteName {get; private set;}
    public String communityPrefix{get; private set;}
    public String secretKey {get; private set;}

    /*
    Map<String, String> mapSettings {private get; private set;}
    */

    /* Redirect this using the URL Rewriter for the relevant community */
    public final static String COMMUNITY_USER_HOME = '/user-home';
    public final static String CREATE_ACTIONS = '/WEBCreateActions';

    /* For tests only */
    private User testSysAdminUser {get;set;}
    private Profile testProfile {get;set;}
        
    public WEBC_CommunityWrapper(String communityPrefix)
    {

        this.communityPrefix = communityPrefix; 

        this.accountId = getCustomSetting('Default_Account_Id');
        
        this.profileId = getCustomSetting('Default_Profile_Id');

        this.stubUrl = getCustomSetting('Stub_Url');
        
        this.siteName = getCustomSetting('Site_Name');

        this.secretKey = getCustomSetting('Secret_Key');


    } 
    
    /* Method used when instatiating a Community Wrapper is not worth the code processing */
    @AuraEnabled
    public static String getCustomSetting (String name, String prefix) {

        if ( Test.isRunningTest() ) {           
            return 'a_dummy_Value';         
        }
        
        return (String)Community_Settings__c.getInstance(prefix + '_' +  name).value__c;

    }

    public static String getOrgWideEmailId(String prefix) {


        String sOrgWideId = null;
        OrgWideEmailAddress[] owea = null;

        if ( Test.isRunningTest() ) { 
            return null;
        }          
        
        String sReplyTo = (String)Community_Settings__c.getInstance(prefix + '_Default_Reply_To_Address').value__c;
        owea = [select Id from OrgWideEmailAddress where Address =:sReplyTo];
        if (owea.size()>0) { return owea.get(0).id; }
        
        return null;

    }



    /* A Static method for calling from other static classes. Provide the name and prefix separately */
    public String getCustomSetting(String name)
    {                   
        if ( Test.isRunningTest() ) {           
            return DF_DataFactory_Test.getCustomSettingTestValue(name);         
        }
        
        return (String)Community_Settings__c.getInstance(communityPrefix + '_' +  name).value__c;
        
        /*
        
        This method of configuration does not make use of the in-built application cache for 
        Custom Settings.        
        
        if ( mapSettings == null ) {
            mapSettings = new Map<String, String>();
            String soql = 'select Id, Value__c, Name from ' + communityPrefix + '_Community_Settings__c order by id';
            List<sObject> lis = Database.query(soql);

            for (sObject o : lis) {
                system.debug('Custom Setting : ' + (String)o.get('Name') + ':' + (String)o.get('Value__c'));
                mapSettings.put((String)o.get('Name'), (String)o.get('Value__c'));
            }
        }       

        return mapSettings.get(name);
        */
        
    }


    /* 
        Send a verification email. 
        The email will contain a link with the password objectId and randomString encoded into it
        The randomString can be stored in the object being verified to ensure the correct object is verified
    */  
    public boolean sendVerificationRequest(Contact contact, String password)
    { 

        return sendVerificationRequestV1(contact, password);

    }

    /* Verification email with custom startUrl */
    public boolean sendVerificationRequest(Contact contact, String password, String startUrl) { 
		
        system.debug('Sending Community Verification id: ' + contact.id);
           return sendVerificationRequest(contact, password, startUrl, null); 
    }

    public String getVerifyUrl(Contact contact, String password, String startUrl) {

        RegistrationData data = new RegistrationData();
        data.randomString = generateRandomString(12);
        data.id = contact.id;
        data.password = password;
        if ( startUrl != null ) { data.startUrl = startUrl; }

        /* data is set up as a JSON string, encrypted and encoded into the email */
        String sJson = JSON.serialize(data);
        system.debug('JSON DATA : ' + sJson);
        String encryptedData = WEBC_CryptoUtils.encryptValue(sJson, getCustomSetting('Secret_Key'));
        String encodedData = EncodingUtil.urlEncode(encryptedData, 'UTF-8');
        system.debug('Sending Community Verification encrypted data: ' + encryptedData);    
        system.debug('Sending Community Verification stubUrl: ' + stubUrl);

        /*  Store the random String. 
            Only verification requests with this string will succeed and when it is cleared
            by the verification process it will prevent the same verification running twice 
         */
         contact.Password_Reset_Key__c = data.randomString;
         update contact;

         /* Make sure the UrlReWriter class is in place for this. 
            Note this is V2 of the process which uses JSON and will respond to a custom URL 
         */
         String sVerifyUrl = stubUrl + 'verify?data=' + encodedData + '&v=2&c=' + communityPrefix;
         return sVerifyUrl;

    }


    /* Verfification email with custom startUrl and custom email template */
    public boolean sendVerificationRequest(Contact contact, String password, String startUrl, String template)
    {
		System.debug('++++ In Community Verification method with: ' + contact + ' ' + password + ' ' + startUrl + ' ' + template);
       try {

            System.debug('Sending Community Verification Id: ' + contact.id);
    
            String sTemplateName = communityPrefix + '_Verification_Request';
            
            if ( template != null ) { 
                sTemplateName = communityPrefix + '_' + template;
            }
    
            // Reserve email capacity for the current Apex transaction       
            Messaging.reserveSingleEmailCapacity(1);
            
            String sReplyTo = getCustomSetting('Default_Reply_To_Address');
            System.debug('Sending Community Verification reply Address: ' + sReplyTo);
    
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:sReplyTo];
            String oweaId = null;
            if ( owea.size() > 0 ) {
                oweaId = owea.get(0).Id;
            }
     
            String sVerifyUrl = getVerifyUrl(contact, password, startUrl);
    
            Map<String, String> mapValues = new Map<String, String>();
            mapValues.put('contact_name', contact.name);
            mapValues.put('verifyLink', sVerifyUrl);

            Messaging.SingleEmailMessage mail = Mail_Utils.getEmailWithData(sTemplateName, 
                                                                 contact.id, 
                                                                 null,
                                                                 oweaId, 
                                                                 true, 
                                                                 null, 
                                                                 mapValues);
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           


        } catch (Exception x) {
            
            system.debug('Error sending Verification email: ' + x.getMessage());
            return false;           
            
        }
        
        system.debug('Sending verification email Now ');
        return true;
    }
    
    public boolean sendAdminVerificationRequest(Contact contact,String orgName, String password, String startUrl, String template)
    {

       try {

            System.debug('Sending Community Verification Id: ' + contact.id);
    
            String sTemplateName = communityPrefix + '_Verification_Request';
            
            if ( template != null ) { 
                sTemplateName = communityPrefix + '_' + template;
            }
    
            // Reserve email capacity for the current Apex transaction       
            Messaging.reserveSingleEmailCapacity(1);
            
            String sReplyTo = getCustomSetting('Default_Reply_To_Address');
            System.debug('Sending Community Verification reply Address: ' + sReplyTo);
    
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:sReplyTo];
            String oweaId = null;
            if ( owea.size() > 0 ) {
                oweaId = owea.get(0).Id;
            }
     
            String sVerifyUrl = getVerifyUrl(contact, password, startUrl);
    
            Map<String, String> mapValues = new Map<String, String>();
            mapValues.put('contact_name', contact.name);
            mapValues.put('organisation_name', orgName);
            mapValues.put('verifyLink', sVerifyUrl);

            Messaging.SingleEmailMessage mail = Mail_Utils.getEmailWithData(sTemplateName, 
                                                                 contact.id, 
                                                                 null,
                                                                 oweaId, 
                                                                 true, 
                                                                 null, 
                                                                 mapValues);
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           


        } catch (Exception x) {
            
            system.debug('Error sending Verification email: ' + x.getMessage());
            return false;           
            
        }
        
        system.debug('Sending verification email Now ');
        return true;
    }
    

    public boolean sendVerificationRequestV1(Contact contact, String password)
    {

       try {

            system.debug('Sending Community Verification (V1) id: ' + contact.id);
    
            String sTemplateName = communityPrefix + '_Verification_Request';
            EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = :sTemplateName];
    
            //reserve email capacity for the current Apex transaction       
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setTargetObjectId(contact.Id);
    
            String sReplyTo = getCustomSetting('Default_Reply_To_Address');
            system.debug('Sending Community Verification reply Address: ' + sReplyTo);
    
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:sReplyTo];
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            String sRandomString = generateRandomString(12);
            String sContactKey = contact.id + ':::' + password + ':::' + sRandomString;
            String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, getCustomSetting('Secret_Key'));
            String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');
            system.debug('Sending Community Verification encrypted data: ' + encryptedContactKey);
    
            system.debug('Sending Community Verification stubUrl: ' + stubUrl);
            /* Make sure the UrlReWriter class is in place for this */
            String sVerifyLinkUrl = stubUrl + 'verify?data=' + encryptedContactKey + '&c=' + communityPrefix;
    
            // Specify the subject line for your email address.
            system.debug('Sending Community Verification siteName: ' + siteName);
            String subject = emailTemplate.Subject;
            mail.setSubject(subject);
    
            String sBody = emailTemplate.Body;
            sBody=sBody.replace('{{contact_name}}',contact.Name);
            sBody=sBody.replace('{{verifyLink}}',sVerifyLinkUrl);
            mail.setPlainTextBody(sBody);
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           

            contact.Password_Reset_Key__c = sRandomString;
            update contact;     
        
        } catch (Exception x) {
            
            system.debug('Error sending Verification email: ' + x.getMessage());
            return false;           
            
        }
        
        system.debug('Sending verification email Now ');
        return true;
        

    }

    public String getOrgAdminUserName(String prefix, String email_domain) {

            if ( email_domain == null || email_domain == '' ) { 

                return prefix + '.admin@' + communityPrefix.toLowerCase() + '_organisation.com';
            }

            return prefix + '.admin@' + email_domain;

    }

    /* 
        Send a verification email for an Org Admin. 
        The email will contain a link with the passowrd objectId and randomString encoded into it
        The randomString can be stored in the object being verified to ensure the correct object is verified
    */  
    public boolean sendOrgAdminVerificationRequest(Contact contact, String orgId, String sOrgName, String sUserName, String password)
    {

       try {

            system.debug('Sending Community Verification id: ' + contact.id);
    
            String sTemplateName = communityPrefix + '_Admin_Verification_Request';
            EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = :sTemplateName];
    
            //reserve email capacity for the current Apex transaction       
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setTargetObjectId(contact.Id);
    
            String sReplyTo = getCustomSetting('Default_Reply_To_Address');
            system.debug('Sending Community Verification reply Address: ' + sReplyTo);
    
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:sReplyTo];
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            String sRandomString = generateRandomString(12);
            String sContactKey = contact.id + ':::' + orgId + ':::' + password + ':::' + sRandomString;
            String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, getCustomSetting('Secret_Key'));
            String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');
            system.debug('Sending Community Verification encrypted data: ' + encryptedContactKey);
    
            system.debug('Sending Community Verification stubUrl: ' + stubUrl);
            /* Make sure the UrlReWriter class is in place for this */
            String sVerifyLinkUrl = stubUrl + 'verify-admin?data=' + encryptedContactKey + '&c=' + communityPrefix;
    
            // Specify the subject line for your email address.
            system.debug('Sending Community Verification siteName: ' + siteName);
            String subject = emailTemplate.Subject;
            mail.setSubject(subject);
        
            String sContactName = contact.Name;
            if ( contact.Name==null || contact.Name == '' ) {

                sContactName = contact.FirstName + ' ' + contact.LastName;
            }

    
            String sBody = emailTemplate.Body;
            sBody=sBody.replace('{{contact_name}}',sContactName);
            sBody=sBody.replace('{{organisation_name}}',sOrgName);
            sBody=sBody.replace('{{user_name}}', sUserName);
            
            sBody=sBody.replace('{{verifyLink}}',sVerifyLinkUrl);
            mail.setPlainTextBody(sBody);
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           

            contact.Password_Reset_Key__c = sRandomString;
            update contact;     
        
        } catch (Exception x) {
            
            system.debug('Error sending Verification email: ' + x.getMessage());
            return false;           
            
        }
        
        system.debug('Sending verification email Now ');
        return true;
        

    }

    public static Contact getContactRecordForUser(User user) {
        
            system.debug('CommunityWrapper : ContactId for User ' + user.id + ' : ' + user.ContactId);
        
            
            if ( user.ContactId == null ) { 
            
                system.debug('CommunityWrapper : ContactId null getting contact');  
                return null; 
                
            }
            
            system.debug('CommunityWrapper : user is not null ');
            List<Contact> lisContact = null;
            try {
        
                lisContact = [select id, name, FirstName, LastName,phone, Title, Email, AccountId from Contact where id =:user.ContactId];
                if ( lisContact.isEmpty() ) { 
                    system.debug('CommunityWrapper : lis is Empty');
                    return null;                
                }
                    
            } catch(Exception x) {              
                system.debug('CommunityWrapper : lis is Empty ' + x.getMessage());
            }
            
            Contact contact = (Contact)lisContact[0]; 
            system.debug('CommunityWrapper : ContactId ' + contact.id);
            return contact;     
        
    }


    public boolean sendForgotPasswordEmail(Contact contact) { 
        
        User user = getUserRecord(contact);
        return sendForgotPasswordEmail(contact, user);      
    }

    public boolean sendForgotPasswordEmail(User user) { 
                
        Contact contact = getContactRecordForUser(user);
        return sendForgotPasswordEmail(contact, user);      
    }

    /* 
        Send a forgot password email. This is a custom configured email that flags a reset password request
        The email contains the user id and a key that is generated here and stored in the DF Contact Record
          
    */
    public boolean sendForgotPasswordEmail(Contact contact, User user)
    {

        try {

            system.debug('Sending Community Password Forgot : ' + contact.id);
        
            String sTemplateName = communityPrefix + '_Forgot_Password';
            EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = :sTemplateName];
    
            //reserve email capacity for the current Apex transaction       
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setTargetObjectId(contact.Id);
    
            String sReplyTo = getCustomSetting('Default_Reply_To_Address');
            system.debug('Sending Community Verification reply Address: ' + sReplyTo);
    
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:sReplyTo];
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
                        
            DateTime dt = system.now();
            String sRandomString = generateRandomString(12);
            String sContactKey = contact.id + ':::' + sRandomString + ':::' + dt.getTime();
            String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, getCustomSetting('Secret_Key'));
            String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');
            system.debug('Sending password reset encrypted data: ' + encryptedContactKey);
    
            system.debug('Sending password reset stubUrl: ' + stubUrl);
            /* Make sure the UrlReWriter class is in place for this */
            String sVerifyLinkUrl = stubUrl + 'reset-password?data=' + encryptedContactKey + '&c=' + communityPrefix;
    
            // Specify the subject line for your email address.
            system.debug('Sending password reset: ' + siteName);
            String subject = emailTemplate.Subject;
            mail.setSubject(subject);
    
            String sBody = emailTemplate.Body;
            sBody=sBody.replace('{{contact_name}}',contact.Name);
            

            String sUserName = user.UserName;
            if ( isAdminUserName(sUserName) ) {
                sUserName = getAdminUserNamePrefix(user.UserName);                
            }

            sBody=sBody.replace('{{user_name}}',sUserName);

            sBody=sBody.replace('{{verifyLink}}',sVerifyLinkUrl);
            mail.setPlainTextBody(sBody);
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            contact.Password_Reset_Key__c = sRandomString;
            update contact;     
            
        } catch (Exception x) {
            
            system.debug('Error sending Forgot Password email: ' + x.getMessage());
            return false;           
            
        }

        system.debug('Sending password reset email Now ');
        return true;

    }
    
     public User registerUser(String lastName, String firstName, String email, String password, boolean bSendNotification)
    {
        
        User u = new User();
        u.Username = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.Email = email;        
        u.CommunityNickname = (email.length() > 40 ? email.substring(0,40) : email);
        u.ProfileId = profileId;
        
        // TODO - sort this out. All times in the web site are shown in GMT - session times etc. 
        // That needs to be investigated. For now it makes sense as all Portal users are UK based  April 2015
        u.TimeZoneSidKey='Europe/London'; // set all users to GMT timezone   290716 LV  set timezone to BST
                    
        String sPassword = (password==null || password== ''? 'NotSetByUser99' : password);                    
                                   
        system.debug('Creating New User  Data : ' + accountId + ',' + profileId + ',' + sPassword + ',' + bSendNotification);                           
                                                                            
        String userId = Site.createPortalUser(u, accountId, sPassword, bSendNotification);
        system.debug('WEBC_CommunityWrapper : Portal User Created Id :' + userId);
        
        if (userid==null) {
        
            if ( !Test.isRunningTest() ) {
            
                system.debug('WEBC_CommunityWrapper : Error Email for Null UserId Ignored');
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { getCustomSetting('Sys_Admin_Id') };
                message.setSubject(communityPrefix + ' Community User Registration Error : ' + email);
                message.plainTextBody = communityPrefix + ' Error in Registration : ' + email + ' : ' + System.now();
                Messaging.SingleEmailMessage[] messages = 
                        new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            }

            return null; 

        }
        
        
         return   [select id,Username,FirstName,LastName,Email,CommunityNickname,ProfileId,contactId from User where id=:userId ];
        
    }
    

    public User registerOrgAdminUser(Contact contact, String sUserName, String password, boolean bSendNotification)
    {
        
        User u = new User();
        u.Username = sUserName;
        u.FirstName = contact.FirstName;
        u.LastName = contact.LastName;
        u.Email = contact.email;

        String[] vUserName = sUserName.split('@');        
        u.CommunityNickname = vUserName[0];
        u.ProfileId = profileId;
        u.TimeZoneSidKey='GMT'; // set all users to GMT timezone
                    
        String sPassword = (password==null || password== ''? 'NotSetByUser99' : password);                    
                                   
        system.debug('Creating New User  Data : ' + contact.accountId + ',' + profileId + ',' + sPassword + ',' + bSendNotification);                           
                                                                            
        String userId = Site.createPortalUser(u, contact.AccountId, sPassword, bSendNotification);
        system.debug('WEBC_CommunityWrapper : Portal User Created Id :' + userId);
    
        if ( userid == null ) {

            if ( !Test.isRunningTest() ) {
            
                system.debug('WEBC_CommunityWrapper : Error Email for Null UserId Ignored');

                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { getCustomSetting('Sys_Admin_Id') };
                message.setSubject(communityPrefix + ' Org Admin Registration Error : ' + contact.Email + ' : ' + contact.AccountId );
                message.plainTextBody = communityPrefix + ' Error in Registration : ' + contact.Email + ' : ' + contact.AccountId + ' : ' + System.now();
                Messaging.SingleEmailMessage[] messages = 
                        new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            }

            return null; 
        }

        return   [select id,Username,FirstName,LastName,Email,CommunityNickname,ProfileId,contactId from User where id=:userId ];
        
    }


    public static User getUserRecord(Contact contact)
    {
        
            system.debug('Utils - querying user for contact : ' + contact.Id);
            
            /* The Connection between DF_Contact and Contact is established
               with a future method, so may not be immediately available */             
            try { 
            
                User u = [select id, Name, UserName, Email, ContactId from User where ContactId =: contact.id LIMIT 1];

                system.debug('User Record Found : ' + contact.id);
                return u;
            
            } catch (Exception x) {             

                system.debug('User Record Not Found : ' + contact.id);
                system.debug(x.getMessage());
                return null;                

            }
        
    }
    
    /* Does this DF_Contact have registered User record (for login) */  
    public static boolean hasUserRecord(Contact contact)
    {
            User u = getUserRecord(contact);
            system.debug('Community Wrapper - User Record is null : ' + u == null);
            return u != null; 
    }


    public static String generateRandomString(Integer len) {
        
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    
        String randStr = '';
        
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
            randStr += chars.substring(idx, idx+1);
        }
        
        return randStr; 
    }
    
    public static boolean isPhoneOK(String phoneNumber) {
        
        //Pattern emailPattern = Pattern.compile('([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
        
        string s = phoneNumber;
        s=s.trim();
        s= s.replaceall('(\\s+)', '');
        
        Pattern phonePattern = Pattern.compile('(^0[0-9]{10}$)');

        Matcher phoneMatcher = phonePattern.matcher(s);
        system.debug('*** -- emailPatternMatcher = ' + phoneMatcher.matches() + ' -- ***');            
        return phoneMatcher.matches();      
    }
    


    public static boolean isPasswordOK(String password) {
        
        if ( password.trim().length() < 8 ) {
            return false;
        }

        if ( password.toLowerCase().indexOf('password') > -1 ) { 
            return false;
        }

        return password.isAlphanumeric();

        /*       
        Pattern passwordPattern = Pattern.compile('^([a-zA-Z+]+[0-9+]+|[0-9+]+[a-zA-Z+]+)$');
        Matcher passwordMatcher = passwordPattern.matcher(password);
        system.debug('*** -- passwordPatternMatcher = ' + passwordMatcher.matches() + ' -- ***');

        return passwordMatcher.matches();       

        */
                          
        
    }
    
    public static boolean isEmailAddressOK(String emailAddress) {
        
        //Pattern emailPattern = Pattern.compile('([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
        
        // Very simple pattern that does not pick uip all special characters, but traps spaces etc
        // The pattern above does not capture all special characters
        Pattern emailPattern = Pattern.compile('(^\\S+@\\S+\\.\\S+$)');

        Matcher emailMatcher = emailPattern.matcher(emailAddress);
        system.debug('*** -- emailPatternMatcher = ' + emailMatcher.matches() + ' -- ***');            
        return emailMatcher.matches();      
    }
    
    public static Boolean isLoggedIn {
    
        get {
              system.debug('Is logged in ' + UserInfo.getUserType());
              return (UserInfo.getUserType() == 'Guest' ? false : true);
        }
    
    }
    
    public static User currentUser {
        
        get {
        
            if ( !isLoggedIn ) { return null; } 
            return [SELECT Id, Email, Username, AccountId, ContactId, firstName, lastName, title, CommunityNickname
                                FROM User
                                WHERE Id = :UserInfo.getUserId()
                                Limit 1];                       
        }
        
        private set;
        
    }

    public static String getAdminUserNamePrefix(String sUserName) {

        try {
            return sUserName.split('.admin')[0];
        } catch (Exception x) {
            return sUserName;
        }
    }
   
    public static boolean isAdminUserName(String sUserName) {
        boolean b = sUserName.contains('.admin@');  
        return b;
    }

    public static boolean isOrgAdmin() {

        String sUserName = UserInfo.getUserName();
        boolean b = isAdminUserName(sUserName);  
        system.debug('User isAdmin : ' + b);
        return b;

        /*  
            try {

                if ( user.ContactId == null || user.ContactId =='') { return false; }
                Contact contact = [select id, name, email, RecordType.DeveloperName from Contact where id =: user.ContactId];
                if ( contact.RecordType.DeveloperName == DF_Utils.RT_ORG_ADMIN ) { return true; }
                return false;

            } catch (Exception x) {

                system.debug('User not found looking for isAdmin');
                return false;

            }
            */

    }

    public class RegistrationData {

        public String email {get;set;}
        public String id {get;set;}
        public String password {get;set;}
        public String randomString {get;set;}
        public String startUrl {get;set;}
        public String name{get;set;}


    }

}