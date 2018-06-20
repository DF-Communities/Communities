@isTest
private class DF_Pure360EventReportTriggerHander_Test{

  static testMethod void myUnitTest() {
  Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
  DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc'); 
  
  List<Pure360_Event_Report__c> events = new List<Pure360_Event_Report__c>();
  Pure360_Event_Report__c report = new Pure360_Event_Report__c();
  report.type__c = 'Click';
  report.MessageName__c = 'messageName';
  report.lastName__c = 'test';
  report.firstName__c = 'test';
  report.Event_Date__c = DF_Utils.getDatetimeforUnixTimeStamp('1477562400');
  report.email__c = 'test.testcontact@myemail.com';
  report.Click_Date__c = system.now();

  events.add(report );
  insert events;
  test.starttest();
  DF_Pure360EventReportTriggerHander handler = new DF_Pure360EventReportTriggerHander(false, 1);
  handler.onBeforeInsert(events,null);
  system.assertNotEquals(null,report.DF_Contact__c);
  system.assertNotEquals(null,report.Click_Date__c);
  
  }


}