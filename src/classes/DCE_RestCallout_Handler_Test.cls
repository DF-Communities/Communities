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
private class DCE_RestCallout_Handler_Test {

	private static DCE_SingleRequestMock calloutAuthenticationGood = new DCE_SingleRequestMock(200, 'OK', blob.valueOf('{"access_token":"00D3E000000Cp5d!AQMAQCFOU4YLCSzHSQiPWFdWycxPsrFHkYbExD31weaOZTzkff6F5JtAmCl.ZsNMS.TkkCScJN2cDai8451pa5UpGBee4Fs4","instance_url":"https://alzheimerssociety--AndyDev2.cs82.my.salesforce.com","id":"https://test.salesforce.com/id/00D3E000000Cp5dUAC/005700000047b7xAAA","token_type":"Bearer","issued_at":"1457442815889","signature":"iIZ81oiZzoAsNo6zo763nr4HZl+7lv9Z1tCtcOgV4Bk="}'), null);
	private static DCE_SingleRequestMock calloutResponseGood = new DCE_SingleRequestMock(202, 'Accepted', blob.valueOf('{"RecordId":"MadeUpID","Result":"Successfully Updated"}'), null);
	private static DCE_SingleRequestMock calloutResponseBad = new DCE_SingleRequestMock(409, 'Conflict', blob.valueOf('Example error message'), null);
	private static map<string, string> fieldMappings = new map<string, string>();
	
	@testSetup static void setupData(){
		DCE_TestDataFactory.setUpDataWithAmends();
		DCE_TestDataFactory.setUpDataWithAmendsAsync();
	}

    static testMethod void testSuccessWithImplicitUpdate() {
		
		list<DCE_ServiceAmend__c> amends = [select id, Name from DCE_ServiceAmend__c where status__c != 'Accepted - Transfer Complete' limit 1];
		
		system.assert(amends.size() > 0);
		
		map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationGood);
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/apexrest/DCERecordAmend/', calloutResponseGood);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);
		
		test.startTest();
		
		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		system.enqueueJob(new DCE_RestCallout_Handler(amends, fieldMappings));
		
		test.stopTest();
		
		amends = [select id, Name, status__c, ServiceId__c from DCE_ServiceAmend__c where id IN :amends];
		
		for(DCE_ServiceAmend__c amend : amends){
			//system.assertEquals('Accepted - Transfer Complete', amend.status__c);
			//system.assertEquals('MadeUpID', amend.ServiceId__c);
		}

    }
    
    static testMethod void testSuccessWithExplicitUpdate() {
		
		list<DCE_ServiceAmend__c> amends = [select id, Name from DCE_ServiceAmend__c where status__c != 'Accepted - Transfer Complete' limit 1];
		
		system.assert(amends.size() > 0);
		
		map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationGood);
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/apexrest/DCERecordAmend/', calloutResponseGood);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);
		
		test.startTest();
		
		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		system.enqueueJob(new DCE_RestCallout_Handler(amends, fieldMappings, true));
		
		test.stopTest();
		
		amends = [select id, Name, status__c from DCE_ServiceAmend__c where id IN :amends];
		
		for(DCE_ServiceAmend__c amend : amends){
			//system.assertEquals('Accepted - Transfer Complete', amend.status__c);
		}

    }
    
    static testMethod void testSuccessWithExplicitNonUpdate() {
		
		list<DCE_ServiceAmend__c> amends = [select id, Name from DCE_ServiceAmend__c where status__c != 'Accepted - Transfer Complete' limit 1];
		
		system.assert(amends.size() > 0);
		
		map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationGood);
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/apexrest/DCERecordAmend/', calloutResponseGood);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);
		
		
		test.startTest();
		
		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		system.enqueueJob(new DCE_RestCallout_Handler(amends, fieldMappings, false));
		
		test.stopTest();
		
		amends = [select id, Name, status__c from DCE_ServiceAmend__c where id IN :amends];
		
		for(DCE_ServiceAmend__c amend : amends){
			//system.assertNotEquals('Accepted - Transfer Complete', amend.status__c);
		}

    }
    
    static testMethod void testFailure() {
		
		list<DCE_ServiceAmend__c> amends = [select id, Name from DCE_ServiceAmend__c where status__c != 'Accepted - Transfer Complete' limit 1];
		
		system.assert(amends.size() > 0);
		
		map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationGood);
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/apexrest/DCERecordAmend/', calloutResponseBad);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);
		
		test.startTest();
		
		//Test.setMock(HttpCalloutMock.class, calloutResponseBad);
		Test.setMock(HttpCalloutMock.class, multiCalloutMock);
		system.enqueueJob(new DCE_RestCallout_Handler(amends, fieldMappings));
		
		test.stopTest();
		
		amends = [select id, Name, status__c, (select id, Details__c, StatusCode__c from DCEAmendmentIssues__r) from DCE_ServiceAmend__c where id IN :amends];
		
		for(DCE_ServiceAmend__c amend : amends){
			system.assertNotEquals('Accepted - Transfer Complete', amend.status__c);
			
			for(DCE_RecordUpdateIssue__c iss : amend.DCEAmendmentIssues__r){
				//system.debug('Here is the issue - '+iss);
				//system.assertEquals(409, iss.StatusCode__c);
				//system.assertEquals('Example error message', iss.Details__c);
			}
		}

    }
}
