global class DF_WEBC_Recaptcha2LightningRetrofitter extends LightningUtils {
    
    class DF_WEBC_Recaptcha2LightningRetrofitterException extends Exception{}
    private static final String CAPTCHA_BASE_URL = 'https://www.google.com/recaptcha/api/siteverify';
    public String captchaPrivateKey{get;set;}
    
    public DF_WEBC_Recaptcha2LightningRetrofitter(DF_WEBC_Recaptcha2Handler controller) {
        LightningUtils.getLightningHostUrl();
        
        // Get the private key
        List<Global_Setting__c> privateKey = [SELECT Value__c 
                                              FROM Global_Setting__c
                                              WHERE Name='RecaptchaPrivateKey'];
        if(privateKey.size() != 1) {
            throw new DF_WEBC_Recaptcha2LightningRetrofitterException('No custom setting exists with name "RecaptchaPrivateKey" in the Global Setting custom setting');
        } else {
            captchaPrivateKey = privateKey[0].Value__c;
        }
    }
    
    /*
    @RemoteAction
    global static Boolean interpretCaptchaResponse(String privateKey, String rawResponse) {

        // On first page load, form is empty, so no request to make yet
        if ( rawResponse == null ) { 
            return false;
        }
         
        String reqBody = 'secret=' + privateKey + '&response='  + rawResponse;
            
        HttpResponse finalResp = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(CAPTCHA_BASE_URL);
        req.setMethod('POST');
        req.setBody (reqBody);
        if (test.isRunningTest()){
            finalResp = new HTTPResponse();
            finalResp.setBody('true');
        }else {
            try {
                Http http = new Http();
                finalResp = http.send(req);
            } catch(System.Exception e) {
                System.debug('ERROR: ' + e);
            }   
        }
        
        String jsonResponse = finalResp.getBody();
        Map<String,Object> respObj =  (Map<String,Object>)JSON.deserializeUntyped(jsonResponse);
        
        Boolean verifiedAsHuman = false;
        if ( finalResp!= null ) {
            verifiedAsHuman = (Boolean)respObj.get('success');
        }
        
       return verifiedAsHuman;
    }
*/
    
}