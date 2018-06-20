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
private class DCE_PermissionSetManager_Queuable_Test {

    @testSetup private static void setupData(){
    	DCE_testDataFactory.setUpDataWithAmends();
    }
    
    static testMethod void testAdd() {
        
        list<Contact> profileList = [select id from Contact where Id IN (select ContactId from User where ContactId != null)];
        
        list<Id> contactIds = new list<Id>();
        
        for(Contact c : [select id from Contact where Id IN (select ContactId from User where ContactId != null)]){
        	contactIds.add(c.id);
        }
        
        
        test.StartTest();
        
        system.enqueueJob(new DCE_PermissionSetManager_Queuable(contactIds, 'Add'));
        
        test.StopTest();
        
    }
    
    static testMethod void testRemove() {
    	
    	list<Contact> profileList = [select id from Contact where Id IN (select ContactId from User where ContactId != null)];
        
        list<Id> contactIds = new list<Id>();
        
        for(Contact c : [select id from Contact where Id IN (select ContactId from User where ContactId != null)]){
        	contactIds.add(c.id);
        }
        
        
        test.StartTest();
        
        system.enqueueJob(new DCE_PermissionSetManager_Queuable(contactIds, 'Remove'));
        
        test.StopTest();
    }
    
    static testMethod void testFail() {
    	
    	list<Contact> profileList = [select id from Contact where Id IN (select ContactId from User where ContactId != null)];
        
        list<Id> contactIds = new list<Id>();
        
        for(Contact c : [select id from Contact where Id IN (select ContactId from User where ContactId != null)]){
        	contactIds.add(c.id);
        }
        
        
        test.StartTest();
        
        try{
        	system.enqueueJob(new DCE_PermissionSetManager_Queuable(contactIds, 'Wrong input'));
        	system.assert(false);
		} catch (exception e){
			system.assertEquals('DCE_Exception', e.getTypeName());
			system.assertEquals('Please instantiate the class only with Add or Remove mode.', e.getMessage());
		}
        
        test.StopTest();
    }
}