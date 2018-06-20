@isTest
class Dfc_SnippetServiceCtl_Test
{

   @testSetup
   static void setupData() {

        Dfc_DataFactory_Test.TestDataCreation();

    }

    @isTest
    static void itShould()
    {
        List<Page_Display_Snippet__c> pageDisplaySnippets = Dfc_SnippetServiceController.getSnippets('dfc_apply');
        
        String key = 'dfc-apply-submit-intro';
        List<Page_Snippet__c> lis = [select Id, Name, Body_Text__c from Page_Snippet__c where Unique_Name__c = :key];        
        
        Page_Snippet__c snippet = lis[0];
       
        
        snippet.Body_Text__c = 'Updated';
        
        Dfc_SnippetServiceController.updateSnippet(snippet);
        
        
    }
}