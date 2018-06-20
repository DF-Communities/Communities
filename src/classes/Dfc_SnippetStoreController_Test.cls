@isTest
class Dfc_SnippetStoreController_Test
{

  @testSetup
  static void setupData() {

    Dfc_DataFactory_Test.TestDataCreation();

  }

  @isTest
  static void itShould()
  {
  
    String s =  (String) Dfc_SnippetStoreController.readSnippet('dfc-apply-submit-intro');
 
    List<Page_Snippet__c> lis = [select Id, Name, Body_Text__c from Page_Snippet__c where Unique_Name__c = 'dfc-apply-submit-intro'];        
    Page_Snippet__c snippet1 = lis[0];

    snippet1.Body_Text__c= 'updated';
    Object o = Dfc_SnippetStoreController.updateSnippet(snippet1);

    Object p;

    //Dfc_ErrorResponse e = (Dfc_ErrorResponse)Dfc_SnippetStoreController.readSnippet('null');
    Dfc_ErrorResponse e = (Dfc_ErrorResponse)Dfc_SnippetStoreController.updateSnippet(new Page_Snippet__c());

  }

  
}