@isTest
public class ExchangeTopicsListController_Test {

	@testSetup
    static void setupData() {  ExchangeDataFactory_Test.TestDataCreation(); }

	
	@isTest static void test_method_one() {
		
	 
		User u = [SELECT Id FROM User WHERE Email = 'test.testcontact@myemail.com'];       
      
        NetworkMember membership = new NetworkMember();
          membership = [SELECT networkId, memberID FROM NetworkMember where memberID=:u.Id  limit 1];

          system.runAs(u){     
          Test.startTest();  
            ExchangeTopicsListController.NetworkId  = membership.networkId;
        	ExchangeTopicsListController controller = new ExchangeTopicsListController();
        	controller.userId = u.Id;
          Test.stopTest();

        }
	}
	
	
}