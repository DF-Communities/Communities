/*
 *
 * 2014-08-19 : CSL : This controller is for the WEBErrorPage on the Web Site
 *
 */

global class WEBErrorController {

	global WEBErrorController() {
		//Constructor left blank
	}

	// Getting referer page for current visualforce page
	@testVisible
	private static String getReferer() {
		String referer = ApexPages.currentPage().getHeaders().get('Referer');
		if (referer != null && referer.length() > 240) {
			referer = referer.substring(0, 240);
		}
		return referer;
	}

	global void recordErrorAuth() {
		WebErrorServices.recordError(WebErrorServices.AUTH_REQUIRED_CODE, getReferer(), UserInfo.getSessionId());
	}

	global void recordErrorPageNotFound() {
		WebErrorServices.recordError(WebErrorServices.PAGE_NOT_FOUND_CODE, getReferer(), UserInfo.getSessionId());
	}

	global void recordErrorMaintenance() {
		WebErrorServices.recordError(WebErrorServices.MAINTENANCE_CODE, getReferer(), UserInfo.getSessionId());
	}

	global void recordErrorLimitExceeded() {
		WebErrorServices.recordError(WebErrorServices.LIMIT_EXCEEDED_CODE, getReferer(), UserInfo.getSessionId());
	}

	//2014-08-19 : CSL : This method runs at the load of the WEBErrorPage and will record the date/time of the error into a new Custom Object WEBError_Record__c
	global void recordError() {
		WebErrorServices.recordError(WebErrorServices.GENERIC_ERROR_CODE, getReferer(), UserInfo.getSessionId());
	}
}