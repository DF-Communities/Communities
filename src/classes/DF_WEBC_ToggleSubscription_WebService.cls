/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : Web Service Register/Unregister a subscriber to the newsletter
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
@RestResource(urlMapping = '/friend/toggle-subscribe/*')
global with sharing class DF_WEBC_ToggleSubscription_WebService {
 
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
          //resp.statusCode = 500;
          ResponseHolder responseHolder = new ResponseHolder();
          responseHolder.returnCode = 0;
          responseHolder.message = x.getMessage();  
          //resp.responseBody = Blob.valueOf(JSON.serialize(responseHolder));     
          return responseHolder;
        }

    }
    
    private static ResponseHolder handlePost(DataHolder data)
    {

      ResponseHolder responseHolder = null;
      RestResponse resp = RestContext.response;
        
      if ( !WEBC_CommunityWrapper.isLoggedIn ) {
        
            system.debug ('Subscribing new User: User is not Logged in');
            responseHolder = new ResponseHolder();
            responseHolder.returnCode = 0;
            responseHolder.message = 'Error : User not identified - not logged in';  
            return responseHolder;
            
      }       

      
      /* Check to see if there is a DF Contact for this email address */
      DF_Contact__c dfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());            
      
      if ( dfc==null ) {
            
        responseHolder = new ResponseHolder();
        responseHolder.returnCode = 0;
        responseHolder.message = 'Error : User not identified - not logged in or not DFC user';  
        system.debug('Subscription toggler ' + responseHolder.message);
        return responseHolder;
        
      }
            
      system.debug ('Toggle subscription : Action ' + data.action);     
                    
      if ( data.action!=null && data.action == 'on' ) {

          system.debug ('Do Toggle subscription On');       
          dfc.Newsletters__c = true;
          update dfc;   
        
      }

      if ( data.action!=null && data.action == 'off'  ) {
        
          system.debug ('Do Toggle subscription Off');
          dfc.Newsletters__c = false;
          update dfc;   
        
      }

        system.debug ('Toggle Subscription Action Complete ' + dfc.Newsletters__c);

        responseHolder = new ResponseHolder();
        responseHolder.returnCode = 1;
        responseHolder.message = 'OK';

        return responseHolder;

    }
    

    global class DataHolder extends Holder
    {

        public String action = '';

    }

    /* The object returned in the JSON */
    global class ResponseHolder extends Holder
    {

        public String message = '';
        public Integer returnCode;

    }


    global abstract class Holder
    {


    }
}