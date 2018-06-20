/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : Queueble class kicked-off by the DCE_Profile__c trigger. When a Person's "DCE Profile" record is marked as Active or Inactive, a Permission set is added or removed from the User. 
 		It's Async because there are certain things that APEX can't do in the same transaction.
 *            
 *  Author  : Andy Rouse
 *  Date    : 02-2016
 *  Version : 1.0
 *
 *  Description:
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DCE_PermissionSetManager_Queuable implements queueable{
    
    private list<Id> contactIds;
    private string mode;
    
    public DCE_PermissionSetManager_Queuable(list<Id> contactIds, string mode){
    	this.contactIds = contactIds;
    	this.mode = mode;
    	
    	if(mode != 'Add' && mode != 'Remove'){ throw new DCE_Exception('Please instantiate the class only with Add or Remove mode.'); }
    	
    	system.debug('Queued class setup');
    	
    }
    
    public void execute(QueueableContext qc) {
		
		if(mode == 'Add'){
			list<User> usersToAdd = [select id, Name, isActive,
    								(select id from PermissionSetAssignments where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME)
    								from User
    								where ContactId IN :contactIds];
    								
	    	list<PermissionSet> DCEPS = [select id from PermissionSet where Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME];
	    	
	    	if(DCEPS.size() == 1){
	    		
	    		list<PermissionSetAssignment> pmaList = new list<PermissionSetAssignment>();
	    		list<User> usersToUpdate = new list<User>();
	    		
	    		for(User u : usersToAdd){
	    			
	    			if(!u.isActive){
	    				u.isActive = true;
	    				usersToUpdate.add(u);
	    			}
	    			
	    			if(u.PermissionSetAssignments.size() == 0){ pmaList.add(new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId=DCEPS[0].id)); }
	    		}
	    	
	    		if(usersToUpdate.size() > 0){
	    			update usersToUpdate;
	    		}
	    		
	    		insert pmaList;
	    	}
		} else if (mode == 'Remove') {
			list<PermissionSetAssignment> pmaToRemove = [select id from PermissionSetAssignment where Assignee.Contactid IN :contactIds and PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME];
    
	    	if(pmaToRemove.size() > 0){
	    		delete pmaToRemove;
	    	}
		} /*else {
			throw new DCE_Exception('Please instantiate the class only with Add or Remove mode.');
		}*/
		
	}
    
}