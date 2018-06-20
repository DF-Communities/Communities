@isTest
public class DF_Mail_ChampNoSessions_Bch_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_ChampNoSessions_Batcher
***********************************************************************************************/

static testMethod void CoverMethod () {

    Id OW = Mail_Utils.getOrgWideEmail() ; 
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   
    Date d = System.today().addDays(-60 );
      
    DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession');
    DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion'); 
     
     
    dc.Code_Verefied__c = True;
    dc.Status__c = DF_Utils.STATUS_CONVERTED;
    de.Event_Date_Time__c = d;   
   
  
    test.starttest();
    update de;
    update dc;
    
    DF_Mail_ChampNoSessions_Batcher batch = new DF_Mail_ChampNoSessions_Batcher();
    batch.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_2_MONTHS;
    batch.days = -60;
    Database.executeBatch( batch, 1 );
  }
  
  static testMethod void CoverMethod2 () {
  
   Date d = System.today().addDays(-120 );
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   
   
   dc.Code_Verefied__c = True;
   dc.Status__c = DF_Utils.STATUS_CONVERTED;
   de.Event_Date_Time__c = d;
 

  test.starttest();
  update de;
  update dc ;
  DF_Mail_ChampNoSessions_Batcher batch = new DF_Mail_ChampNoSessions_Batcher();
  batch.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_4_MONTHS;
  batch.days = -120;
  Database.executeBatch( batch, 1 );
 
 }

  static testMethod void CoverMethod3 () {
  
   Date d = System.today().addDays(-180 );
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   
   
   dc.Code_Verefied__c = True;
   dc.Status__c = DF_Utils.STATUS_CONVERTED;
   de.Event_Date_Time__c=d;

  
  test.starttest();
  update de;
  update dc ;
  DF_Mail_ChampNoSessions_Batcher batch = new DF_Mail_ChampNoSessions_Batcher();
  batch.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_6_MONTHS;
  batch.days = -180;
  Database.executeBatch( batch, 1 );
 
 }
 
   static testMethod void CoverMethod4 () {
  
   Date d = System.today().addDays(-240 );
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();    
   DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   
   
  dc.Code_Verefied__c = True;
  dc.Status__c = DF_Utils.STATUS_CONVERTED;
  de.Event_Date_Time__c=d;

 
  test.starttest();
  update de;
  update dc ;
  DF_Mail_ChampNoSessions_Batcher batch = new DF_Mail_ChampNoSessions_Batcher();
  batch.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_8_MONTHS;
  batch.days = -240;
  Database.executeBatch( batch, 1 );
 
 }

   static testMethod void CoverMethod5 () {
  
   /*Date d = System.today().addDays(-300);
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();    
   DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   
   
   dc.Code_Verefied__c = True;
   dc.Status__c = DF_Utils.STATUS_CONVERTED;
   de.Event_Date_Time__c=d;
  
     
  test.starttest();
  update de;
  update dc ;   
  DF_Mail_ChampNoSessions_Batcher batch = new DF_Mail_ChampNoSessions_Batcher();
  batch.templateName = DF_Mail_Utils.VF_CHAMPS_NO_SESSIONS_IN_10_MONTHS;
  batch.days = -300;
  batch.newStatus = DF_Utils.STATUS_RETIRED;
  Database.executeBatch( batch, 1 );*/
 
 }
}