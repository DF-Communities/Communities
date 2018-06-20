@isTest
private class CkeDownloadController_Test
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
	static void itShould()
	{

		PageReference pr = Page.Cke_Download;
		Test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('key', 'pack');

		CkeDownloadController ctl = new CkeDownloadController();
		PageReference redirect = ctl.go();

	}


}