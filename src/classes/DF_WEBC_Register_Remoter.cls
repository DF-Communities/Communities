/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Remote Action to handle post of JSON data from the DF Long Registration form
 *  Author  : Gary Grant
 *  Date    : 17/11/2015
 *  Version : 
 *

 *                 Long Form
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/

global without sharing class DF_WEBC_Register_Remoter {

    @RemoteAction   
    global static DF_WEBC_RegisterBase_Handler.ResponseHolder handleCommunityAdminJson(String sJson) {

        DF_WEBC_RegisterCommunityAdmin_Handler handler = new DF_WEBC_RegisterCommunityAdmin_Handler(sJson);
        return handler.handleJson();
        
    }

    @RemoteAction   
    global static DF_WEBC_RegisterBase_Handler.ResponseHolder handleFriendJson(String sJson) {
		
        DF_WEBC_RegisterFriend_Handler handler = new DF_WEBC_RegisterFriend_Handler(sJson);
        return handler.handleJson();
        
    }


    @RemoteAction   
    global static DF_WEBC_RegisterBase_Handler.ResponseHolder handleChampionJson(String sJson) {

        DF_WEBC_RegisterChampion_Handler handler = new DF_WEBC_RegisterChampion_Handler(sJson);
        return handler.handleJson();
        
    }

    @RemoteAction   
    global static DF_WEBC_RegisterBase_Handler.ResponseHolder handleDigitalFriendJson(String sJson) {
        System.debug('json direct from form: ' + sJson);
        DF_WEBC_RegisterDigitalFriend_Handler handler = new DF_WEBC_RegisterDigitalFriend_Handler(sJson);
        return handler.handleJson();
        
    }

    @RemoteAction   
    global static DF_WEBC_RegisterBase_Handler.ResponseHolder handleMakeDDFJson(String sJson) {

        DF_WEBC_RegisterDigitalFriend_Handler handler = new DF_WEBC_RegisterDigitalFriend_Handler(sJson);
        return handler.handleJson();
        
    }


    @RemoteAction   
    global static DF_WEBC_RegisterBase_Handler.ResponseHolder handleSubscriberJson(String sJson) {

       DF_WEBC_RegisterSubscriber_Handler handler = new DF_WEBC_RegisterSubscriber_Handler(sJson);
       return handler.handleJson();
       
    }

    @RemoteAction   
    global static DF_WEBC_RegisterBase_Handler.ResponseHolder handleOrgAdminJson(String sJson) {

       DF_WEBC_RegisterOrgAdmin_Handler handler = new DF_WEBC_RegisterOrgAdmin_Handler(sJson);
       return handler.handleJson();
       
    }

}