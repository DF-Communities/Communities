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
private class DCE_RestConnector_Test {

    private static DCE_SingleRequestMock calloutAuthenticationGood = new DCE_SingleRequestMock(200, 'OK', blob.valueOf('{"access_token":"00D3E000000Cp5d!AQMAQCFOU4YLCSzHSQiPWFdWycxPsrFHkYbExD31weaOZTzkff6F5JtAmCl.ZsNMS.TkkCScJN2cDai8451pa5UpGBee4Fs4","instance_url":"https://alzheimerssociety--AndyDev2.cs82.my.salesforce.com","id":"https://test.salesforce.com/id/00D3E000000Cp5dUAC/005700000047b7xAAA","token_type":"Bearer","issued_at":"1457442815889","signature":"iIZ81oiZzoAsNo6zo763nr4HZl+7lv9Z1tCtcOgV4Bk="}'), null);
	private static DCE_SingleRequestMock calloutAuthenticationBad = new DCE_SingleRequestMock(401, 'Conflict', blob.valueOf('{"error":"invalid_grant","error_description":"authentication failure - Invalid Password"}﻿'), null);
    private static DCE_SingleRequestMock calloutGETGood = new DCE_SingleRequestMock(200, 'Complete', '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Services__c","url":"/services/data/v35.0/sobjects/Services__c/a0z3E00000000K7QAI"},"Id":"a0z3E00000000K7QAI","Name":"Example Memory Assessment Service","service_type__c":"Dementia Support & Groups"}]}', null);
    private static DCE_SingleRequestMock calloutGETBad = new DCE_SingleRequestMock(404, 'Not Found', '{Bad result}', null);
    private static DCE_SingleRequestMock calloutPOSTGood = new DCE_SingleRequestMock(202, 'Accepted', blob.valueOf('Successfully Updated'), null);
    private static DCE_SingleRequestMock calloutPOSTBad = new DCE_SingleRequestMock(409, 'Conflict', blob.valueOf('Example error message'), null);
    
    @testSetup static void setupData(){
    	DCE_TestDataFactory.setUpDataWithAmends();
    }
    
    static testMethod void testAuthenticationFailure() {
        
        map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationBad);
		endPointsToMockresponses.put('exampleQuery', calloutGETGood);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);

		test.startTest();
			
		test.setMock(HttpCalloutMock.class, multiCalloutMock);
		DCE_RestConnector cont = new DCE_RestConnector('exampleQuery', 'GET');
		
		system.assertEquals('AUTHERROR', cont.authenticationToken);
        system.assertEquals(true, cont.restError);
        system.assert(cont.restErrorMessage.startsWith('There has been an error authenticating this session with the Dementia Connect database. Please contact your administrator with the following error details:'));
    
    	test.stopTest();
    }
    
    static testMethod void testAuthenticateSuccessGetSuccess() {
        
         map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationGood);
		endPointsToMockresponses.put('exampleQuery', calloutGETGood);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);
        
		test.startTest();
			
		test.setMock(HttpCalloutMock.class, multiCalloutMock);
		DCE_RestConnector cont = new DCE_RestConnector('exampleQuery', 'GET');
        
        test.stopTest();
        
        system.assertNOTEquals('AUTHERROR', cont.authenticationToken);
        system.assertEquals(false, cont.restError);
    	system.assertEquals(cont.res.getBody(), '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Services__c","url":"/services/data/v35.0/sobjects/Services__c/a0z3E00000000K7QAI"},"Id":"a0z3E00000000K7QAI","Name":"Example Memory Assessment Service","service_type__c":"Dementia Support & Groups"}]}');
    }
    
	static testMethod void testAuthenticateSuccessGetFailure() {
        
         map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationGood);
		endPointsToMockresponses.put('exampleQuery', calloutGETBad);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);
        
		test.startTest();
			
		test.setMock(HttpCalloutMock.class, multiCalloutMock);
		DCE_RestConnector cont = new DCE_RestConnector('exampleQuery', 'GET');
        
        test.stopTest();
        
        system.assertNOTEquals('AUTHERROR', cont.authenticationToken);
        system.assertEquals(true, cont.restError);
        system.assert(cont.restErrorMessage.startsWith('There has been an error contacting the Dementia Connect database. Please contact your administrator with the following error details:'));
    	system.assertEquals(cont.res.getBody(), '{Bad result}');
	}
	
	static testMethod void testAuthenticateSuccessPostSuccess() {
        
		DCE_ServiceAmend__c amend = database.query('select '+DCE_ServiceAmendWrapper.fieldsOfInterestPortal+' from  DCE_ServiceAmend__c limit 1');
		
		map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationGood);
		endPointsToMockresponses.put('exampleQuery', calloutPOSTGood);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);
        
		test.startTest();
			
		test.setMock(HttpCalloutMock.class, multiCalloutMock);
		DCE_RestConnector cont = new DCE_RestConnector('exampleQuery', 'POST', amend, DCE_ServiceAmendWrapper.portalToProductionFieldMap);
        
        test.stopTest();
        
        system.assertNOTEquals('AUTHERROR', cont.authenticationToken);
        system.assertEquals(false, cont.restError);
        system.assertEquals(cont.res.getBody(), 'Successfully Updated');
	}
	
	static testMethod void testAuthenticateSuccessPostFailure() {
        
		DCE_ServiceAmend__c amend = database.query('select '+DCE_ServiceAmendWrapper.fieldsOfInterestPortal+' from  DCE_ServiceAmend__c limit 1');
		
		map<string, DCE_SingleRequestMock> endPointsToMockresponses = new map<string, DCE_SingleRequestMock>();
		
		endPointsToMockresponses.put('https://Instance.salesforce.com/services/oauth2/token?grant_type=password&client_id=a_dummy_Value&client_secret=a_dummy_Value&username=a_dummy_Value&password=a_dummy_Value', calloutAuthenticationGood);
		endPointsToMockresponses.put('exampleQuery', calloutPOSTBad);
		
		DCE_MultipleRequestMock multiCalloutMock = new DCE_MultipleRequestMock(endPointsToMockresponses);
        
		test.startTest();
			
		test.setMock(HttpCalloutMock.class, multiCalloutMock);
		DCE_RestConnector cont = new DCE_RestConnector('exampleQuery', 'POST', amend, DCE_ServiceAmendWrapper.portalToProductionFieldMap);
        
        test.stopTest();
        
        system.assertNOTEquals('AUTHERROR', cont.authenticationToken);
        system.assertEquals(true, cont.restError);
        system.assertEquals(cont.res.getBody(), 'Example error message');
        system.assert(cont.restErrorMessage.startsWith('Example error message'));
        
	}
}