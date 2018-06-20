public without sharing class DF_ContactTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the DF_Contact__c Trigger.
 *  Author  : Ian Smith
 *  Date    : 23-01-2014
 *  Version : 0.1 Unit Test
 *
 *  Description:    Apex Class calls the LastTransactionDateLookup Apex Class to update the 
 *                  lastTransactionDate__c field for the DF_Contact__c Record.
 *               
 *  Modification History
 *  Date            Who         Description 
 *  24-01-2014      MTinson     Added Call to UpdateLastTransactionDate Class.
 *  27-02-2014      NTadikonda  Added Call to Update Parent Organisations Statistics
 *  03-03-2014      NTadikonda  Added Call to Map DF_Contacts to RSOAreaLookUp
 *  24-03-2014      MTinson     Update statistics to remove large reads of data
 *  01-04-2014      Iansm       Removed Call to Update Parent Organisations Statistics.  
 *  11-04-2014      MTinson     Handle missing postcodes in RSO lookup.   
 *  23-04-2014      MTinson     Empty Postcodes in RSO lookup.
 *  12/05/2014      CSL         Commenting out code for LastTransactionDateLookup     
 *  16/10/2015      GG          Update Assign Region methods
 *	18/01/2018		AndyR		championExchangeAccessHandle - Moved into After triggers
 								Re-factored logic in championExchangeAccessHandler to handle changes in record type or champions exchange access boolean tickboxes
 										               
*******************************************************************************************/

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;    
    private Map<String, String> mapRegionPostcodes;
    private String RT_Champion;
    
 
    public DF_ContactTriggerHandler(boolean isExecuting, integer size){

        m_isExecuting = isExecuting;
        BatchSize = size;

    }
    
    private void initRegionCodesMap() {

        if (mapRegionPostcodes !=null && mapRegionPostcodes.size()>0) { return;  }

        List<DF_Region_Postcode__c> lis = [select Name, DF_Region__c from DF_Region_Postcode__c];
        
        mapRegionPostcodes = new Map<String, String>();                
        for (DF_Region_Postcode__c pc : lis) {
            mapRegionPostcodes.put(pc.Name, pc.DF_Region__c);
        }

        RT_Champion = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
        return;

    }

    
     public void OnBeforeInsert(DF_Contact__c[] dfContacts, Map<ID, DF_Contact__c> DFContactMap)
     {
       System.debug('****** DF_ContactTriggerHandler.OnBeforeInsert  ******');

        initRegionCodesMap();   
        checkDFCAddressUpdate(dfContacts,null);   
        //if(!system.isBatch()){
        ///championExchangeAccessHandle(dfContacts,null);  
        //}                          
        for(DF_Contact__c df : dfContacts)
        {            
            //2014-06-02 : CSL : We need to make sure the Name field on a DF_Contact__c is equal to First_Name__c + Last_Name__c
            if (df.Name != df.First_Name__c + ' ' + df.Last_Name__c){
                df.Name = df.First_Name__c + ' ' + df.Last_Name__c;
            }

            assignRegion(null, df);


        }


    }



    public void OnAfterInsert(DF_Contact__c[] dfContacts, Map<ID, DF_Contact__c> DFContactMap){
		championExchangeAccessHandle(dfContacts,null); 
    }   
 
 
 
     public void OnBeforeUpdate(DF_Contact__c[] oldDFContact,Map<ID, DF_Contact__c> oldDFContactMap, DF_Contact__c[] updatedDFContact, Map<ID, DF_Contact__c> DFContactMap)
     {
        //updatePartnerChampionFriendsCount(oldDFContactMap,updatedDFContact);
        checkDFCAddressUpdate(updatedDFContact,oldDFContactMap);  
        initRegionCodesMap();
        //if(!system.isBatch()){
        //championExchangeAccessHandle(updatedDFContact,oldDFContactMap);
        //}
        for(DF_Contact__c df : updatedDFContact)
        {
            //2014-06-02 : CSL : We need to make sure the Name field on a DF_Contact__c is equal to First_Name__c + Last_Name__c
            if (df.Name != df.First_Name__c + ' ' + df.Last_Name__c){
                df.Name = df.First_Name__c + ' ' + df.Last_Name__c;
            }
        
            DF_Contact__c dfOld = oldDFContactMap.get(df.id);
            assignRegion(dfold, df);
            
        }

    }


    public void OnAfterUpdate(Map<ID, DF_Contact__c> oldDFContactMap, DF_Contact__c[] updatedDFContact, Map<ID, DF_Contact__c> DFContactMap){
		championExchangeAccessHandle(updatedDFContact,oldDFContactMap);
    }

    
    public void OnAfterDelete(DF_Contact__c[] oldDFContact, Map<ID, DF_Contact__c> DFContactMap){
  
    
    }
        
    public boolean IsTriggerContext
    {
        get{ return m_isExecuting;}
    }

    private void assignRegion(DF_Contact__c dfOld, DF_Contact__c dfNew) {

        if ( dfNew.RecordTypeId == RT_Champion && dfNew.Status__c == DF_Utils.STATUS_PROSPECTIVE) { 
             dfNew.DF_Region__c =null;
             return;
        }   

        //Only allocate Region if the DFC is a Champion or has previously run sessions
        if ( dfnew.RecordTypeId != RT_Champion ) {

            if ( dfNew.Total_No_of_Completed_Info_Sessions__c == 0 ) { 
                 dfNew.DF_Region__c = null;    
                 return;            
            }
        }

        String pcid = mapRegionPostcodes.get(dfnew.Postcode_Sector__c);
        system.debug('DF Contact Region Postcode : pcName ' + pcid);
        
        dfNew.DF_Region__c = pcid;
        return;
 
    }
    
         public void checkDFCAddressUpdate(List<DF_Contact__c> updatedDFContact, Map<ID, DF_Contact__c> oldDFContactMap){
        
        List<DF_Contact__c> dfcToUpdate = new List<DF_Contact__c>();
        
        for (DF_Contact__c d :updatedDFContact) {
            if (oldDFContactMap==null & d.Street__c!=null){
                 
                d.Address_updated__c = true;
                dfcToUpdate.add(d);
            }
        
            if (oldDFContactMap!=null & d.Street__c!=null){
               if(oldDFContactMap.get(d.id).PostCode__c != d.PostCode__c)
        
              d.Address_updated__c = true;
              dfcToUpdate.add(d);
            }
         }

         //update dfcToUpdate;
    }
    
    private void championExchangeAccessHandle(List<DF_Contact__c> updatedDFContact, Map<ID, DF_Contact__c> oldDFContactMap)
    {
        Set<Id> enableExchangeAccess = new Set<Id>();
        Set<Id> disableExchangeAccess = new Set<Id>();
        Set<Id> enableExchangeModeratorAccess = new Set<Id>();
        Set<Id> disableExchangeModeratorAccess = new Set<Id>();
        RT_Champion = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
        
        for (DF_Contact__c d :updatedDFContact) {
         
         DF_Contact__c oldDFContact = (oldDFContactMap != null && oldDFContactMap.containsKey(d.id)) ? oldDFContactMap.get(d.id) : new DF_Contact__c();
         
         boolean newContactIsChampion = (d.RecordTypeId == RT_Champion) ? true : false;
         boolean oldContactIsChampion = (oldDFContact.RecordTypeId == RT_Champion) ? true : false;
         
         if(newContactIsChampion != oldContactIsChampion || d.Champion_Exchange_Access__c != oldDFContact.Champion_Exchange_Access__c){
         
         	if(d.Champion_Exchange_Access__c && newContactIsChampion){ 
         		enableExchangeAccess.add(d.portal_user__c); 
         	} else if (oldContactIsChampion && oldDFContact.Champion_Exchange_Access__c) {
         		disableExchangeAccess.add(d.portal_user__c); 
         	}
         
         }
         
         if(newContactIsChampion != oldContactIsChampion || d.Has_exchange_moderator_access__c != oldDFContact.Has_exchange_moderator_access__c || d.Champion_Exchange_Access__c != oldDFContact.Champion_Exchange_Access__c){
         
         	if(d.Has_exchange_moderator_access__c && newContactIsChampion && d.Champion_Exchange_Access__c){ 
         		enableExchangeModeratorAccess.add(d.portal_user__c); 
         	} else if (oldContactIsChampion && oldDFContact.Has_exchange_moderator_access__c && oldDFContact.Champion_Exchange_Access__c) {
         		disableExchangeModeratorAccess.add(d.portal_user__c); 
         	}
         
         }
         
         /*if(d.RecordTypeId!= RT_Champion){break;}
            if (oldDFContactMap==null)
            {
             if(d.Champion_Exchange_Access__c){
                 
                enableExchangeAccess.add(d.portal_user__c);
             }

             if(d.Has_exchange_moderator_access__c){

                enableExchangeModeratorAccess.add(d.portal_user__c);

             }
           }
           else{

             if(oldDFContactMap.get(d.id).Champion_Exchange_Access__c!=d.Champion_Exchange_Access__c )
              { 
                if(d.Champion_Exchange_Access__c)
                {
                   enableExchangeAccess.add(d.portal_user__c); 
                }
                else
                {
                  disableExchangeAccess.add(d.portal_user__c); 
                }
              }  
             if(oldDFContactMap.get(d.id).Has_exchange_moderator_access__c!=d.Has_exchange_moderator_access__c)
             {
                if (d.Has_exchange_moderator_access__c){
                    enableExchangeModeratorAccess.add(d.portal_user__c);
                }
                else
                {
                    disableExchangeModeratorAccess.add(d.portal_user__c); 
                }

              }
                

             }*/
        
    }
    
    if(enableExchangeAccess.size()>0){ 
    	
    	DF_User_TriggerHandler.enableChampionExchangeAccess(enableExchangeAccess);
    	
    }
    
    if(disableExchangeAccess.size()>0){ 
    	
    	DF_User_TriggerHandler.disableChampionExchangeAccess(disableExchangeAccess);
    
    }

    if(enableExchangeModeratorAccess.size()>0){ 
    	
    	DF_User_TriggerHandler.enableExchangeModeratorAccess(enableExchangeModeratorAccess);
    
    }

    if(disableExchangeModeratorAccess.size()>0){ 
    	
    	DF_User_TriggerHandler.disableExchangeModeratorAccess(disableExchangeModeratorAccess);
    
    }
 }

}