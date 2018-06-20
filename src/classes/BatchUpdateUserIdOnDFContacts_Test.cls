@isTest
public class BatchUpdateUserIdOnDFContacts_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for BatchUpdateUserIdOnDFContacts
***********************************************************************************************/

static testMethod void CoverMethod () {

   
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();   
   DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('DFc');
   BatchUpdateUserIdOnDFContacts batch = new BatchUpdateUserIdOnDFContacts();
  // batch.query =  'Select ID, Portal_Contact__c ,Portal_User__c from DF_Contact__c  where  id=DFc.id';
   test.starttest();
   Database.executeBatch( batch,4);
   

}
}