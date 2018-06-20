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
private class DCE_JSONResponseConverter_Test {

    private static string GOOD_JSON_ONE_RECORD = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Services__c","url":"/services/data/v35.0/sobjects/Services__c/a0z3E00000000K7QAI"},"Id":"a0z3E00000000K7QAI","Name":"Example Memory Assessment Service","service_type__c":"Dementia Support & Groups","Street_Line_4__c":null, "Referral_only__c":true, "Advertising_Start_Date__c":"2016-04-30"}]}';
    private static string GOOD_JSON_MULTIPLE_RECORDS = '{"totalSize":2,"done":true,"records":[{"attributes":{"type":"Services__c","url":"/services/data/v35.0/sobjects/Services__c/a0z3E00000000K7QAI"},"Id":"a0z3E00000000K7QAI","Name":"Example Memory Assessment Service","service_type__c":"Dementia Support & Groups"},{"attributes":{"type":"Services__c","url":"/services/data/v35.0/sobjects/Services__c/a0z3E00000000K7QAI"},"Id":"a0z3E00000000K7QAI","Name":"Example Memory Assessment Service","service_type__c":"Dementia Support & Groups"}]}';
    private static string GOOD_JSON_NO_RECORDS = '{"totalSize":0,"done":true,"records":[]}';
    private static string GOOD_JSON_WRONG_SOBJECT = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"customObject__c","url":"/services/data/v35.0/sobjects/Services__c/a0z3E00000000K7QAI"},"FieldName__c":"Here is the value","DareBlam__c":"Something else"}]}';
    private static string GOOD_JSON_NOT_QUERY = '{"BadJSON":"something","IsThisWrong":true}';
    private static string NOT_JSON = 'Well, I have just passed in a random string.';
    
    
    @testSetup private static void testSetup(){
    	
    }
    
	private static testMethod void successWithExistingRecord() {
        
		DCE_ServiceAmend__c service = new DCE_ServiceAmend__c();
		service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord(service, DCE_ServiceAmendWrapper.productionToPortalFieldMap, GOOD_JSON_ONE_RECORD);
        
        system.assertEquals('a0z3E00000000K7QAI', service.ServiceId__c);
        system.assertEquals('Example Memory Assessment Service', service.Name);
        system.assertEquals('Dementia Support & Groups', service.service_type__c);
        system.assertEquals(null, service.Street_Line_4__c);
        system.assertEquals(true, service.Referral_only__c);
        system.assertEquals(Date.newInstance(2016,4,30), service.Advertising_Start_Date__c);
    
    }
     
    private static testMethod void successWithNewRecord() {
       
		DCE_ServiceAmend__c service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('DCE_ServiceAmend__c', DCE_ServiceAmendWrapper.productionToPortalFieldMap, GOOD_JSON_ONE_RECORD);
        
        system.assertEquals('Example Memory Assessment Service', service.Name);
        system.assertEquals('Dementia Support & Groups', service.service_type__c);
    }
    
    private static testMethod void failureNonExistentSObjectType() {
        try{
        	DCE_ServiceAmend__c service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('madeUpSObject__c', DCE_ServiceAmendWrapper.productionToPortalFieldMap, GOOD_JSON_ONE_RECORD);
        	system.assert(false);
        } catch (exception e){
        	system.assertEquals('DCE_Exception', e.getTypeName());
        	system.assertEquals('SObject type does not exist in this Salesforce instance.', e.getMessage());
        }
	}
    
    private static testMethod void failureBadJSON() {
        try{
        	DCE_ServiceAmend__c service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('DCE_ServiceAmend__c', DCE_ServiceAmendWrapper.productionToPortalFieldMap, GOOD_JSON_NOT_QUERY);
        	system.assert(false);
        } catch (exception e){
        	system.assertEquals('DCE_Exception', e.getTypeName());
        	system.assertEquals('JSON String received does not resolve to SObject records. Please check inputs.', e.getMessage());
        }
    }
    
    private static testMethod void failureNotJSON() {
        try{
        	DCE_ServiceAmend__c service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('DCE_ServiceAmend__c', DCE_ServiceAmendWrapper.productionToPortalFieldMap, NOT_JSON);
        	system.assert(false);
        } catch (exception e){
        	system.assertEquals('DCE_Exception', e.getTypeName());
        	system.assertEquals('Passed in string may not have been JSON. Please check inputs.', e.getMessage());
        }
        
    }
    
    private static testMethod void failureObjectNotInSF() {
        try{
        	DCE_ServiceAmend__c service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('DCE_ServiceAmend__c', DCE_ServiceAmendWrapper.productionToPortalFieldMap, GOOD_JSON_WRONG_SOBJECT);
        	system.assert(false);
        } catch (exception e){
        	system.assertEquals('DCE_Exception', e.getTypeName());
        	system.assertEquals('The JSON supplied does not contain any fields that match with the target SObject. Please check that input.', e.getMessage());
        }
    }
    
    private static testMethod void failureBadMap() {
        
        map<string, string> badFieldMappings = new map<string, string>();
        badFieldMappings.put('Field1__c', 'Field1__c');
        badFieldMappings.put('Field2__c', 'Field2__c');
        badFieldMappings.put('Field3__c', 'Field3__c');
        badFieldMappings.put('Field4__c', 'Field4__c');
        badFieldMappings.put('Field5__c', 'Field5__c');
        badFieldMappings.put('Field6__c', 'Field1__c');
        
        try{
        	DCE_ServiceAmend__c service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('DCE_ServiceAmend__c', badFieldMappings, GOOD_JSON_ONE_RECORD);
        	system.assert(false);
        } catch (exception e){
        	system.assertEquals('DCE_Exception', e.getTypeName());
        	system.assertEquals('The map passed in needs to have a different value for every key, otherwise the field mappings will fail. Please re-check the map passed in.', e.getMessage());
        }
        
    }
    
    private static testMethod void failureMultipleRecords() {
        try{
        	DCE_ServiceAmend__c service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('DCE_ServiceAmend__c', DCE_ServiceAmendWrapper.productionToPortalFieldMap, GOOD_JSON_MULTIPLE_RECORDS);
        	system.assert(false);
        } catch (exception e){
        	system.assertEquals('DCE_Exception', e.getTypeName());
        	system.assertEquals('Request returned multiple SObject records. Please check inputs.', e.getMessage());
        }
        
    }
    
    private static testMethod void failureNoRecords() {
        try{
        	DCE_ServiceAmend__c service = (DCE_ServiceAmend__c)DCE_JSONResponseConverter.DCE_JSONResponseConvertSingleRecord('DCE_ServiceAmend__c', DCE_ServiceAmendWrapper.productionToPortalFieldMap, GOOD_JSON_NO_RECORDS);
        	system.assert(false);
        } catch (exception e){
        	system.assertEquals('DCE_Exception', e.getTypeName());
        	system.assertEquals('Request did not return any records. Please check inputs.', e.getMessage());
        }
        
    }
}