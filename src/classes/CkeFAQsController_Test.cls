/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CkeFAQsController_Test {

    static testMethod void faqTest() {
        
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
        
        
    FAQ_Category__c cat = new FAQ_Category__c();
    cat.Name__c = '*** FAQ Catagory ***';
    cat.Rank__c = '1';
    cat.Website__c = 'Cupcake';
    FAQ_Category__c cat2 = new FAQ_Category__c();
    cat2.Name__c = '*** FAQ Catagory ***';
    cat2.Rank__c = '2';
    cat2.Website__c = 'Cupcake';
    
    insert cat;
    insert cat2;
    
    FAQ__c faq = new FAQ__c();
    faq.Question__c = '*** FAQ Question ***';
    faq.Answer__c = '*** FAQ Answer ***';
    faq.Rank__c = '1';
    faq.Category__c = cat.Id;
    
    FAQ__c faq2 = new FAQ__c();
    faq2.Question__c = '*** FAQ Question ***';
    faq2.Answer__c = '*** FAQ Answer ***';
    faq2.Rank__c = '1';
    faq2.Category__c = cat2.Id;
    
    insert faq;
    insert faq2;

    CkeFAQsController controller;
    
    Test.startTest();
    controller = new CkeFAQsController();

    system.assertEquals(2, controller.faqCategories.size());
    system.assertEquals(2, controller.faqs.size());
    system.assertEquals(2, controller.mapFaqs.size());
    
    Test.stoptest();
  }
}