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
private class DCE_MailUtils_Test {

    @testSetup static void dataSetup(){
    	DCE_TestDataFactory.setUpDataWithAmends();
    }
    
    static testMethod void testSendApprovalCommencedEmail() {
        
        test.startTest();
        DCE_ServiceAmend__c amend = [select id, Name, ServiceOwner__c from DCE_ServiceAmend__c limit 1];
        
        User u = [select id, FirstName, Name, Email from User where isActive = true and email != null and Id IN (select assigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 1];
        
        system.assertEquals(true, DCE_MailUtils.sendApprovalCommencedEmail(amend.id, amend.Name, u));
		test.stopTest();
    }
    
    static testMethod void testSendUserActiveUpdate() {
        
        test.startTest();
        
        //list<User> u = [select id, FirstName, Name,IsActive, Email from User where isActive = true and email != null and Id IN (select assigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 5];
        list<DCEProfile__c> u = [select id, Contact__c, Contact__r.FirstName, Contact__r.Name, Active__c from DCEProfile__c where Active__c = true and Contact__r.email != null limit 5];
        
		system.assertEquals(true, DCE_MailUtils.sendUserActiveUpdate(u));
		test.stopTest();
    }
    
    static testMethod void testMailOwnerChanged() {
    	
    	test.startTest();	
    	
    	map<id, DCE_ServiceAmend__c> amendMap = new map<id, DCE_ServiceAmend__c>([select id, Name, ServiceOwner__c from DCE_ServiceAmend__c limit 1]);
    	
    	
    	list<User> u = [select id, FirstName, Name,IsActive, Email from User where isActive = true and email != null and Id IN (select assigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 2];
    	
    	system.assertEquals(true, DCE_MailUtils.mailOwnerChanged(new list<Id>(amendMap.keySet()), amendMap, amendMap));
    	
    	test.stopTest();
    }
    
    static testMethod void testMonthlyDigest() {
    	
    	test.startTest();
    	
    	list<User> u = [select id, FirstName, Name,IsActive, Email from User where isActive = true and email != null and Id IN (select assigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 5];
    	
    	system.assertEquals(true, DCE_MailUtils.monthlyMailDigest(new list<User>(u)));
    	    	
    	test.stopTest();
    	
    }
    
    static testMethod void testServiceReview() {
    	
    	test.startTest();
    	
    	DCE_ServiceAmend__c amend = [select id, Name, ServiceOwner__c from DCE_ServiceAmend__c limit 1];
    	
    	system.assertEquals(true, DCE_MailUtils.sendServiceReviewEmail(amend.id));
    	    	
    	test.stopTest();
    	
    }	
    
}