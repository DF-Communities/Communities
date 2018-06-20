@isTest
private class DF_ActionTriggerHandler_Test
{


  @isTest
  static void coverMethod()
  {
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    Action__c action  = (Action__c)mapTestData.get('Action');
    DF_Contact__c Dfc  = (DF_Contact__c)mapTestData.get('DFc');
    test.starttest();  
    
     update action;
    Action__c act = new Action__c();
    act.DF_Contact__c = Dfc.id;
    act.Standard_Actions__c='Campaign for change';
    insert act;

    
    }

 
}