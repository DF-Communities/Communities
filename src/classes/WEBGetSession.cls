/*
*
* 2014-05-28 : CSL : This class is used to redirect a user from a sent Session URL link
* to the right protocol and URL for the session, depending if a user is logged in or not
*
*/

public with sharing class WEBGetSession extends WEBController {
	public final String ID_PARAM = 'id';
	public final String SECURE_URL = 'https://asdf.secure.force.com/';
	public final String NON_SECURE_URL = 'http://alzheimers.dementiafriends.org.uk/';
	
	public WEBGetSession(){
		//The constructor can be left blank
		//as this class will only call one method on the load of the page
	}
	
	//Method called on the load of the VF Page
	public PageReference loadSession(){
		system.debug('*** -- Into loadSession -- ***');
		PageReference returnPage;
		String sessionId = ApexPages.currentPage().getParameters().get(ID_PARAM);
		system.debug('*** -- sessionId = ' + sessionId + ' -- ***');
		if (sessionId == null){
			system.debug('*** -- isLoggedIn = ' + isLoggedIn + ' -- ***');
			if (isLoggedIn){
				returnPage = new PageReference(SECURE_URL);
			}else {
				returnPage = new PageReference(NON_SECURE_URL);
			}
		}else {
			system.debug('*** -- isLoggedIn = ' + isLoggedIn + ' -- ***');
			if (isLoggedIn){
				returnPage = new PageReference(SECURE_URL + 'WEBSessionDetails?id=' + sessionId);
			}else {
				returnPage = new PageReference(NON_SECURE_URL + 'WEBSessionDetails?id=' + sessionId);
			}
		}
		system.debug('*** -- About to return ' + returnPage.getUrl() + ' -- ***');
		returnPage.setRedirect(true);
		return returnPage;
	}

}