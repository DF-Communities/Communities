@IsTest 
public with sharing class DF_Mail_DoAllMailBatches_Test {
/******************************************************************************************
 *    
 *  Purpose : APEX test class for DF_Mail_DoAllMailBatches.
 *  Author  : CSL
 *  Date    : 30-09-2015
 *  Version : 1.0
 *
 *  Description:    Apex test class.
 *               
 *  Modification History
 *  Date            Who         Description 
 *                    
*******************************************************************************************/

  static testmethod void coverMethod() {
  
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('DFc');
   Test.startTest();
      
    
      string sch = '0 1 1 * * ?';
       system.schedule ('Batch', sch,new DF_Mail_DoAllMailBatches());
    
  }
}