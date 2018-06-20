/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Batch APEX Class to to delete weberror records that are older than 30 days.
 *  Author  : Mike Tinson
 *  Date    : 25-06-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Batch APEX Class to delete weberror records that are older than 30 days.
 *                  
 *
 *        //Called via the Execute Anonymous window. 
 *        BatchPurgeWeberror webErrBatch = new BatchPurgeWeberror ();
 *        webErrBatch.query = 'Select name, id from weberror_record__c where owner.name='Mike Tinson' and name >='WE-16122014-3002' and name < 'WE-16122014-3010';
 *        //Invoke the Batch class.
 *        ID batchprocessid = Database.executeBatch(webErrBatch, 20);
 *                  
 *  Modification History
 *  Date            Who         Description 
 *                     
*******************************************************************************************/

@isTest
private class TestBatchPurgeWeberror {

    private static final String notABigString = 'http://referer.com/page';
    private static final String baseString = 'Cnt8OecqyEVMLv6jy2mD0x2u7PZ4xdBqIX5YUTJyHGuaF06uSMExQqTuc3eYNReUWbb3DMeDxD6tsYQgiN0iLeivrqxA6Jsb0XMi217Ib7b0MuO05dnLYDcLOv7elPHfbFmYgUZiNKUoQdw5jKe4lOMhs1lZCZad2RECftFayK28gff8mwtVBdICl6zIv6kf1UwmGGdSquJ9qK29FMZCdnbbWvKQK3K3CkoDmyKk1qJFKF8w';
    private static final String bigString = baseString + 'Fmic';

    static testMethod void testConstructor() {
        createTestData();
        Test.startTest();
            PageReference testPage = Page.WEBErrorPage;
            Test.setCurrentPage(testPage);
            WEBErrorController ctrl = new WEBErrorController();
        Test.stopTest();
        System.assertNotEquals(null, ctrl);
    }

    static testMethod void testRecordErrors() {
        createTestData();
        Test.startTest();
            PageReference testPage = Page.WebErrorAuth;
            Test.setCurrentPage(testPage);
            WEBErrorController ctrl = new WEBErrorController();
            ctrl.recordErrorAuth();
            ctrl.recordErrorPageNotFound();
            ctrl.recordErrorMaintenance();
            ctrl.recordErrorLimitExceeded();
            ctrl.recordError();
            List<WEBError_Record__c> errorRecords = getErrorRecords();
            //Build batch 
            BatchPurgeWeberror webErrBatch = new BatchPurgeWeberror ();
            webErrBatch.query = 'Select name, id from weberror_record__c where id=' + '\''+ errorRecords[0].id +'\'';
            //Invoke the Batch class.
            ID batchprocessid = Database.executeBatch(webErrBatch, 4);
            Test.stopTest();
    }

    static void createTestData() {
        Global_Setting__c gsLogErrors = new Global_Setting__c();
        gsLogErrors.Name = 'LogWEBErrors';
        gsLogErrors.Value__c = 'TRUE';
        insert gsLogErrors;
    }

    static List<WEBError_Record__c> getErrorRecords() {
        List<WEBError_Record__c> records = [SELECT Id FROM WEBError_Record__c LIMIT 1];
        return records;
    }

    static List<WEBError_Record_Detail__c> getErrorChildRecords(Id parentId) {
        List<WEBError_Record_Detail__c> records = [select w.Id from WEBError_Record_Detail__c w WHERE w.WEBError_Record__c = :parentId];
        return records;
    }
}