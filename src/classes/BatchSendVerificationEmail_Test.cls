@isTest
private class BatchSendVerificationEmail_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        DF_Contact__c dfc = (DF_Contact__c )mapTestData.get('Champion');
        dfc.isVerifyEmailNotSent__c = true;
        update dfc;
        BatchSendVerificationEmail batch = new BatchSendVerificationEmail();
        test.starttest();
        Database.executeBatch( batch, 1 ); 
    }
}