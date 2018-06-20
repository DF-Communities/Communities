trigger TaskTrigger on Task (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
/*
* 2015-07-23 : SM : New trigger to process inserted / updated / deleted Tasks
*/

System.debug('****** TaskTrigger ******');

    // Delegate responsibility to the TaskTriggerHandler Class.
    TaskTriggerHandler handler = new TaskTriggerHandler(Trigger.isExecuting, Trigger.size);
    

      if ( trigger.isAfter && trigger.isInsert ){
    system.debug('*******after trigger insert entry*******');
               
       //handler.OnBeforeInsert(Trigger.new,Trigger.newMap);
                  
    } else if ( trigger.isAfter && trigger.isUpdate){
            
        
    } else if (trigger.isBefore && trigger.isInsert){
    
         handler.OnBeforeInsert(Trigger.new); 
               
    } else if (trigger.isBefore && trigger.isUpdate){
            
        
    }


}