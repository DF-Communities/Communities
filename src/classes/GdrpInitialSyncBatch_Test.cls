@isTest
private class GdrpInitialSyncBatch_Test {
    
    private static testmethod void coverageOnly(){

		DF_DataFactory_Test.getTestData();  
 		Id rtId = [SELECT Id FROM RecordType WHERE Name='Dementia Friend' AND SobjectType='Contact'].Id;
        Id orgId = [SELECT Id FROM Account LIMIT 1].Id;
        
		Contact c = new Contact(LastName='Test',RecordTypeId=rtId, AccountId = orgId);
        Database.SaveResult dsr = Database.insert(c, true);
        
        Test.startTest();

        GdrpInitialSyncBatch batch = new GdrpInitialSyncBatch();
        Database.executeBatch(batch);
        
        Test.stopTest();

        
    }

}