@isTest(seeAllData=false)
public with sharing class WEBFAQTest {
  static testMethod void faqTest() {
    FAQ_Category__c cat = new FAQ_Category__c();
    cat.Name__c = '*** FAQ Catagory ***';
    cat.Rank__c = '1';
    cat.Website__c = 'Dementia Friends';
    FAQ_Category__c cat2 = new FAQ_Category__c();
    cat2.Name__c = '*** FAQ Catagory ***';
    cat2.Rank__c = '2';
    cat2.Website__c = 'Dementia Friends';
    
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

    WEBFAQs controller;
    
    Test.startTest();
    controller = new WEBFAQs();

    system.assertEquals(2, controller.faqCategories.size());
    system.assertEquals(2, controller.faqs.size());
    system.assertEquals(2, controller.mapFaqs.size());
    
    Test.stoptest();
  }
}