public with sharing class Dfc_SnippetStoreController {
    
   
    @AuraEnabled
    public static Object readSnippet(String key) 
    {
      try{
        return Dfc_Util.readSnippet(key);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
      
    @AuraEnabled
    public static Object updateSnippet(Page_Snippet__c snippet) 
    {
      try{
        return Dfc_Util.updateSnippet(snippet);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }

   
}