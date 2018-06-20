@isTest
private class DF_DFCAddressUpdatePCA_Batcher_Test{
    
    static testmethod void doTest1()
    {
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');  
        dfc.Postcode__c=' N16 8AZ';
        Test.startTest();
        update dfc;
    }
    
    static testmethod void doTest2()
    {
        DF_DFCAddressUpdatePCA_Batcher dfpca = new DF_DFCAddressUpdatePCA_Batcher();
        Database.executeBatch(dfpca,4);
    }
    
}