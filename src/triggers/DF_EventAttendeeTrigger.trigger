trigger DF_EventAttendeeTrigger on DF_EventAttendee__c (after delete, after insert, after undelete, 
    after update, before delete, before insert, before update){

    /* The code is broken down into a Trigger and an Apex “handler” class that implements the actual functionality.
       It’s best practice to only have one trigger for each object and to avoid complex logic in triggers. 
       To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic.*/

    System.debug('****** DF_EventAttendeeTrigger ******');

    // Delegate responsibility to the DF_EventAttendeeTriggerHandler Class.
    DF_EventAttendeeTriggerHandler handler = new DF_EventAttendeeTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if(Trigger.isInsert && Trigger.isBefore){

    }
    else if(Trigger.isInsert && Trigger.isAfter){
        //Call the Handler OnAfterInsert Method and execute trigger logic.
        handler.OnAfterInsert(Trigger.new, Trigger.newMap);
        //2014-04-14 : CSL : Call the method to send all appropriate email notifications
        Set<Id> inIdSet = new Set<Id>();
        for (DF_EventAttendee__c dfa : trigger.new){
            inIdSet.add(dfa.Id);
        }
        DF_EventAttendeeTriggerMethods.processNotificationEmailsFuture(inIdSet, false, true);
        
    }
    else if(Trigger.isUpdate && Trigger.isBefore){

    } 
    else if(Trigger.isUpdate && Trigger.isAfter){
        //Call the Handler OnAfterUpdate Method and execute trigger logic.
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
        //2014-04-14 : CSL : Call the method to send all appropriate email notifications
        Set<Id> inIdSet = new Set<Id>();
        for (DF_EventAttendee__c dfa : trigger.new){
            inIdSet.add(dfa.Id);
        }
        DF_EventAttendeeTriggerMethods.processNotificationEmailsFuture(inIdSet, false, false);
        
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        //2014-04-14 : CSL : Call the method to send all appropriate email notifications
        //Set<Id> inIdSet = new Set<Id>();
        //for (DF_EventAttendee__c dfa : trigger.old){
        //  inIdSet.add(dfa.Id);
        //}
        //DF_EventAttendeeTriggerMethods.processNotificationEmails(inIdSet, true, false);
         //2014-04-14 : CSL : Call the method to send all appropriate email notifications
        DF_EventAttendeeTriggerMethods.processNotificationEmails(trigger.old, true, false);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        //Call the Handler OnAfterDelete Method and execute trigger logic.
        handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
       
        
    }
    else if(Trigger.isUnDelete){

    }  
}