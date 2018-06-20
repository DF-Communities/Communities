@isTest
private class DF_RegionPostcode_TriggerHandler_Test
{
    @isTest
    static void doTest()
    {
        List< DF_Region_Postcode__c > lis = new List< DF_Region_Postcode__c>();
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Region_Postcode__c rp = (DF_Region_Postcode__c)mapTestData.get('RegionPostcode');    
        lis.add(rp);
        DF_Region_Postcode_TriggerHandler handler = new DF_Region_Postcode_TriggerHandler();
        handler.OnAfterInsert(lis);
        //TODO! - add asserts
    }
}