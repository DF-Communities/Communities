trigger DF_ActionTrigger on Action__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    /* The code is broken down into a Trigger and an Apex “handler” class that implements the actual functionality.
       It’s best practice to only have one trigger for each object and to avoid complex logic in triggers. 
       To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic.*/

    System.debug('****** Action__c ******');

    // Delegate responsibility to the DF_ActionTriggerHandler Class.
    DF_ActionTriggerHandler handler = new DF_ActionTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore)
    {
      handler.onBeforeInsert(Trigger.new,Trigger.newMap);

    }
    
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
      handler.onBeforeUpdate(Trigger.new,Trigger.oldMap);
     
    }
    
    

}