@isTest
public class DF_Mail_PopulateSurveyURL_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            29-10-2015
     * @description     Test class for DF_Mail_PopulateSurveyURL
***********************************************************************************************/

static testMethod void CoverMethod () {

   Date dt= System.today().addDays(2);
   Date d =date.newinstance(dT.year(), dT.month(), dT.day());
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   DF_Event__c De = (DF_Event__c )mapTestData.get('ChampCourse');
   DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');     
   
   test.starttest();
   update DFeatt;
   
   DF_Mail_PopulateSurveyURL ctr = new DF_Mail_PopulateSurveyURL();
   DF_EventAttendee__c ev = ctr.Attendees;
   
}

}