@isTest
public class DF_Mail_CourseReminder_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_CourseReminder
***********************************************************************************************/

static testMethod void CoverMethod () {
    
   Id OW = Mail_Utils.getOrgWideEmail() ; 
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   
   Datetime d = System.today().addDays( 2 );
   DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
   DF_Event__c De = (DF_Event__c )mapTestData.get('ChampCourse');
   
   de.Event_Status__c = 'Available';
   de.Event_Date_Time__c = d;
   de.Event_End_Date_Time__c = d; 
   
   test.starttest();
   update  De; 
   
   DF_Mail_CourseReminder batch = new DF_Mail_CourseReminder();   
   batch.templateName = DF_Mail_Utils.VF_DFC_COURSE_REMINDER;
   Database.executeBatch( batch, 1 );
    
}
}