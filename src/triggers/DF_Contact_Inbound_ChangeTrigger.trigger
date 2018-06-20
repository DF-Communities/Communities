trigger DF_Contact_Inbound_ChangeTrigger on DF_Contact_Inbound_Change__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
   /* The code is broken down into a Trigger and an Apex “handler” class that implements the actual functionality.
       It’s best practice to only have one trigger for each object and to avoid complex logic in triggers. 
       To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic.*/

    System.debug('****** DF_Contact_Inbound_Change__c******');

    // Delegate responsibility to the DF_Pack_Request__cHandler Class.
    DF_Contact_Inbound_ChangeTriggerHandler handler = new DF_Contact_Inbound_ChangeTriggerHandler(Trigger.isExecuting, Trigger.size);

   if(Trigger.isInsert && Trigger.isBefore)
    { 
        handler.OnBeforeInsert( Trigger.new ,Trigger.newMap);
    }
    
    if(Trigger.isInsert && Trigger.isAfter)
    { 
        handler.OnAfterInsert( Trigger.new ,Trigger.newMap);
    }
    
     if(Trigger.isUpdate && Trigger.isBefore)
    { 
        
    }
    
    if(Trigger.isInsert && Trigger.isAfter)
    { 
        
    }
    
    if(Trigger.isUpdate && Trigger.isAfter)
    { 
        
    }
    
    
}