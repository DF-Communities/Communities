@isTest
public class DF_Mail_PopulateSessionDetails_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            29-10-2015
     * @description     Test class for DF_Mail_PopulateSessionDetails
***********************************************************************************************/

static testMethod void CoverMethod () {

   Date dt= System.today().addDays(2);
   Date d =date.newinstance(dT.year(), dT.month(), dT.day());
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    
   DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('FriendAtten');
   DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession');
   
   De.Event_Status__c = 'Available';
   De.Event_Date_Time__c = d;
   De.Event_End_Date_Time__c = d;
   
   test.starttest();
   DF_Mail_PopulateSessionDetails ctr = new DF_Mail_PopulateSessionDetails();
   ctr.dfContactId = DFeatt.DF_Contact__c; 
   DF_EventAttendee__c ev = ctr.EventDetails;
   Double i = ctr.offset;
}

}