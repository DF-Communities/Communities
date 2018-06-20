@isTest
public class DF_Mail_PopulateCourseDetails_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            29-10-2015
     * @description     Test class for DF_Mail_PopulateCourseDetails
***********************************************************************************************/

static testMethod void CoverMethod () {

   Date dt= System.today().addDays(2);
   Date d =date.newinstance(dT.year(), dT.month(), dT.day());
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   DF_Event__c De = (DF_Event__c )mapTestData.get('ChampCourse');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   
   De.Event_Status__c = 'Available';
   De.Event_Date_Time__c = d;
   De.Event_End_Date_Time__c = d;
   
   test.starttest();
   DF_Mail_PopulateCourseDetails ctr = new DF_Mail_PopulateCourseDetails();
   ctr.dfContactid = Dc.id;
   DF_EventAttendee__c ev = ctr.CourseDetails;
   Double i = ctr.offset;
   
}

}