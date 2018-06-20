/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Take a link from an email and verify the user, register in the community
 *  Author  : Gary Grant
 *  Date    : 10 Feb 2015
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 

*******************************************************************************************/ 

global abstract class WEBC_VerifyRegistration_Controller extends WEBC_ControllerBase {


    public  WEBC_VerifyRegistration_Controller() {
        
    }

    public pageReference doAction() {

        String v = ApexPages.currentPage().getParameters().get('v');
        if ( v == null ) { return doActionV1(); }
        return doActionV2();

    }

    /* November 2015. New style of registration using a JSON format for the data */
    private pageReference doActionV2() {

        if ( isLoggedIn && !Test.isRunningTest()) {
            return new PageReference('/errorPage?msg=E001'); 
        }

        /* Get the data parameter from the Url */
        String encryptedValue = ApexPages.currentPage().getParameters().get('data');
        system.debug('Verify Registration : ' + encryptedValue);

        /* The community prefix */
        String communityPrefix = ApexPages.currentPage().getParameters().get('c');
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper(communityPrefix);

        String key = community.secretKey;
        system.debug('Crypto Value : Key :' + key);

        String sJson = WEBC_CryptoUtils.decryptValue(encryptedValue, key);
        system.debug('Crypto Value : ' + sJson);
        
        if ( sJson.startsWith('Error') ) {            
            return new PageReference('/errorPage');
        }

        WEBC_CommunityWrapper.RegistrationData data = (WEBC_CommunityWrapper.RegistrationData)JSON.deserialize(sJson, WEBC_CommunityWrapper.RegistrationData.class);

        List<Contact> lisContacts = [select Id, Email, Name, LastName, FirstName, RecordType.DeveloperName, Password_Reset_Key__c from Contact where Id=:data.id];
        if ( lisContacts.size() ==0 ) {
            system.debug('Verify Registration Community Contact not found : ');
            PageReference pageReference = new PageReference('/errorPage');
            return pageReference;
        }

        Contact contact = (Contact)lisContacts[0];

        if  ( data.randomString != contact.Password_Reset_Key__c ) {
            system.debug('Verify Registration Community Password Reset Key does not match : ');
            return new PageReference('/errorPage?msg=E005');  
        }

        system.debug('Verifiy Registration Community Contact : ' + contact.id);

        String startUrl = (data.startUrl == null || data.startUrl=='' ? WEBC_CommunityWrapper.COMMUNITY_USER_HOME : data.startUrl);

        if (!WEBC_CommunityWrapper.hasUserRecord(contact)) {

            system.debug('Verifiy Registration Community No User Record : ');
            User u = community.registerUser(contact.LastName, contact.FirstName, contact.Email, data.password, false);       

            if (u == null) { 
        
                system.debug('Verify Registration Error Creating Community User: ');
                PageReference pageReference = new PageReference('/errorPage');
                return pageReference;
            
            } else {

                system.debug('Verify Registration Created Community User: ' + u.id);
                doPostRegistration(u);                
                return Site.login(contact.Email, data.password, startUrl);
                
            }


        }  else {

            /* The link has already been clicked */  
            system.debug('Verify Registration User has Record Already: ');
            PageReference pageReference = new PageReference('/errorPage');            
            pageReference.getParameters().put('msg','E002');
            return pageReference;  

        }

    }


    /* This is the response to a click on an email verification */
    public PageReference doActionV1(){

        if ( isLoggedIn && !Test.isRunningTest()) {
            return new PageReference('/errorPage?msg=E001'); 
        }

        /* Get the data parameter from the Url */
        String encryptedValue = ApexPages.currentPage().getParameters().get('data');
        system.debug('Verify Registration : ' + encryptedValue);

        /* The community prefix */
        String communityPrefix = ApexPages.currentPage().getParameters().get('c');
        system.debug('Verify Registration Community Key : ' + communityPrefix);
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper(communityPrefix);

        String key = community.secretKey;
        system.debug('Crypto Value : Key :' + key);

        String stringValue = WEBC_CryptoUtils.decryptValue(encryptedValue, key);
        system.debug('Crypto Value : ' + stringValue);
        
        if ( stringValue.startsWith('Error') ) {            
            return new PageReference('/errorPage');
        }

        String[] stringValues = stringValue.split(':::');
        String id = stringValues[0];
        String password = stringValues[1];
        String sRandomString = stringValues[2];

        Contact contact = [select Id, Email, Name, LastName, FirstName, RecordType.DeveloperName, Password_Reset_Key__c from Contact where Id=:id];
        if ( contact == null ) {
            system.debug('Verifiy Registration Community Contact not found : ');
            return new PageReference('/errorPage');
        }

        if  ( sRandomString != contact.Password_Reset_Key__c ) {
            system.debug('Verifiy Registration Community Password Reset Key does not match : ');
            return new PageReference('/errorPage');  
        }

        system.debug('Verifiy Registration Community Contact : ' + contact.id);

        String startUrl = WEBC_CommunityWrapper.COMMUNITY_USER_HOME;

        if (!WEBC_CommunityWrapper.hasUserRecord(contact)) {

            system.debug('Verifiy Registration Community No User Record : ');
            User u = community.registerUser(contact.LastName, contact.FirstName, contact.Email, password, false);       
            //doPostRegistration(u,contact);


            if (u == null) {
        
                system.debug('Verifiy Registration Error Creating Community User: ');
                return new PageReference('/errorPage');
            
            } else {
                 system.debug('++user+++'+u);
                 doPostRegistration(u);
                
                system.debug('Verifiy Registration New Community User : ' + u.id);
                return Site.login(contact.Email, password, startUrl);
                
            }

        }  else {

            /* The link has already been clicked 
               TODO - how some kind of message to say the link has already been clicked     
            */  
            system.debug('Verifiy Registration User has Record Already: ');
            return new PageReference(startUrl);  

        }


    }


   @TestVisible 
   private void doPostRegistration(User u) {
        
        // not implemented here. Implementation in sub class
   
   }

}