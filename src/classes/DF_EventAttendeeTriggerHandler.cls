public without sharing class DF_EventAttendeeTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the DF_EventAttendee__c Trigger.
 *  Author  : Ian Smith
 *  Date    : 24-01-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Apex Class calls the LastTransactionDateLookup Apex Class to update the 
 *          lastTransactionDate__c field for the DF_EventAttendee__c Record.
 *               
 *  Modification History
 *  Date            Who       Description 
 *  24-01-2014      MTinson   Added Call to UpdateLastTransactionDate Class.
 *  12/05/2014      CSL       Commenting out code for LastTransactionDateLookup                           
*******************************************************************************************/

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
   
    public DF_EventAttendeeTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnAfterInsert(DF_EventAttendee__c[] dfEventAttendee, Map<ID, DF_EventAttendee__c> dfEventAttendeeMap){

    }   

    public void OnAfterUpdate(DF_EventAttendee__c[] olddfEventAttendee, DF_EventAttendee__c[] updateddfEventAttendee, Map<ID, DF_EventAttendee__c> dfEventAttendeeMap){
      
        System.debug('****** DF_EventAttendeeTriggerHandler.OnAfterUpdate  ******');
        List<DF_EventAttendee__c> champAttendeelis = new List<DF_EventAttendee__c>();
        Datetime dtLastTransactionDate = datetime.now(); 
        for(DF_EventAttendee__c eat :updateddfEventAttendee)  {
        	if(eat.Event_Record_type__c=='Champion_Training_Course'){
        		champAttendeelis.add(eat);
        	}
        }  
        if(champAttendeelis.size()>0) {      
         DF_Mail_TriggerClass.EmailTriggers(champAttendeelis);
        }
         
    }
  
   public void OnAfterDelete(DF_EventAttendee__c[] oldDFEventAttendee, Map<ID, DF_EventAttendee__c> DFEventAttendeeMap){


   }
        
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }

}