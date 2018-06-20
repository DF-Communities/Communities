@isTest
public  class DF_Mail_ChampCloseSession_Bch_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_ChampCloseSession_Batcher
***********************************************************************************************/


static testMethod void MainTest () {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 
    DF_Event__c DFe = (DF_Event__c )mapTestData.get('FriendSession');
    
    Id OW = Mail_Utils.getOrgWideEmail() ; 
    
    Datetime d = System.today().addDays( -14 );
       
    DFchamp.Status__c = 'Converted';
    DFe.Event_Status__c = 'Available';
    DFe.Event_Date_Time__c = d;
    
    test.starttest(); 
    update DFe;
    update DFchamp ;
    
    DF_Mail_ChampCloseSession_Batcher batch = new DF_Mail_ChampCloseSession_Batcher ();
    batch.query =  'Select ID, Portal_Contact__c from DF_Contact__c where id=:DFchamp.id';
     
    batch.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_14_DAYS;
    batch.days = -14;
    database.executebatch(batch,1);
    System.assert(true);
    
    
    
   
}

static testMethod void MainTest2 () {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 
    DF_Event__c DFe = (DF_Event__c )mapTestData.get('FriendSession');
     
    
    Id OW = Mail_Utils.getOrgWideEmail() ; 
    
    Datetime d = System.today().addDays( -30 );
    
    DFchamp.Status__c = 'Converted';
    DFe.Event_Status__c = 'Available';
    DFe.Event_Date_Time__c = d;
    
    test.starttest(); 
    update DFe;
    update DFchamp ;
    
    DF_Mail_ChampCloseSession_Batcher batch = new DF_Mail_ChampCloseSession_Batcher ();
    batch.query =  'Select ID, Portal_Contact__c from DF_Contact__c  where  id=:DFchamp.id';
    
     
        
    batch.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_30_DAYS;
    batch.days = -30;
    database.executebatch(batch,1);
    System.assert(true);   
     
   
}

static testMethod void MainTest3 () {
    
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 
    DF_Event__c DFe = (DF_Event__c )mapTestData.get('FriendSession');
     
    
    Id OW = Mail_Utils.getOrgWideEmail() ; 
    
    Datetime d = System.today().addDays( -45 );
    
    DFchamp.Status__c = 'Converted';
    DFe.Event_Status__c = 'Available';
    DFe.Event_Date_Time__c = d;
    
    test.starttest();
    update DFe;
    update DFchamp ;
    
    DF_Mail_ChampCloseSession_Batcher batch = new DF_Mail_ChampCloseSession_Batcher ();
    batch.query =  'Select ID, Portal_Contact__c from DF_Contact__c  where  id=:DFchamp.id';
    batch.templateName = DF_Mail_Utils.VF_CLOSE_SESSIONS_AFTER_45_DAYS;
    batch.days = -45;
    database.executebatch(batch,1);
    System.assert(true);   
     
   
}

}