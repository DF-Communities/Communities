/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for Dfc_ActionArea_TriggerHandler
 *  Author  : Lakshmi Vasudevan
 *  Date    : 31-05-2016
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
private class Dfc_ActionArea_TriggerHandler_Test {


     @testSetup
    public static void setupData() {

        Dfc_DataFactory_Test.TestDataCreation(); 

    }
    
    static testMethod void myUnitTest() {
      DFC_Action_Area__c act =[select id,name from DFC_Action_Area__c  limit 1];
      DFC_Community__c community = [select id,name from DFC_Community__c limit 1];
      
      test.starttest();
      
      update act;
       DFC_Action_Area__c a= new DFC_Action_Area__c();
            a.Name = 'Action Area test';
            a.Active__c = true;
            a.Sequence__c = 10;
      insert a;
        
    }
}