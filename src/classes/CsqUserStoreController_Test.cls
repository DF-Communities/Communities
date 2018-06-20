@isTest
without sharing class CsqUserStoreController_Test {

  @testSetup
  static void setupData() { 
    Dfc_DataFactory_Test.TestDataCreation(); 
  }


  @isTest
  static void itShould()
  {
    User testUser = [select Id from User where Email = 'test1.testcontact@myemail.com'];

     // Run as the test user  
     System.runAs(testUser) {
         Map<String, Object> mapUser = CsqUserStoreController.getCurentUserInfo();
    }
    
 }
  
}