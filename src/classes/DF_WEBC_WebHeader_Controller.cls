/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : Web Header Class to back the web Header
 *            
 *  Author  : Gary Grant
 *  Date    : 07-02-2015
 *  Version : 1.0
 *
 *  Description:     
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/

public without sharing class DF_WEBC_WebHeader_Controller extends DF_WEBC_ControllerBase {

	public boolean isSubscriber {
		
		get {
			  if ( !isLoggedIn ) { return false; }
			  if ( WEBC_CommunityWrapper.isOrgAdmin() ) { return false; }
			  DF_Contact__c dfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());
			  return dfc != null ? dfc.Newsletters__c : false ;			
		}
		private set;
		
	}

	public void toggleSubscription() {

		   if ( !isLoggedIn ) { return; }
		   if ( WEBC_CommunityWrapper.isOrgAdmin() ) { return; }
		   DF_Contact__c dfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());
		   String option = Apexpages.currentPage().getParameters().get('option');
		   dfc.Newsletters__c = (option =='true' ? true : false);
		   update dfc;
	}

	/*
	public List<String> showTotalFriendCountList() {

			List<String> lis = new List<String>();
			String s = totalFriendCount;
			for (Integer n = 0; n<s.length(); n++) {
				lis.add(s.substring(n, n+1));
			}

			return lis;

	}
	*/

}