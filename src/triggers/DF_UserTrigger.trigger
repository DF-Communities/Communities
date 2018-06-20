trigger DF_UserTrigger on User (after insert) {

   DF_User_TriggerHandler handler = new DF_User_TriggerHandler(); 

   if (Trigger.isInsert && Trigger.isAfter) {

           handler.OnAfterInsert(Trigger.New, Trigger.NewMap); 
   }

}