/******************************************************************************************
 *  Modification History
 *  Date            Who         Description 
    23/01/2015      Gary Grant  Insert and Update Before Handlers                    
*******************************************************************************************/

Trigger DF_EventTrigger on DF_Event__c (after delete, after insert, after undelete, 
    after update, before delete, before insert, before update) {

    /* The code is broken down into a Trigger and an Apex “handler” class that implements the actual functionality.
       It’s best practice to only have one trigger for each object and to avoid complex logic in triggers. 
       To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic.*/

    // Delegate responsibility to the DF_EventTriggerHandler Class.
    DF_EventTriggerHandler handler = new DF_EventTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore){       
    
        handler.OnBeforeInsert(Trigger.new);
    
    }
    
    else if(Trigger.isInsert && Trigger.isAfter){
        //Call the Handler OnAfterInsert Method and execute trigger logic.
        //2014-04-24 : SM : Disabling this call to stop TOO MANY SOQL QUERIES error during deployment
        handler.OnAfterInsert(Trigger.new, Trigger.newMap);
         //We need to update the GeoLocation field on the Event for the Saved Search functionality
        List<Id> eventIdList = new List<Id>();
        for (DF_Event__c dfe : trigger.new){
            eventIdList.add(dfe.Id);
        }
        if (eventIdList.size() == 1){
            LocationCallouts.getLocationForEvent(eventIdList[0]);
        }
       //handler.updateChampionsFriendsCounts(null,trigger.new, null);
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
    
        handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
        
    }
    
    else if(Trigger.isUpdate && Trigger.isAfter){
        //Call the Handler OnAfterUpdate Method and execute trigger logic.
        //2014-04-24 : SM : Disabling this call to stop TOO MANY SOQL QUERIES error during deployment
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
        //We now need to send any notification emails if this event is CANCELLED or UPDATED
          DFEventTriggerMethods.sendEmailNotifications(trigger.new, trigger.oldMap);
        //trigger has query row 50001 limit issues
        //handler.updateChampionsFriendsCounts(trigger.old,trigger.new, trigger.oldMap);
       
        List<Id> eventIdList = new List<Id>();
        for (DF_Event__c dfe : trigger.new){
            DF_Event__c oldEvent = trigger.oldMap.get(dfe.Id);
            if (dfe.Location_Geographic_Details__Latitude__s == null || dfe.Postcode__c != oldEvent.Postcode__c){
                eventIdList.add(dfe.Id);
            }
        }
        if (eventIdList.size() == 1 && !system.isFuture() && !system.isBatch()){
            LocationCallouts.getLocationForEvent(eventIdList[0]);
        }        
        

    }
    else if(Trigger.isDelete && Trigger.isBefore){

    }
    else if(Trigger.isDelete && Trigger.isAfter){
        //Call the Handler OnAfterDelete Method and execute trigger logic.
        //2014-04-24 : SM : Disabling this call to stop TOO MANY SOQL QUERIES error during deployment
        handler.OnAfterDelete(Trigger.old, Trigger.oldMap);

    }
    else if(Trigger.isUnDelete){
  
    }

}