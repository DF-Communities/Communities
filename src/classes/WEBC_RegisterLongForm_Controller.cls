/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for Long Register Form
 *  Author  : Valerie Dunphy
 *  Date    : 17/11/2015
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBRegisterFriend component.
  *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
global without sharing class WEBC_RegisterLongForm_Controller {

    @RemoteAction
    global static boolean handleEmailCheck(String email) {

        List<User> lisUser = [select id from User where UserName = :email];
        return (!lisUser.isEmpty());

    }
    
       @RemoteAction
    global static boolean isExistingOrg(String orgName) {

        List<Partner_Organisation__c> lisOrg = [select id from Partner_Organisation__c where name = :orgName];
        return (!lisOrg.isEmpty());

    }

}