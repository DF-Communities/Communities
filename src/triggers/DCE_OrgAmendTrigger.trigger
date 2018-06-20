trigger DCE_OrgAmendTrigger on DCE_OrgAmend__c (after insert, after update) {
    
    list<DCE_OrgAmend__c> amendsToTransfer = new list<DCE_OrgAmend__c>();
    list<DCE_OrgAmend__c> amendsToUpdateAccount = new list<DCE_OrgAmend__c>();
    
    for(DCE_OrgAmend__c amend : trigger.new){
    	if(amend.status__c == 'Accepted - Pending Transfer' && (trigger.isInsert || (trigger.isUpdate && trigger.oldMap.get(amend.id).status__c != amend.status__c) )  ){
    		
    		amendsToTransfer.add(amend);
    		
    	}
    	
    	if(amend.status__c == 'Accepted - Transfer Complete' && (trigger.isInsert || (trigger.isUpdate && trigger.oldMap.get(amend.id).status__c != amend.status__c) )){
    		amendsToUpdateAccount.add(amend);
    	}
    }
    
    if(amendsToTransfer.size() > 0){
    	System.enqueueJob(new DCE_RestCallout_Handler(amendsToTransfer, DCE_OrgAmendWrapper.portalToProductionFieldMap));
    }
    
    if(amendsToUpdateAccount.size() > 0){
    	list<Account> accsToUpdate = new list<Account>();
    	
    	for(DCE_OrgAmend__c amend : amendsToUpdateAccount){
    		Account acc = new Account(	Id = amend.Organisation__c, 
    									Name=amend.Name__c,
    									phone = amend.phone__c,
    									BillingStreet = amend.BillingStreet__c,
    									BillingCity = amend.BillingCity__c,
    									BillingState = amend.BillingState__c,
    									BillingCountry = amend.BillingCountry__c,
    									BillingPostalCode = amend.BillingPostalCode__c
    								);
    		accsToUpdate.add(acc);
    	}
    	
    	try{
    		update accsToUpdate;
    	} catch (dmlException e){
    		//ERROR
    	}
    }
    
}