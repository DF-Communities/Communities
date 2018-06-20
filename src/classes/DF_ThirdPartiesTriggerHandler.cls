public without sharing class DF_ThirdPartiesTriggerHandler {

/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the DF_Third_Parties__c Trigger.
 *  Author  : Ian Smith
 *  Date    : 21-02-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Apex Class calls the LastTransactionDateLookup Apex Class to update the 
 *          lastTransactionDate__c field for the DF_Contact__c Record.
 *               
 *  Modification History
 *  Date            Who       Description 
 *  12/05/2014		CSL		  Commenting out code for LastTransactionDateLookup                           
*******************************************************************************************/

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public DF_ThirdPartiesTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnAfterInsert(DF_Third_Parties__c[] updatedThirdParty, Map<ID, DF_Third_Parties__c> thirdPartyMap){
        System.debug('****** DF_ThirdPartiesTriggerHandler.OnAfterInsert  ******');
        
        List<Id> dfThirdPartyIds = new List<Id>();
        Datetime dtLastTransactionDate = datetime.now();

    //Iterate over the DF_Third_Parties__c Object for the DF_Third_Parties/s being Inserted via the DF_Third_Parties__c Trigger.        
        for(DF_Third_Parties__c df : updatedThirdParty){
            dfThirdPartyIds.add(df.id);
        }
        System.debug('****** dfThirdPartyIds.Size ******' + dfThirdPartyIds.Size());

    if(dfThirdPartyIds.isEmpty() == false)
    {
      //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime. 
      //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records
      //LastTransactionDateLookup handler = new LastTransactionDateLookup();
      //handler.UpdateLastTransactionDate(dfThirdPartyIds[0], dtLastTransactionDate); 
    }
    }
    
public void OnAfterUpdate(DF_Third_Parties__c[] OldThirdParty, DF_Third_Parties__c[] updatedThirdParty, Map<ID, DF_Third_Parties__c> thirdPartyMap){
        System.debug('****** DF_ThirdPartiesTriggerHandler.OnAfterUpdate  ******');
        
        List<Id> dfThirdPartyIds = new List<Id>();
        Datetime dtLastTransactionDate = datetime.now();
        
        //Iterate over the DF_Third_Parties__c Object for the DF_Third_Parties/s being Inserted via the DF_Third_Parties__c Trigger.
        for(DF_Third_Parties__c df : updatedThirdParty){
            dfThirdPartyIds.add(df.id);
        }
        System.debug('****** dfThirdPartyIds.Size ******' + dfThirdPartyIds.Size());

    if(dfThirdPartyIds.isEmpty() == false)
    {
      //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime. 
      //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records
      //LastTransactionDateLookup handler = new LastTransactionDateLookup();
      //handler.UpdateLastTransactionDate(dfThirdPartyIds[0], dtLastTransactionDate); 
    }
    }



  public void OnAfterDelete(DF_Third_Parties__c[] OldThirdParty, Map<ID, DF_Third_Parties__c> thirdPartyMap){
        System.debug('****** DF_ThirdPartiesTriggerHandler.OnAfterDelete  ******');
        
        List<Id> dfThirdPartyIds = new List<Id>();
        Datetime dtLastTransactionDate = datetime.now();
        
    //Iterate over the DF_Third_Parties__c Object for the DF_Third_Parties/s being Inserted via the DF_Third_Parties__c Trigger.        
        for(DF_Third_Parties__c df : OldThirdParty){
            dfThirdPartyIds.add(df.id);
        }
        System.debug('****** dfThirdPartyIds.Size ******' + dfThirdPartyIds.Size());

    if(dfThirdPartyIds.isEmpty() == false)
    {
      //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime.
      //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records 
      //LastTransactionDateLookup handler = new LastTransactionDateLookup();
      //handler.UpdateLastTransactionDate(dfThirdPartyIds[0], dtLastTransactionDate); 
      
    }
    }
        
        
        
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }     
    
}