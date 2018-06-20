@RestResource(urlMapping='/cupcake-downloads/*')
global without sharing class CkeDownloadHandler {
    
   @HttpGet
    global static void serveAttachment() 
    {

        System.debug('Fetching download pack');

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String key = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String grp = 'cke-downloads';

        try {
                Edt_Item__c item = [select id, (select id 
                            from Attachments limit 1) from Edt_Item__c 
                            where Group__c =:grp and Key__c=:key];

                Attachment att = item.Attachments[0];   
                Attachment a = [select id, ContentType, Name, Body from Attachment where id=:att.id];                     
        
                res.addHeader('Content-Type', a.ContentType);
                res.addHeader('Content-disposition','inline; filename="' +  a.Name + '"'); 
                res.responseBody = a.Body;

        } catch (Exception x) {

            SysApiUtils.sendError(x);

        }
    

    }


}