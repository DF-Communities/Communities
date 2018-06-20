/**
 * Service class for work with WEBError_Record__c
 */
public with sharing class WebErrorServices {
	
	// Custom setting constants that allows error logging
	public static final String CS_GLOBAL_NAME = 'LogWEBErrors';
    public static final String CS_GLOBAL_VALUE = 'TRUE';
	
	// Error codes constants
	public static final String AUTH_REQUIRED_CODE = '401';
	public static final String PAGE_NOT_FOUND_CODE = '404';
	public static final String MAINTENANCE_CODE = '500';
	public static final String LIMIT_EXCEEDED_CODE = '509';
	public static final String GENERIC_ERROR_CODE = 'GENERIC';
	
	public static final Set<String> validErrorCodes = new Set<String> {
		AUTH_REQUIRED_CODE, PAGE_NOT_FOUND_CODE, MAINTENANCE_CODE, LIMIT_EXCEEDED_CODE, GENERIC_ERROR_CODE
	}; 
	
	// Error type names
	public static final Map<String,String> errorCodeNames = new Map<String,String> {
		AUTH_REQUIRED_CODE => 'Authorization Required Page (401)',
		PAGE_NOT_FOUND_CODE => 'Page Not Found Page (404)',
		MAINTENANCE_CODE => 'Maintenance Page(500/503)',
		LIMIT_EXCEEDED_CODE => 'Limit Exceeded Page (509)',
		GENERIC_ERROR_CODE => 'Generic Error Page'
	};
	
	/**
	 * Find WEBError_Record__c by Session ID or create it
	 * @param sessionId ID of session
	 * @return WEBError_Record__c
	 */
	private static WEBError_Record__c findMasterErrorRecord(String sessionId) {
		List<WEBError_Record__c> masterList = [SELECT Id, Session_ID__c FROM WEBError_Record__c WHERE Session_ID__c = :sessionId LIMIT 1];
		WEBError_Record__c masterError;
		if ( masterList.isEmpty() ) {
			masterError = new WEBError_Record__c(Session_ID__c = sessionId);
			insert masterError;
		} else {
			masterError = masterList[0];
		}
		return masterError;
	}
	
	/**
	 * Return true if in Custom Setting is allowed 
	 */
	public static Boolean isErrorLoggingAllowed() {
		Global_Setting__c gs = Global_Setting__c.getValues(CS_GLOBAL_NAME);
		if ( gs != null ) {
			return ( gs.Value__c == CS_GLOBAL_VALUE );
		}
		return false;
	}
	
	/**
	 * Add error log object into database
	 * @param errCode Code of error. Default value from GENERIC_ERROR_CODE constants
	 * @param referrer HTTP Refferer page
	 * @page sessionId ID of user session
	 * @return WEBError_Record_Detail__c instance
	 */
	public static WEBError_Record_Detail__c recordError(String errCode, String referrer, String sessionId) {
		if ( !isErrorLoggingAllowed() ) {
			return null;
		}
		
		if ( !validErrorCodes.contains(errCode) ) {
			errCode = GENERIC_ERROR_CODE;
		}
		String errCondition = errorCodeNames.get(errCode);
		WEBError_Record__c masterError = findMasterErrorRecord(sessionId);
		WEBError_Record_Detail__c detailError = new WEBError_Record_Detail__c(
			WEBError_Record__c = masterError.Id,
			Error_Condition__c = errCondition,
			Referrer__c = referrer
		);
		insert detailError;
		return detailError;
	}
	

}