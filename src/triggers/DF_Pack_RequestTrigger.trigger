trigger DF_Pack_RequestTrigger on DF_Pack_Request__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    /* The code is broken down into a Trigger and an Apex “handler” class that implements the actual functionality.
       It’s best practice to only have one trigger for each object and to avoid complex logic in triggers. 
       To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic.*/

    System.debug('****** DF_Pack_Request__c ******');

    // Delegate responsibility to the DF_Pack_Request__cHandler Class.
    DF_Pack_RequestTriggerHandler handler = new DF_Pack_RequestTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore)
    {
      handler.onBeforeInsert(Trigger.new,Trigger.newMap);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        //Call the Handler OnAfterInsert Method and execute trigger logic.
        
        
    }
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
   
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        //Call the Handler OnAfterUpdate Method and execute trigger logic.
        
        
    }
    else if(Trigger.isDelete && Trigger.isBefore){

    }
    else if(Trigger.isDelete && Trigger.isAfter){
        //Call the Handler OnAfterDelete Method and execute trigger logic.
      
        
    }
    else if(Trigger.isUnDelete){
  
    }

}