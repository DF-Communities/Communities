trigger DF_ContactTrigger on DF_Contact__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    /* The code is broken down into a Trigger and an Apex “handler” class that implements the actual functionality.
       It’s best practice to only have one trigger for each object and to avoid complex logic in triggers. 
       To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic.*/

    System.debug('DF_ContactTrigger');

    // Delegate responsibility to the DF_ContactTriggerHandler Class.
    DF_ContactTriggerHandler handler = new DF_ContactTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore && !DF_Utils.isDisabledTriggers())
    {
 
        System.debug('DF_ContactTrigger - Insert Before');
        handler.OnBeforeInsert(Trigger.new, Trigger.newMap);

    }
    else if(Trigger.isInsert && Trigger.isAfter && !DF_Utils.isDisabledTriggers()){

        System.debug('DF_ContactTrigger - Insert After');
        handler.OnAfterInsert(Trigger.new, Trigger.newMap);
        DFContactTriggerMethods.createContacts(trigger.new);
         DFP_Utils.updatePartnerAdministrators(trigger.New);
          
        //2014-04-30 : SM : We need to call an @future method to update the DF Contact
        //with the created Contact record (field : Portal_Contact__c)
        Set<Id> dfContactIDs = new Set<Id>();   
        for (DF_Contact__c dfc : trigger.new){
            dfContactIDs.add(dfc.Id);
        }     
        
        if (dfContactIDs.size() > 0 && !system.isFuture() && !system.isBatch()){
            DFContactTriggerMethods.assignPortalContact(dfContactIDs);
        }
        
        
    }
    else if(Trigger.isUpdate && Trigger.isBefore && !DF_Utils.isDisabledTriggers())
    {

        System.debug('DF_ContactTrigger - Update Before');
        handler.OnBeforeUpdate(Trigger.old,Trigger.oldMap,Trigger.new, Trigger.newMap);
    }

    else if(Trigger.isUpdate && Trigger.isAfter && !DF_Utils.isDisabledTriggers()){

        System.debug('DF_ContactTrigger - Update After');
        handler.OnAfterUpdate(Trigger.oldMap, Trigger.new, Trigger.newMap);

        System.debug('DF_ContactTrigger - Calling Update');
        if(!system.isFuture()&& !system.isBatch() ){
            DFContactTriggerMethods.updateContacts(trigger.new);
        }
    }

    else if(Trigger.isDelete && Trigger.isBefore && !DF_Utils.isDisabledTriggers()){

    }


    else if(Trigger.isDelete && Trigger.isAfter && !DF_Utils.isDisabledTriggers()){

        handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        
    }

    else if(Trigger.isUnDelete && !DF_Utils.isDisabledTriggers()){
  
    }

}