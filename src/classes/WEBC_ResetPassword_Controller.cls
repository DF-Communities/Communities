/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Reset user password
 *  Author  : Gary Grant
 *  Date    : 10 Feb 2015
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 

*******************************************************************************************/ 

public without sharing class WEBC_ResetPassword_Controller {

    public String password{get;set;}
    public String password2{get;set;}
    public String userData {get;set;}
    public String communityPrefix {get;set;}
    public String errorMessage {get;set;}
    public String errorBadDataMessage{get;set;}
    public Contact contact {get;set;}

    public WEBC_ResetPassword_Controller() {                
        
        userData = ApexPages.currentPage().getParameters().get('data');
        communityPrefix = ApexPages.currentPage().getParameters().get('c');     
        contact = getContact();
    
    }

    private Contact getContact() {

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper(communityPrefix);

        String key = community.secretKey;
        system.debug('Crypto Value : Key :' + key);

        String stringValue = WEBC_CryptoUtils.decryptValue(userData, key);
        system.debug('Crypto Value : ' + stringValue);
        
        if ( stringValue.startsWith('Error') ) {            
            errorBadDataMessage = 'User data supplied is not valid';
            return null;
        }

        String[] stringValues = stringValue.split(':::');
        String id = stringValues[0];
        String sRandomString = stringValues[1];
        String sTime = stringValues[2];
        
        DateTime dt = system.now();
        DateTime dtCheck = DateTime.newInstance(Long.valueOf(sTime));
        
        if ( dt.getTime() - dtCheck.getTime() > (3600000 * 6) ) {           
            errorBadDataMessage = 'User data is invalid : Reset password request has expired';  
            return null;        
        }   

        List<Contact> lisContacts = [select Id, Email, FirstName, LastName, Password_Reset_Key__c, RecordType.DeveloperName from Contact where Id=:id];
        
        if ( lisContacts.isEmpty() ) {
            errorBadDataMessage = 'User data is invalid : Cannot find user record';
            return null;
        }
        
        Contact contact = lisContacts[0];
        
        /* Check that the random string entered when the request was originally made matches */ 
        if ( contact.Password_Reset_Key__c != sRandomString ) {
            errorBadDataMessage = 'User data is invalid  : This password reset request has been used before';
            return null;
        }

        return contact;

    }


    /* This is the response to a click on an email verification */
    public PageReference resetPassword() {

        if ( password == null || password.length()==0 ) {
            
            errorMessage = 'Passwords entered do not match';
            return null;                
        }


        if ( password != password2 ) {          
            
            errorMessage = 'Passwords entered do not match';
            return null;            
        
        }
        
        if ( !WEBC_CommunityWrapper.isPasswordOK(password) ) {
            
            errorMessage = 'Password must be minimum 8 characters with numbers and letters and cannot contain the word \'password\'';
            return null;            
        }

        if (contact==null) { 
            errorMessage = 'User data invalid : (Contact record not found in the database)';
            return null; 
        }
                        
        User u = WEBC_CommunityWrapper.getUserRecord(contact);

        if (u != null) {

            /* If a user record is found, update the password and log the user in */
            system.debug('Reset Password Community User Record Found');

            try {   

                system.setPassword( u.id, password );
                contact.Password_Reset_Key__c = null;       
                update contact;

            } catch (Exception x) {
                        

                    system.debug('Password reset failed: ' + x.getMessage());
                    
                    /* The password change may fail because the user is not allowed to 
                       use an old password again
                    */

                    errorMessage = 'Password is not valid. Please try a different password.';                       
                    String[] sError = x.getMessage().split(':');
                    errorMessage = errorMessage + ' [' + sError[1] + ']';
                    
                    String sLowerError = x.getMessage().toLowerCase();
                    if ( sLowerError.contains('invalid repeated password') )  { 
                        errorMessage = 'Error : this old password cannot be reused.';                           
                    }

                    return null;
            }

            return Site.login(u.UserName, password, WEBC_CommunityWrapper.COMMUNITY_USER_HOME);

        } else {

            /* If a user record is not found, this is a user who registered, but never validated their account
               Being here effectively validates their email account so register based on the details provided and log them in.
            */   
            WEBC_CommunityWrapper community = new WEBC_CommunityWrapper(communityPrefix);
            u = community.registerUser(contact.LastName, contact.FirstName, contact.Email, password, false);            
            return Site.login(contact.Email, password, WEBC_CommunityWrapper.COMMUNITY_USER_HOME);

        }

    }

}