/* 

Redirect to an attachment on an Editable Item 
Gary Grant
May 2016	

*/

public without sharing class EdtDownloadController {

	public String keyParam {get;set;}
	public String grpParam {get;set;}

	public EdtDownloadController() {
		
	}

	public PageReference doRedirect() {

		keyParam = ApexPages.currentPage().getParameters().get('key');
		grpParam = ApexPages.currentPage().getParameters().get('group');
		return getRedirect(keyParam, grpParam);

	}

	public PageReference getRedirect(String key, String grp) {

		try { 
	
			Edt_Item__c item = [select id, (select id, ContentType from Attachments limit 1) from Edt_item__c where Group__c =:grp and Key__c=:key];
			Attachment att = item.Attachments[0];
			return new PageReference('/servlet/servlet.FileDownload?file=' + att.id);

		} catch (Exception x) {

			return null;

		}	

	}

}