@isTest
public class CkePaymentController_Test {


   @testSetup
   	static void testSetup(){
        
   		PayPal_Settings__c settings = new PayPal_Settings__c();
   		settings.Gateway_Data_1__c= 'xxx';
   		settings.Gateway_Data_2__c = 'xxx';
   		settings.Live_Payments__c = false;
   		insert settings;

   	}

	public static CkePaymentController.Command getData() {
        
        Community_Settings__c paymentProgressIdSetting = new Community_Settings__c(Name = 'CKE_Payment_Progress_Id', Value__c = 'testPaymentProgressId');
        insert paymentProgressIdSetting;
        Community_Settings__c paymentProgressDonateIdSetting = new Community_Settings__c(Name = 'CKE_Donate_Progress_Id', Value__c = 'testDonateProgressId');
        insert paymentProgressDonateIdSetting;

		CkePaymentController.Command cmd = new CkePaymentController.Command();
		cmd.Title = 'Mr';
		cmd.FirstName = 'Test';
		cmd.LastName = 'Test';
		cmd.Email = 'Test@test.com';

		cmd.City = 'test';
		cmd.County = 'test';
		cmd.AddressLine1 = 'test';
		cmd.Postcode = 'SW3 1PE';
		cmd.OptinEmail = true; 
		cmd.OptinPhone = true;
		cmd.OptinSMS = true;
		cmd.proximity = 'xxx';
		cmd.giftaid = 'no';

		cmd.cardType = 'VISA';
        cmd.cvv = '123';
		cmd.cardNumber = '1234 1234 1234 1234';
        cmd.cardholderName = 'John Smith';        
        cmd.expiryMonth = '10';
        cmd.expiryYear = '2016';               
		cmd.amount = '100';
		cmd.description = 'xxx';

		cmd.type = CkePaymentController.TYPE_PAYIN;

		return cmd;

	}

	// Successful save and Submit
	@isTest
	static void itShould()
	{
        Edt_Item__c ei1 = new Edt_Item__c(Group__c='gdpr', Key__c='contact-preferences',Text1__c='test');
        insert ei1;
        Edt_Item__c ei2 = new Edt_Item__c(Group__c='gdpr', Key__c='connection-to-dementia',Text1__c='test');
        insert ei2;
        Edt_Item__c ei3 = new Edt_Item__c(Group__c='gdpr', Key__c='company',Text1__c='test');
        insert ei3;
        
        Community_Settings__c cs1 = new Community_Settings__c(Name='CKE_Pack_Progress_Id', Value__c='asdfasdf');
        insert cs1;
        Community_Settings__c cs2 = new Community_Settings__c(Name='Cke_Captcha_Site', Value__c='asdfasdf');
        insert cs2;
        Community_Settings__c cs3 = new Community_Settings__c(Name='Cke_Captcha_Secret', Value__c='asdfasdf');
        insert cs3;
        
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        
		CkePaymentController.Command cmd = getData();
        CKE_Payment__c pmt = CkePaymentController.buildPaymentRecord(cmd);
        PayPalClient paypal = new PayPalClient();
		
        Continuation con = (Continuation)CkePaymentController.createPayment(cmd);
        HttpResponse response = new HttpResponse();
        response.setBody('{"id":"PAY-13A25562RH949731XK4LVWNA","create_time":"2016-04-20T10:34:28Z","update_time":"2016-04-20T10:34:33Z","state":"approved","intent":"sale","payer":{"payment_method":"credit_card","funding_instruments":[{"credit_card":{"type":"visa","number":"xxxxxxxxxxxx0119","expire_month":"1","expire_year":"2021","first_name":"John","last_name":"Joseph","billing_address":{"line1":"5 Vivian Way","line2":"","city":"London","postal_code":"N2 0AB","country_code":"GB"}}}]},"transactions":[{"amount":{"total":"50.00","currency":"GBP","details":{"subtotal":"50.00"}},"related_resources":[{"sale":{"id":"9GJ566936P797745J","create_time":"2016-04-20T10:34:28Z","update_time":"2016-04-20T10:34:33Z","amount":{"total":"50.00","currency":"GBP"},"state":"completed","parent_payment":"PAY-13A25562RH949731XK4LVWNA","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/sale/9GJ566936P797745J","rel":"self","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/sale/9GJ566936P797745J/refund","rel":"refund","method":"POST"},{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAY-13A25562RH949731XK4LVWNA","rel":"parent_payment","method":"GET"}],"fmf_details":{},"processor_response":{"avs_code":"X","cvv_code":"M"}}}]}],"links":[{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAY-13A25562RH949731XK4LVWNA","rel":"self","method":"GET"}]}');  
        Test.setContinuationResponse('xtest', response);
        Test.invokeContinuationMethod(new CkePayinController(), con);

		Test.stopTest();
	}

	// Successful save and Submit
	@isTest
	static void itShould2()
	{
        Edt_Item__c ei1 = new Edt_Item__c(Group__c='gdpr', Key__c='contact-preferences',Text1__c='test');
        insert ei1;
        Edt_Item__c ei2 = new Edt_Item__c(Group__c='gdpr', Key__c='connection-to-dementia',Text1__c='test');
        insert ei2;
        Edt_Item__c ei3 = new Edt_Item__c(Group__c='gdpr', Key__c='company',Text1__c='test');
        insert ei3;
        
        Community_Settings__c cs1 = new Community_Settings__c(Name='CKE_Pack_Progress_Id', Value__c='asdfasdf');
        insert cs1;
        Community_Settings__c cs2 = new Community_Settings__c(Name='Cke_Captcha_Site', Value__c='asdfasdf');
        insert cs2;
        Community_Settings__c cs3 = new Community_Settings__c(Name='Cke_Captcha_Secret', Value__c='asdfasdf');
        insert cs3;
	
		Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
		CkePaymentController.Command cmd = getData();
		CkePaymentController.setExpressCheckout(cmd);

	}


}