@isTest
public class DF_EventListingHelper_Test {

     @testSetup static void setup() {
        // Create the test data once and then run all methods on the dataset
        DF_DataFactory_Test.getTestData();  
        
    }
    
    static testmethod void getRequestedSessionsChampAsOrganiser_positive() {
        
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend_Champion' AND SObjectType = 'DF_Contact__c'].Id;
        DF_Contact__c champDfContact = [SELECT Id 
                     FROM DF_Contact__c
                     WHERE RecordTypeId = :rtId
                     LIMIT 1];
        
		champDfContact.Type_of_Champion__c = 'Super Champion';
        update champDfContact;
        
        DF_EventListingHelper.getRequestedSessions(true, true, champDfContact.Id);
    	
    }
    
    static testmethod void getRequestedSessionsChampAsRequester_positive() {
        
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend_Champion' AND SObjectType = 'DF_Contact__c'].Id;
        Id champId = [SELECT Id 
                     FROM DF_Contact__c
                     WHERE RecordTypeId = :rtId
                     LIMIT 1].Id;
        
        DF_EventListingHelper.getRequestedSessions(true, true, champId);
    	
    }
    
    static testmethod void getDeliveredSessionsChamp_positive() {
        
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend_Champion' AND SObjectType = 'DF_Contact__c'].Id;
        Id champId = [SELECT Id 
                     FROM DF_Contact__c
                     WHERE RecordTypeId = :rtId
                     LIMIT 1].Id;
        
        DF_EventListingHelper.getDeliveredSessions(champId);
    	
    }
    
    static testmethod void getRequestedSessionsFriend_positive() {
        
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend' AND SObjectType = 'DF_Contact__c'].Id;
        Id friendId = [SELECT Id 
                     FROM DF_Contact__c
                     WHERE RecordTypeId = :rtId LIMIT 1].Id;
        
        DF_EventListingHelper.getRequestedSessions(false, false, friendId);
    	
    }
    
    static testmethod void getCreatedSessionsChamp_positive() {
        
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend_Champion' AND SObjectType = 'DF_Contact__c'].Id;
        Id champId = [SELECT Id 
                     FROM DF_Contact__c
                     WHERE RecordTypeId = :rtId LIMIT 1].Id;
        
        DF_EventListingHelper.getCreatedSessions(champId);
    	
    }
}