@isTest
private class ExchangeHeaderCmpController_Test {
	
	@testSetup
    static void setupData() {  ExchangeDataFactory_Test.TestDataCreation(); }
	
	@isTest static void test_method_two() {
	Test.startTest();
		// Implement test code
     User u = [SELECT Id FROM User WHERE Email = 'test.testcontact@myemail.com'];
	 DF_Contact__c dfc = [SELECT About_me__c,Date_of_Champion_Training__c,Title__c,city__c,Why_do_you_want_to_become_a_Champion__c,First_Name__c,name__c,name,recordtype_name__c,County__c,Total_No_of_Friends_Created__c,Total_No_of_Completed_Info_Sessions__c,interests__c,Other_interests__c FROM DF_Contact__c WHERE Email__c = 'test.testcontact@myemail.com'];          
      system.runAs(u){
      	system.assertNotEquals(null,ExchangeHeaderCmpController.totalFriendCount());
        system.assertNotEquals(null,ExchangeHeaderCmpController.getCurrentUser());
      Test.stopTest();
     }
	}
	
}