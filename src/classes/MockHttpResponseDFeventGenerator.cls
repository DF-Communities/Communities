@isTest
global class MockHttpResponseDFeventGenerator implements HttpCalloutMock {
   
    global HTTPResponse respond(HTTPRequest req) {
       
        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCt8-YgkPglTjv7i7hWe01-M3JUZF1VshM&address=560033&sensor=false');
        
        req.setMethod('GET');
        req.setTimeout(60000);
        System.assertEquals('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCt8-YgkPglTjv7i7hWe01-M3JUZF1VshM&address=560033&sensor=false', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setBody('{"location":"postcode"}');
        res.setBody('{"location" : {"lat" : 1.338581,"lng" : 103.690581}}');
        res.setStatusCode(200);
        return res;
    }
}