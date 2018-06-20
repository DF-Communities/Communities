@isTest
private class PayPalClient_Test
{

    @testSetup
    static void testSetup(){

        PayPal_Settings__c settings = new PayPal_Settings__c();
        settings.Gateway_Data_1__c= 'xxx';
        settings.Gateway_Data_2__c = 'xxx';
        settings.Live_Payments__c = false;
        insert settings;

    } 

    @isTest
    static void itShould()
    {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        PayPalData.PaymentData data = new PayPalData.PaymentData();

        data.addressLine1 = 'xxx';  
        data.addressLine2 = 'xxx';
        data.city = 'xxx';
        data.postcode = 'xxx';
        data.countryCode = 'xxx';
        data.cardType = 'VISA';
        data.cvv = '123';
        data.cardNumber = '1234 1234 1234 1234';
        data.cardholderName = 'John Smith';        
        data.expiryMonth = '10';
        data.expiryYear = '2016';               
        data.amount = '100';
        data.description = 'xxx';

        PayPalClient client = new PayPalClient(true);
        client.token='xxx';
        client.createPayment(data);
        

    
    }


    @isTest
    static void itShould2()
    {

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new PayPalMockHttp_Test());
        PayPalClient client = new PayPalClient(true);
        client.token='xxx';
        
        try {
            client.setExpressCheckout('100','','','');
            } catch (Exception x) {
                // transaction failed
            }        
    
    }
    
    @isTest
    static void itShould3()
    {

        Test.startTest();

        PayPalData.PaymentResponse r = new PayPalData.PaymentResponse();
        r.id='xxx';
        r.state='xxz';
        r.intent='xxx';
        r.create_time ='xxx';
        
        PayPalData.CreditCard cc = new PayPalData.CreditCard();

        //ID of the credit card. This ID is provided in the response when storing credit cards. Required if using a stored credit card.
        cc.setId('xxx');
        String s = cc.getId();
        
        //Credit card number. Numeric characters only with no spaces or punctuation. The string must conform with modulo and length required by each credit card type. Redacted in responses. Required.
        cc.setCard_number('1234 1234 1234 1234');
        s=cc.getCard_number();

        
        //Credit card type. Valid types are: visa, mastercard, discover, amex Required.
        cc.setCardType('VISA');
        s=cc.getCardType();

        
        //Expiration month with no leading zero. Acceptable values are 1 through 12. Required.
        cc.setExpireMonth(10);
        Integer i = cc.getExpireMonth();

        
        //4-digit expiration year. Required.
        cc.setExpireYear(2016);
        i = cc.getExpireYear();

        
        //3-4 digit card validation code.
        cc.setCvv2('1234');
        s=cc.getCvv2();

        
        //Cardholder’s first name.
        cc.setFirstName('xxx');
        s=cc.getFirstName();

        
        //Cardholder’s last name.
        cc.setLastName('xxx');
        s=cc.getLastName();
        
    
    }
    
}