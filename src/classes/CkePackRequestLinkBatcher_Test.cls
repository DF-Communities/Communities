@isTest
private class CkePackRequestLinkBatcher_Test
{

 	@testSetup
   	static void testSetup(){

   		Community_Settings__c setting = new Community_Settings__c();
		setting.Name = 'CKE_Pack_Progress_Id';
		setting.Value__c = 'xxx';
		insert setting;

		setting = new Community_Settings__c();
		setting.Name = 'CKE_Payment_Progress_Id';
		setting.Value__c = 'xxxp';
		insert setting;

		setting = new Community_Settings__c();
		setting.Name = 'CKE_Donate_Progress_Id';
		setting.Value__c = 'xxxd';
		insert setting;
   		 

		CKE_Pack_Request__c pr = new CKE_Pack_Request__c();
		pr.Title__c = 'Mr';
		pr.First_Name__c = 'Test';
		pr.Last_Name__c = 'Test';
		pr.Email__c = 'Test@test.com';

		pr.City__c = 'test';
		pr.County__c = 'test';
		pr.Address_Line1__c = 'test';
		pr.Postcode__c = 'SW3 1PE';		
		pr.Status__c= 'Completed';
		pr.Progress_Form_Id__c = 'xxx';
		insert pr;


		pr = new CKE_Pack_Request__c();
		pr.Title__c = 'Mr';
		pr.First_Name__c = 'Test';
		pr.Last_Name__c = 'Test';
		pr.Email__c = 'Test@test.com';

		pr.City__c = 'test';
		pr.County__c = 'test';
		pr.Address_Line1__c = 'test';
		pr.Postcode__c = 'SW3 1PE';		
		pr.Status__c= 'Completed';
		pr.Progress_Form_Id__c = 'xxx';
		insert pr;

		CKE_Payment__c payment = new CKE_Payment__c();
		payment.Title__c = 'Mr';
		payment.First_Name__c = 'Test';
		payment.Last_Name__c = 'Test';
		payment.Email__c = 'Test@test.com';

		payment.City__c = 'test';
		payment.County__c = 'test';
		payment.Address_Line1__c = 'test';
		payment.Postcode__c = 'SW3 1PE';
		payment.Proximity_to_Dementia__c = 'xxx';
		payment.Gift_Aid__c = false;
		payment.Progress_Form_Id__c = 'xxxp';
		payment.Status__c = 'Completed';

		payment.Amount__c = 100;

		payment.Type__c = CkePaymentController.TYPE_PAYIN;

		insert payment;

		payment = new CKE_Payment__c();
		payment.Title__c = 'Mr';
		payment.First_Name__c = 'Test';
		payment.Last_Name__c = 'Test';
		payment.Email__c = 'Test@test.com';

		payment.City__c = 'test';
		payment.County__c = 'test';
		payment.Address_Line1__c = 'test';
		payment.Postcode__c = 'SW3 1PE';
		payment.Proximity_to_Dementia__c = 'xxx';
		payment.Gift_Aid__c = false;
		payment.Progress_Form_Id__c = 'xxxp';
		payment.Status__c = 'Completed';

		payment.Amount__c = 100;

		payment.Type__c = CkePaymentController.TYPE_DONATION;

		insert payment;


   	}


	@isTest
	static void itShould()
	{




		Test.startTest();

		CkeLinkBatchScheduler scheduler = new CkeLinkBatchScheduler();
		String timeString = '0 0 23 * * ?'; 
		system.schedule('Link Batch Scheduler', timeString, scheduler); 

		Test.stopTest();

	}

	@isTest
	static void itShould2() {


		CkePackRequestLinkBatcher batcher = new CkePackRequestLinkBatcher('xxx', 'xxxp','xxxd');
		Database.executeBatch(batcher);


	}

}