public with sharing class WEBNews extends DF_WEBC_ControllerBase {
   
    public List<News__c> newsStories {
        get {
            if (newsStories == null) {
                newsStories = new List<News__c>();
            }

            return newsStories;
        }
        private set;
    }
    public String imageId {get; set;}
    public Integer pageSize{get;set;}
    public Integer noOfPages{get;set;}
    public Integer pageNumber{get;set;}
    private String baseQuery = 'SELECT Body_Text__c,Id,Promote_On_Homepage__c,Publish_Date__c,Title__c,Unique_Text__c FROM News__c WHERE Publish_Date__c <= today ORDER BY Publish_Date__c Desc';
    private Integer totalNoOfRecs;
       
    
    public WEBNews(){
      
      String storyId = ApexPages.currentPage().getParameters().get('storyId');

      
      pageSize = 10;
        noOfRecords = [select count() from News__c limit 50000 ];
       
      
      
      if ((storyId != null) && (storyId.length() > 0)){
            newsStories = [SELECT Body_Text__c,Id,Promote_On_Homepage__c,Publish_Date__c,Title__c,Unique_Text__c, (Select Id, Name, BodyLength From Attachments) FROM News__c WHERE Id = :storyId];
      }
      else{
        
      newsStories = Database.query(baseQuery + ' limit 10');
      
      }
        
      if (newsStories.size() > 0){
            selectedStory = newsStories[0];
            if (selectedStory.Attachments.size() > 0){
              imageId = selectedStory.Attachments[0].Id;
            }
      }
    }
    
     
    public Integer noOfRecords {get;set;}
        
    public Integer recordsPerPage {
        get {
            if (recordsPerPage == null)
                recordsPerPage = 10;
            return recordsPerPage;
        }
        set;
    }
    public Integer startRecord {
        get {
            if (startRecord == null)
                startRecord = 0;
            return startRecord;
        }
        set;
    }
    public PageReference nextPage() {
        startRecord += recordsPerPage;
        if (startRecord > noOfRecords)
            startRecord = startRecord - recordsPerPage;
       queryNews();
        return null;
    }
    public PageReference previousPage() {
        startRecord = startRecord - recordsPerPage;
        if (startRecord < 0)
            startRecord = 0;
         queryNews();
        return null;
    }  
    public PageReference changeRecordsPerPage() {
        startRecord = 0;
        queryNews();
        return null;//applyFilter();
    }
  
    
    public News__c selectedStory {
        get {
            if (selectedStory == null) {
                selectedStory = new News__c();
            }

            return selectedStory;
        }
        private set;
    }
    
  
    
    private void queryNews()
    {
             
        
        String query = baseQuery + ' limit '+ recordsPerPage + ' OFFSET ' + startRecord;
        System.debug('Query is'+query);
       
       try{
      
          newsStories = Database.query(query);  
          
         }
          catch(Exception e){
            ApexPages.addMessages(e);
        }
    }
}