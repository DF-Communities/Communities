global with sharing class DF_WEBC_Recaptcha2Handler {
    
    private static final String CAPTCHA_VERIFY_URL = 'https://www.google.com/recaptcha/api/siteverify';
    private static final String CAPTCHA_LOAD_URL = 'https://www.google.com/recaptcha/api.js';
    
    public String fullRecaptchaUri {get;set;}
    
    public String captureParams;
    public String getCaptureParams(){ return captureParams; }
    public void setCaptureParams(String value){
        captureParams = value;
        DF_WEBC_Recaptcha2Handler();
    }
    
    public void DF_WEBC_Recaptcha2Handler() {
        
        if(captureParams != null) {
            fullRecaptchaUri = CAPTCHA_LOAD_URL + '?' + captureParams;
        } else {
            fullRecaptchaUri = CAPTCHA_LOAD_URL;
        }
        
    }
    
    
    
    public static String captchaSite{
        
        get {
            
            String s = '6Lc8lxkTAAAAABWgV2BcYEDEsy6Ff9IU8iEAxpyO';
            try { 
                String sCap = (String)Community_Settings__c.getInstance('DF_Captcha_Site').value__c;
                if ( sCap != null && sCap.length() > 0) { s = sCap; }
            } catch (Exception x) { }
            
            return s;        
            
        }
        
        set;}
    
    public static String captchaSecret {
        
        get {
            
            String s = '6Lc8lxkTAAAAAKhi7vXZgBKHxZ96hkXRuMr2kJzD';
            try { 
                String sCap = (String)Community_Settings__c.getInstance('DF_Captcha_Secret').value__c;
                if ( sCap != null && sCap.length() > 0) { s = sCap; }
            } catch (Exception x) {}
            
            return s;        
            
        }
        
        set;}
    
    @RemoteAction
    global static Boolean interpretCaptchaResponse(String privateKey, String rawResponse) {
        
        // On first page load, form is empty, so no request to make yet
        if ( rawResponse == null ) { 
            return false;
        }
        
        String reqBody = 'secret=' + privateKey + '&response='  + rawResponse;
        Boolean verifiedAsHuman = false;
        
        HttpResponse finalResp = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(CAPTCHA_VERIFY_URL);
        req.setMethod('POST');
        req.setBody (reqBody);
        System.debug('Body is: ' + reqBody);
        if (test.isRunningTest()){
            finalResp = new HTTPResponse();
            finalResp.setBody('{"key","object"}');
        }else {
            try {
                Http http = new Http();
                finalResp = http.send(req);
            } catch(System.Exception e) {
                System.debug('ERROR: ' + e);
            }   
            
            String jsonResponse = finalResp.getBody();
            System.debug('jsonResponse is: ' + jsonResponse);
            Map<String,Object> respObj =  (Map<String,Object>)JSON.deserializeUntyped(jsonResponse);
            
            if ( finalResp!= null ) {
                verifiedAsHuman = (Boolean)respObj.get('success');
            }
        }
        
        return verifiedAsHuman;
    }
}