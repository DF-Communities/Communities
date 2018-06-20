/**
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
global class DF_Pure360_HttpMockResponse implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {

        // Optionally, only send a mock response for a specific endpoint

        // and method.

        System.assertEquals('https://response.pure360.com/interface/list.php?accName=webD.sys&listName=Welcome+Email&doubleOptin=FALSE&successUrl=NO-REDIRECT&errorUrl=NO-REDIRECT', req.getEndpoint());

        System.assertEquals('POST', req.getMethod());

         

        // Create a fake response

        HttpResponse res = new HttpResponse();

        res.setHeader('Content-Type', 'application/json');

        res.setBody('&dff');
      
        res.setStatusCode(200);

        return res;

            
    }
}