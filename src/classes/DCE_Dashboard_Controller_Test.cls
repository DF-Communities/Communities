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
private class DCE_Dashboard_Controller_Test {

    @testSetup
    static void testSetup(){
    	DCE_TestDataFactory.createCustomSettings();
    }
    
    static testMethod void retrieveExpectedResponseWithOneServiceAndFiveAmends() {
		
		DCE_TestDataFactory.setUpDataWithAmends();
		
		User u = [select id from User where isActive = true and Contact.Account.Name = 'PartnerAccount1' limit 1];
		
		system.runAs(u){
		
			test.startTest();
			
			DCE_SingleRequestMock fakeResponse = new DCE_SingleRequestMock(200, 'Complete', '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Services__c","url":"/services/data/v35.0/sobjects/Services__c/a0z3E00000000K7QAI"},"Id":"a0z3E00000000K7QAI","Name":"Example Memory Assessment Service","service_type__c":"Dementia Support & Groups","Last_Reviewed__c":"2016-04-02", "service_status__c":"Pending","Service_Reference__c":"ReferenceNo"}]}', null);
	        
	        Test.setMock(HttpCalloutMock.class, fakeResponse);
	        
	        DCE_Dashboard_Controller cont = new DCE_Dashboard_Controller();
	        
	        Account acc = cont.partnerAccount;
	        
			list<DCE_Dashboard_Controller.serviceHolder> partnerServices = cont.services;
	        map<string, DCE_ServiceAmend__c> amendmentMap = cont.amendmentMap;
	        
	        test.stopTest();
	        
	        system.assertEquals(6, partnerServices.size());
	        system.assertEquals(20, amendmentMap.size());
		}
        
    }
    
    static testMethod void retrieveExpectedResponseWithNoServicesOrAmends() {
		
		DCE_TestDataFactory.setUpDataWithoutAmends();
		
		test.startTest();
		
		DCE_SingleRequestMock fakeResponse = new DCE_SingleRequestMock(200, 'Complete', '{"totalSize":0,"done":true,"records":[]}', null);
        
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        DCE_Dashboard_Controller cont = new DCE_Dashboard_Controller();
        
		list<DCE_Dashboard_Controller.serviceHolder> partnerServices = cont.services;
		map<string, DCE_ServiceAmend__c> amendmentMap = cont.amendmentMap;
        
        test.stopTest();
        
        system.assertEquals(0, partnerServices.size());
        system.assertEquals(0, amendmentMap.size());
        system.assertEquals('Your organisation does not currently have any services listed. If you would like to create one, start by clicking the "New service" button.', cont.PageMessage);
        
    }
    
    static testMethod void cannotConnect() {
        
        test.startTest();
        
        DCE_SingleRequestMock fakeResponse = new DCE_SingleRequestMock(401, 'Error', 'Error', null);
        
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        DCE_Dashboard_Controller cont = new DCE_Dashboard_Controller();
        cont.initiation();
        
        test.stoptest();
        
        system.debug('cont.PageMessage - '+cont.PageMessage);
        system.assert(cont.PageMessage.startsWith('There has been an error authenticating this session with the Dementia Connect database.'));
        
    }
    
    static testMethod void receiveUnexpectedResponse() {
        
        test.startTest();
        
        DCE_SingleRequestMock fakeResponse = new DCE_SingleRequestMock(200, 'Complete', 'Just a completely nonsense response', null);
        
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        DCE_Dashboard_Controller cont = new DCE_Dashboard_Controller();
        cont.initiation();
        
        test.stoptest();
        
        system.debug('cont.PageMessage - '+cont.PageMessage);
        system.assert(cont.PageMessage.startsWith('<strong>Error Code: [DCE-554]</strong> There has been an error authenticating this session with the Dementia Connect database. Please contact your administrator.'));
        
    }
}