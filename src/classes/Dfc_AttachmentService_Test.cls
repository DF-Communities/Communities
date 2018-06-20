@IsTest 
class Dfc_AttachmentService_Test {
    
    @testSetup
    public static void setupData() {

        Dfc_DataFactory_Test.TestDataCreation(); 

    }
    
  @IsTest 
    static void testserveAttachment() {

        DFC_Community__c community= [select Id from DFC_Community__c c where c.Name__c = 'ACTIVE TEST COMMUNITY' LIMIT 1]; 

        DFC_Activity__c activity = [select Id from DFC_Activity__c a where a.Community__c = :community.Id LIMIT 1]; 
     
        System.debug('+++++++++ Activity ID  '+activity.Id);

        Attachment attachment = [Select Id from Attachment where ParentId =: activity.Id];
        // http://blog.jeffdouglas.com/2012/03/21/writing-unit-tests-for-v24-apex-rest-services/

        System.debug('Attachment Id : ' + attachment.id);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        // pass the req and resp objects to the method     
        req.requestURI = '/dfc/attachment';          
        req.httpMethod = 'GET';

        //Create and add the signed and encrypted payload with a date expiration
        String x = Dfc_Util.createSignedPayload(attachment.id);
        req.addParameter('id', x);

        RestContext.request = req;
        RestContext.response = res;

        Dfc_AttachmentService.serveAttachment();

  }

}