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

public without sharing class DF_WEBC_VerifyAdmin_Controller extends DF_WEBC_ControllerBase {


    public DF_WEBC_VerifyAdmin_Controller() {
        
    }

    /* This is the response to a click on an email verification */
    public PageReference doAction(){

        if ( isLoggedIn && !Test.isRunningTest() ) {
            return new PageReference('/errorPage?msg=E001'); 
        }

        /* Get the data parameter from the Url */
        String encryptedValue = ApexPages.currentPage().getParameters().get('data');
        system.debug('Verify Registration : ' + encryptedValue);

        /* The community prefix */
        String communityPrefix = ApexPages.currentPage().getParameters().get('c');
        system.debug('Verifiy Registration Community Key : ' + communityPrefix);
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
        String orgId = stringValues[1];
        String password = stringValues[2]; 
        String sRandomString = stringValues[3];

        List<Contact> lisContacts = [select Id, Email, Name, LastName, FirstName, RecordType.DeveloperName, Password_Reset_Key__c, AccountId from Contact where Id=:id];
        if ( lisContacts.isEmpty() ) {
            system.debug('Verifiy Registration Community Contact not found : ');
            return new PageReference('/errorPage');
        }

        Contact contact = lisContacts[0];

		List<Partner_Organisation__c> lisPorg = [select Id, Name, Admin_User_Name__c, Email_Domain__c, Account__c from Partner_Organisation__c where Id=:orgId];
		if ( lisPorg.isEmpty() ) {
            system.debug('Verifiy Registration Community Partner Org not found : ');
            return new PageReference('/errorPage');
        }

        Partner_Organisation__c porg = lisPorg[0]; 

        if  ( sRandomString != contact.Password_Reset_Key__c ) {
            system.debug('Verifiy Registration Community Password Reset Key does not match : ');
            return new PageReference('/errorPage?msg=E005');  
        }

        system.debug('Verifiy Registration Community Contact : ' + contact.id);

        String startUrl = WEBC_CommunityWrapper.COMMUNITY_USER_HOME;

        if (!WEBC_CommunityWrapper.hasUserRecord(contact)) {

            system.debug('Verifiy Registration Community No User Record : ');

            String sUserName = community.getOrgAdminUserName(porg.Admin_User_Name__c, porg.Email_Domain__c);
            User u = community.registerOrgAdminUser(contact, sUserName, password, false);       

            if (u == null) {
            
                system.debug('Verifiy Registration Error Creating Community User: ');
                return new PageReference('/errorPage');
            
            } else {
            
                porg.OwnerId = u.id;
                update porg;

                system.debug('Verifiy Registration New Community User : ' + u.id);
                return Site.login(sUserName, password, startUrl);
            
            }

        }  else {

            /* The link has already been clicked 
               TODO - how some kind of message to say the link has already been clicked     
            */  
            system.debug('Verifiy Registration User has Record Already: ');
           	return new PageReference(startUrl);  

        }


    }

}