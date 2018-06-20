/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : Web Service Register a subscriber to the newsletter
 *  Author  : Gary Grant
 *  Date    : 16/02/2015
 *  Version : 1.0
 *
 *  Description:    Web Service - registers a new user as a newsletter subscriber
                    also used in the first stage of the Register Friend process
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
@RestResource(urlMapping = '/friend/subscribe/*')
global with sharing class DF_WEBC_RegisterSubscriber_WebService {

     @HttpPost      
     global static ResponseHolder doPost(DataHolder data) {
        
        
        system.debug('Web Service - User : ' + UserInfo.getUserId());
        
        /*
        RestResponse resp = RestContext.response;
        resp.headers.put('Access-Control-Allow-Origin','*');
        resp.headers.put('Content-Type','application/json');
        */

        /* Don't use charset=URTF8 because IE9 chokes
            resp.headers.put('Content-Type','application/json;charset=UTF8');
        */       

        try {
                    
                ResponseHolder responseHolder = handlePost(data);
                return responseHolder;
                //resp.responseBody = Blob.valueOf(JSON.serialize(responseHolder));
                //resp.statusCode = 200;  
                

        } catch (Exception x) {

          // TODO Look into generic RestError Message class 
          system.debug ('Subscribing new User Error:' + data.emailAddress);            
          //resp.statusCode = 500;
          ResponseHolder responseHolder = new ResponseHolder();
          responseHolder.returnCode = 0;
          responseHolder.standardErrorMsg = x.getMessage();  
          return responseHolder;
          //resp.responseBody = Blob.valueOf(JSON.serialize(responseHolder));     
        }

    }

    private static ResponseHolder handlePost(DataHolder data)
    {

      ResponseHolder responseHolder = null;
      //RestResponse resp = RestContext.response;
      
     /* Validate the data */
     if (data.firstName == '' || data.lastName == '' || data.emailAddress =='' || ( data.emailAddress != data.emailAddress2 ) ) {
        
            system.debug('Subscribing FirstName ' + data.firstName);
            system.debug('Subscribing LastName ' + data.lastName);
            system.debug('Subscribing EmailAddress ' + data.emailAddress);
            system.debug('Subscribing EmailAddress2 ' + data.emailAddress2);
        
            system.debug ('Subscribing new User: data is null');
            responseHolder = new ResponseHolder();
            responseHolder.returnCode = 0;
            responseHolder.standardErrorMsg = 'Please complete all the fields';  
            return responseHolder;              
      }
      
      if ( !WEBC_CommunityWrapper.isEmailAddressOK(data.emailAddress) ) {
        
            system.debug ('Subscribing new User: email is bad');
            responseHolder = new ResponseHolder();
            responseHolder.returnCode = 0;
            responseHolder.standardErrorMsg = 'Please enter a valid email address';  
            return responseHolder;
        
      }
      
      system.debug ('Subscribing new User Data is OK :' + data.emailAddress);

      if ( data.doRecaptcha !=null && data.doRecaptcha ) {
        
            if (!isRecaptchaOK(data.recaptcha_challenge, data.recaptcha_response, responseHolder) ) {
                responseHolder = new ResponseHolder();
                responseHolder.returnCode = 0;
                responseHolder.standardErrorMsg = WEBC_RecaptchaHandler.RECAPTCHA_VALIDATION_FAILED;  
                return responseHolder;
            }
        
      }
      
      system.debug ('Subscribing new User Recaptcha is Ok :' + data.emailAddress);

      /* Check to see if there is a DF Contact for this email address */
      DF_Contact__c dfc = null;      
      List<DF_Contact__c> lisDfc =[select id, title__c, email__c, Last_Name__c, first_Name__c, Newsletters__c, RecordType.DeveloperName, Portal_Contact__c from DF_Contact__c where email__c=:data.emailAddress.toLowerCase() LIMIT 1];
      
      if ( lisDfc.isEmpty() ) {
            
        system.debug ('Subscribing new User: dfc Creating new Dfc');    
            
        dfc = new DF_Contact__c();
          
        dfc.Email__c = data.emailAddress.toLowerCase();
        dfc.Last_Name__c = data.lastName;
        dfc.First_Name__c = data.firstName;
        dfc.NewsLetters__c = data.newsletter;

        if ( data.isSimpleUpdate !=null && data.isSimpleUpdate ) {
            dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_NEWSLETTER_CONTACT);
        } else {
            dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_REGISTRATION);
        }
          
        insert dfc;                
        responseHolder = new ResponseHolder(dfc);
        responseHolder.returnCode = 1;
        
        system.debug ('Subscribing new User: created new Dfc');

        return responseHolder;
      
      }
                    
      dfc = lisDfc[0];
      system.debug ('Subscribing new User: dfc Found ' + dfc.Email__c);

      if ( data.isSimpleUpdate !=null && data.isSimpleUpdate ) {
                
            system.debug ('Subscribing new User: dfc Simple Update');   
        
            dfc.Newsletters__c = data.newsletter;
            update dfc;
            system.debug ('Subscribing new User: dfc updated');
    
        } else {
    
            system.debug ('Subscribing new User: Not Simple update ');
            
            /* If the email address is already registered, and is more than a simple registration, 
               throw it back */                                 
            //if (dfc.RecordType.DeveloperName !='Registration') {
            if ( DF_Utils.hasUserRecord(dfc) ) {            
                
                system.debug ('Subscribing new User: dfc already registered ' + dfc.Email__c);
                responseHolder = new ResponseHolder();
                responseHolder.returnCode=-2;
                responseHolder.standardErrorMsg = 'This email address is already registered';
                return responseHolder;
                    
           
           }
        }
    


        responseHolder = new ResponseHolder(dfc);
        responseHolder.returnCode = 1;

        return responseHolder;

    }
    
    private static boolean isRecaptchaOK(String recaptcha_challenge, String recaptcha_response, ResponseHolder responseHolder)
    {

        try {
            system.debug('WEBC_RegisterSubscriber_Loggin :' + recaptcha_challenge);
            system.debug('WEBC_RegisterSubscriber_Loggin :' + recaptcha_response);
            system.debug('WEBC_RegisterSubscriber_Loggin :' + remoteHost); 
    
            /* Reset these values here because the challenge and response will be set after the page has loaded by the JS code */
            WEBC_RecaptchaHandler recaptchaHandler = new WEBC_RecaptchaHandler(recaptcha_challenge, recaptcha_response, remoteHost);
            if ( !recaptchaHandler.verify() ){
    
                responseHolder.standardErrorMsg = DF_Utils.STANDARD_ERROR_MSG;
                responseHolder.reCAPTCHAError = WEBC_RecaptchaHandler.RECAPTCHA_VALIDATION_FAILED;
                return false;
            }
    
            return true;
        } catch (Exception x) {
            
            system.debug('WEBC_RegisterFriend_Loggin : ' + x.getMessage());     
            return false;
        }

    }
    

    global class DataHolder extends Holder
    {

        /* If this is a simple update for a new subscriber or existing DFC, 
           simply set the newsletter value and return.

           Otherwise this is the frist step of a DF registration and
           the user needs to be informed they are already registered
        */
        public Boolean isSimpleUpdate = false;
        public Boolean doRecaptcha = false;
        
        public String recaptcha_challenge;
        public String recaptcha_response;    

        public String emailAddress2;                                                          

    }

    /* The object returned in the JSON */
    global class ResponseHolder extends Holder
    {

        Integer returnCode;
        String message = '';
        String userid;
        String standardErrorMsg = '';
        String reCAPTCHAError = '';

        public ResponseHolder()
        {
            newsLetter = false;
        }

        public ResponseHolder(DF_Contact__c dfc)
        {
            lastName = dfc.Last_Name__c;
            firstName = dfc.First_Name__c;
            emailAddress = dfc.Email__c;
            userid = dfc.id;
            newsLetter = dfc.Newsletters__c;

        } 

    }


    global abstract class Holder
    {
        public String firstName = '';
        public String lastName = '';
        public String emailAddress = '';
        public boolean newsLetter = false;

    }

    private static String remoteHost { 
        
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
 
            RestRequest req = RestContext.request;           
            Map<String, String> hdrs = req.headers;   
            if (hdrs.get('x-original-remote-addr')!= null)        
                ret =  hdrs.get('x-original-remote-addr');        
            else if (hdrs.get('X-Salesforce-SIP')!= null)        
               ret =  hdrs.get('X-Salesforce-SIP');        
            return ret;        
        }
    }    

    
}