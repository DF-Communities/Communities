trigger Dfc_Action_Area_Trigger on DFC_Action_Area__c (after insert, before update) {
    
   Dfc_ActionArea_TriggerHandler handler = new Dfc_ActionArea_TriggerHandler();

        if (Trigger.isInsert && Trigger.isAfter) {

            handler.OnAfterInsert(trigger.new);
        
        } else if (Trigger.isUpdate && Trigger.isBefore) {

            handler.OnBeforeUpdate(trigger.old, trigger.new, trigger.oldMap);
        
        } 
 
}