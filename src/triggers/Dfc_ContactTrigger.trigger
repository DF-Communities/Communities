trigger Dfc_ContactTrigger on DF_Contact__c (after insert) 
{
   Dfc_Util.resolveInvitations(Trigger.New);
}