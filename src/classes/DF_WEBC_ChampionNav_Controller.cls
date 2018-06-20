/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Controller for Champion Navigation Component.
 *  Author  : Gary Grant
 *  Date    : May 2015
 *  Version : 0.1 Unit Test
 *
 *  Description:  
 *               
 *  Modification History
 *  Date            Who         Description 
 
*******************************************************************************************/

public without sharing class DF_WEBC_ChampionNav_Controller {
	
	
	public String totalFriendCount {

		get {
				Integer i = DF_Utils.totalFriendCount;
				return i.format();
		}
		private set;

	}
	public static string exchange{get;set;}

	public DF_WEBC_ChampionNav_Controller() {
	exchange=Community_Settings__c.getInstance('Exchange_Domain').value__c;
 	
		/* This controller could be used to fetch the current user, but that would be wasteful, so better to pass it in. */

	}
}