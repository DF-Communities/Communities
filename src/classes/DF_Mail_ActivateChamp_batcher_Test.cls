@isTest
public class DF_Mail_ActivateChamp_batcher_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_ActivateChamp_batcher
***********************************************************************************************/

static testMethod void CoverMethod () {

   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   
   Datetime dt = System.today().addDays(-14 );
   Date d =date.newinstance(dT.year(), dT.month(), dT.day());
   DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
   DF_Event__c De = (DF_Event__c )mapTestData.get('ChampCourse');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   DF_Event__c Def = (DF_Event__c )mapTestData.get('FriendSession');
      
   DFeatt.Event_Status__c = 'Available';
   DFeatt.EventAttendeeStatus__c ='Attended';
   dc.Status__c = 'Converted';
   de.Event_Date_Time__c = d;
   dc.Date_of_champion_training__c = d;
   
   
   
   test.starttest();
   update  DFeatt;
   update  De;
   update dc ;
   delete Def;
   
   DF_Mail_ActivateChamp_batcher batch = new DF_Mail_ActivateChamp_batcher();
   batch.days =-14;
   Database.executeBatch( batch, 1 );

}
}