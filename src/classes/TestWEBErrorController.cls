/**
 * 2014-08-19 : CSL : Test class for the WEBErrorController
 */
@isTest
private class TestWEBErrorController {

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

    static testMethod void testGetReferer() {
        ApexPages.currentPage().getHeaders().put('Referer', bigString);
        System.assertEquals(baseString, WEBErrorController.getReferer());

        ApexPages.currentPage().getHeaders().put('Referer', notABigString);
        System.assertEquals(notABigString, WEBErrorController.getReferer());
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
            System.assert(errorRecords.size() > 0);
            WEBError_Record__c errorrecord = errorRecords[0];
            List<WEBError_Record_Detail__c> errorChildRecords = getErrorChildRecords(errorrecord.Id);
            System.assertEquals(5, errorChildRecords.size());
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