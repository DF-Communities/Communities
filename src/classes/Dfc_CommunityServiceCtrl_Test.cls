@isTest
private class Dfc_CommunityServiceCtrl_Test
{

	@testSetup
	public static void setupData() {

		Dfc_DataFactory_Test.TestDataCreation();

	}

	@isTest
	static void itShould()
	{

		User testUser = [SELECT Id FROM User WHERE Email = 'test1.testcontact@myemail.com'];

		// Run as the test user	
	
	
		DFC_Community__c community = [SELECT Id from DFC_Community__c limit 1];

		DFC_Community_Action_Area__c[] lisAreas = [select Id, name from DFC_Community_Action_Area__c where Community__c =: community.id];

		DFC_Community_Representative__c rep = [select Id from DFC_Community_Representative__c limit 1];

		test.startTest();


		DFC_Community__c comm = (DFC_Community__c)Dfc_CommunityServiceController.getCommunity(community.id);
		System.assertEquals('Here Somewhere', comm.Location__c);

		System.RunAs(testUser) {
		
			Dfc_CommunityServiceController.updateCommunity(comm, lisAreas);		
			Dfc_CommunityServiceController.addRepresentative(comm.id, 'test3.testcontact@myemail.com');
			Dfc_CommunityServiceController.inviteRepresentative(comm.id, 'test4.testcontact@myemail.com', 'Test4 TestContact');

			
			Dfc_CommunityServiceController.deleteRepresentative(comm.id, rep.id);
	    

			Object o = Dfc_CommunityServiceController.getCommunityWithContext(community.Id) ;

		}

	}

	@isTest
	static void itShould2()
	{
	
		Dfc_ErrorResponse error = (DFC_ErrorResponse)Dfc_CommunityServiceController.getCommunity('xxx');

		DFC_Community__c community = [ SELECT Id FROM DFC_Community__c limit 1];
		DFC_Community_Action_Area__c[] lisAreas = [SELECT id, name FROM DFC_Community_Action_Area__c WHERE  Community__c =: community.id];
		community.Name__c = '';

		error = (Dfc_ErrorResponse)Dfc_CommunityServiceController.updateCommunity(community, lisAreas);
		String s = error.getMessage();
		s = error.getType();
		s = error.getStackTrace();
		boolean b = error.getIsErrorResponse();

	}

	@isTest
	static void itShould3()
	{
	
		Dfc_ErrorResponse error = (Dfc_ErrorResponse)Dfc_CommunityServiceController.inviteRepresentative('xxx', 'xxx', 'xxx');
		String s = error.getMessage();
		s = error.getType();
		s = error.getStackTrace();

	}

	@isTest
	static void itShould4()
	{
	
		Dfc_ErrorResponse error = (Dfc_ErrorResponse)Dfc_CommunityServiceController.deleteRepresentative('xxx', 'xxx');
		String s = error.getMessage();
		s = error.getType();
		s = error.getStackTrace();

	}



	@isTest
	static void itShould5()
	{
	
		DFC_Community__c community = [select Id from DFC_Community__c limit 1];
		Dfc_CommunityServiceController.addRepresentative(community.id, 'test3.testcontact@myemail.com');
		Dfc_CommunityServiceController.addRepresentative(community.id, 'test3.testcontact@myemail.com');

	}

	@isTest
	static void isShould6()
	{

		User u = [select Id from User where Email = 'test1.testcontact@myemail.com'];	
		DFC_Alliance__c alliance = [select Id from DFC_Alliance__c limit 1];


		System.runAs(u) {

			String s = Dfc_CommunityServiceController.getCurrentUserId();
			Object o = Dfc_CommunityServiceController.getCommunitiesForDaa(alliance.Id);


		}

	}



}