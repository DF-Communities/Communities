@isTest
public class FormUtils_Test {

    static testmethod void getPicklistSelectOptions_postive() {
        //DF_Event__c testEvent = [SELECT Id, Request_Status__c FROM DF_Event__c LIMIT 1];
        List<SelectOption> options = FormUtils.getPicklistSelectOptions(new DF_Event__c(), 'Preference_1_Period__c');
        System.assert(options.size() > 0);
    }
}