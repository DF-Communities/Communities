/*
*	Name		DCE_RestCallout_Handler
*	Author		Andy Rouse
*	Created		2016-02
*
*
*	Purpose		This class is called by other classes within the Dementia Connect Portal application when they need to send information to update Dementia Connect Live
*				
*
*
*/
public with sharing class DCE_RestCallout_Handler implements Queueable, Database.allowsCallouts{
    
    string postEndPointStem = Community_Settings__c.getInstance('DCE_RestEndpoint').value__c+'/services/apexrest/DCERecordAmend/';
    list<SObject> amends;
    map<string, string> fieldMappings;
    boolean updateStatus;
    
	/*Used to update a record in Dementia Connect Live from a source record in the portal*/
	public DCE_RestCallout_Handler(list<SObject> amends, map<string, string> fieldMappings){
    	
    	this.amends = amends;
    	this.fieldMappings = fieldMappings;
    	this.updateStatus = true;
	}
	
	/*Used to update a record - Does not update the source portal record status afterwards if given "False".*/
	public DCE_RestCallout_Handler(list<SObject> amends, map<string, string> fieldMappings, boolean updateStatus){
    	
    	this.amends = amends;
    	this.fieldMappings = fieldMappings;
    	this.updateStatus = updateStatus;
	}
    
	public void execute(QueueableContext context) {
    	
    	list<DCE_RecordUpdateIssue__c> issues = new list<DCE_RecordUpdateIssue__c>();
    	list<SObject> recordsToUpdate = new list<SObject>();
    	
    	for(SObject amend : amends){
    		
    		DCE_RestConnector callout;
    		
    		ID amendId = amend.id;
    		Schema.SObjectType amendType = amendId.getSObjectType();
    		
    		try{
    			callout = new DCE_RestConnector(postEndPointStem, 'POST', amend, fieldMappings);
    		} catch (exception e) {
				
				DCE_RecordUpdateIssue__c newIssue = new DCE_RecordUpdateIssue__c(Details__c=e.getTypeName()+' - '+e.getMessage()+'\r\r'+e.getStackTraceString());
				newIssue.put(lookupFieldPopulator.get(amendType), amend.id);
				
				issues.add(newIssue);
    		}
    		
    		if(callout == null){ continue; }
    		
    		if(callout.restError){
    			
				DCE_RecordUpdateIssue__c newIssue = new DCE_RecordUpdateIssue__c(Details__c=callout.res.getBody(), StatusCode__c=callout.res.getStatusCode());
				newIssue.put(lookupFieldPopulator.get(amendType), amend.id);
				
				issues.add(newIssue);
			} else {
				
				SObject castRecord = amendType.newSObject(amendId);
				
				if(updateStatus){
					castRecord.put('status__c','Accepted - Transfer Complete');
				}
				
				// This code links updates the "ServiceId__c" field on the record in the portal with the live id from Dementia Connect, to "sew" the two records together
				if(amendType == Schema.DCE_ServiceAmend__c.SObjectType){
					
					system.debug('Here is the body to be put into ServiceId__c - '+callout.res.getBody());
					map<string, Object> deserializeMap = (map<string, Object>)Json.deserializeUntyped(callout.res.getBody());
					
					string recordId = (string)deserializeMap.get('RecordId');
					
					castRecord.put(DCE_ServiceAmend__c.ServiceId__c,recordId);
				}
				
				recordsToUpdate.add(castRecord);
			}
		}
    	
    	if(recordsToUpdate.size() > 0){
    		
    		list<Database.SaveResult> srList = Database.Update(recordsToUpdate, false);
    		
    		for(integer i = 0 ; i < srList.size() ; i++){
    			
    			Database.SaveResult sr = srList[i];
    			
    			if(sr.isSuccess()){ continue; }
    			
    			SObject amend = recordsToUpdate[i];
    			Schema.SObjectType amendType = amend.getSObjectType();
    			
    			
    			for(Database.Error err : sr.getErrors()){
    				
    				string fieldsAffected = '';
    				
    				for(string s : err.getFields()){
    					fieldsAffected += s+'; ';
    				}
    				
    				DCE_RecordUpdateIssue__c newIssue = new DCE_RecordUpdateIssue__c(Details__c=err.getStatusCode()+' - '+err.getMessage()+'\r\rFields Affected: '+fieldsAffected);
					newIssue.put(lookupFieldPopulator.get(amendType), amend.id);
					
					issues.add(newIssue);
    			}
    		}
    	}
    	
    	if(issues.size() > 0){
    		try{
				insert issues;
			} catch (exception e){
				system.debug('Well......Damn. My exception handling failed.');
			}
    	}
    }
    
    
    //The "DCE Record Amend Issue" SObject has 2 lookups on it. One to Service Amendments and one to Partner Org amendments. This mapping tells the code at run-time which
    //one of those 2 fields to populate, based upon the record being amended
    private map<Schema.SObjectType, Schema.SObjectField> lookupFieldPopulator{
    	get{
    		if(lookupFieldPopulator != null){ return lookupFieldPopulator; }
    		
    		lookupFieldPopulator = new map<Schema.SObjectType, Schema.SObjectField>();
    		
    		lookupFieldPopulator.put(Schema.DCE_ServiceAmend__c.SObjectType, DCE_RecordUpdateIssue__c.DCEService__c);
    		lookupFieldPopulator.put(Schema.DCE_OrgAmend__c.SObjectType, DCE_RecordUpdateIssue__c.DCE_Partner_Amendment__c);
    		
    		return lookupFieldPopulator;
    	}
    	
    	private set;
    }
    
}