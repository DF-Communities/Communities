@isTest
public class DF_Mail_NoOfFriends_bch_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_NoOfFriends_batcher
***********************************************************************************************/
@testSetup
  public static void testData() {

  Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   
  DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion2');
   
  DF_Event__c DFe = (DF_Event__c )mapTestData.get('FriendSession2');
  
  DF_Contact__c Dc2 = (DF_Contact__c )mapTestData.get('Champion');
   
  DF_Event__c DFe2 = (DF_Event__c )mapTestData.get('FriendSession');

  }
static testMethod void CoverMethod25Friends () {
 Id OW = Mail_Utils.getOrgWideEmail() ;
 
  DF_Contact__c  DFc= [select id,Status__c,recordtype_name__c,Total_No_of_Friends_Created__c from DF_Contact__c where email__c ='test.testcontact3@myemail.com'];
  DF_Event__c DFe =[select Id,Event_Date__c,Number_of_Attendees__c,Session_Organiser__r.name,Event_Status__c,name from DF_Event__c where name='Test Friends Session 2' limit 1];
  DFe.Number_of_Attendees__c=26;
  DFe.Event_Status__c = DF_Utils.EVENT_STATUS_COMPLETED;
  DFc.Total_No_of_Friends_Created__c = 26;
  DFc.Status__c =  DF_Utils.STATUS_CONVERTED ;

 
 
 
  test.starttest();
  
  update DFc ;
  update DFe ; 
     

  DF_Mail_NoOfFriends_batcher batch = new DF_Mail_NoOfFriends_batcher();
  system.debug('MY Query'+batch.query );
  batch.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
  batch.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;

  Database.executeBatch( batch, 1 );
  
   }
   
 static testMethod void CoverMethod50Friends () {
  
  DF_Contact__c  DFc= [select id,Status__c,Total_No_of_Friends_Created__c from DF_Contact__c where email__c ='test.testcontact3@myemail.com'];
  DF_Event__c DFe =[select Id,Number_of_Attendees__c,Event_Status__c,name from DF_Event__c where name='Test Friends Session 2' limit 1];
  
  DFe.Event_Status__c = DF_Utils.EVENT_STATUS_COMPLETED;
  DFe.Number_of_Attendees__c=51;
  DFc.Status__c =  DF_Utils.STATUS_CONVERTED ;
  
  test.starttest();
  update DFc ;
  update DFe ;  
  DF_Mail_NoOfFriends_batcher batch = new DF_Mail_NoOfFriends_batcher();
  batch.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
  batch.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;

  Database.executeBatch( batch, 1 );
  
   }
   
   static testMethod void CoverMethod75Friends () {
 
 DF_Contact__c  DFc= [select id,recordtype_name__c,Status__c,Total_No_of_Friends_Created__c from DF_Contact__c where email__c ='test.testcontact3@myemail.com'];
 DF_Event__c DFe =[select Id,Number_of_Attendees__c,Event_Date__c,Is_Last_Event__c ,Event_Status__c,name from DF_Event__c where name='Test Friends Session 2' limit 1];
  
  DFe.Event_Status__c = DF_Utils.EVENT_STATUS_COMPLETED;
  DFe.Number_of_Attendees__c = 75;
  DFc.Status__c =  DF_Utils.STATUS_CONVERTED ;
  
  test.starttest();
  
  
  update DFc ;
  update DFe ;
  
  DF_Mail_NoOfFriends_batcher batch = new DF_Mail_NoOfFriends_batcher();
  batch.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
  batch.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;

  Database.executeBatch( batch, 1 );
  
   }
   
 
   
 static testMethod void CoverMethod100Friends () {
  DF_Contact__c  DFc= [select id,Status__c,recordtype_name__c,Total_No_of_Friends_Created__c from DF_Contact__c where email__c ='test.testcontact3@myemail.com'];
  DF_Event__c DFe =[select Id,Event_Date__c,Number_of_Attendees__c,Session_Organiser__r.name,Event_Status__c,name from DF_Event__c where name='Test Friends Session 2' limit 1];
  
  DFe.Event_Status__c = DF_Utils.EVENT_STATUS_COMPLETED;
  DFe.Number_of_Attendees__c=101;
  DFc.Status__c =  DF_Utils.STATUS_CONVERTED ;
  
  test.starttest();
  update DFc ;
  update DFe ;  
  DF_Mail_NoOfFriends_batcher batch = new DF_Mail_NoOfFriends_batcher();
  batch.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
  batch.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;

  Database.executeBatch( batch, 1 );
  
   }
  static testMethod void CoverMethod151Friends () {
   DF_Contact__c  DFc= [select id,Status__c,Total_No_of_Friends_Created__c from DF_Contact__c where email__c ='test.testcontact3@myemail.com'];
  DF_Event__c DFe =[select Id,Event_Status__c,Number_of_Attendees__c,name from DF_Event__c where name='Test Friends Session 2' limit 1];
  
  DFe.Event_Status__c = DF_Utils.EVENT_STATUS_COMPLETED;
  DFe.Number_of_Attendees__c = 151;
  DFc.Status__c =  DF_Utils.STATUS_CONVERTED ;
  
  test.starttest();
  update DFc ;
  update DFe ;  
  DF_Mail_NoOfFriends_batcher batch = new DF_Mail_NoOfFriends_batcher();
  batch.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
  batch.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;

  Database.executeBatch( batch, 1 );
  
   }
   
    static testMethod void CoverMethod251Friends () {
   DF_Contact__c  DFc= [select id,Status__c,Total_No_of_Friends_Created__c from DF_Contact__c where email__c ='test.testcontact3@myemail.com'];
  DF_Event__c DFe =[select Id,Event_Status__c,Number_of_Attendees__c,name from DF_Event__c where name='Test Friends Session 2' limit 1];
  
  DFe.Event_Status__c = DF_Utils.EVENT_STATUS_COMPLETED;
  DFe.Number_of_Attendees__c = 251;
  DFc.Status__c =  DF_Utils.STATUS_CONVERTED ;
  
  test.starttest();
  update DFc ;
  update DFe ;  
  DF_Mail_NoOfFriends_batcher batch = new DF_Mail_NoOfFriends_batcher();
  batch.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
  batch.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;

  Database.executeBatch( batch, 1 );
  
   }
   
    static testMethod void CoverMethod300Friends () {
   DF_Contact__c  DFc= [select id,Status__c,Total_No_of_Friends_Created__c from DF_Contact__c where email__c ='test.testcontact3@myemail.com'];
  DF_Event__c DFe =[select Id,Event_Status__c,Number_of_Attendees__c,name from DF_Event__c where name='Test Friends Session 2' limit 1];
  
  DFe.Event_Status__c = DF_Utils.EVENT_STATUS_COMPLETED;
  DFe.Number_of_Attendees__c = 300;
  DFc.Status__c =  DF_Utils.STATUS_CONVERTED ;
  
  test.starttest();
  update DFc ;
  update DFe ;  
  DF_Mail_NoOfFriends_batcher batch = new DF_Mail_NoOfFriends_batcher();
  batch.templatename1 = DF_Mail_Utils.VF_NO_OF_FRIENDS;
  batch.templatename2 = DF_Mail_Utils.VF_NO_OF_FRIENDS_AND_CERT ;

  Database.executeBatch( batch, 1 );
  
   }
    
}