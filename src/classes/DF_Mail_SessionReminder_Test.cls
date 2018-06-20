@isTest
public class DF_Mail_SessionReminder_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_SessionReminder
***********************************************************************************************/

static testMethod void CoverMethod () {

   Id OW = Mail_Utils.getOrgWideEmail() ; 
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();

   Date dt= System.today().addDays(2);
   Date d =date.newinstance(dT.year(), dT.month(), dT.day());
   
   DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('FriendAtten');
   DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession');
   
   De.Event_Status__c = 'Available';
   De.Event_Date_Time__c = d;
   De.Event_End_Date_Time__c = d;
   
   test.starttest();
   
   update  De;
     
   DF_Mail_SessionReminder batch = new DF_Mail_SessionReminder();   
   batch.templateName = DF_MAIL_Utils.VF_DF_SESSION_REMINDER;
   Database.executeBatch( batch, 1 );
}
}