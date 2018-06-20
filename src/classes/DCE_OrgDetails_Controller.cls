public with sharing class DCE_OrgDetails_Controller extends DCE_ControllerUtils{
    
    @testVisible private boolean doneCallout = false;
    
    public DCE_OrgAmend__c partner{
    	
    	public get{
    		
    		system.debug('Getting Partner - '+partner);		
    		/*Controller already has an amendment in this instance*/
    		if(partner != null){ return partner; }
    		
    		list<DCE_OrgAmend__c> existingOrgAmendments = Database.query('select '+DCE_OrgAmendWrapper.fieldsOfInterestLocal+', status__c from DCE_OrgAmend__c where Organisation__c = \''+userWithDCEDetails.AccountId+'\''); //:currentContact.accountId');
    													
    		if(existingOrgAmendments.size() > 1){
    			displayPageError('There has been an error returning your Organisation details. Please raise an issue with the Dementia Connect Admin team. [DCE120]');
    		}
    		
    		
    		
    		/*Is there an existing amendment that is currently being edited, or in the approval process?*/
    		if(existingOrgAmendments.size() == 1 && DCE_ServiceAmendWrapper.editingStatuses.contains(existingOrgAmendments[0].status__c)){
    			partner = existingOrgAmendments[0];
    			displayPageSuccess('There is information on this page which is not yet live. You will need to submit it for Approval for it to be made public.');
    			system.debug('Found existing Amend');
    			system.debug('Return Partner 1 - '+partner);
    			return partner;
    		}
    		
    		/*
    		There are either no amendment records in the system, or there is a completed amendment record (that needs to be refreshed and set back to draft).
    		Either way, a call to the REST API is required
    		*/
    		
    		string queryEndPoint = WEBC_CommunityWrapper.getCustomSetting('RestEndpoint','DCE')+'/services/data/v35.0/query';
			queryEndPoint += '?q='+EncodingUtil.urlEncode('select '+DCE_OrgAmendWrapper.fieldsOfInterestProduction+' from Account where Id = \''+CRSAccountId+'\' LIMIT 1', 'UTF-8');
				
			DCE_RestConnector request = new DCE_RestConnector(queryEndPoint, 'GET');
				
    		if(request.restError){
				displayPageError('There has been an error returning your Organisation details. Please raise an issue with the Dementia Connect Admin team. [DCE121]');
			}
    		
    		doneCallout = true;
    		
    		if(existingOrgAmendments.size() == 1){
	    		try{
	    			system.debug('Refreshing the system version from Dementia Connect');
	    			partner = new DCE_OrgAmendWrapper(request.res.getbody(), existingOrgAmendments[0]).partner;
	    			return partner;
	    		} catch (exception e) {
	    			displayPageError('There has been an error returning your Organisation details. Please raise an issue with the Dementia Connect Admin team. [DCE122]');
	    			return partner;
	    		}
    		}
    		
    		system.debug('Using the Org from Dementia Connect');
    		partner = new DCE_OrgAmendWrapper(request.res.getbody()).partner;
    		
    		if(partner == null){ displayPageError('Could not find your Organisation within Dementia Connect. Please raise an issue with the Dementia Connect Admin team. [DCE123]'); }
    		
    		system.debug('Here is the partner - '+partner);
    		system.debug('Return Partner 2 - '+partner);
    		return partner;
    		
    	}
    	
    	public set;
	}
	
	public boolean isLockedForApproval{
    	get{
    		
    		if(!partnerLoadSuccess || partner == null || partner.id == null){ return false;}
    		return Approval.isLocked(partner);
    		
    	}
    	
    	private set;
    }
    
	public boolean partnerLoadSuccess{
		public get{
			if(partnerLoadSuccess != null){return partnerLoadSuccess; }
    		
			partnerLoadSuccess = true;
    		
			if(partner == null){ partnerLoadSuccess = false; }
    			
			return partnerLoadSuccess;
		}
    	
		private set;
	
	}
    
    public Attachment orgLogo{
    	public get{
    		
    		if(orgLogo != null){ return orgLogo;}
    		
    		string logoDeveloperName = 'DCE_Logo_'+CRSAccountId;
    		
    		list<CommunityResource__c> orgLogos = [select id, Name,
    												(select id from Attachments limit 1)
    												from CommunityResource__c where Name = :logoDeveloperName];
    		
    		if(orgLogos.size() > 0 && orgLogos[0].Attachments.size() == 1){orgLogo = orgLogos[0].Attachments[0]; }
    		
    		return orgLogo;
    	}
    	
    	private set;
    }
    
    private list<DCEProfile__c> orgUsers{
    	private get{
    		
    		if(orgUsers != null){ return orgUsers;}
    		
    		//With sharing means this this only returns the Profiles for the Account
    		orgUsers = [select id, Active__c, Name__c, Contact__c
    						from DCEProfile__c 
    						order by LastName__c asc nulls last];
    		
    		return orgUsers;
    	}
    	
    	private set;
    }
    
    public list<DCEProfile__c> activeUsers{
    	public get{
    		if(activeUsers != null){ return activeUsers;}
    		
    		activeUsers = new list<DCEProfile__c>();
    		
    		for(DCEProfile__c u : orgUsers){
    			system.debug('Here is the user - '+u);
    			if(u.Active__c){
    				system.debug('ACTIVE');
    				activeUsers.add(u);
    			}
    		}
    		
    		system.debug('Here are the active users - '+activeUsers);
    		return activeUsers;
    	}
    	
    	private set;
    }
    
    public list<DCEProfile__c> inActiveUsers{
    	public get{
    		if(inActiveUsers != null){ return inActiveUsers;}
    		
    		inActiveUsers = new list<DCEProfile__c>();
    		
    		for(DCEProfile__c u : orgUsers){
    			system.debug('Here is the user - '+u);
    			if(!u.Active__c){
    				system.debug('INACTIVE');
    				inActiveUsers.add(u);
    			}
    		}
    		system.debug('Here are the inactive users - '+inActiveUsers);
    		return inActiveUsers;
    	}
    	
    	private set;
    }
    
    public pageReference save(){
    	genericUpsert(partner, true);
    	
    	return null;
    }
    
    public pageReference discardDraft(){
    	
    	partner.status__c = 'Accepted - Transfer Complete';
    	save();
    	
    	return page.DCE_Dashboard;
    }
    
    public pageReference commitApproval(){
    	system.debug('Getting commitApproval.');
    	
    	map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
   		Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('DCE_OrgAmend__c');
		Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
    	Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get('RequiredForApproval');
    	
    	string fieldsNeedingValue = '';
    	
    	system.debug('Field Members - '+fieldSetObj.getFields());
    	
    	for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
    		system.debug('Field Member - '+fsm.getFieldPath());
    		system.debug('Field Value - '+partner.get(fsm.getFieldPath()));
    		
    		if(partner.get(fsm.getFieldPath()) != null && partner.get(fsm.getFieldPath()) != ''){ continue; }
    		
    		fieldsNeedingValue += '<li>'+fsm.getLabel()+'</li>';
    		
    	}
    	
    	system.debug('Fields needing completed - '+fieldsNeedingValue);
    	
    	if(fieldsNeedingValue != ''){
    		
    		displayPageError('Before submission for Approval, the following fields still require completion: <ul>'+fieldsNeedingValue+'</ul>');
    		return null;
    	}
    	
    	sendForApproval(partner);
    	return null;
    }
    
    public pageReference recallApproval(){
    	
    	recallFromApproval(partner.id);
    	return null;
    }
    
    public pageReference updateAdmins(){
    	
    	list<DCEProfile__c> toUpdate = new list<DCEProfile__c>();
    	
    	for(DCEProfile__c u : activeUsers){
    		if(!u.active__c){
    			toUpdate.add(u);
    		}
    	}
    	
    	for(DCEProfile__c u : inActiveUsers){
    		if(u.active__c){
    			toUpdate.add(u);
    		}
    	}
    	
    	if(toUpdate.size() > 0){
    		genericUpdateList(toUpdate);
    		
    		activeUsers = null;
    		inactiveUsers = null;
    		
    		DCE_MailUtils.sendUserActiveUpdate(toUpdate);
    	}
    	
    	return null;
    }
    
    
    @remoteAction
    public static void photoUpload(string photoCroppedData){
    	
    	system.debug('Called the upload method');
    	system.debug('Here is photo data - '+photoCroppedData);
    	
    	User u = [select id, Contact.Account.DCEProdOrgID__c from User where Id = :UserInfo.getUserId()];
    	string logoDeveloperName = 'DCE_Logo_'+u.Contact.Account.DCEProdOrgID__c;
    	
    	CommunityResource__c existingOrgLogoResource;
    	
    	
    	list<CommunityResource__c> orgLogos = [select id, Name,
    												(select id from Attachments limit 1)
    												from CommunityResource__c where Name = :logoDeveloperName];
    	
    	system.debug('orgLogos - '+orgLogos);
    	
    	if(orgLogos.size() == 0){
    		system.debug('no system resource - ');
    		existingOrgLogoResource = new CommunityResource__c(Name = logoDeveloperName);
    		
    		try{
    			insert existingOrgLogoResource;
    			system.debug('New resource created');
    		} catch (exception e) {
    			throw new dce_exception('There was an issue uploading your logo, please contact the Dementia Connect administration team: [DCE 401]');
    		}
    		
    	} else {
    		existingOrgLogoResource = orgLogos[0];
    	}
    	
    	Attachment existingAttachment;
    	
    	if(existingOrgLogoResource.Attachments.size() == 0){
    		system.debug('No attachment');
    		existingAttachment = new Attachment();
	    	existingAttachment.ParentId = existingOrgLogoResource.id;
	    	
	    } else {
    		system.debug('UPDATING EXISTING');
    		existingAttachment = existingOrgLogoResource.Attachments[0];
    	}
    	
    	existingAttachment.ContentType = 'image/png';
	    existingAttachment.isPrivate = false;
	    existingAttachment.Name = logoDeveloperName+'.png';
	    
    	existingAttachment.Body = EncodingUtil.base64Decode(photoCroppedData);
    	
    	system.debug('Here is the document - '+existingAttachment);
    	
    	try{
    		upsert existingAttachment;
    	} catch (exception e) {
    		throw new DCE_Exception('There was an issue uploading your logo, please contact the Dementia Connect administration team: [DCE 402]');
    	}
    	
    }
    /*
    public class userSelect{
    	public User user {get; set;}
    	public boolean updateMe {get; set;}
    	
    	public userSelect(User user){
    		this.user = user;
    		this.updateMe = false;
    	}
    }*/
}