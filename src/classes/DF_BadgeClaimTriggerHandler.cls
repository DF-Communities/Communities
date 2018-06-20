public with sharing class DF_BadgeClaimTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the Badge_Claim__c Trigger.
 *  Author  : Ian Smith
 *  Date    : 21-03-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Apex Class calls the LastTransactionDateLookup Apex Class to update the 
 *                  lastTransactionDate__c field for the Partner_Organisation__c Record.
 *               
 *  Modification History
 *  Date            Who         Description 
 *  12/05/2014		CSL		  Commenting out code for LastTransactionDateLookup                           
*******************************************************************************************/

private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public DF_BadgeClaimTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
  
  
  
  public void OnAfterInsert(Badge_Claim__c[] badgeClaim, Map<ID, Badge_Claim__c> badgeClaimMap){
        System.debug('****** DF_BadgeClaimTriggerHandler.OnAfterInsert  ******');
        
        List<Id> badgeClaimIds = new List<Id>();
        Datetime dtLastTransactionDate = datetime.now();
        
        //Iterate over the Badge_Claim__c Object for the Badge_Claim/s being Inserted via the Badge_Claim__c Trigger.
        for(Badge_Claim__c po : badgeClaim){
          //Add the Badge_Claim Id field to a List Collection.
            badgeClaimIds.add(po.Id);
        }
        System.debug('****** badgeClaimIds.Size ******' + badgeClaimIds.Size());

    if(badgeClaimIds.isEmpty() == false)
    {
      //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime. 
      //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records
      //LastTransactionDateLookup handler = new LastTransactionDateLookup();
      //handler.UpdateLastTransactionDate(badgeClaimIds[0], dtLastTransactionDate); 
    }
    }   
    
    

    public void OnAfterUpdate(Badge_Claim__c[] oldBadgeClaim, Badge_Claim__c[] updatedBadgeClaim, Map<ID, Badge_Claim__c> badgeClaimMap){
        System.debug('****** DF_BadgeClaimTriggerHandler.OnAfterUpdate  ******');
        
        List<Id> badgeClaimIds = new List<Id>();
        Datetime dtLastTransactionDate = datetime.now();
        
        //Iterate over the Badge_Claim__c Object for the Badge_Claim/s being Inserted via the Badge_Claim__c Trigger.
        for(Badge_Claim__c po : updatedBadgeClaim){
            //Add the Badge_Claim Id field to a List Collection.
            badgeClaimIds.add(po.Id);
        }
        System.debug('****** badgeClaimIds.Size ******' + badgeClaimIds.Size());

    if(badgeClaimIds.isEmpty() == false)
    {
      //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime.
      //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records 
      //LastTransactionDateLookup handler = new LastTransactionDateLookup();
      //handler.UpdateLastTransactionDate(badgeClaimIds[0], dtLastTransactionDate); 
    }
    }

  
  
  public void OnAfterDelete(Badge_Claim__c[] oldBadgeClaim, Map<ID, Badge_Claim__c> badgeClaimMap){
    
        System.debug('****** DF_BadgeClaimTriggerHandler.OnAfterUpdate  ******');
        
        List<Id> badgeClaimIds = new List<Id>();
        Datetime dtLastTransactionDate = datetime.now();
        
        //Iterate over the Badge_Claim__c Object for the Badge_Claim/s being Inserted via the Badge_Claim__c Trigger.
        for(Badge_Claim__c df : oldBadgeClaim){
            //Add the Badge_Claim Id field to a List Collection.
            badgeClaimIds.add(df.Id);
        }
        System.debug('****** badgeClaimIds.Size ******' + badgeClaimIds.Size());

    if(badgeClaimIds.isEmpty() == false)
    {
      //Call Apex Class to populate LastTransactionDateLookup__c Object passing a RecordId and current DateTime.
      //2014-05-12 : CSL : Temporarily commenting out the code to look at the LastTransactionDateLookup records 
      //LastTransactionDateLookup handler = new LastTransactionDateLookup();
      //handler.UpdateLastTransactionDate(badgeClaimIds[0], dtLastTransactionDate); 
    }
    }


        
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    } 
}