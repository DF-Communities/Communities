@isTest
public class DF_Mail_NeverRunSession_Bch_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_NeverRunSession_Batcher
***********************************************************************************************/

static testMethod void CoverMethod () {

   Id OW = Mail_Utils.getOrgWideEmail() ; 
   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
   integer days30 = -30;
   integer days60 = -60;
   integer days120= -120 ;
   
   Date dt1 = System.today().addDays(days30 );
   Date d1 =date.newinstance(dT1.year(), dT1.month(), dT1.day());
 
   Date dt2 = System.today().addDays(days60 );
   Date d2 =date.newinstance(dT2.year(), dT2.month(), dT2.day());  

   Date dt3 = System.today().addDays(days120);
   Date d3 =date.newinstance(dT3.year(), dT3.month(), dT3.day());
      
       
  test.starttest();
  DF_Contact__c Dc = (DF_Contact__c )mapTestData.get('Champion2'); 
  DF_Event__c De = (DF_Event__c )mapTestData.get('FriendSession2');
   
   delete De;
   dc.Code_Verefied__c = True;
   dc.Status__c = 'Converted';
   dc.Date_of_Champion_Training__c = d1;
  update dc ;
   
  DF_Mail_NeverRunSession_Batcher batch = new DF_Mail_NeverRunSession_Batcher();
  
  batch.templateName = DF_Mail_Utils.VF_WITHOUTSESSIONS1M;
  batch.days = -30;
  database.executebatch(batch,1);
 
  
  DF_Contact__c Dc2 =[select Date_of_Champion_Training__c from DF_Contact__c where id =:dc.id];
  Dc2.Date_of_Champion_Training__c =d2;
  update Dc2;
  
  
  batch.templateName = DF_Mail_Utils.VF_WITHOUTSESSIONS2M;
  batch.days = -60;
  database.executebatch(batch,1);
  
  
  DF_Contact__c Dc3 =[select Date_of_Champion_Training__c from DF_Contact__c where id =:dc.id];
  Dc3.Date_of_Champion_Training__c =d2;
  update Dc3;
     

  batch.templateName = DF_Mail_Utils.VF_WITHOUTSESSIONS4M;
  batch.days = -1200;
  database.executebatch(batch,1);
  test.stoptest();
   
}
}