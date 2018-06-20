@isTest
private class CkeDownloadHandler_Test
{

    @testSetup
    public static void setupData() {

        Edt_Item__c item = new Edt_Item__c();
        item.Text1__c = 'xxx';
        item.Text2__c = 'xxx';
        item.Text3__c = 'xxx';

        item.Value1__c = 'xxx';
        item.Value2__c = 'xxx';
        item.Value3__c = 'xxx';
        item.Value4__c = 'xxx';
        item.Value5__c = 'xxx';
        item.Value6__c = 'xxx';

        item.Group__c = 'cke-downloads';
        item.Key__c = 'pack';

        insert item;

        Attachment attach=new Attachment();

        attach.Name='Unit Test Attachment ';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.Body=bodyBlob;
        attach.ParentId=item.id;
        attach.ContentType = 'application/msword';
        attach.IsPrivate = false;
        attach.Description = 'Test';

        insert attach;
        
    }

    @isTest
    static void doTest() {
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/cupcake-download/pack';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        CkeDownloadHandler.serveAttachment();        

    }


    @isTest
    static void doTest2() {
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/cupcake-download/book';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        CkeDownloadHandler.serveAttachment();        

    }


}