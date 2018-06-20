@isTest
public class Dfc_DAA_Region_TriggerHdler_Test {

	public Dfc_DAA_Region_TriggerHdler_Test() {


	}

	@testSetup
	public static void setupData() {

		Dfc_DataFactory_Test.TestDataCreation();

	}

	@isTest
	public static void doTest() {

		DFC_Community__c community = [select Id from DFC_Community__c limit 1];
		update community;

		DFC_DAA_Region__c region = [select Id, DAA_Regional_Lead__c from DFC_DAA_Region__c limit 1];
		User u = [select Id from User where Id !=: region.DAA_Regional_Lead__c limit 1];

		region.DAA_Regional_Lead__c = u.id;
		update region;


	}

}