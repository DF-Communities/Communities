/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Controller for Friend Video Component
 *  Author  : Gary Grant
 *  Date    : April 2015
 *  Version : 
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/

public without sharing class DF_WEBC_FriendVideo_Controller extends WEBC_ControllerBase {
	
	public boolean watchedVideo { 

		get {
			if ( !isLoggedIn ) { return false; }
			DF_Contact__c dfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());
			return (dfc.Digital_Friend_Signup_Time__c ==null);
		}
		set;

	}

	public void doSetVideoWatched() {
      String videoType= Apexpages.currentPage().getParameters().get('videoType');
      
      system.debug('FriendVideo :video type'+videoType);
		system.debug('FriendVideo : Start');

		if ( !isLoggedIn ) { return; }
		DF_Contact__c dfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());
		if ( dfc.Digital_Friend_Signup_Time__c != null ) { return; }
		
		dfc.Digital_Friend_Signup_Time__c = System.now();
		dfc.Watched_video_type__c = (videoType!=null?videoType:'');
		update dfc;
	  
	}

}