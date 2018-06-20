/* Single Class to Testing all the Edt Page Components */

@isTest
private class EdtPageContext_Test
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

		item.Group__c = 'grp-xxx';
		item.Key__c = 'key-xxx';

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

		// Check permission
		EdtEnableController ctl = new EdtEnableController();
		boolean b = ctl.getEditEnabled();

		EdtPageContext context = new EdtPageContext();

		Edt_Item__c item = context.readStore('grp-xxx','key-xxx');
		String s = context.generateId();

	}

	/* Video */
	@isTest
	static void itShould2()
	{

		// Check permission
		EdtEnableController ctl = new EdtEnableController();
		boolean b = ctl.getEditEnabled();

		EdtPageContext context = new EdtPageContext();
		Edt_Item__c item = context.readStore('grp-xxx','key-xxx');
		
		EdtVideoController ctlV = new EdtVideoController();
		ctlV.pageContext = context;

		String s = ctlV.getOptionString();
		s = ctlV.getCoverImageUrl();



	}

	/* Text */
	@isTest
	static void isShould3()
	{
	
		EdtPageContext context = new EdtPageContext();		
		EdtComponentController ctl = new EdtComponentController();

		ctl.pageContext = context;

		ctl.itemGroup = 'grp-xxx';
		ctl.itemKey = 'key-xxx';
		ctl.checkStore();	

		String s = ctl.itemText1;
		s = ctl.itemText2;
		s = ctl.itemText3;
		s = ctl.itemValue1;
		s = ctl.itemValue2;
		s = ctl.itemValue3;
		s = ctl.itemValue4;
		s = ctl.itemValue5;
		s = ctl.itemValue6;
		s = ctl.htmlClass;
		s = ctl.htmlStyle;

		s = ctl.getItemId();
		Attachment att = ctl.getAttachment();

	}



	/* Download Controller */
	@isTest
	static void isShould4()
	{

		PageReference pr = Page.Edt_Download;
		Test.setCurrentPage(pr);
		ApexPages.currentPage().getParameters().put('group', 'grp-xxx');
        ApexPages.currentPage().getParameters().put('key', 'key-xxx');

		EdtDownloadController ctl = new EdtDownloadController();
		PageReference redirect = ctl.getRedirect('key-xxx', 'grp-xxx');
		redirect = ctl.doRedirect();

	}

	/* Download Controller Error*/
	@isTest
	static void isShould5()
	{

		PageReference pr = Page.Edt_Download;
		Test.setCurrentPage(pr);
		ApexPages.currentPage().getParameters().put('group', 'grp-yyy');
        ApexPages.currentPage().getParameters().put('key', 'key-xxx');

		EdtDownloadController ctl = new EdtDownloadController();
		PageReference redirect = ctl.getRedirect('key-xxx', 'grp-yyy');
		redirect = ctl.doRedirect();

	}

	@isTest
	static void isShould6()
	{
        Edt_Item__c ei1 = new Edt_Item__c(Group__c='gdpr', Key__c='contact-preferences',Text1__c='test');
        insert ei1;
        Edt_Item__c ei2 = new Edt_Item__c(Group__c='gdpr', Key__c='connection-to-dementia',Text1__c='test');
        insert ei2;
        Edt_Item__c ei3 = new Edt_Item__c(Group__c='gdpr', Key__c='company',Text1__c='test');
        insert ei3;
        
        Community_Settings__c cs1 = new Community_Settings__c(Name='CKE_Pack_Progress_Id', Value__c='asdfasdf');
        insert cs1;
        Community_Settings__c cs2 = new Community_Settings__c(Name='Cke_Captcha_Site', Value__c='asdfasdf');
        insert cs2;
        Community_Settings__c cs3 = new Community_Settings__c(Name='Cke_Captcha_Secret', Value__c='asdfasdf');
        insert cs3;

		PageReference pr = Page.Cke_Home;
		Test.setCurrentPage(pr);

		EdtPageController ctl = new EdtPageController();
		EdtPageContext context = ctl.edtContext;


		Edt_Item__c item = [select id from Edt_Item__c limit 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(item);
		ctl = new EdtPageController(sc);
		
	}



}