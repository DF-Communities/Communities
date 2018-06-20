public without sharing class DFC_PageSnippetController {
  public string pageName {get;set;}
  public string key {get;set;}
    
    public  Page_Display_Snippet__c getSnippets() {
    List<Page_Display_Snippet__c>  ps = new List<Page_Display_Snippet__c>();

    ps= [select Page_Snippet__r.Unique_Name__c, Page_Snippet__r.Title__c, Page_Snippet__r.Body_Text__c, Page_Snippet__c, Page_Snippet__r.Link_Title__c, Page_Snippet__r.Link_Url__c 
                from Page_Display_Snippet__c 
                where Page__r.Unique_text__c = :pageName 
                and Page_Snippet__r.Unique_Name__c= :key]; 
                system.debug('pagesnippet'+ps+'@@'+pageName+'@@'+key+'@@');
    
    return ps!=null?ps[0]:null;

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