public with sharing class DCE_NewOrgRequestController extends DCE_ControllerUtils{
    
    public Lead orgRequest{
    	
    	public get{
    		if(orgRequest != null){ return orgRequest;}
    		
    		orgRequest = new Lead(LeadSource='Web');
    		
    		list<RecordType> DCEApplicationRT = [select id, Name, DeveloperName from RecordType where DeveloperName = 'DCE_Application'];
    		
    		if(DCEApplicationRT.size() > 0){ orgRequest.recordTypeId = DCEApplicationRT[0].id; }
    		
    		list<Group> DCEQueue = [select id, Name from Group where DeveloperName = 'DCE_Admins' and Type = 'Queue'];
    		
    		if(DCEQueue.size() > 0){ 
    			orgRequest.ownerId = DCEQueue[0].id; 
    		} else {
    			orgRequest.ownerId = [select id from User where isActive = true and Profile.Name = 'System Administrator' limit 1].id;
    		}
    		
    		
    		return orgRequest;
    	}
    	
    	public set;
    }
    
    public pageReference submitLead(){
    	
    	genericUpsert(orgRequest);
    	
    	if(!pageErrorMessage){
    		return Page.DCE_newOrgRequestConfirm;
    	}
    	
    	return null;
    }
}