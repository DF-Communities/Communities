/*
* 2014-03-17 : SM : Test class for the BatchContactCreate class
* 2016-06-24 : Lakshmi Vasudevan
 */
 
@isTest
private class TestDFContactCleanup {

    private static final String RT_NEWSLETTER = 'E_Newsletter_Subscriber';
    private static final String RT_DEMENTIA_FRIEND = 'Dementia_Friend';
    private static final String RT_DEMENTIA_FRIEND_CHAMPION = 'Dementia_Friend_Champion';

    static testMethod void testBatchCreate() {
        Account portalAccount = new Account(Name = '** PORTAL REGISTRATION ACCOUNT **');
        insert portalAccount;
        
        Map<String, RecordType> dfContactRTMap = new Map<String, RecordType>();
        for (RecordType r : [select r.Id, r.DeveloperName from RecordType r where r.IsActive = true and r.SObjectType = 'DF_Contact__c']){
            dfContactRTMap.put(r.DeveloperName, r);
        }
        
        List<DF_Contact__c> contactsToSave = new List<DF_Contact__c>();
        
        /*for(integer i = 0; i<85; i++){
            DF_Contact__c dfc = new DF_Contact__c();
            dfc.RecordTypeId = dfContactRTMap.get(RT_DEMENTIA_FRIEND).Id;
            dfc.First_Name__c = 'DFirst' + i;
            dfc.Last_Name__c = 'DLast'+i;
            dfc.Email__c = 'dfirst' + i + '.dlast' + i + '@myemail.com';
            contactsToSave.add(dfc);
        }
        
        for(integer i = 0; i<85; i++){
            DF_Contact__c dfc = new DF_Contact__c();
            dfc.RecordTypeId = dfContactRTMap.get(RT_DEMENTIA_FRIEND_CHAMPION).Id;
            dfc.First_Name__c = 'CFirst' + i;
            dfc.Last_Name__c = 'CLast'+i;
            dfc.Email__c = 'cfirst' + i + '.clast' + i + '@myemail.com';
            contactsToSave.add(dfc);
        }
        
        for(integer i = 0; i<30; i++){
            DF_Contact__c dfc = new DF_Contact__c();
            dfc.RecordTypeId = dfContactRTMap.get(RT_NEWSLETTER).Id;
            dfc.First_Name__c = 'EFirst' + i;
            dfc.Last_Name__c = 'ELast'+i;
            dfc.Email__c = 'efirst' + i + '.elast' + i + '@myemail.com';
            contactsToSave.add(dfc);
            
            if (i == 0) system.debug('*** -- dfcEmail = ' + dfc.Email__c + ' -- ***');
        }
   
        insert contactsToSave;
        */
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');  
        DF_Contact__c dfc2 = (DF_Contact__c)mapTestData.get('Champion'); 
        test.startTest();
        dfc.name = 'test124';
        dfc2.name = 'test124';
        update dfc;
        update dfc2;
        contactsToSave.add(dfc);
        contactsToSave.add(dfc2);     
        
        
        DFContactCleanup dfcc = new DFContactCleanup();
        dfcc.query = 'Select d.Id, d.Name, d.First_Name__c, d.Last_Name__c from DF_Contact__c d LIMIT 200';
        
        ID batchprocessid = Database.executeBatch(dfcc);

        test.stopTest();

                
        /*DF_Contact__c dfcNewsLetter = [select d.Id, d.Name, d.First_Name__c, d.Last_Name__c from DF_Contact__c d where d.Email__c = 'efirst0.elast0@myemail.com' LIMIT 1];
        DF_Contact__c dfcFriend = [select d.Id, d.Name, d.First_Name__c, d.Last_Name__c from DF_Contact__c d where d.Email__c = 'dfirst0.dlast0@myemail.com' LIMIT 1];
        DF_Contact__c dfcChampion = [select d.Id, d.Name, d.First_Name__c, d.Last_Name__c from DF_Contact__c d where d.Email__c = 'cfirst0.clast0@myemail.com' LIMIT 1];
        
        system.assertEquals(dfcNewsLetter.Name, dfcNewsLetter.First_Name__c + ' ' + dfcNewsLetter.Last_Name__c);
        system.assertEquals(dfcFriend.Name, dfcFriend.First_Name__c + ' ' + dfcFriend.Last_Name__c);
        system.assertEquals(dfcChampion.Name, dfcChampion.First_Name__c + ' ' + dfcChampion.Last_Name__c);
        */

    }
}