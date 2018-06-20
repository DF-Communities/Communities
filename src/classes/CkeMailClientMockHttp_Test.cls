@isTest
global class CkeMailClientMockHttp_Test implements HttpCalloutMock {

    public CkeMailClientMockHttp_Test() {
        
    }
    
    global HTTPResponse respond(HTTPRequest req) {
       
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<xml>some response</xml>');
        res.setStatusCode(200);
        return res;

    }


}