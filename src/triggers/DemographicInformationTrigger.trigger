trigger DemographicInformationTrigger on Demographic_information__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

/*after delete, after insert, after undelete, 
after update, before delete, before insert, before update*/

    /* The code is broken down into a Trigger and an Apex “handler” class that implements the actual functionality.
       It’s best practice to only have one trigger for each object and to avoid complex logic in triggers. 
       To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic.*/

    System.debug('****** DemographicInfoTrigger ******');

    // Delegate responsibility to the DemographicInfoTriggerHandler Class.
    DemographicInfoTriggerHandler handler = new DemographicInfoTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore){
        //Call the Handler OnBeforeInsert Method and execute trigger logic.
        handler.OnBeforeInsert(Trigger.new, Trigger.newMap);
        
    }
   
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert( Trigger.new,Trigger.newMap);
        
    }
    /*
    else if(Trigger.isUpdate && Trigger.isBefore){
        
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        
    }
    else if(Trigger.isDelete && Trigger.isBefore){

    }
    else if(Trigger.isDelete && Trigger.isAfter){
      
    }
    else if(Trigger.isUnDelete){
  
    }*/

}