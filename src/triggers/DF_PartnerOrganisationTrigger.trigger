trigger DF_PartnerOrganisationTrigger on Partner_Organisation__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    /* The code is broken down into a Trigger and an Apex “handler” class that implements the actual functionality.
       It’s best practice to only have one trigger for each object and to avoid complex logic in triggers. 
       To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic.*/

    System.debug('****** DF_PartnerOrganisationTrigger ******');

    // Delegate responsibility to the DF_PartnerOrgTriggerHandler Class.
    DF_PartnerOrgTriggerHandler handler = new DF_PartnerOrgTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore)
    {

    }
    else if(Trigger.isInsert && Trigger.isAfter){
        //Call the Handler OnAfterInsert Method and execute trigger logic.
        handler.OnAfterInsert(Trigger.new, Trigger.newMap);
        
    }
    else if(Trigger.isUpdate && Trigger.isBefore)
    {

    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        //Call the Handler OnAfterUpdate Method and execute trigger logic.
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
        
    }
    else if(Trigger.isDelete && Trigger.isBefore){

    }
    else if(Trigger.isDelete && Trigger.isAfter){
        //Call the Handler OnAfterDelete Method and execute trigger logic.
        handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
        
    }
    else if(Trigger.isUnDelete){
  
    }

}