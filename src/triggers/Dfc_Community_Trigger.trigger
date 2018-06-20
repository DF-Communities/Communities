trigger Dfc_Community_Trigger on DFC_Community__c (before insert, after insert, before update, after update, before delete, after delete) {


 Dfc_Community_TriggerHandler handler = new Dfc_Community_TriggerHandler();


    System.debug('Dfc_Community_Trigger');

    if( Trigger.isInsert && Trigger.isBefore) {

        handler.onBeforeInsert(Trigger.new, Trigger.newMap);

    }

    if( Trigger.isUpdate && Trigger.isBefore) {

		handler.OnBeforeUpdate(Trigger.old,Trigger.oldMap,Trigger.new, Trigger.newMap);

    }

    if( Trigger.isUpdate && Trigger.isAfter) {

		handler.OnAfterUpdate(Trigger.old,Trigger.oldMap,Trigger.new, Trigger.newMap);

    }
    
    if( Trigger.isInsert && Trigger.isAfter) {

		handler.OnAfterInsert(Trigger.new);

    }


}