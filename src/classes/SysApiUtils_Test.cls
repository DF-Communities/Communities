@isTest
private class SysApiUtils_Test
{
    @isTest
    static void itShould()
    {
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/xx';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;

        SysApiUtils.setCache('100');
        SysApiUtils.setNoCache();
        SysApiUtils.setShortCache();
        SysApiUtils.setLongCache();

        Object o = '{stuff:stuff}';
        SysApiUtils.sendJson(o);

        SysApiUtils.sendText('xx');
        
        HttpResponse resp = new HttpResponse();
        resp.setBody('xxx');
        resp.setStatusCode(200);
        SysException ex = new SysException('Error', resp);

        try {

            integer i = 1/0; 

        } catch ( Exception x) {

            SysApiUtils.sendError(x);

        }
    }

}