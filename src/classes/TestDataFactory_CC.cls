/*
    Class used to create test data for unit tests
*/
public class TestDataFactory_CC {

    public static void createAllCustomSettings() {
    
        createCkeRecordSettings();
        createPaypalSettings();
        
    }
    
    private static void createCkeRecordSettings() {
        
        List<Community_Settings__c> cupcakeCustomSettings = new List<Community_Settings__c>{ new Community_Settings__c(Name = 'CKE_Donate_Progress_Id', Value__c = 'EVCD17_DON'),
                                                                                             new Community_Settings__c(Name = 'CKE_Pack_Progress_Id', Value__c = 'EVCD17_KIT'),
                                                                                             new Community_Settings__c(Name = 'CKE_Payment_Progress_Id', Value__c = 'EVCD17_PAY')};
        insert cupcakeCustomSettings;
        
    }
    
    private static void createPaypalSettings() {
        
        PayPal_Settings__c settings = new PayPal_Settings__c();
        settings.Gateway_Data_1__c= 'xxx';
        settings.Gateway_Data_2__c = 'xxx';
        settings.Gateway_Data_3__c = 'xxx';
        settings.Gateway_Data_4__c = 'xxx';
        settings.Gateway_Data_5__c = 'xxx.xxx.xxx.com';
        settings.Live_Payments__c = false;
        insert settings;

        Cke_Payment__c payment = new Cke_Payment__c();
        payment.Status__c = 'Checkout1';
        payment.Amount__c = 100;
        payment.Paypal_Token__c = 'xxxx';
        payment.First_Name__c = 'Test';
        payment.Last_Name__c = 'Test';
        payment.Email__c = 'Test@test.com';
        insert payment;

        Cke_Payment__c payment2 = new Cke_Payment__c();
        payment2.Status__c = 'Checkout99';
        payment2.Amount__c = 100;
        payment2.Paypal_Token__c = 'bad';
        payment2.First_Name__c = 'Test';
        payment2.Last_Name__c = 'Test';
        payment2.Email__c = 'Test@test.com';
        insert payment2;

        Cke_Payment__c payment3 = new Cke_Payment__c();
        payment3.Status__c = 'Checkout2';
        payment3.Amount__c = 100;
        payment3.Paypal_Token__c = 'EC-4HD21310W5753063G';
        payment3.First_Name__c = 'Test';
        payment3.Last_Name__c = 'Test';
        payment3.Email__c = 'Test@test.com'; 
        insert payment3;
        
    }

}