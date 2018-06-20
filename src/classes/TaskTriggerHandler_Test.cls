@isTest
public class TaskTriggerHandler_Test{

 static testmethod void covermethod(){
 
 Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
 

 DF_Contact__c Dc1 = (DF_Contact__c )mapTestData.get('Champion2');
  
  DF_Event__c DFe = (DF_Event__c )mapTestData.get('FriendSession2');
  
   DFe.Event_Status__c = DF_Utils.EVENT_STATUS_COMPLETED;  
   DFe.Number_of_Attendees__c =100;
   Dc1.Total_No_of_Friends_Created__c =26;

  
   test.starttest();
   update Dc1;
   update DFe;
   
   DF_Mail_NoOfFriends_Batcher batch = new DF_Mail_NoOfFriends_Batcher();
   batch.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
   batch.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;
   Database.executeBatch( batch, 1 );
   
   Task tsk =new Task();
   tsk.Description ='creating 26 Dementia Friends Email Id:TEREF16';
   tsk.WhatId=Dc1.Id;
   insert tsk;
   Task t = [Select DFC_Email_Tracker__c,Description from Task where Id=:tsk.Id];
  system.assert(integer.valueOf(t.Description.substringBetween('creating','Dementia Friends').replaceAll( '\\s+', ''))==26);
   Task tsk2 =new Task();
   tsk2.Description ='Email Id:TEREF1';
   tsk2.WhatId=Dc1.Id;
   insert tsk2;
   
   Task t2 = [Select DFC_Email_Tracker__c from Task where Id=:tsk2.Id];
   system.assert(t2.DFC_Email_Tracker__c=='TEREF1');
  }

}