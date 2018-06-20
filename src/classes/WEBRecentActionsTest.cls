@isTest
private class WEBRecentActionsTest{

  static testmethod void covermethod(){
  
  Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        DF_Contact__c u  = (DF_Contact__c)mapTestData.get('Dfc');
        Action__c a = (Action__c)mapTestData.get('Action');
        a.Public__c = true;
        
        update a;
        
   test.starttest();
   WEBRecentActions controller = new WEBRecentActions();
   
  }



}