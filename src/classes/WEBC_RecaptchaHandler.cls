/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : RecaptchaHandler. Used in combination with the Recaptcha Component
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
public without sharing class WEBC_RecaptchaHandler {

	public final static String MISSING_CAPTCHA_ERROR = 'Missing reCAPTCHA input';
	
	/* Original message : Captcha value is wrong: incorrect-captcha-sol - but changing to something nicer */
    public final static String RECAPTCHA_VALIDATION_FAILED = 'You have not typed in the validation characters correctly.';
    private final String DEFAULT_RECAPTCHA_BASE_URL = 'https://www.google.com/recaptcha/api/verify';
    private final String DEFAULT_RECAPTCHA_PRIVATE_KEY = '6Lc-wO4SAAAAACD6-YESZ_7gtgeJdGmuc4NG8gwg';
    private final String DEFAULT_RECAPTCHA_PUBLIC_KEY = '6Lc-wO4SAAAAAExvZIBvdvhgKVyjbprSn9Ygwkwb';

	/*
       The API endpoint for the reCAPTCHA service
       private static String baseUrl = 'https://www.google.com/recaptcha/api/verify';    
    */
    public String baseURL {get; set;}
    
    /* The keys you get by signing up for reCAPTCHA for your domain
       private static String privateKey = '6Lc-wO4SAAAAACD6-YESZ_7gtgeJdGmuc4NG8gwg';
    */    
    public String privateKey {get; set;}    
    public String publicKey {get; set;}
 
    public String challenge {get; set;}     
    public String response {get;set;}         
      
    /* Whether the submission has passed reCAPTCHA validation or not */
    public Boolean verified { get; private set; }    
    public String remoteHost{ get; set; }

    public WEBC_RecaptchaHandler()
    {
        init();
    }


    public WEBC_RecaptchaHandler(String challenge_field, String response_field, String remoteHost_value)
    {
    	
    	response = response_field;
    	system.debug('recaptcha: response ' + response);
    	
    	challenge = challenge_field;
    	system.debug('recaptcha: challenge ' + challenge);
    	
    	remoteHost = remoteHost_value;    	
    	system.debug('recaptcha: remoteHost ' + remoteHost);
    	
        init();
        
        this.verified = false;
    }

    private void init()
    {

        /* Set up the recaptch vars */
        Global_Setting__c baseURLSetting = Global_Setting__c.getInstance('RecaptchaBaseURL');
        baseURL = DEFAULT_RECAPTCHA_BASE_URL;        
        if ( baseURLSetting != null ){
             baseURL = baseURLSetting.Value__c;        
        }
        
        Global_Setting__c recaptchaPrivateKey = Global_Setting__c.getInstance('RecaptchaPrivateKey');
        privateKey = DEFAULT_RECAPTCHA_PRIVATE_KEY;
        if ( recaptchaPrivateKey != null ){
            privateKey = recaptchaPrivateKey.Value__c;
        }
        
        Global_Setting__c recaptchaPublicKey = Global_Setting__c.getInstance('RecaptchaPublicKey');
        publicKey = DEFAULT_RECAPTCHA_PUBLIC_KEY;
        if ( recaptchaPublicKey != null ){
            publicKey = recaptchaPublicKey.Value__c;
        }

    }

    
    //reCAPTCHA code
    public boolean verify() {
    
        System.debug('reCAPTCHA verification attempt');
        // On first page load, form is empty, so no request to make yet
    
    	system.debug('recaptcha: challenge ' + challenge);
    	system.debug('recaptcha: response ' + response);	
        system.debug('recaptcha: remoteHost ' + remoteHost);    
    
        if ( challenge == null || response == null ) { 
            System.debug('reCAPTCHA verification attempt with empty form');
            return false; 
        }
                    
        HttpResponse r = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response
        );
        
        system.debug('reCAPTCHA : ' + r.getBody());
        
        if ( r!= null ) {
            this.verified = (r.getBody().startsWithIgnoreCase('true'));
        }        
        
        return this.verified;
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
            response.setBody('true');
    
        } else {
            
            try {
            
                Http http = new Http();
                response = http.send(req);
                System.debug('reCAPTCHA response: ' + response);
                System.debug('reCAPTCHA body: ' + response.getBody());
            
            } catch(System.Exception e) {
              
                System.debug('ERROR: ' + e);
            
            }   
        }
        
        return response;
    }   
 
}