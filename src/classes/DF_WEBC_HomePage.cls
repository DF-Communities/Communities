public class DF_WEBC_HomePage extends DF_WEBC_ControllerBase {

    public News_Flash__c newsFlash {
    
        get {
            if (newsFlash == null){
                List<News_Flash__c> nfList = new List<News_Flash__c>();
                nfList = [Select n.Main_Body__c, n.IsActive__c, n.Date_to_be_published__c From News_Flash__c n where n.IsActive__c = true ORDER BY n.Date_to_be_published__c DESC LIMIT 1];
                if (nfList.size() > 0){
                    newsFlash = nfList[0];
                }else {
                    newsFlash = new News_Flash__c();
                }
            }
            
            return newsFlash;
        }
    
        set;
    
    }
    
    public List<DF_WEBC_HomePage.Slide> slides {
    	
    	get { 
    		
    		List<Slide> lis = new List<Slide>();
    		
    		List<Page_Display_Snippet__c> lisSnippets = 
    		
    				[select Page_Snippet__r.Title__c, Page_Snippet__r.Body_Text__c, Page_Snippet__c, Page_Snippet__r.Link_Title__c, Page_Snippet__r.Link_Url__c from Page_Display_Snippet__c 
    						where Page__r.Unique_text__c = 'Home_Page' and Page_Snippet__r.Position__c = 'slide'];
    		
    		for (Page_Display_Snippet__c pds : lisSnippets) {    		
    			Slide slide = new Slide(pds);
    			lis.add(slide);    			
    		}
    		
    		return lis;
    	}
    	
    	
    	set;}
    
    public class Slide
    {
    	
    	public String fileId {get;set;}
    	public String title {get;set;}
    	public String body {get;set;}
        public String link_title {get;set;}
        public String link_url {get;set;}
    	
    	public slide(Page_Display_Snippet__c pds) {
    		
    		title = pds.Page_Snippet__r.Title__c;
    		body = pds.Page_Snippet__r.Body_Text__c;

            link_title = pds.Page_Snippet__r.Link_Title__c;
            link_url = pds.Page_Snippet__r.Link_Url__c;
    		
            List<Attachment> attachedFiles = [select Id from Attachment where parentId =:pds.Page_Snippet__c limit 1];
        	if( attachedFiles != null && attachedFiles.size() > 0 ) {
            	fileId = attachedFiles[0].Id;
        	}
    		
    	}
    	
    	public slide() {
    		
    	}
    	
    }
    
    
}