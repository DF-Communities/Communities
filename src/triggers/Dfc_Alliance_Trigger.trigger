/*  DFC Alliance records are created automatically from the DAA WEbsite using a scheduled task 

    The Alliance need to be linked to a Region of England
*/


trigger Dfc_Alliance_Trigger on DFC_Alliance__c (
            before insert, 
            before update, 
            before delete, 
            after insert, 
            after update, 
            after delete, 
            after undelete) {

        Dfc_Alliance_TriggerHandler handler = new Dfc_Alliance_TriggerHandler();

        if (Trigger.isInsert && Trigger.isBefore) {

            handler.OnBeforeInsert(trigger.new);
        
        } else if (Trigger.isUpdate && Trigger.isBefore) {

            handler.OnBeforeUpdate(trigger.old, trigger.new, trigger.oldMap);
        
        } 

}