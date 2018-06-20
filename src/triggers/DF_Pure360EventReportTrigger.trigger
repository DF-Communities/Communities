trigger DF_Pure360EventReportTrigger on Pure360_Event_Report__c (before insert) {

  DF_Pure360EventReportTriggerHander handler = new DF_Pure360EventReportTriggerHander(Trigger.isExecuting, Trigger.size);

  if(Trigger.isInsert && Trigger.isBefore)  
  {
  handler.OnBeforeInsert(Trigger.new,Trigger.oldMap);  
  }

}