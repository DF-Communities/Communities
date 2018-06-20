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
private class DCE_OrgDetails_Controller_Test {

    //private static DCE_SingleRequestMock fakeResponseP1 = new DCE_SingleRequestMock(200, 'Complete', '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Account","url":"/services/data/v35.0/sobjects/Services__c/0011234567890ABCDE"},"Id":"0011234567890ABCDE","Name":"Example Partner Name","Phone":"01883 717776", "Office_Contact_Hours__c":"Whenever you like!"}]}', null);
    private static DCE_SingleRequestMock fakeResponseP2 = new DCE_SingleRequestMock(200, 'Complete', '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Account","url":"/services/data/v35.0/sobjects/Services__c/0011234567890ABCDE"},"Id":"0012234567890ABCDE","Name":"Example Partner Name","Phone":"01883 717776", "Office_Contact_Hours__c":"Whenever you like!"}]}', null);
    
    @testSetup private static void setupData(){
    	DCE_TestDataFactory.setUpDataWithAmends();
    }
    
    static testMethod void testWithExistingEditingAmends() {
        
		Account partnerAccount = [select id from Account where Name = 'PartnerAccount1'];
		
		User u = [select id, AccountId from User where AccountId = :partnerAccount.id and isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 1];
		
		list<DCE_OrgAmend__c> orgAmends = [select id, Name__c from DCE_OrgAmend__c];
		system.assertEquals(1, orgAmends.size());
		
		system.runAs(u){
			
			orgAmends = [select id, Name__c from DCE_OrgAmend__c];
			system.assertEquals(1, orgAmends.size());
			
			test.startTest();
			
			DCE_OrgDetails_Controller cont = new DCE_OrgDetails_Controller();
			
			DCE_OrgAmend__c amend = cont.partner;
			
			system.assertEquals('Draft', amend.status__c);
			system.assertEquals(false, cont.doneCallout);
			system.assertEquals(false, cont.isLockedForApproval);
			
			amend.Name__c = 'New Name';
			
			cont.save();
			
			cont.discardDraft();
			
			test.stopTest();
		}
	}
    
    static testMethod void testWithoutAnyAmends() {
    	Account partnerAccount = [select id from Account where Name = 'PartnerAccount2'];
    	
    	User u = [select id, AccountId from User where AccountId = :partnerAccount.id and isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 1];
		
		
		
		list<DCE_OrgAmend__c> orgAmends = [select id, Name__c from DCE_OrgAmend__c];
		system.assertEquals(1, orgAmends.size());
		
		system.runAs(u){
			
			orgAmends = [select id, Name__c from DCE_OrgAmend__c];
			system.assertEquals(0, orgAmends.size());
			
			test.startTest();
			
			DCE_OrgDetails_Controller cont = new DCE_OrgDetails_Controller();
			
			Test.setMock(HttpCalloutMock.class, fakeResponseP2);
			
			DCE_OrgAmend__c amend = cont.partner;
			
			system.assertEquals('Example Partner Name', amend.Name__c);
			system.assertEquals(true, cont.doneCallout);
			
			test.stopTest();
		}    	
    }
    
    static testMethod void testWithLiveAmendRecords(){
    	
    	Account partnerAccount = [select id, Name, DCEProdOrgID__c from Account where Name = 'PartnerAccount2'];
    	DCE_OrgAmend__c liveAmend = DCE_TestDataFactory.newPartnerOrgAmend(partnerAccount);
    	liveAmend.status__c = 'Accepted - Transfer Complete';
    	insert liveAmend;
    	
		system.assertEquals('PartnerAccount2', liveAmend.Name__c);
    	
    	User u = [select id, AccountId from User where AccountId = :partnerAccount.id and isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 1];
    	
    	list<DCE_OrgAmend__c> orgAmends = [select id, Name__c, Organisation__c, OrganisationId__c from DCE_OrgAmend__c];
		system.assertEquals(2, orgAmends.size());
    	
    	system.debug('Here are the view all amends - '+orgAmends);
    	
    	system.runAs(u){
    		orgAmends = [select id, Name__c, Organisation__c, OrganisationId__c from DCE_OrgAmend__c];
			system.assertEquals(1, orgAmends.size());
    		
    		test.startTest();
    		
    		DCE_OrgDetails_Controller cont = new DCE_OrgDetails_Controller();
			
			system.assertEquals(false, cont.doneCallout);
			
			Test.setMock(HttpCalloutMock.class, fakeResponseP2);
			
			//DCE_OrgAmend__c amend = cont.partner;
			liveAmend = cont.partner;
			
			system.assertEquals('Example Partner Name', liveAmend.Name__c);
			system.assertNotEquals(null, liveAmend.Id);
			system.assertEquals(true, cont.doneCallout);
			
			liveAmend.Name__c = 'New Name';
			
			system.debug('Here are the sharing specific Org Amends - '+orgAmends);
			
			cont.commitApproval();
    		
    		system.assertEquals(false, cont.isLockedForApproval);
    		
    		liveAmend.BillingStreet__c = 'New Name';
    		liveAmend.BillingCity__c = 'New Name';
    		liveAmend.BillingPostalCode__c = 'New Name';
    		liveAmend.BillingCountry__c = 'New Name';
    		
    		cont.commitApproval();
    		
    		system.assertEquals(true, cont.isLockedForApproval);
    		
    		cont.recallApproval();
    		
    		system.assertEquals(false, cont.isLockedForApproval);
    		
    		test.stopTest();
    	}
    	
    }
    
    static testMethod void testUserManagement(){
    	Account partnerAccount = [select id from Account where Name = 'PartnerAccount1'];
		
		User u = [select id, AccountId from User where AccountId = :partnerAccount.id and isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 1];
		
		list<User> allUsers = [select id, AccountId from User where isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME)];
		system.assert(allUsers.size() >= 25);
		
		
		system.runAs(u){
			
			/* DEPRECATED - SHARING MODEL IS NO LONGER PRIVATE FOR COMMUNITY USERS
			//Testing that portal users can only see their own records
			allUsers = [select id, AccountId from User where isActive = true];
			system.assertEquals(1, allUsers.size());
			*/
			
			test.startTest();
			
			DCE_OrgDetails_Controller cont = new DCE_OrgDetails_Controller();
			
			list<DCEProfile__c> activeUsers = cont.activeUsers;
			list<DCEProfile__c> inactiveUsers = cont.inActiveUsers;
			
			system.assertEquals(5, activeUsers.size());
			system.assertEquals(0, inactiveUsers.size());
			
			integer numDeactivated = 0;
			
			for(DCEProfile__c user : activeUsers){
				if(user.Contact__c != cont.userWithDCEDetails.contactId && numDeactivated < 3){
					user.active__c = false;
					numDeactivated++;
				}
			}
			
			cont.updateAdmins();
			
			activeUsers = cont.activeUsers;
			inactiveUsers = cont.inActiveUsers;
			
			system.assertEquals(2, activeUsers.size());
			system.assertEquals(3, inactiveUsers.size());
			
			integer numActivated = 0;
			
			for(DCEProfile__c user : inActiveUsers){
				if(user.Contact__c != cont.userWithDCEDetails.contactId && numActivated < 1){
					user.active__c = true;
					numActivated++;
				}
			}
			
			cont.updateAdmins();
			
			test.stopTest();
			
			activeUsers = cont.activeUsers;
			inactiveUsers = cont.inActiveUsers;
			
			system.assertEquals(3, activeUsers.size());
			system.assertEquals(2, inactiveUsers.size());
					
			
		}
    }
    
    static testMethod void testLogoUpload(){
    	Account partnerAccount = [select id, DCEProdOrgID__c from Account where Name = 'PartnerAccount1'];
		
		User u = [select id, AccountId, Name from User where AccountId = :partnerAccount.id and isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 1];
		
        system.debug('User Id - '+u.id);
        
		list<User> allUsers = [select id, AccountId from User where isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME)];
		system.assert(allUsers.size() >= 25);
		
        system.debug('The number of DCE users is - '+allUsers.size());
        
		StaticResource sr = [select id, body from StaticResource where Name = 'DCE_AZLogo_Small'];
		
		
		test.startTest();
		
		system.runAs(u){
			
            system.debug('Hi, I am - '+u);
            /* DEPRECATED - SHARING MODEL IS NO LONGER PRIVATE FOR COMMUNITY USERS
			//Testing that portal users can only see their own records
			allUsers = [select id, AccountId from User where isActive = true];
			system.assertEquals(1, allUsers.size());
			*/
			DCE_OrgDetails_Controller.photoUpload(EncodingUtil.base64Encode(sr.body));
			
		}	
		
		string recName = 'DCE_Logo_'+partnerAccount.DCEProdOrgID__c;
		
		list<CommunityResource__c> resource = [select id, Name from CommunityResource__c where Name LIKE :recName];
		
		system.assertEquals(1, resource.size());
		
		system.runAs(u){
			
			/* DEPRECATED - SHARING MODEL IS NO LONGER PRIVATE FOR COMMUNITY USERS
			//Testing that portal users can only see their own records
			allUsers = [select id, AccountId from User where isActive = true];
			system.assertEquals(1, allUsers.size());
			*/
			
			DCE_OrgDetails_Controller.photoUpload(EncodingUtil.base64Encode(sr.body));
			
		}
		
		resource = [select id, Name from CommunityResource__c where Name LIKE :recName];
		
		system.assertEquals(1, resource.size());
    	
    	system.runAs(u){
			
			DCE_OrgDetails_Controller cont = new DCE_OrgDetails_Controller();
			
			system.assertNotEquals(null, cont.orgLogo);
			
		}
    
    }
}