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
private class DCE_OrgAmendWrapper_Test {

	private static string JSON_INPUT = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Account","url":"/services/data/v35.0/sobjects/Account/0011234567890ABCDE"},"Id":"0011234567890ABCDE","Name":"Example Account Name"}]}';
	
	@testSetup static void setupData(){
		//DCE_TestDataFactory.setUpDataWithoutAmends();
	}
	
    static testMethod void newWrapperWithoutExistingSObject() {
        test.startTest();
        
        	DCE_OrgAmendWrapper orgWrap = new DCE_OrgAmendWrapper(JSON_INPUT);
        	
        	system.assertEquals('Example Account Name', orgWrap.partner.Name__c);
        	
        	map<string, string> testMap1 = DCE_OrgAmendWrapper.PortalToProductionFieldMap;
        	string fieldsOfInterestLocal = DCE_OrgAmendWrapper.fieldsOfInterestLocal;
        	string fieldsOfInterestProduction = DCE_OrgAmendWrapper.fieldsOfInterestProduction;
        
        test.stopTest();
    }
    
    static testMethod void newWrapperWithExistingSObject() {
        test.startTest();
        
        	DCE_OrgAmend__c amend = DCE_TestDataFactory.createPartner1OrgAmend();
        	
        	DCE_OrgAmendWrapper orgWrap = new DCE_OrgAmendWrapper(JSON_INPUT, amend);
        	
        	system.assertEquals('Example Account Name', orgWrap.partner.Name__c);
        	
        test.stopTest();
    }
}