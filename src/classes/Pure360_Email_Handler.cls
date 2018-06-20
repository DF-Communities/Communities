public virtual class Pure360_Email_Handler {
    
    
    public Pure360_Email_Handler() {
        
    }
    
    public static final string ENDPOINT = 'https://response.pure360.com/interface/common/one2OneCreate.php';
    
    public virtual String getUserName() {
        
        return '';
    }
    
    public virtual String getPassword() {
        
        return '';
    }
    
    public String bodyBase {
        get { 
            
            String body = 'userName=';
            body += getUserName();
            
            body +='&password=';
            body += getPassword();
            
            body +='&message_contentType=EMAIL';
            body +='&message_SYS_dataPolicy=discard';
            
            return body;
            
        }
        
        set;
        
    }
    
    public String message {get;set;}
    
    public boolean doRequest(String body){
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setEndpoint(ENDPOINT);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        
        Http h = new Http();
        HttpResponse res;
        
        if ( Test.isRunningTest() ) { 
            
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/text');
            res.setBody('Error');     
            res.setStatusCode(200);
            
        } else {      
            
            res = h.send(req);
        }
        
        message = 'OK';
        if (res.getStatusCode()!=200 || res.getBody().left(5) == 'Error') {
            
            message = (res.getStatusCode()!=200 ? 'Error : ' : '' );
            message += (res.getBody() == null ? res.getStatus() : res.getBody());
            
            System.debug('Request failed ('+res.getStatusCode()+'):' + message);
            
        } 
        
        return (message == 'OK');        
        
    }
    
    /*
* This method is used to allow emails to be send from a record trigger
*/
    @future(callout=true)
    public static void doRequestFromTrigger(String body){
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setEndpoint(ENDPOINT);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        
        Http h = new Http();
        HttpResponse res;
        
        if ( Test.isRunningTest() ) { 
            
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/text');
            res.setBody('Error');     
            res.setStatusCode(200);
            
        } else {      
            
            res = h.send(req);
        }
        
        String message = 'OK';
        if (res.getStatusCode()!=200 || res.getBody().left(5) == 'Error') {
            
            message = (res.getStatusCode()!=200 ? 'Error : ' : '' );
            message += (res.getBody() == null ? res.getStatus() : res.getBody());
            
            System.debug('Request failed ('+res.getStatusCode()+'):' + message);
            
        } 
        
        System.debug('Pure360 email was triggered from the API with body response: ' + res.getBody()); 
        System.debug('The request payload was: ' + JSON.serialize(body));
        
    }
    
    
}