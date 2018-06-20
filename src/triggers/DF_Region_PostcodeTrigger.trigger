/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : DF_Region_Postcode trigger
 *  Author  : Gary Grant
 *  Date    : June 2015
 *  Version : 0.1 Unit Test
 *
 *  Description:    
 *               
 *  Modification History
 *  Date            Who       Description 
 *  
*******************************************************************************************/
trigger DF_Region_PostcodeTrigger on DF_Region_Postcode__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

		DF_Region_Postcode_TriggerHandler handler = new DF_Region_Postcode_TriggerHandler();

		if (Trigger.isInsert && Trigger.isAfter) {

			handler.OnAfterUpdate(trigger.old, trigger.new, trigger.newMap);
	    
		} else if (Trigger.isUpdate && Trigger.isAfter) {

	    	handler.OnAfterUpdate(trigger.old, trigger.new, trigger.newMap);
	    
		}
}