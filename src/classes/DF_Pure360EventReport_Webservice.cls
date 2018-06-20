@RestResource(urlMapping='/pure360EventReport/*')
global without sharing class DF_Pure360EventReport_Webservice {
       
   
 @HttpPost
 global static void doPost() {
  system.debug('pure http post' );
   RestRequest  req = RestContext.request;
   RestResponse res = RestContext.response;
      system.debug('Here is the request - '+req);
      system.debug('Here is the request headers - '+req.headers);
      system.debug('Here is the request params - '+req.params);
      system.debug('Here is the request remote address - '+req.remoteAddress);
      system.debug('Here is the request body - '+req.requestBody);
      system.debug('Here is the request url - '+req.requestURI);
      system.debug('Here is the request resource path - '+req.resourcePath);
    
   
 List<Pure360_Event_Report__c> lisEvents = new List<Pure360_Event_Report__c>();
   
  Pure360_Event_Report__c report = new Pure360_Event_Report__c();
  report.type__c = System.RestContext.request.params.get('type');
  report.deliveryDate__c = DF_Utils.getDatetimeforUnixTimeStamp(System.RestContext.request.params.get('deliveryDate'));
  report.Delivery_ID__c = System.RestContext.request.params.get('Delivery_ID');
  report.MessageName__c = System.RestContext.request.params.get('messageName');
  report.lastName__c = System.RestContext.request.params.get('lastName');
  report.firstName__c = System.RestContext.request.params.get('firstName');
  report.Event_Date__c = DF_Utils.getDatetimeforUnixTimeStamp(System.RestContext.request.params.get('Event_date'));
  report.notificationSubject__c = System.RestContext.request.params.get('notificationSubject');
  report.email__c = System.RestContext.request.params.get('email');
  report.Click_Date__c = DF_Utils.getDatetimeforUnixTimeStamp(System.RestContext.request.params.get('Click_Date'));
  report.Click_Url__c = System.RestContext.request.params.get('Click_Url');

  lisEvents.add(report);
     
    if(lisEvents.size()>0){
      insert lisEvents;
    }  
  
  
 }
 //String type,String Event_date,String email,String mobile,String messageName,String deliveryDate,String device_type,String device_OS,String device_Browser,String Delivery_ID,String firstName,String lastName,String notificationSubject,String Click_Date

    
}