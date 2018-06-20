public without sharing class Dfc_SnippetServiceController {
    
    @AuraEnabled
    public static List<Page_Display_Snippet__c>  getSnippets(String pageName) {
    
    return [select Page_Snippet__r.Unique_Name__c, Page_Snippet__r.Title__c, Page_Snippet__r.Body_Text__c, Page_Snippet__c, Page_Snippet__r.Link_Title__c, Page_Snippet__r.Link_Url__c 
                from Page_Display_Snippet__c 
                where Page__r.Unique_text__c = :pageName ];
  	} 

  	@AuraEnabled
    public static Object updateSnippet(Page_Snippet__c snippet) 
    {
        try {
            return Dfc_Util.updateSnippet(snippet);
        }
        catch(Exception e) {
            return new Dfc_ErrorResponse(e);
        }
    }     

}