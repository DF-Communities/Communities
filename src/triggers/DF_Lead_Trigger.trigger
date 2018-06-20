trigger DF_Lead_Trigger on Lead (before update) {

 DF_Lead_TriggerHandler handler = new DF_Lead_TriggerHandler();

 if(Trigger.isUpdate && Trigger.isBefore){

  handler.OnBeforeUpdate(Trigger.new,Trigger.oldMap);
  
  
  }

}