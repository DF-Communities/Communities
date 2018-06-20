@isTest
public class CkeMailClient_Test {

 @isTest    
 public static void itShould() {

    Cke_Payment__c p = new Cke_Payment__c();
    p.First_Name__c = 'xxx';
    p.Type__c = 'Pay-in';
    p.Amount__c = 10;
    p.Transaction_Id__c = 'xxx';     

    Test.startTest();

    Test.setMock(HttpCalloutMock.class, new CkeMailClientMockHttp_Test());
    CkeMailClient client = new CkeMailClient();
    client.sendTestMail('xxx@xxx.com', 'xxx', 10);
    client.sendPackConfirmationMail('xxx@xxx.com', 'xxx', 10);
    client.sendPayinConfirmationMail('xxx@xxx.com', 'xxx', 10, 'xxx');
    client.sendDonationConfirmationMail('xxx@xxx.com', 'xxx', 10, 'xxx');
    client.sendRegisterInterestConfirmationMail('xxx@xxx.com', 'xxx');

    client.sendPaymentConfirmationMail(p);
    
    p.Type__c = CkePaymentController.TYPE_DONATION;
    client.sendPaymentConfirmationMail(p);    

    p.Type__c = null;
    client.sendPaymentConfirmationMail(p);    

 }

}