global class GdrpInitialSyncBatch implements Database.Batchable<sObject> {
    
    global Database.Querylocator start(Database.BatchableContext BC) {
       //Query to fetch contacts that don't have Individual created. You may modify the query to add custom fields  
       //Please add  "IsPersonAccount = false" condition to below query to exclude person accounts
       return Database.getQueryLocator('Select FirstName, LastName, Salutation, DF_Contact__c from Contact where IndividualId = NULL');
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> contactList) { 
        Map<Id, Individual> individualRecordsToCreate = new Map<Id, Individual>();
        for(Contact con : contactList) {
            individualRecordsToCreate.put(con.Id, new Individual(FirstName = con.FirstName, 
                                                                 LastName = con.LastName, 
                                                                 Salutation=con.Salutation,
                                                                 DF_Contact__c = con.DF_Contact__c,
                                                                 DF_ContactExternalId__c = con.DF_Contact__c)
                                         );
        }
        Database.insert(individualRecordsToCreate.values(), true);
        for(Contact con : contactList) {
            con.IndividualId = individualRecordsToCreate.get(con.Id).Id;
        }
        update contactList;
    }
    
    global void finish(Database.BatchableContext BC) {}
   
}