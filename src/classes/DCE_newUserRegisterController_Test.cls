/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DCE_newUserRegisterController_Test {

    @testSetup static void testSetup(){
    	DCE_TestDataFactory.setUpDataWithAmends();
    	
    	Contact goodContact = DCE_TestDataFactory.newPartner1Contacts(1)[0];
    	goodContact.lastName = 'NewContact';
    	insert goodContact;
    }
    
    static testMethod void testNoParams() {
    	
    	test.startTest();
    	
    	try{
    		DCE_newUserRegisterController controller = new DCE_newUserRegisterController();
    		system.assert(false);
    	} catch (exception e){
        	system.assertEquals('DCE_Exception', e.getTypeName());
        	system.assertEquals('This page requires correct parameters to function correctly. Please check your URL.', e.getMessage());
        }
    	
    	test.stopTest();
    }
    
    static testMethod void testExistingUser() {
        
		Contact person = [select id from Contact where createdDate = TODAY and LastName = 'TestPerson1' limit 1];
		
		string cryptoKey = Community_Settings__c.getInstance('DCE_Secret_Key').value__c;
    	string encodedId = WEBC_CryptoUtils.encryptValue(person.id, cryptoKey);
		
		Profile p = [SELECT Id FROM Profile WHERE Name= :DCE_ControllerUtils.DCE_PUBLIC_ACCESS_PROFILE];

		User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='DCEPublicUserTest987632@ALZDCETEST8976324.org');
		
		test.startTest();
        
        System.runAs(u) {
	        //create page and create controller with a reference to the StandardController    
		    PageReference pageRef = Page.DCE_newUserRegister;
			pageRef.getParameters().put('cid', encodedId);
		    
			test.setCurrentPage(pageRef);
			
			DCE_newUserRegisterController controller = new DCE_newUserRegisterController();
			
			system.assertEquals(true, controller.userAlreadyExists);
			system.assertEquals(null, controller.user);
			system.debug('URL - '+controller.autoLogin().getUrl());
			system.assert(controller.autoLogin().getUrl().contains('dce_loginpage'));
        }
	}
	
	static testMethod void testBadContactId() {
        
		string cryptoKey = Community_Settings__c.getInstance('DCE_Secret_Key').value__c;
    	string encodedId = WEBC_CryptoUtils.encryptValue('0031234567890ABCDE', cryptoKey);
		
		Profile p = [SELECT Id FROM Profile WHERE Name= :DCE_ControllerUtils.DCE_PUBLIC_ACCESS_PROFILE]; 

		User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='DCEPublicUserTest987632@ALZDCETEST8976324.org');
		
		test.startTest();
        
        System.runAs(u) {
	        //create page and create controller with a reference to the StandardController    
		    PageReference pageRef = Page.DCE_newUserRegister;
			pageRef.getParameters().put('cid', encodedId);
		    
			test.setCurrentPage(pageRef);
			
			DCE_newUserRegisterController controller = new DCE_newUserRegisterController();
			
			system.assertEquals(false, controller.userAlreadyExists);
			system.assertEquals(null, controller.user);
			system.assertEquals(null, controller.person);
			system.assertEquals('This link does not relate to a recognised record. Please check link included in your new user registration email.', controller.pageMessage);
        	system.assertEquals(null, controller.autoLogin());
        }
	}
	
	static testMethod void testGoodContactIdBadPassword() {
        
        Contact goodContact = [select id from Contact where lastName = 'NewContact' limit 1];
        
		string cryptoKey = Community_Settings__c.getInstance('DCE_Secret_Key').value__c;
    	string encodedId = WEBC_CryptoUtils.encryptValue(goodContact.id, cryptoKey);
		
		Profile p = [SELECT Id FROM Profile WHERE Name= :DCE_ControllerUtils.DCE_PUBLIC_ACCESS_PROFILE]; 

		User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='DCEPublicUserTest987632@ALZDCETEST8976324.org');
		
		test.startTest();
        
        System.runAs(u) {
	        //create page and create controller with a reference to the StandardController    
		    PageReference pageRef = Page.DCE_newUserRegister;
			pageRef.getParameters().put('cid', encodedId);
		    
			test.setCurrentPage(pageRef);
			
			DCE_newUserRegisterController controller = new DCE_newUserRegisterController();
			
			system.assertEquals(false, controller.userAlreadyExists);
			system.assertNotEquals(null, controller.user);
			system.assertNotEquals(null, controller.person);
			system.assertEquals(null, controller.autoLogin());
			
			controller.password1 = 'Short';
			controller.password2 = 'Short';
			
			system.assertEquals(null,controller.RegisterUser());
			
			system.debug('HERE ARE THE MESSAGES - '+ApexPages.getMessages());
        }
	}
	
	static testMethod void testGoodContactIdGoodPassword() {
		//This test is largely redundant as it does not appear possible to create users at the moment using "CreateExternalUser" in tests

        Contact goodContact = [select id from Contact where lastName = 'NewContact' limit 1];
        
		string cryptoKey = Community_Settings__c.getInstance('DCE_Secret_Key').value__c;
    	string encodedId = WEBC_CryptoUtils.encryptValue(goodContact.id, cryptoKey);
		
		Profile p = [SELECT Id FROM Profile WHERE Name= :DCE_ControllerUtils.DCE_PUBLIC_ACCESS_PROFILE]; 

		User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='DCEPublicUserTest987632@ALZDCETEST8976324.org');
		
		test.startTest();
        
        System.runAs(u) {
	        //create page and create controller with a reference to the StandardController    
		    PageReference pageRef = Page.DCE_newUserRegister;
			pageRef.getParameters().put('cid', encodedId);
		    
			test.setCurrentPage(pageRef);
			
			DCE_newUserRegisterController controller = new DCE_newUserRegisterController();
			
			system.assertEquals(false, controller.userAlreadyExists);
			system.assertNotEquals(null, controller.user);
			system.assertNotEquals(null, controller.person);
			system.assertEquals(null, controller.autoLogin());
			
			controller.password1 = '0ldM4nByTh3S34';
			controller.password2 = '0ldM4nByTh3S34';
			
			PageReference register = controller.RegisterUser();
			
			/* Cannot test - CreateExternalUser does not appear to create users during testing
			system.assertNotEquals(null, register);
			system.assert(register.getUrl().contains('dce_dashboard'));
			*/
			
		}
	}
}