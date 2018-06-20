@isTest
public  class DF_Mail_TriggerClass_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_Triggerclass
***********************************************************************************************/


static testMethod void CoverMethodemail1(){

   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   
   DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
   DF_Event__c De = (DF_Event__c )mapTestData.get('ChampCourse');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   List<DF_EventAttendee__c> lisatt = new List<DF_EventAttendee__c>();
   DFeatt.EventAttendeeStatus__c = 'Attended';
   Dc.Status__c = 'Converted';
   
   test.starttest();
   update DFeatt;
   lisatt.add(DFeatt);
   Update DC;
   ApexPages.StandardController sc = new ApexPages.StandardController(De);      
   DfEventAttendeeController controller = new DfEventAttendeeController(sc);
  
   PageReference pageRef = Page.DF_Contact_Status;
   pageRef.getParameters().put('id', String.valueOf(De.Id));
   Test.setCurrentPage(pageRef);
        
   controller.save();
   DF_Mail_Triggerclass.emailtriggers(lisatt);
   
}

static testMethod void CoverMethodemail2(){

   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   
   DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
   DF_Event__c De = (DF_Event__c )mapTestData.get('ChampCourse');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   List<DF_EventAttendee__c> lisatt = new List<DF_EventAttendee__c>();
   DFeatt.EventAttendeeStatus__c = 'Attended';
   Dc.Status__c = 'Converted';
   Dc.Type_of_Champion__c = 'Super Champion';
   
   
   test.starttest();
   update DFeatt;
   lisatt.add(DFeatt);
   Update DC;
   
   DF_Mail_Triggerclass.emailtriggers(lisatt);
   
}

static testMethod void CoverMethodemail3(){

   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   
   DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
   DF_Event__c De = (DF_Event__c )mapTestData.get('ChampCourse');
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion');
   List<DF_EventAttendee__c> lisatt = new List<DF_EventAttendee__c>();
   DFeatt.EventAttendeeStatus__c = 'No Show';
   Dc.Status__c = 'Prospective';
   
   test.starttest();
   update DFeatt;
   lisatt.add(DFeatt);
   Update DC;
   DF_Mail_Triggerclass.emailtriggers(lisatt);
   
}

}