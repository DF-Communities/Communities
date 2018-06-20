public class WEBSitemapController {

    public List<PageWrapper> getPageList() {
        List<Page__c> pages = [Select p.LastModifiedDate, p.Unique_text__c, p.Title__c, p.SEO_Keywords__c, p.SEO_Description__c, p.Name, p.Id From Page__c p Order By Unique_Text__c LIMIT 1000];
        List<PageWrapper> pageList = new List<PageWrapper>();
        for (Page__c p : pages){
        	pageList.add(new PageWrapper(p));
        }
    
        return pageList;
    }
    
    public List<NewsWrapper> getNewsList(){
    	List<News__c> newsStories = [Select n.LastModifiedDate, n.Unique_text__c, n.Id From News__c n Order By n.Unique_Text__c LIMIT 1000];
    	List<NewsWrapper> newsList = new List<NewsWrapper>();
    	for (News__c n : newsStories){
    		newsList.add(new NewsWrapper(n));
    	}
    	
    	return newsList;
    }
    
    @isTest(SeeAllData=false)
    private static void test_pageList() {
    
        //Site_Page__c sp = new Site_Page__c();
        //sp.Name = '*** TEST ***';
        //sp.Title__c = '*** TEST ***';
        //sp.Page_Id__c = '***TEST***';
        //insert sp;
        
        News__c news = new News__c();
        news.Title__c = 'Test news';
        news.Body_Text__c = 'Test Body';
        news.Unique_Text__c = 'testnews';
        insert news;
        
        Page__c page = new Page__c();
        page.Title__c = 'Test Page';
        page.Unique_text__c = 'testpage';
        insert page;
        
        Test.startTest();
        WebSitemapController controller = new WEBSitemapController();
        
        List<WEBSitemapController.PageWrapper> pl = controller.getPageList();
        List<WEBSitemapController.NewsWrapper> nl = controller.getNewsList();

        system.assertEquals(1, pl.size());
        
        Test.stoptest();   
    }
   
   public class NewsWrapper {
   	public News__c theNews {get; set;}
   	public String newsURL {get; set;}
   	
   	public NewsWrapper(News__c n){
   		theNews = n;
   		newsURL = 'http://dfdevpro-asdf.cs17.force.com/WEBNewsStory?storyId=' + n.Unique_Text__c;
   	}
   }
   
   public class PageWrapper {
   	public Page__c thePage {get; set;}
   	public String pageURL {get; set;}
   	
   	public PageWrapper(Page__c p){
   		thePage = p;
   		pageURL = 'http://dfdevpro-asdf.cs17.force.com/WEBArticle?page=' + p.Unique_Text__c;
   	}
   	
   }
   
}