@isTest
private class DF_EventAddressUpdatePCA_Batcher_Test{
    
    static testmethod void doTest1()
    {
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Event__c dfe = (DF_Event__c)mapTestData.get('ChampCourse');  
        dfe.Postcode__c=' N16 8AZ';
        Test.startTest();
        update dfe;
    }
    
    static testmethod void doTest2()
    {
        DF_EventAddressUpdatePCA_Batcher dfepca = new DF_EventAddressUpdatePCA_Batcher();
        Database.executeBatch(dfepca,4);
    }
    
}