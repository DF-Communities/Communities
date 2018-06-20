/* Serves an attachment based on id in query string parameter 
    may be the id of an activity attachment
*/
@RestResource(urlMapping='/dfc/attachment')
global without sharing class Dfc_AttachmentService
{
   @HttpGet
    global static void serveAttachment() 
    {

        RestResponse res = RestContext.response;

        String data = RestContext.request.params.get('id');
        
        String attid = Dfc_Util.extractSignedPayload(data);

        Attachment att = [select ParentId, ContentType, Body from attachment where id = :attid];
        
        res.addHeader('Content-Type', att.ContentType); 
        res.responseBody = att.Body;
    }
    
}