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
private class DCE_UserCreateKickOff_Test {

    private static DCE_SingleRequestMock responseCorrectRecord = new DCE_SingleRequestMock(200, 'Complete', '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Account","url":"/services/data/v35.0/sobjects/Account/0011234567890ABCDE"},"Id":"0011234567890ABCDE","Name":"Example Org Name From Dementia Connect"}]}', null);
    
    @testSetup static void setupData(){
    	DCE_TestDataFactory.createCustomSettings();
    	DCE_TestDataFactory.createPartnerUsers();
    }
    
    static testMethod void testNewUser() {
		
		//This is only necessary to ensure that the DCEProdOrgID__c field is a real id
		Account acc = [select id, DCEProdOrgID__c from Account where Name = 'PartnerAccount1'];
		acc.DCEProdOrgID__c = acc.id;
		update acc;
		
		Contact c = new Contact(accountId=acc.id, FirstName='John', lastName='Smith', EMail='aiwudhawduhk@kuh43i374.com'); 
		
		insert c;

        test.startTest();

		test.setCurrentPage(page.DCE_USerCreateKickOff);

		DCE_UserCreateKickOff cont = new DCE_UserCreateKickOff(new ApexPages.StandardController(c));

		test.SetMock(HttpCalloutMock.class, responseCorrectRecord);

		Account partnerOrg = cont.partnerOrg;
		DCE_OrgAmend__c partner = cont.prodAccount;
		
		system.assertEquals('Example Org Name From Dementia Connect', partner.name__c);
	    system.assertEquals(false, cont.alreadyDCEUser);
	    system.assertEquals(false, cont.emailSent);
		system.assertEquals(false, cont.alreadyPortalUser);
	    
	    cont.searchPartner();   
		
		cont.confirmPartner();
	       
		cont.sendEmail();
		
		system.assertEquals(true, cont.emailSent);
		
		//cont.searchPartner();
		
		test.stopTest();
        
        
    }
    
    static testMethod void testNewUserBadPartnerID() {
		
		//This is only necessary to ensure that the DCEProdOrgID__c field is a real id
		Account acc = [select id, DCEProdOrgID__c from Account where Name = 'PartnerAccount1'];
		acc.DCEProdOrgID__c = acc.id;
		update acc;
		
		Contact c = new Contact(accountId=acc.id, FirstName='John', lastName='Smith', EMail='aiwudhawduhk@kuh43i374.com'); 
		
		insert c;

        test.startTest();

		test.setCurrentPage(page.DCE_USerCreateKickOff);

		DCE_UserCreateKickOff cont = new DCE_UserCreateKickOff(new ApexPages.StandardController(c));
		
		Account partnerOrg = cont.partnerOrg;
		
		partnerOrg.DCEProdOrgID__c = 'Nonsense';
		
		cont.searchPartner();
		
		//cont.sendEmail();
		
		system.assertEquals(false, cont.emailSent);
		system.assert(apexPages.getMessages()[apexPages.getMessages().size()-1].getSummary().contains('There is an issue with the Partner Org ID you have chosen. Please check that and try again.'));
		
		test.stopTest();
		
    }
    
    static testMethod void testExistingUser() {
    	
    	Contact c = [select id, Name, FirstName, LastName, email, AccountId from Contact where Account.Name = 'PartnerAccount1' limit 1];

        test.startTest();
        
        test.setCurrentPage(page.DCE_USerCreateKickOff);

		DCE_UserCreateKickOff cont = new DCE_UserCreateKickOff(new ApexPages.StandardController(c));
        
        system.assertEquals(true, cont.alreadyDCEUser);
	    system.assertEquals(false, cont.emailSent);
	    system.assertEquals(false, cont.alreadyPortalUser);
	    system.assertEquals('active', cont.userStatus);	    
	    
	    cont.sendEmail();
        
        system.assertEquals(false, cont.emailSent);
        
        test.stopTest();
    }
    
    static Integer s_num = 1;
    
    static testMethod void testExistingPortalUser(){
    	
    	User nonDCEUser = DCE_TestDataFactory.createNonDCEPartnerUser();
    	
    	String result = String.valueOf(s_num++);
      	string fakeId = '001' + 
         '0'.repeat(12-result.length()) + result;
    	
    	Account acc = new Account(name='Brand New Account', DCEProdOrgID__c=fakeId);
		insert acc;
		
		Contact c = new Contact(accountId=acc.id, FirstName='John', lastName='Smith', EMail=nonDCEUser.email); 
		
		insert c;
    	
    	test.startTest();
    	
    	test.setCurrentPage(page.DCE_USerCreateKickOff);

		DCE_UserCreateKickOff cont = new DCE_UserCreateKickOff(new ApexPages.StandardController(c));

		test.SetMock(HttpCalloutMock.class, responseCorrectRecord);

		Account partnerOrg = cont.partnerOrg;
		DCE_OrgAmend__c partner = cont.prodAccount;
		
		system.assertEquals('Example Org Name From Dementia Connect', partner.name__c);
	    system.assertEquals(false, cont.alreadyDCEUser);
	    system.assertEquals(false, cont.emailSent);
		system.assertEquals(true, cont.alreadyPortalUser);
		system.assertNotEquals(null, cont.existingPortalUser);
		system.assertNotEquals(null, cont.person.AccountId);
		system.assertNotEquals(null, cont.existingPortalUser.Contact.AccountId);
		system.assertNotEquals(cont.person.AccountId, cont.existingPortalUser.Contact.AccountId);
	    
	    string existingAccountId = string.valueOf(cont.existingPortalUser.Contact.AccountId);
	    system.debug('Existing Account id - '+existingAccountId);
	    system.debug('New Account id - '+cont.person.AccountId);
	    
		cont.searchPartner();   
		
		cont.confirmPartner();
		
		system.assertEquals(true, cont.partnerConfirmed);
    	
		cont.assignExisting();
    	
    	cont.getExistingContactMoved();
    	
    	//system.debug('Existing Account id - '+existingAccountId);
	    //system.debug('Moved Account Id - '+cont.existingPortalUser.Contact.AccountId);
    	
    	//system.assertNotEquals(existingAccountId, cont.existingPortalUser.Contact.AccountId);
    	
    	
    	
		//system.assertEquals(true, cont.getExistingContactMoved());
    	
    	test.stopTest();
    	
    	
    }
}