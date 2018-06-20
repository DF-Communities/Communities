/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX Test class for DF_WEBC_RegisterCommunityAdmin_Ctl
 *  Author  : Valerie Dunphy
 *  Date    : 17/11/2015
 *  Version : 1.0
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
@isTest
public class DF_WEBC_RegisterCommunityAdmin_Ctl_Test {

 	@testSetup
	static void setupData() { 
	    Dfc_DataFactory_Test.TestDataCreation(); 
	}

	// Logged in user
    @isTest
    private static void doTest() {
    
       DF_WEBC_RegisterCommunityAdmin_Ctl ctl = new DF_WEBC_RegisterCommunityAdmin_Ctl();
        
       User u = [select id from User where email = 'test1.testcontact@myemail.com'];

       System.runAs(u) {

       	ctl.handleInvite();

       }


    }

	// Successfull Run
    @isTest
    private static void doTest1() {
    	   
	   DFC_Community__c comm = [select id from DFC_Community__c where Status__c = 'Active' limit 1];

	   DFC_Community_Representative__c invite = new DFC_Community_Representative__c();
       invite.Community__c = comm.id;
       invite.Invited_Email__c = 'AnewGuy@newguy.com';
       invite.Invited_Name__c = 'Test Test';
       invite.Role__c = 'Invited';
       insert invite; 
        
       String key = 'Nl8sPwQ9dAZMOVI+XQMNXQ==';
       WEBC_CommunityWrapper.RegistrationData data = new WEBC_CommunityWrapper.RegistrationData();
       data.email = 'AnewGuy@newguy.com';
       data.id = invite.id;
       String s = JSON.serialize(data);

       String enc = WEBC_CryptoUtils.encryptValue(s, key);  
       PageReference pr = new PageReference('Page.DF_WEBC_RegisterCommunityAdmin'); 
       pr.getParameters().put('invite', enc);
	   Test.setCurrentPageReference(pr); 

	   User guestUser = [select id from user where userType = 'Guest' and Name like 'Dementia Friends%' limit 1];
	   System.runAs(guestUser) {

		   DF_WEBC_RegisterCommunityAdmin_Ctl ctl = new DF_WEBC_RegisterCommunityAdmin_Ctl();
		   ctl.handleInvite();

		}

    }
    
	// Existing User
    @isTest
    private static void doTest2() {
    	   
	   User u = [select id, UserName, email from User where email = 'test1.testcontact@myemail.com'];
	   DFC_Community__c comm = [select id from DFC_Community__c where Status__c = 'Active' limit 1];

	   DFC_Community_Representative__c invite = new DFC_Community_Representative__c();
       invite.Community__c = comm.id;
       invite.Invited_Email__c = u.UserName;
       invite.Invited_Name__c = 'Test Test';
       invite.Role__c = 'Invited';
       insert invite; 
        
       String key = 'Nl8sPwQ9dAZMOVI+XQMNXQ==';
       WEBC_CommunityWrapper.RegistrationData data = new WEBC_CommunityWrapper.RegistrationData();
       data.email = u.UserName;
       data.id = invite.id;
       String s = JSON.serialize(data);

       String enc = WEBC_CryptoUtils.encryptValue(s, key);  
       PageReference pr = new PageReference('Page.DF_WEBC_RegisterCommunityAdmin'); 
       pr.getParameters().put('invite', enc);
	   Test.setCurrentPageReference(pr); 

	   User guestUser = [select id from user where userType = 'Guest' and Name like 'Dementia Friends%' limit 1];
	   System.runAs(guestUser) {

		   DF_WEBC_RegisterCommunityAdmin_Ctl ctl = new DF_WEBC_RegisterCommunityAdmin_Ctl();
		   ctl.handleInvite();

		}


    }

	// bad invite Id
    @isTest
    private static void doTest3() {

	   DFC_Community__c comm = [select id from DFC_Community__c where Status__c = 'Active' limit 1];
        
       String key = 'Nl8sPwQ9dAZMOVI+XQMNXQ==';
       WEBC_CommunityWrapper.RegistrationData data = new WEBC_CommunityWrapper.RegistrationData();
       data.email = 'someotherGuy@someotherGuy.com';
       data.id = comm.id; // has to be a valid id, but wrong
       String s = JSON.serialize(data);

       String enc = WEBC_CryptoUtils.encryptValue(s, key);
       PageReference pr = new PageReference('Page.DF_WEBC_RegisterCommunityAdmin'); 
       pr.getParameters().put('invite', enc);
	   Test.setCurrentPageReference(pr); 

	   User guestUser = [select id from user where userType = 'Guest' and Name like 'Dementia Friends%' limit 1];
	   System.runAs(guestUser) {

	   	   System.debug('DF_WEBC_RegisterCommunityAdmin Running Test on bad Invite Id'); 	
		   DF_WEBC_RegisterCommunityAdmin_Ctl ctl = new DF_WEBC_RegisterCommunityAdmin_Ctl();
		   ctl.handleInvite();

		}

    }

    // Successfull Run with no invite
    @isTest
    private static void doTest4() {
    	   
	   DFC_Community__c comm = [select id from DFC_Community__c where Status__c = 'Active' limit 1];
        
       PageReference pr = new PageReference('Page.DF_WEBC_RegisterCommunityAdmin'); 
	   Test.setCurrentPageReference(pr); 

	   User guestUser = [select id from user where userType = 'Guest' and Name like 'Dementia Friends%' limit 1];
	   System.runAs(guestUser) {

		   DF_WEBC_RegisterCommunityAdmin_Ctl ctl = new DF_WEBC_RegisterCommunityAdmin_Ctl();
		   ctl.handleInvite();

		}

    }


}