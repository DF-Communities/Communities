@isTest
class Dfc_UploadController_Test
{

	@testSetup
	static void setupData() {

		Dfc_DataFactory_Test.TestDataCreation();

	}

	@isTest
	static void itShould()
	{

	   DFC_Community__c community = [select Id from DFC_Community__c limit 1];

	   DFC_Activity__c activity = [select Id from DFC_Activity__c a where a.Title__c = 'Activity 1' limit 1];

	   PageReference pr = Page.dfc_apply;
       pr.getParameters().put('id', community.Id);
       Test.setCurrentPage(pr);

	   Dfc_UploadController ctl = new Dfc_UploadController();
	   Attachment att = ctl.attachment;
	   att.ParentId = activity.Id;
	   att.Name = 'Test.txt';

	   Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       att.Body = bodyBlob;

       ctl.upload();

       Dfc_UploadController.AttData[] atts = ctl.getAttachments();
       System.assertEquals(1, atts.size());

       Dfc_UploadController.removeAttachment(att.id);
       atts = ctl.getAttachments();
       System.assertEquals(0, atts.size());

       Dfc_UploadController.removeAttachment(att.id);

     } 

	@isTest
	static void itShould2()
	{
	   // Test that the attachment body is null which will be the case if the File Size exceed 25MB
	   Dfc_UploadController ctl = new Dfc_UploadController();


	   DFC_Activity__c activity = [select Id from DFC_Activity__c a where a.Title__c = 'Activity 1' limit 1];

	   Attachment att = ctl.attachment;
	   att.Name = 'Test.txt';
	   att.ParentId = activity.Id;	

	   DFC_Community__c community = [select Id from DFC_Community__c limit 1];

	   PageReference pr = Page.dfc_apply;
       pr.getParameters().put('id', community.Id);
       Test.setCurrentPage(pr);
        
       ctl.upload();

     } 




}