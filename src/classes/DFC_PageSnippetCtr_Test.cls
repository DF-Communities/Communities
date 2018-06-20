@isTest
private class DFC_PageSnippetCtr_Test {
    
    @testSetup
   static void setupData() {

        Dfc_DataFactory_Test.TestDataCreation();

    }

    @isTest
    static void itShould()
    {
    
        DFC_PageSnippetController controller = new DFC_PageSnippetController();
        controller.key = 'dfc-apply-submit-intro';
        controller.pageName = 'dfc_apply';
        Page_Display_Snippet__c pageDisplaySnippets = controller.getSnippets();
        
        
        List<Page_Snippet__c> lis = [select Id, Name, Body_Text__c from Page_Snippet__c where Unique_Name__c = :controller.key];        
        
        Page_Snippet__c snippet = lis[0];
       
        
        snippet.Body_Text__c = 'Updated';
        
        DFC_PageSnippetController.updateSnippet(snippet);
        
        
    }
}