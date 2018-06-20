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
private class DCE_ServiceAmendTrigger_Test {

    @testSetup static void setupData(){
    	DCE_TestDataFactory.setUpDataWithAmends();
    }
    
	static testMethod void testOwnershipChange() {
        
        test.startTest();
        
        list<DCE_ServiceAmend__c> allAmends = [select id, OwnerId, ServiceOwner__c, status__c, LastReviewed__c, service_closeDate__c, service_status__c from DCE_ServiceAmend__c];
        list<User> users = [select id, Name, AccountId from User where isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME)];
        
        User userA = users[0];
        
        DCE_ServiceAmend__c amendToChangeOwner;
        
        for(DCE_ServiceAmend__c amend : allAmends){
        	if(amend.ServiceOwner__c != userA.id && amend.OwnerId != userA.id){
        		amendToChangeOwner = amend;
        		break;
        	}
        }
        
        system.assertNotEquals(null, amendToChangeOwner);
        
        amendToChangeOwner.ServiceOwner__c = userA.id;
        
        update amendToChangeOwner;
        
        test.stopTest();
        
        amendToChangeOwner = [select id, OwnerId, ServiceOwner__c from DCE_ServiceAmend__c where id = :amendToChangeOwner.id];
        
        system.assertEquals(userA.id, amendToChangeOwner.OwnerId);
        system.assertEquals(userA.id, amendToChangeOwner.ServiceOwner__c);
    }
    
    static testMethod void testTransfer() {
        
        test.startTest();
        
        list<DCE_ServiceAmend__c> allAmends = [select id, OwnerId, ServiceOwner__c, status__c, LastReviewed__c, service_closeDate__c, service_status__c from DCE_ServiceAmend__c];
        list<User> users = [select id, Name, AccountId from User where isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME)];
        
        User userA = users[0];
        
        DCE_ServiceAmend__c amendToChangeStatus;
        
        for(DCE_ServiceAmend__c amend : allAmends){
        	if(amend.status__c != 'Accepted - Pending Transfer' && amend.service_closeDate__c == null){
        		amendToChangeStatus = amend;
        		break;
        	}
        }
        
        system.assertNotEquals(null, amendToChangeStatus);
        
        amendToChangeStatus.status__c = 'Accepted - Pending Transfer';
        amendToChangeStatus.service_closeDate__c = system.today();
        
        update amendToChangeStatus;
        
        test.stopTest();
        
        amendToChangeStatus = [select id, LastReviewed__c, service_closeDate__c, service_status__c from DCE_ServiceAmend__c where id = :amendToChangeStatus.id];
        
        system.assertEquals(system.today(), amendToChangeStatus.LastReviewed__c);
        system.assertnotEquals('Closed', amendToChangeStatus.service_status__c);
        
    }
    
    static testMethod void testTransferAndClose() {
        
        test.startTest();
        
        list<DCE_ServiceAmend__c> allAmends = [select id, OwnerId, ServiceOwner__c, status__c, LastReviewed__c, service_closeDate__c, service_status__c from DCE_ServiceAmend__c];
        list<User> users = [select id, Name, AccountId from User where isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME)];
        
        User userA = users[0];
        
        DCE_ServiceAmend__c amendToChangeStatus;
        
        for(DCE_ServiceAmend__c amend : allAmends){
        	if(amend.status__c != 'Accepted - Pending Transfer' && amend.service_closeDate__c == null){
        		amendToChangeStatus = amend;
        		break;
        	}
        }
        
        system.assertNotEquals(null, amendToChangeStatus);
        
        amendToChangeStatus.status__c = 'Accepted - Pending Transfer';
        amendToChangeStatus.service_closeDate__c = system.today().addDays(-6);
        
        update amendToChangeStatus;
        
        test.stopTest();
        
        amendToChangeStatus = [select id, LastReviewed__c, service_closeDate__c, service_status__c from DCE_ServiceAmend__c where id = :amendToChangeStatus.id];
        
        system.assertEquals(system.today(), amendToChangeStatus.LastReviewed__c);
        system.assertEquals('Closed', amendToChangeStatus.service_status__c);
        
    }
}