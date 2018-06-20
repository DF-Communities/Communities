/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Take a link from an email and verify the user, register in the DF community
 *  Author  : Gary Grant
 *  Date    : 29 Sep 2015
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 

*******************************************************************************************/ 

public without sharing class DF_WEBC_VerifyRegistration_Controller extends WEBC_VerifyRegistration_Controller {
     
    
        
  @TestVisible 
  private void doPostRegistration(User u) {

       // Exit if either value is null 
       if(u.id == null  ) { return; }

       /* 
       system.debug('DF Verify Registration - Post Registration method');
       DF_Contact__c dfc = [select id,portal_user__c from DF_Contact__c where Portal_Contact__c =:u.ContactId limit 1];
       dfc.portal_user__c = u.id;
       dfc.ownerId = u.id;
       
       update dfc;
       */

    }


}