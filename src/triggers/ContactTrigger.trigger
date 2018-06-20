/*
* 2014-02-17 : SM : New trigger to process inserted / updated / deleted Contacts
*/

trigger ContactTrigger on Contact (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    /* In the original implementation there were calls to 
       ContactTriggerMethods.updateDFContacts(trigger.new);
       ContactTriggerMethods.createDFContacts(trigger.new);

       That was resulting in infinite update loops so was removed
       Updates to Contact do NOT update DF_Contact__c and may be overwritten 
       by the DF_Contact__c trigger when the DF_Contact__c is updated 

    */      

    if ( trigger.isBefore && (trigger.isInsert || trigger.isUpdate) ) {
        GDPR.createDefaultIndivRecord(trigger.new);
    }

}