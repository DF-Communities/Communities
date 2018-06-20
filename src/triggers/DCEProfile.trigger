trigger DCEProfile on DCEProfile__c (before insert, after insert, after update, before delete) {
    
    if(trigger.isBefore && trigger.isInsert){
    	
    	map<id, DCEProfile__c> contactIdMap = new map<id, DCEProfile__c>();
    	
    	for(DCEProfile__c dcep : trigger.new){
    		if(contactIdMap.containsKey(dcep.contact__c)){ 
    			dcep.addError('This Contact already has a Dementia Connect Portal Profile'); 
    		} else {
    			contactIdMap.put(dcep.contact__c, dcep);
    		}
    	}
    	
    	for(DCEProfile__c dcep : [select id, Contact__c from DCEProfile__c where Contact__c IN :contactIdMap.keySet()]){
    		DCEProfile__c dcepError = contactIdMap.get(dcep.Contact__c);
    		dcepError.addError('This Contact already has a Dementia Connect Portal Profile'); 
    	}
    	
    }
    
    
    if(trigger.isdelete){
    	for(DCEProfile__c dcep : trigger.old){
    		dcep.addError('Dementia Connect Profile records cannot be deleted. Please only deactivate the profile, if need be.');
    	}
    }
    
	list<Id> profilesToAdd = new list<Id>();
	list<Id> profilesToRemove = new list<Id>();
    
    if(trigger.isafter && (trigger.isinsert || trigger.isupdate)){
    	
    	for(DCEProfile__c dcep : trigger.new){
    		if(trigger.isInsert || (trigger.isUpdate && dcep.Active__c != trigger.oldMap.get(dcep.id).Active__c)){
    			if(dcep.Active__c){ profilesToAdd.add(dcep.Contact__c); }
    			if(!dcep.Active__c){ profilesToRemove.add(dcep.Contact__c); }
    		}
    	}
    }
    
    if(profilesToAdd.size() > 0){
    	if(!test.isRunningTest()){ System.enqueueJob(new DCE_PermissionSetManager_Queuable(profilesToAdd, 'Add')); }
	}
    
    if(profilesToRemove.size() > 0){
    	if(!test.isRunningTest()){ System.enqueueJob(new DCE_PermissionSetManager_Queuable(profilesToRemove, 'Remove')); }
    }
}