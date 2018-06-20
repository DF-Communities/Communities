/**
 * Unit test for WebErrorServices class
 */
@isTest
private class TestWebErrorServices {
	
	// test values
	static String oneSessionId = 'abcde';
	static String twoSessionId = 'diff_sid';
	static String referrer = 'http://google.com/about.html';
	static String unsupportedErrorCode = '_DUMMY_';
	
	static List<WEBError_Record__c> findWebErrorRecords(String sessionId) {
		return [SELECT Error_Count_RollUp__c, Last_Error_Datetime__c, Session_ID__c FROM WEBError_Record__c WHERE Session_ID__c = :sessionId];
	}

    static testMethod void testRecordError() {
    	// work only if custom setting is on
    	String errCode = WebErrorServices.AUTH_REQUIRED_CODE;
        WEBError_Record_Detail__c errDetail = WebErrorServices.recordError(errCode, referrer, oneSessionId);
        System.assert(errDetail == null);
        
        // Turn on error logging
        Global_Setting__c gsLogErrors = new Global_Setting__c(Name = WebErrorServices.CS_GLOBAL_NAME, Value__c = WebErrorServices.CS_GLOBAL_VALUE);
        insert gsLogErrors;
    	
        // create record for session first time
        errDetail = WebErrorServices.recordError(errCode, referrer, oneSessionId);
        System.assert(errDetail != null);
        System.assertEquals(WebErrorServices.errorCodeNames.get(errCode), errDetail.Error_Condition__c);
        System.assertEquals(referrer, errDetail.Referrer__c);
        Id masterErrorId = errDetail.WEBError_Record__c;
        
        // create another error for the same session
        errCode = WebErrorServices.MAINTENANCE_CODE;
        errDetail = WebErrorServices.recordError(errCode, referrer, oneSessionId);
        System.assertEquals(WebErrorServices.errorCodeNames.get(errCode), errDetail.Error_Condition__c);
        System.assertEquals(referrer, errDetail.Referrer__c);
        System.assertEquals(masterErrorId, errDetail.WEBError_Record__c);
        Datetime lastDt = [SELECT CreatedDate FROM WEBError_Record_Detail__c WHERE Id = :errDetail.Id].CreatedDate;
        
        // create unsupported error, empty referrer and different session ID
        errDetail = WebErrorServices.recordError(unsupportedErrorCode, null, twoSessionId);
        System.assertEquals(WebErrorServices.errorCodeNames.get(WebErrorServices.GENERIC_ERROR_CODE), errDetail.Error_Condition__c);
        System.assert(String.isBlank(errDetail.Referrer__c));
        System.assertNotEquals(masterErrorId, errDetail.WEBError_Record__c);
        
        // check summary roll-up fields
        List<WEBError_Record__c> masterErrors = findWebErrorRecords(oneSessionId);
        System.assertEquals(1, masterErrors.size());
        WEBError_Record__c errRecord = masterErrors[0];
        System.assertEquals(lastDt, errRecord.Last_Error_Datetime__c);
        System.assertEquals(2, errRecord.Error_Count_RollUp__c);
    }
    
}