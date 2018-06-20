@isTest
public class DF_RegionStats_Process_Batcher_Test {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test APEX Class for DF_RegionStats_Process_Batcher Apex Class.
 *  Author  : Lakshmi Rajendram
 *  Date    : 13-07-2015
 *  Version : 0.1 Unit Test
 *
 *  Description:    Test APEX Class for DF_RegionStats_Process_Batcher Apex Class which 
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
       DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 
       DF_Region__c dfr2 = (DF_Region__c )mapTestData.get('Region2'); 
       
       Test.startTest();
       
       DF_RegionStats_Processor dfp = new  DF_RegionStats_Processor ();
       dfp.processStats(dfr);
       dfp.processStats(dfr2);

       
        DF_RegionStats_Process_Batcher batcher = new DF_RegionStats_Process_Batcher();
        database.executebatch(batcher);
       Test.stopTest();       
       
       List<DF_Region_Statistics__c> rstat =[Select id from DF_Region_Statistics__c];
       system.assert(rstat.size()>0,'Stat record created');
}

}