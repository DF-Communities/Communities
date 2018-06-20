/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBArticle.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class loads Page Content, Snippets and Sections for Website content.
 *               
 *  Modification History
 *  Date            Who         Description 
 *  27-02-2014      SM     Updated SOQL Call to only look at 'Active' page sections                  
*******************************************************************************************/
public without sharing class WEBArticle {
	public static final String PARAM_PageId = 'pageId'; // Salesforce Id
	public static final String PARAM_Page = 'page'; // some-unique-name from Unique field
	public static final String PARAM_PageName = 'pageName'; // P-0000
	public static final String PAGE_Error_Page = 'error-page'; // Error page if no article found

	Public Page__c thisPage {
		get {
			if (thisPage == null) {
				thisPage = new Page__c();
				thisPage.Title__c = 'ERROR : PAGE NOT FOUND';
			}
			return thisPage;
		}
		private set;
	}

	Public List<Section__c> pageSections {
		get {
			if (pageSections == null)
				pageSections = new List<Section__c>();
			return pageSections;
		}
		private set;
	}

	Public List<Page_Display_Snippet__c> pageSnippets {
		get {
			if (pageSnippets == null)
				pageSnippets = new List<Page_Display_Snippet__c>();
			return pageSnippets;
		}
		private set;
	}

	public WEBArticle() {
		String pageId = ApexPages.currentPage().getParameters().get(PARAM_PageId);
		String page = ApexPages.currentPage().getParameters().get(PARAM_Page);
		String pageName = ApexPages.currentPage().getParameters().get(PARAM_PageName);

		if (page == null)
			page = '%';

		if (pageName == null)
			pageName = '%';
		
		List<Page__c> pages = [SELECT Show_Menu__c, Use_Breadcrumb__c, Active_Menu__c, Bottom_Link_List__c,Date_Published__c,Id,IsPublished__c,Name,Parent_Page__c, Parent_Page__r.Title__c, Parent_Page__r.Unique_text__c,SEO_Description__c,SEO_Keywords__c,Title__c,Unique_text__c FROM Page__c WHERE Name LIKE :pageName AND Unique_text__c LIKE :page LIMIT 1];

		if ((pages != null) && (!pages.isEmpty())) {
			thisPage = pages[0];
			
			system.debug('*** -- Active Menu = ' + thisPage.Active_Menu__c + ' -- ***');
			system.debug('WEBArticle : Page id ' + thisPage.id);

			pageSections = [SELECT Body_Text__c,Display_Order__c,Heading__c,Intro_Paragraph__c,IsActive__c,Link_Title__c,Link_URL__c,Name,Page__c FROM Section__c WHERE Page__c = :thisPage.Id and IsActive__c = true ORDER BY Display_Order__c];

			system.debug('WEBArticle : Page Sections ' + pageSections.size());

			pageSnippets = [SELECT Name,Page_Snippet__r.Name__c, Page_Snippet__r.CSS_Class__c, Page_Snippet__r.Body_Text__c, Display_Order__c, Page_Snippet__r.Link_Title__c, Page_Snippet__r.Link_URL__c FROM Page_Display_Snippet__c WHERE Page__c = :thisPage.Id ORDER BY Display_Order__c];

			system.debug('WEBArticle : Page Snippets ' + pageSnippets.size());


		} else {
			system.debug('*** -- Into error handling -- ***');
			//Error Handling
			pages = [Select p.Use_Breadcrumb__c, p.Unique_text__c, p.Title__c, p.Name, p.IsPublished__c, p.Id, p.Active_Menu__c, 
					(Select Name, Heading__c, Intro_Paragraph__c, Body_Text__c, Display_Order__c, Link_Title__c, Link_URL__c, IsActive__c, 
					Page__c From Sections__r) From Page__c p where p.Unique_text__c = :PAGE_Error_Page LIMIT 1];
					
			pageSections = pages[0].Sections__r;
		}
	}
	
}