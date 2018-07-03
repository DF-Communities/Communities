@isTest
public class GDPR_Test {
    
    private static testmethod void coverageOnly() {
        
        DF_DataFactory_Test.getTestData();  
        Id rtId = [SELECT Id FROM RecordType WHERE Name='Dementia Friend' AND SobjectType='Contact'].Id;
        Id orgId = [SELECT Id FROM Account LIMIT 1].Id;
        
        Contact c = new Contact(Firstname='Test',Lastname='Test',RecordTypeId=rtId, AccountId = orgId);
        Database.SaveResult dsr = Database.insert(c, true);

        GDPR inst = new GDPR(false, false, false, false, false);
        inst.populateIndvData(c);

        Contact c2 = [select id, DF_Contact__c, IndividualId from Contact where id =:c.id];
        inst = new GDPR(true, true, false, false, false);
        inst.populateIndvData(c2);

        Id indvId = [SELECT Id FROM Individual LIMIT 1].Id;
        DF_Contact__c dfContact = [SELECT Id, First_Name__c, Last_Name__c, Portal_Contact__c FROM DF_Contact__c LIMIT 1];
        inst.populateIndvData(dfContact);

        GDPR.createDefaultIndivRecord(new List<Contact>{c});
        
        Individual indv = new Individual(Firstname=dfContact.First_Name__c, Lastname=dfContact.Last_Name__c);
        insert indv;
        
        Contact cIndv = [SELECT IndividualId FROM Contact WHERE DF_Contact__c = :dfContact.Id];
        cIndv.IndividualId = indv.Id;
        update cIndv;
        
        GDPR.getExistingDfContactPrefs(dfContact.Id);
        
    }
}