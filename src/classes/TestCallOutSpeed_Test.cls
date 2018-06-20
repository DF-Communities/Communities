@isTest
public without sharing class TestCallOutSpeed_Test implements Database.AllowsCallouts {

	public TestCallOutSpeed_Test() {
		
	}

	 static testmethod void covermethod(){
 
		 Test.startTest();
		 Test.setMock(HttpCalloutMock.class, new TestCallOutSpeedMock());
		 TestCallOutSpeed batch =new TestCallOutSpeed();
		 batch.execute(null);

		 Test.stopTest();
 
	}


	 static testmethod void covermethod2(){
 
		 Test.startTest();
		 Test.setMock(HttpCalloutMock.class, new TestCallOutSpeedMock());
		 TestCallOutSpeed batch =new TestCallOutSpeed();
		 batch.urlOption = 'DAA';
		 batch.execute(null);

		 Test.stopTest();
 
	}


}