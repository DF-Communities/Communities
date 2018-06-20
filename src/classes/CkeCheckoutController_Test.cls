@isTest
private class CkeCheckoutController_Test
{

    @testSetup
    static void testSetup(){

        TestDataFactory_CC.createAllCustomSettings();

    }

    public static CkeCheckoutController.Command getData(String token) {

        CkeCheckoutController.Command cmd = new CkeCheckoutController.Command();
        cmd.token=token;
        cmd.payerId='xxxxx';
        cmd.amount='100';

        return cmd;

    }


    @isTest
    static void itShould()
    {
    
        PageReference pr = Page.Cke_Payment;
        Test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('token', 'xxxx');

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        CkeCheckoutController ctl = new CkeCheckoutController();
        ctl.getCheckoutDetails();   

        String t = ctl.getToken();
        t = ctl.getErrorStatus();
        t = ctl.getPayerId();
        t = ctl.getAmount();
        t = ctl.getCancelUrl();
        t = ctl.getTitle();
        t = ctl.getCopy();
        t = ctl.getPaymentType();
        
        Test.stopTest();    

    }

    @isTest
    static void itShould1a()
    {
    
        PageReference pr = Page.Cke_Payment;
        Test.setCurrentPage(pr);

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        
        CkeCheckoutController ctl = new CkeCheckoutController();
        ctl.getCheckoutDetails();   

        
        Test.stopTest();    

    }

    @isTest
    static void itShould1b()
    {
    
        PageReference pr = Page.Cke_Payment;
        Test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('token', 'bad');

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        
        CkeCheckoutController ctl = new CkeCheckoutController();
        ctl.getCheckoutDetails();   

        
        Test.stopTest();    

    }

    @isTest
    static void itShould1c()
    {
    
        PageReference pr = Page.Cke_Payment;
        Test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('token', 'NoneThere');

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        
        CkeCheckoutController ctl = new CkeCheckoutController();
        ctl.getCheckoutDetails();   

        
        Test.stopTest();    

    }


    // Successful save and Submit
    @isTest
    static void itShould2()
    {

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        
        CkeCheckoutController ctl = new CkeCheckoutController();
        CkeCheckoutController.Command cmd = getData('EC-4HD21310W5753063G');        

        Continuation con = (Continuation)CkeCheckoutController.createPayment(cmd);
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('TOKEN=EC-4HD21310W5753063G SUCCESSPAGEREDIRECTREQUESTED=false TIMESTAMP=2016-05-30T12:52:05Z CORRELATIONID=513835e6bf1ce ACK=Success VERSION=93 BUILD=000000 INSURANCEOPTIONSELECTED=false SHIPPINGOPTIONISDEFAULT=false PAYMENTINFO_0_TRANSACTIONID=7A688454G53060724 PAYMENTINFO_0_TRANSACTIONTYPE=expresscheckout PAYMENTINFO_0_PAYMENTTYPE=instant PAYMENTINFO_0_ORDERTIME=2016-05-30T12:52:05Z PAYMENTINFO_0_AMT=1.00 PAYMENTINFO_0_FEEAMT=0.23 PAYMENTINFO_0_TAXAMT=0.00 PAYMENTINFO_0_CURRENCYCODE=GBP PAYMENTINFO_0_PAYMENTSTATUS=Completed PAYMENTINFO_0_PENDINGREASON=None PAYMENTINFO_0_REASONCODE=None PAYMENTINFO_0_PROTECTIONELIGIBILITY=Eligible PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=ItemNotReceivedEligible,UnauthorizedPaymentEligible PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=EANWD7BGRY8PS PAYMENTINFO_0_ERRORCODE=0 PAYMENTINFO_0_ACK=Success');  
        Test.setContinuationResponse('xtest', response);
        Test.invokeContinuationMethod(new CkeCheckoutController(), con);
      
        Test.stopTest();
    }

    // Successful save and Submit
    @isTest
    static void itShould3()
    { 

        String token = 'EC-4HD21310W5753063G';
        Cke_Payment__c payment = [ select Id, Status__c, Type__c, Amount__c, First_Name__c, Last_Name__c, Email__c, Paypal_Token__c, Transaction_Id__c, Extended_Status__c from Cke_Payment__c where Paypal_Token__c = :token ];
        
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        
        CkeCheckoutController ctl = new CkeCheckoutController();
        
        CkeCheckoutController.ContinuationData state = new CkeCheckoutController.ContinuationData('EC-4HD21310W5753063G', payment, new PayPalClient());

        Object o = CkeCheckoutController.createPaymentContinue(state);

    }



    
}