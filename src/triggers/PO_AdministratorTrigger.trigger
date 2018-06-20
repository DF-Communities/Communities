trigger PO_AdministratorTrigger on PO_Administrator__c (after insert) {
 PO_AdministratorTriggerHandler handler = new PO_AdministratorTriggerHandler();

    if( Trigger.isInsert && Trigger.isAfter) {

        handler.onAfterInsert(Trigger.new, Trigger.newMap);

    }   
}