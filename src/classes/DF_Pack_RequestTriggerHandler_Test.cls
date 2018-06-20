@isTest
private class DF_Pack_RequestTriggerHandler_Test
{
   
    static testmethod void doTest()
    {
        List< DF_Pack_Request__c > lis = new List< DF_Pack_Request__c>();
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Pack_Request__c pack = (DF_Pack_Request__c)mapTestData.get('Pack');    
        lis.add(pack);
        DF_Pack_RequestTriggerHandler handler = new DF_Pack_RequestTriggerHandler(Trigger.isExecuting, Trigger.size);
        test.starttest();
        handler.OnBeforeInsert(lis,null);
        system.assertEquals(pack.Street__c ,'test street');
        test.stoptest();
    }
}