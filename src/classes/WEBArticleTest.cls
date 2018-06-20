/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBArticle.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex test class.
 *               
 *  Modification History
 *  Date            Who         Description 
 *                    
*******************************************************************************************/
@isTest(seeAllData=false)
public with sharing class WEBArticleTest {
	static testMethod void WEBArticleTest() {
		Page__c page = new Page__c();
		insert page;

		Section__c pageSection = new Section__c();
		pageSection.Page__c = page.Id;
		insert pageSection;

		Page_Snippet__c snippet = new Page_Snippet__c();
		snippet.Name__c = '*** Test Snippet ***';
		insert snippet;

		Page_Display_Snippet__c pageDisplaySnippet = new Page_Display_Snippet__c();
		pageDisplaySnippet.Page__c = page.Id;
		pageDisplaySnippet.Page_Snippet__c = snippet.Id;
		insert pageDisplaySnippet;
		
		Page__c page2 = new Page__c();
		page2.Unique_text__c = 'error-page';
		insert page2;
		
		

		WEBArticle controller;
    
	    Test.startTest();
	    controller = new WEBArticle();
	    ApexPages.currentPage().getParameters().put('pageName', page.Name);

	    system.assertNotEquals(null, controller.thisPage);
	    system.assertNotEquals(null, controller.pageSnippets);
	    system.assertNotEquals(null, controller.pageSections);
	    
	    controller = new WEBArticle();
	    ApexPages.currentPage().getParameters().put('pageName', null);
	     system.assertNotEquals(null, controller.thisPage);
	    system.assertNotEquals(null, controller.pageSnippets);
	    system.assertNotEquals(null, controller.pageSections);
	    
	    Test.stoptest();
	}
}