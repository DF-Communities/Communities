/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX class for Dementia Connect Extranet classes containing generic methods which can be called from multiple other classes which extend it
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

public abstract without sharing class DCE_ControllerUtils extends WEBC_ControllerBase{
    
    public string pageMessage{get;set;}
    public string pageMessageType{get; set;}
    
    public static string DCE_PERMISSION_SET_NAME = 'DementiaConnectPortalUser';
    public static string DCE_PUBLIC_ACCESS_PROFILE = 'Dementia Connect Portal Profile';
    
    public boolean pageErrorMessage{
    	get{
    		if(pageErrorMessage!=null){ return pageErrorMessage; }
    		pageErrorMessage = false;
    		return pageErrorMessage;
    	}
    	
    	public set;
    }
    
    public boolean displayPageMessage{
    	get{
    		if(displayPageMessage!=null){ return displayPageMessage; }
    		displayPageMessage = false;
    		return displayPageMessage;
    	}
    	
    	public set;
    }
    
    //Maybe this name should be changed. CRS isn't technically accurate
    public string CRSAccountId{
    	
    	public get{
    		
    		return userWithDCEDetails.Contact.Account.DCEProdOrgID__c;
    	}
    	
    	private set;
    }
    
   	/*Returns the Service Amendment records in the portal which relate to this user's organisation*/
   	public list<DCE_ServiceAmend__c> Amendments{
    	public get{
    		if(Amendments != null){ return Amendments; }
    		
    		Amendments = [select id, Name, DCEPartner__r.Name, ServiceId__c, OwnerId, Owner.Name, Status__c, Service_Status__c, LastReviewed__c, Service_Type__c, ServiceOwner__r.Name from DCE_ServiceAmend__c where DCEPartner__c = :userWithDCEDetails.accountId];
    		
    		return Amendments;
    	}
    	
    	private set;
    }
    
    /*Returns the user's details with DCE information on the User's Organisation record*/
    public User userWithDCEDetails{
    	public get{
    		if(userWithDCEDetails != null){ return userWithDCEDetails; }
    		
    		userWithDCEDetails = [select id, AccountId, ContactId, Contact.AccountId, Contact.Account.Name, Contact.Account.DCEProdOrgID__c from User where Id = :UserInfo.getUserId()]; //Account.Name,
    		
    		system.debug('Here is the user - '+userWithDCEDetails);
    		
    		return userWithDCEDetails;
    	}
    	
    	private set;
    }
    
	
	/* Returns a list of all DCE users within the user's org. All DCE users are effectively admins within the context of their own org's data*/
	public list<User> allAdmins{
    	public get{
    		if(allAdmins != null){ return allAdmins; }
    		
    		allAdmins = [select id, Name 
    							from User 
    							where isActive = true and Contact.AccountId = :userWithDCEDetails.Contact.AccountId and  id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_PERMISSION_SET_NAME)];
    	
    		return allAdmins;
    	}
    	
    	private set;
    }
    
    public list<selectOption> accountUserSelectList{
    	public get{
    		if(accountUserSelectList != null){ return accountUserSelectList;}
    		
    		accountUserSelectList = new list<SelectOption>();
    		
    		for(User u : allAdmins){
    			accountUserSelectList.add(new selectOption(u.id, u.Name));
    		}
    		
    		return accountUserSelectList;
    	}
    	
    	private set;
    }
    /*
    public Account userAccount{
    	public get{
    		
    	}
    }
    */
    public pageReference genericUpsert(SObject obj){
    	return genericUpsert(obj, false);
    }
    
    public pageReference genericUpsert(SObject obj, boolean longerMessage){
    	
    	pageMessage = null;
    	displayPageMessage = false;
    	pageErrorMessage = false;
    	
    	string message = 'Record Updated.';
    	
    	if(longerMessage){ message += ' Please submit this record for approval after you have made all the necessary amendments.'; }
    	
    	try{
    		
    		system.debug('Here is the record - '+obj);
    		upsert obj;
    		
    		displayPageSuccess(message);
    	} catch (dmlException e) { displayPageError(errorMessage(e)); }
    	
    	displayPageMessage = true;
    	return null;
    	
    }
    
    public pageReference genericUpdateList(list<SObject> obj){
    	
    	pageMessage = null;
    	displayPageMessage = false;
    	
    	try{
    		update obj;
    		
    		displayPageSuccess('Records Updated.');
    		
    	} catch (dmlException e) { displayPageError(errorMessage(e)); }
    	
    	displayPageMessage = true;
    	
    	return null;
    }
    
    public boolean sendForApproval(SObject rec){
    	system.debug('Partner record before - '+rec);
    	
    	genericUpsert(rec);
    	
    	system.debug('Partner record after - '+rec);
    	system.debug('pageErrorMessage - '+pageErrorMessage);
    	if(pageErrorMessage){ return false; }
	    
		try{
			Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
			app.setObjectId(rec.id);
			app.setSubmitterId(string.valueOf(rec.get('ownerId')));
			Approval.process(app);
	    	
			displayPageSuccess('Record Locked and sent for approval');
			return true;
		} catch (dmlException e){
			displayPageError('Record could not be sent for approval. Please contact Dementia Connect team: '+errorMessage(e));
			return false;
    	} catch (exception e){
			displayPageError('Record could not be sent for approval. Please contact Dementia Connect team: '+errorMessage(e));
			return false;
		}
    	
    }
    
    public void recallFromApproval(Id recordId){
    	try{
    	
	    	Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();
	        
			list<ProcessInstance> procins = new List<ProcessInstance>([select Id from ProcessInstance where Status = 'Pending' and TargetObjectId = :recordId]);
				
			// Retrieve the process work instance id associated to the process instance
			list<ProcessInstanceWorkitem>  workitem = new list<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstanceId = :procins[0].id]);
	            
			if ((workitem != null) && (workitem.size() > 0)){
				pwr.SetComments('Recalled by '+UserInfo.getName());
				
				pwr.setWorkItemId(workitem[0].id);
				pwr.setAction('Removed'); 
	             
				// Execute process request
				Approval.ProcessResult pr = Approval.process(pwr);
				
			}
			
			displayPageSuccess('Record unlocked.');
			
    	} catch (dmlexception e){
    		displayPageError('Record could not be unlocked. Please contact Dementia Connect team: '+errorMessage(e));
    	} catch (exception e) {
    		displayPageError('Record could not be unlocked. Please contact Dementia Connect team: '+errorMessage(e));
    	}
    }
    
    
    
    public void displayPageError(string errorMessage){
    	pageErrorMessage = true;
    	displayPageMessage(errorMessage, 'alert-danger');
    	
    	/*displayPageMessage = true;
    	pageMessageType = 'alert-danger';
    	pageMessage = errorMessage;*/
    }
    
    public void displayPageSuccess(string Message){
    	displayPageMessage(Message, 'alert-success');
    	/*
    	displayPageMessage = true;
    	pageMessageType = 'alert-success';
    	pageMessage = Message;*/
    }
    
    private void displayPageMessage(string message, string alertType){
    	
    	displayPageMessage = true;
    	pageMessageType = alertType;
    	pageMessage = message;
    	
    }
    
    public string errorMessage(dmlException e){
    	
    	string errorMessage = 'There were one or more problems preventing the record from being updated. Please correct these and try again:<ul>';
            	
		for(integer i = 0 ; i < e.getNumDml() ; i++){
			
			string field = '';
			
			for(string f : e.getDmlFieldNames(i)){ field += f+', '; }
			
			errorMessage += '<li>';
			
			if(field.length() > 0){ errorMessage += '<b>'+field.substring(0, field.length()-1)+'</b>: '; }
				
			//field = field.substring(0, field.length()-1);
				
			errorMessage += e.getDmlMessage(i)+'</li>';
		}
            	
		errorMessage += '</ul>';
            	
		return errorMessage;
    }
    
    private string errorMessage(exception e){
    	
    	return 'There were one or more unexpected problems - '+e.getMessage();
    	
    }
}