trigger DCE_ServiceAmend on DCE_ServiceAmend__c (before insert, before update, after update, after insert) {
    
    list<DCE_ServiceAmend__c> amendsToTransfer = new list<DCE_ServiceAmend__c>();
    list<DCE_ServiceAmend__c> amendsOwnerUpdate = new list<DCE_ServiceAmend__c>();
    
    if(trigger.isBefore){
    	for(DCE_ServiceAmend__c amend : trigger.new){
	    	if(amend.ServiceOwner__c != null && (trigger.isInsert || (trigger.isUpdate && trigger.oldMap.get(amend.id).ServiceOwner__c != amend.ServiceOwner__c) )  ){
	    		
	    		amend.ownerId = amend.ServiceOwner__c;
	    	}
	    	
	    	if(amend.ServiceId__c != null && amend.ServiceId__c.startsWith('a0z') && amend.ServiceId__c.length() == 15 ){
	    		amend.ServiceId__c = Id.ValueOf(amend.ServiceId__c);
	    	}
	    	
	    	//Changes to make to the record before transfer over
	    	if(amend.status__c == 'Accepted - Pending Transfer' && (trigger.isInsert || (trigger.isUpdate && trigger.oldMap.get(amend.id).status__c != amend.status__c) )  ){
	    		
	    		amend.LastReviewed__c = system.today();
	    		
	    		if(amend.service_closeDate__c != null && amend.service_closeDate__c < system.today()){
	    			
	    			amend.service_status__c = 'Closed';
	    		
	    		}
	    		
	    		if(amend.service_status__c == 'Closed' && amend.service_closeDate__c == null){
	    			
	    			amend.service_status__c = 'Open';
	    		
	    		}
	    		
	    	}
	    	
	    }
    }
    
    if(trigger.isAfter){
    	list<Id> recordChangedOwners = new list<Id>();
	    
	    
		for(DCE_ServiceAmend__c amend : trigger.new){
	    	
			if(amend.status__c == 'Accepted - Pending Transfer' && (trigger.isInsert || (trigger.isUpdate && trigger.oldMap.get(amend.id).status__c != amend.status__c) )  ){
	    		
				amendsToTransfer.add(amend);
	    		
	    	}
	    	
			if(trigger.isUpdate && amend.serviceOwner__c != trigger.oldMap.get(amend.id).serviceOwner__c && trigger.oldMap.get(amend.id).serviceOwner__c != null){
				recordChangedOwners.add(amend.id);
			}
	    }
	    
	    
	    if(recordChangedOwners.size() > 0){
	    	boolean sent = DCE_MailUtils.mailOwnerChanged(recordChangedOwners, trigger.oldMap, trigger.newMap);
	    }
    }
    
    if(amendsToTransfer.size() > 0){
    	if(!test.isRunningTest()){ System.enqueueJob(new DCE_RestCallout_Handler(amendsToTransfer, DCE_ServiceAmendWrapper.portalToProductionFieldMap)); }
    }
    
}