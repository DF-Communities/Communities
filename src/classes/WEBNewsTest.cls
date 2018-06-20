@isTest(seeAllData=false)
public with sharing class WEBNewsTest {
  static testMethod void recentNewsTest() {
    News__c news = new News__c();
    news.Title__c = '*** News Title ***';
    news.Body_Text__c = '*** News Body ***';
    
    insert news;

    WEBNews controller;
    
    Test.startTest();
    controller = new WEBNews();

    system.assertEquals(1, controller.newsStories.size());
    system.assertNotEquals(null, controller.selectedStory);
    
    ApexPages.currentPage().getParameters().put('storyId', news.Id);
    controller = new WEBNews();
    system.assertNotEquals(null, controller.selectedStory);
    
    Test.stoptest();
  }
}