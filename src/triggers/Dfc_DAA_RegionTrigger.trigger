trigger Dfc_DAA_RegionTrigger on DFC_DAA_Region__c (before insert, after insert, before update, after update, before delete, after delete) {


	Dfc_DAA_Region_TriggerHandler handler = new Dfc_DAA_Region_TriggerHandler();

    if( Trigger.isInsert && Trigger.isAfter) {

        handler.onAfterInsert(Trigger.new, Trigger.newMap);

    }

    if( Trigger.isUpdate && Trigger.isAfter) {

		handler.OnAfterUpdate(Trigger.old,Trigger.oldMap,Trigger.new, Trigger.newMap);

    }


}