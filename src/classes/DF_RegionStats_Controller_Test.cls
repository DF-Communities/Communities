@isTest
public class DF_RegionStats_Controller_Test {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test APEX Class for DF_RegionStats_Controller Apex Class.
 *  Author  : Lakshmi Rajendram
 *  Date    : 13-07-2015
 *  Version : 0.1 Unit Test
 *
 *  Description:    Test APEX Class for DF_RegionStats_Controller Apex Class which 
 *                  realigns service usage records for a selected Service.
 *
 *                  *Note that since email messages aren’t sent from tests, and because the batch 
 *                  class is invoked by a test method, the email notifications won’t be sent in this case. 
 *
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ??
 *                             
*******************************************************************************************/
static testMethod void mainTest(){

       Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
       DF_Region__c dfr = (DF_Region__c )mapTestData.get('Region'); 
       DF_Region__c dfr2 = (DF_Region__c )mapTestData.get('Region2'); 
       DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion');
       
       DF_RegionStats_Controller drc = new  DF_RegionStats_Controller();
       drc.getStatistics(dfr.id);
       drc.getStatistics(dfr2.id);
}

}