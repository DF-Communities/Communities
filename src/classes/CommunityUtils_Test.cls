@isTest
private class CommunityUtils_Test {
      
    static testMethod void getEnvironmentDomains_positive() {
        
        CommunityUtils.getEnvironmentDomains();
        
    }
    
    static testmethod void getDfCommunityPlaceholderContactId_positive() {
        
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dementia_Friend_Champion' AND SObjectType = 'DF_Contact__c'].Id;
        
        DF_Contact__c defaultOrganiser = new DF_Contact__c();
        defaultOrganiser.RecordTypeId = rtId;
        defaultOrganiser.First_Name__c ='test3';
        defaultOrganiser.Last_Name__c = 'test3';
        defaultOrganiser.Title__c = 'Mr';
        defaultOrganiser.Name='test'+' ' +'test';
        defaultOrganiser.Contact_Number__c = '02011180935';
        defaultOrganiser.Email__c = 'tobeconfirmed@mailinator.com';
        defaultOrganiser.Postcode__c = 'TS1 3TN';
        defaultOrganiser.Street__c = 'test street';
        defaultOrganiser.City__c = 'test';
        defaultOrganiser.County__c = 'test county';
        defaultOrganiser.Country__c = 'test country';
        insert defaultOrganiser;
        
        Community_Settings__c cs=new Community_Settings__c();
        cs.name='DF_Placeholder_InfoSessionOrganiser';
        cs.value__c= [SELECT Id FROM DF_Contact__c WHERE Email__c = 'tobeconfirmed@mailinator.com'].Id;
        insert cs;
        
        CommunityUtils.getDfCommunityPlaceholderContactId();
        
    }
    
    static testmethod void getInternalSalesforceUrl_positive() {
        CommunityUtils.getInternalSalesforceUrl();
    }

}