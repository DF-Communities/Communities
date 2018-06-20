@isTest
public class Dfc_FetchDAAData_Processor_Test{

 static testmethod void covermethod(){
 
 Test.startTest();
  Test.setMock(HttpCalloutMock.class, new Dfc_FetchDAAData_ProcessorMock());
  Dfc_FetchDAAData_Schedulable batch =new Dfc_FetchDAAData_Schedulable();
  batch.execute(null);
  Test.stopTest();
 
 }

}