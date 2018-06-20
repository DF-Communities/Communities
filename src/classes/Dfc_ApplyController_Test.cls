@isTest
without sharing class Dfc_ApplyController_Test {

	@testSetup
	static void setupData() { 
		Dfc_DataFactory_Test.TestDataCreation(); 
	}


	@isTest
	static void itShould()
	{
		User testUser = [SELECT Id FROM User WHERE Email = 'test1.testcontact@myemail.com'];

		// Run as the test user	
		System.runAs(testUser) {

			Dfc_ApplyController ctl = new Dfc_ApplyController();

     		Integer count = ctl.getCommunityCount();
			System.assertEquals(count, 1);

			Integer countDraft = ctl.getDraftCommunityCount();

			String message = ctl.getCommunitiesExistMessage();
			System.assertEquals(countDraft, 1);


			String introText  = ctl.getIntroText(); // dfc-apply-submit-intro
			String submitText = ctl.getSubmitText(); // dfc-apply-submit-intro

	 
	  		System.assertEquals('dfc-apply-intro', ctl.getIntroText());
	  		System.assertEquals('dfc-apply-submit-intro', ctl.getSubmitText());

	  		

	  	//	ApexPages.currentPage().getParameters().put('dfcid',community.id);

			DFC_Community__c  community = ctl.getCommunity();

  		}
    }
}