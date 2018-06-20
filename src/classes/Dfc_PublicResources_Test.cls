@isTest
private class Dfc_PublicResources_Test
{

	@testSetup
	public static void setupData() {

		Dfc_DataFactory_Test.TestDataCreation();

	}

	@isTest
	static void itShould()
	{
		List<DFC_Resource__c> pr =[select Display_on_home_page__c from DFC_Resource__c limit 1];
		pr[0].Display_on_home_page__c = true ;
		test.starttest();
        update pr[0];

		Dfc_PublicResources ctl = new Dfc_PublicResources();
		List<DFC_Resource__c> resources  = ctl.resources; 
	    Map<Id, Attachment> attachmentsMap  = ctl.attachmentsMap;
    	Map<Id, String> attachmentTypesMap  = ctl.attachmentTypesMap;

	}
}