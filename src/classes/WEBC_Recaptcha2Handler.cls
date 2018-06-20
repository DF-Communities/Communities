/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : RecaptchaHandler. Version 2
 *  Author  : Gary Grant
 *  Date    : 16/02/2015
 *  Version : 1.0
 *
 *  Description:    Apex Class controller that backs the Recaptcha component
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class WEBC_Recaptcha2Handler {

	public WEBC_Recaptcha2Handler() {
		
	}

	public final static String MISSING_CAPTCHA_ERROR = 'You must prove you are a human';
	
	/* Original message : Captcha value is wrong: incorrect-captcha-sol - but changing to something nicer */
    public final static String RECAPTCHA_VALIDATION_FAILED = 'You must prove you are a human.';
    private final String DEFAULT_RECAPTCHA_BASE_URL = 'https://www.google.com/recaptcha/api/siteverify';

    public String secret {get; set;}    
    public String response {get;set;}         
      
    /* Whether the submission has passed reCAPTCHA validation or not */
    public Boolean verified { get; private set; }    

    public WEBC_Recaptcha2Handler(String secret, String response)
    {
    	
    	this.secret = secret;
    	this.response = response;    	    	   	       
        this.verified = false;
    }
    
    //reCAPTCHA code
    public boolean verify() {
    
       
        if ( secret == null || response == null ) { 
            return false; 
        }
                    
        HttpResponse r = makeRequest(DEFAULT_RECAPTCHA_BASE_URL,
            'secret=' + secret + 
            '&response=' + response
        );
               
        if ( r!= null ) {

        	system.debug('Recaptcha Response Body: ' + r.getBody());

        	RecaptchaResponse resp = (RecaptchaResponse) JSON.deserialize(r.getBody(), RecaptchaResponse.class);
        	system.debug('Recaptcha Response : ' + resp.success);
        	return resp.success;
            
        }        
        
        return false;
    }
    
    
    public String responseMessaage { 
    	
    	get { return (this.verified ? RECAPTCHA_VALIDATION_FAILED : ''); }     	
    	
    }
    
	private static HttpResponse makeRequest(string url, string body)  {
    
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
    
       if ( test.isRunningTest() ){
            
            response = new HTTPResponse();
            //response.setBody('{"success": false,"error-codes": ["invalid-input-response","invalid-input-secret"]}');
            response.setBody('{"success": true,"challenge_ts": "2016-02-29T20:08:33Z","hostname": "dfdev-dfdev.cs18.force.com"}');
    
        } else {
            
            try {
            
                Http http = new Http();
                response = http.send(req);
            
            } catch(System.Exception e) {
              
                System.debug('ERROR: ' + e);
            
            }   
        }
        
        return response;
    }     


private class RecaptchaResponse {

	public boolean success {get;set;}	

}


}