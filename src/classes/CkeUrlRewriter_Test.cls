/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_UrlRewriter
 *  Author  : Gary Grant
 *  Date    : 22-02-2016
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
public with sharing class CkeUrlRewriter_Test {

    @testSetup
    public static void setupdata()
    {

        Edt_Item__c item = new Edt_Item__c();
        item.Text1__c = 'pack';
        
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


	public CkeUrlRewriter_Test() {
		
	}
    
    @isTest
    static void testMapUrl() {

     
        system.debug('Entering re-writer test');
     
        CkeUrlRewriter rewriter = new CkeUrlRewriter();

        PageReference pr = new PageReference('/request-a-pack');         
        PageReference redirect = rewriter.mapRequestUrl(pr); 

        pr = new PageReference('/request-a-pack?a=b');         
        redirect = rewriter.mapRequestUrl(pr); 

        pr = new PageReference('/download-pack');
        redirect = rewriter.mapRequestUrl(pr);        

        pr = new PageReference('/download-pack?a=b');
        redirect = rewriter.mapRequestUrl(pr);        

        List<PageReference> lis = rewriter.generateUrlFor(new List<PageReference>());
       

    }



}