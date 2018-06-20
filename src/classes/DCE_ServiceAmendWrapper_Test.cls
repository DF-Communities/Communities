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
private class DCE_ServiceAmendWrapper_Test {

    private static string JSON_INPUT = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Services__c","url":"/services/data/v35.0/sobjects/Account/a0z1234567890ABCDE"},"Id":"a0z1234567890ABCDE","Name":"Example Service Name"}]}';
	
	@testSetup static void setupData(){
		DCE_TestDataFactory.setUpDataWithAmends();
	}
	
    static testMethod void newWrapperWithoutExistingSObject() {
        test.startTest();
        
		DCE_ServiceAmendWrapper sWrap = new DCE_ServiceAmendWrapper(JSON_INPUT);
        	
		system.assertEquals('Example Service Name', sWrap.amend.Name);
        	
		map<string, string> testMap1 = DCE_ServiceAmendWrapper.PortalToProductionFieldMap;
		string fieldsOfInterestLocal = DCE_ServiceAmendWrapper.fieldsOfInterestPortal;
		string fieldsOfInterestProduction = DCE_ServiceAmendWrapper.fieldsOfInterest;
        
        test.stopTest();
    }
    
    static testMethod void newWrapperWithExistingSObject() {
        test.startTest();
        
		DCE_ServiceAmend__c amend = [select id, Name from DCE_ServiceAmend__c limit 1];
        	
		DCE_ServiceAmendWrapper sWrap = new DCE_ServiceAmendWrapper(JSON_INPUT, amend, 'edit');
        	
		system.assertEquals('Example Service Name', sWrap.amend.Name);
        	
        test.stopTest();
    }
}