global with sharing class DF_WEBC_PushMessages extends DF_WEBC_ControllerBase {

public List<Push_Notifications__c> champMessages{get;set;}
//public String pushMId {get;set;}

    global DF_WEBC_Pushmessages() {
        
    champMessages = new List<Push_Notifications__c>();
    if(currentdfc!=null)  {
        for(Push_Notifications__c pn :DF_Utils.pushMessages(currentdfc)){
            champMessages.add(pn);

        }
      }
    }

    @RemoteAction
    global static void deleteMessage(id pushMId){
         List<Push_Notifications__c> pn =new  List<Push_Notifications__c>();
         
         //system.debug('message to delete @@'+pushMId);
         for( Push_Notifications__c push: [select Message__c,Status__c from Push_Notifications__c where Id=:pushMId]){

            push.Status__c ='Read';
            pn.add(push);
         }
         
         
          if(pn.size()>0) {update pn;
            }

    }
}