/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Trigger Handler for DF_Region Postcide
 *  Author  : Gary Grant
 *  Date    : June 2015
 *  Version : 0.1 Unit Test
 *
 *  Description:    linking DFCs to Regions
 *               
 *  Modification History
 *  Date            Who       Description 
 *  
*******************************************************************************************/

public class DF_Region_Postcode_TriggerHandler {


    private boolean m_isExecuting = false; 

    public DF_Region_Postcode_TriggerHandler() {

    }
    
    public DF_Region_Postcode_TriggerHandler(boolean isExecuting) {

        m_isExecuting = isExecuting;

    }

    public void OnBeforeInsert(DF_Region_Postcode__c[] lis) {

        // EXECUTE BEFORE INSERT LOGIC

    }

    public void OnAfterInsert(DF_Region_Postcode__c[] lis) {

            applyRegionId(lis);

    }

    public void OnBeforeUpdate(DF_Region_Postcode__c[] lisOld, DF_Region_Postcode__c[] lisNew, Map<ID, DF_Region_Postcode__c> mapO) {

        // BEFORE UPDATE LOGIC

    }


    public void OnAfterUpdate(DF_Region_Postcode__c[] lisOld, DF_Region_Postcode__c[] lisNew, Map<ID, DF_Region_Postcode__c> mapO) {

        	applyRegionId(lisNew);        	

    }

    public void OnBeforeDelete(DF_Region_Postcode__c[] lisDeleted, Map<ID, DF_Region_Postcode__c> mapO) {

        // BEFORE DELETE LOGIC

    }

    public void OnAfterDelete(DF_Region_Postcode__c[] lisDeleted, Map<ID, DF_Region_Postcode__c> mapO) {

        // AFTER DELETE LOGIC

    }

    public void OnUndelete(DF_Region_Postcode__c[] lisRestored){

        // AFTER UNDELETE LOGIC

    }

    public boolean IsTriggerContext{

        get{ return m_isExecuting;}

    }

    private void applyRegionId(DF_Region_Postcode__c[] lis) {


        Map<String, String> mapPostCodes = new Map<String, String>();    
        for ( DF_Region_Postcode__c rp : lis ) { 
           mapPostCodes.put(rp.Name, rp.DF_Region__c);
        }

        DF_Region_Assignment_Batcher batcher = new DF_Region_Assignment_Batcher(mapPostCodes);        
        Id batchProcessid = Database.executeBatch(batcher);
        system.debug('Executing DFC Region Batch : ' + batchProcessid);        

    }

}