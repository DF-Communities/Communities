/*
	Name:	DCE_ServiceEditController
	Date:	2016-03
	By:		Andy Rouse
	
	Purpose:
	Runs the pages for viewing or editing individual services. Queries the database for the correct record (or calls Dementia Connect for the live details)
	Allows users to save/clone the service or sending the service for approval.
	
	The service to return is based upon the service number passed in and the mode of the page (view or edit).
	
*/
public with sharing class DCE_ServiceEditController extends DCE_ControllerUtils {
    
    @testVisible private boolean doneCallout = false; 
    
    @testVisible private string mode{
    	get {
    		system.debug('Getting the mode.');
    		
    		if(mode != null){ return mode; }
    		
    		mode = 'view';
    		
    		system.debug('Looking for mode in URL '+apexPages.currentPage().getUrl());
    		
    		string url = ApexPages.currentPage().getUrl().tolowerCase();
    		
    		if(url.contains('dce_serviceedit') || url.contains('/serviceedit')){
    			mode = 'edit';
    		}
    		
    		system.debug('Mode - '+mode);
    		return mode;
    	}
    	
    	private set;
    }
   
   	public DCE_ServiceEditController(){ system.debug('Just checking I am called'); }
   
    private string portalId{
    	get{
    		system.debug('Getting the portal id.');
    		if(portalId != null){ return portalId;}
    			
    		if(ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get('aid') != null){
    			portalId = ApexPages.currentPage().getParameters().get('aid');
    		}
    		
    		return portalId;
    	}
    	
    	private set;
    }
    
    public boolean isLockedForApproval{
    	get{
    		system.debug('Getting isLockedForApproval.');
    		
    		//SHOULD WORK IN SPRING 16 - But needs a certain setting switched on in the admin interface
    		if(service==null || service.id == null){ return false;}
    		
    		return Approval.isLocked(service);
    		
    	}
    	
    	private set;
    }
    
    public DCE_ServiceAmend__c service{
    	
    	public get{
    		system.debug('Getting service.');
    		
    		/*Controller already has an amendment in this instance, so return that*/
    		if(service != null){ return service; }
    		
    		/*There is no Service ID and no amendment ID- Controller assumes that the user wants to create a new Service completely*/
    		//if(serviceId == null && amendId == null){
    		if(portalId == null){	
    			if(mode=='edit'){
	    			system.debug('Creating a new service');
	    			service = new DCE_ServiceAmend__c(DCEPartner__c=currentUser.AccountId, Operated_By__c=userWithDCEDetails.Contact.Account.DCEProdOrgID__c, Status__c = 'Draft', service_status__c= 'Pending', ServiceOwner__c = Userinfo.getUserId());
	    			return service;
    			} else {
    				displayPageError('Could not find the service you are looking for. Please check your URL. [DCE108]');
    				return null;
    			}
    		}
    		
    		/*Where there is an amendmentID, the controller will check to see if there is already an amendment in progress and return that*/
    		system.debug('Looking for amendments');
    		list<DCE_ServiceAmend__c> existingAmendments = Database.query('select '+DCE_ServiceAmendWrapper.fieldsOfInterestPortal+', ServiceOwner__c, ServiceOwner__r.FirstName, status__c, ownerId from DCE_ServiceAmend__c where Id = :portalId');//serviceId__c = :serviceId');//Id = :amendId'); //  ownerId
    													
			if(existingAmendments.size() > 1){
				displayPageError('Could not find the service you are looking for. Please check your URL. [DCE109]');
			}
			
			if(portalId != null && existingAmendments.size() == 0){
				displayPageError('Could not find the service you are looking for. Please check your URL. [DCE101]');
				return null;
			}
			
			service = existingAmendments[0];
			
			system.debug('Mode - '+mode);
			
    		if(mode=='edit' && DCE_ServiceAmendWrapper.editingStatuses.contains(service.status__c)){
    			return service; 
    		}
    		
    		/*
    		We're either in view mode, or we're newly editing the local copy (so that needs to be refreshed and set back to draft).
    		Either way, a call to the REST API is required
    		*/
    		
    		string queryEndPoint = WEBC_CommunityWrapper.getCustomSetting('RestEndpoint','DCE')+'/services/data/v35.0/query';
			queryEndPoint += '?q='+EncodingUtil.urlEncode('select '+DCE_ServiceAmendWrapper.fieldsOfInterest+' from Services__c where Id =\''+service.serviceId__c+'\' and Operated_By__c = \''+CRSAccountId+'\' LIMIT 1', 'UTF-8');
			
			DCE_RestConnector request = new DCE_RestConnector(queryEndPoint, 'GET');
    		
    		if(request.restError){
				displayPageError('Could not find the service you are looking for. Please check your URL. [DCE103]');
				return null;//new DCE_ServiceAmend__c();
			}
    		
    		doneCallout = true;
    		
    		system.debug('Refreshing the system version from Dementia Connect');
			try{
    			service = new DCE_ServiceAmendWrapper(request.res.getbody(), existingAmendments[0], mode).amend;
    			return service;
			} catch (exception e){
				displayPageError('Could not find the service you are looking for. Please check your URL. [DCE106]');
				return null;
			}
    		
    		return service;
    	}
    	
    	public set;    	
	}
	
	public list<selectOption> recurrenceOptions{
		get{
			system.debug('Getting recurrenceOptions.');
			if(recurrenceOptions != null){ return recurrenceOptions;}
			
			recurrenceOptions = new list<selectOption>();
			
			for(Schema.PicklistEntry e : DCE_ServiceAmend__c.Recurrence__c.getDescribe().getPicklistValues()){
				recurrenceOptions.add(new selectOption(e.getValue(), e.getLabel()));
			}
			
			return recurrenceOptions;
		}
		private set;
	}
	
	public list<string> daysChosen{
		public get{
			system.debug('Getting daysChosen.');
			if(daysChosen != null){ return daysChosen; }
				
			daysChosen = new list<string>();
			
			if(service.Days__c == null){ return daysChosen;}
			
			for(string s : service.Days__c.split(';')){
				daysChosen.add(s);
			}
			
			system.debug('DAYS CHOSEN - '+daysChosen);
			return daysChosen;
		}
		
		public set;
	}
	
	public list<selectOption> recurrenceDays{
		get{
			system.debug('Getting recurrenceDays.');
			if(recurrenceDays != null){ return recurrenceDays;}
			
			recurrenceDays = new list<selectOption>();
			
			for(Schema.PicklistEntry e : DCE_ServiceAmend__c.Days__c.getDescribe().getPicklistValues()){
				recurrenceDays.add(new selectOption(e.getValue(), e.getLabel()));
			}
			
			return recurrenceDays;
		}
		private set;
	}
	
	public list<selectOption> contactOptions{
		get{
			system.debug('Getting contactOptions.');
			if(contactOptions != null){ return contactOptions;}
			
			contactOptions = new list<selectOption>();
			
			Integer i = 1;
			
			contactOptions.add(new selectOption('', '--None--'));
			
			for(Schema.PicklistEntry e : DCE_ServiceAmend__c.Further_contact_requirements__c.getDescribe().getPicklistValues()){
				contactOptions.add(new selectOption(e.getValue(), 'Option '+string.valueOf(i)));
				i++;
			}
			
			return contactOptions;
		}
		private set;
	}
	
	/*Converts the variable populated by a "Select2" input field into a format usable by the Server for an SObject multi-select picklist*/
	private void bindDaysField(){
		
		service.Days__c = null;
    	
    	for(string s : daysChosen){
    		if(service.Days__c == null){ service.Days__c = ''; }
    		service.Days__c += s+';';
    	}
		
	}
	
	
	public pageReference save(){
    	system.debug('About to save');
    	
    	bindDaysField();
    	
    	genericUpsert(service, true);
    	
    	return null;
    }
    
    public pageReference cloneRecord(){
    	
    	system.debug('CLONING RECORD');
    	
    	DCE_ServiceAmend__c clonedService = service.clone(false, true, false, false);
    	clonedService.Name = 'CLONE - '+service.Name;
    	clonedService.lastReviewed__c = null;
    	clonedService.ServiceId__c = null;
    	clonedService.Service_Reference__c = null;
    	clonedService.DCEPartner__c = currentUser.AccountId;
    	clonedService.Operated_By__c=userWithDCEDetails.Contact.Account.DCEProdOrgID__c;
    	clonedService.Status__c = 'Draft';
    	clonedService.service_status__c= 'Pending';
    	clonedService.ServiceOwner__c = Userinfo.getUserId();
    	
    	
    	map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.DCE_ServiceAmend__c.fields.getMap();
    	
    	for(string s : fieldMap.KeySet()){
    		Schema.DescribeFieldResult dfr = fieldMap.get(s).getDescribe();
    		
    		if(dfr.getType()==Schema.DisplayType.TextArea){
    			if(clonedService.get(s) != null && ((string)clonedService.get(s)).length() > dfr.getLength()){
    				string fVal = (string)clonedService.get(s);
    				fVal = fVal.substring(0, dfr.getLength()-1);
    				clonedService.put(s, fVal);
    			}
    		}
    	}
    	
    	insert clonedService;
    	
    	clonedService = [select id, portalServiceNumber__c from DCE_ServiceAmend__c where id = :clonedService.id];
    	
    	system.debug('RECORD CLONED');
    	
    	//I'd like to do this without hard-coding the URL, but couldn't get it to work with the URL re-writer
    	PageReference clonedPage = new PageReference('/ServiceEdit/'+clonedService.portalServiceNumber__c);
    	clonedPage.setRedirect(false);
    	
    	return clonedPage;
    	
    }
    
    public pageReference commitApproval(){
    	
    	bindDaysField();
    	
    	system.debug('Getting commitApproval.');
    	Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
   		Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('DCE_ServiceAmend__c');
		Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
    	Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get('RequiredForApproval');
    	
    	string fieldsNeedingValue = '';
    	
    	system.debug('Field Members - '+fieldSetObj.getFields());
    	
    	for(Schema.FieldSetMember fsm : fieldSetObj.getFields()){
    		system.debug('Field Member - '+fsm.getFieldPath());
    		system.debug('Field Value - '+service.get(fsm.getFieldPath()));
    		
    		if(service.get(fsm.getFieldPath()) != null && service.get(fsm.getFieldPath()) != ''){ continue; }
    		
    		fieldsNeedingValue += '<li>'+fsm.getLabel()+'</li>';
    		
    	}
    	
    	boolean openingTimesAIssue = false;
    	boolean openingTimesABlank = false;
    	
    	system.debug('service.Recurrence__c - '+service.Recurrence__c);
    	system.debug('service.Days__c - '+service.Days__c);
    	system.debug('service.End_time_Hours__c - '+service.End_time_Hours__c);
    	system.debug('service.End_time_Minutes__c - '+service.End_time_Minutes__c);
    	system.debug('service.Start_time_Hours__c - '+service.Start_time_Hours__c);
    	system.debug('service.Start_time_Minutes__c - '+service.Start_time_Minutes__c);
    	
    	
    	if((service.Recurrence__c != null || service.Days__c != null || service.End_time_Hours__c != null || service.End_time_Minutes__c != null || service.Start_time_Hours__c != null || service.Start_time_Minutes__c != null) 
    			&&
    	   (service.Recurrence__c == null || service.Days__c == null || service.End_time_Hours__c == null || service.End_time_Minutes__c == null || service.Start_time_Hours__c == null || service.Start_time_Minutes__c == null)
    	){
    		system.debug('THERE IS AN OPENING TIMES ISSUE');
    		openingTimesAIssue = true;
    	}
    	
    	if(service.Recurrence__c == null && service.Days__c == null && service.End_time_Hours__c == null && service.End_time_Minutes__c == null && service.Start_time_Hours__c == null && service.Start_time_Minutes__c == null){
    		system.debug('OPENING TIMES A ALL BLANK');
    		openingTimesABlank = true;
    	}
    	
    	if(openingTimesAIssue || (openingTimesABlank && (service.Opening_times_Other__c == null || service.Opening_times_Other__c.trim().Length() == 0)  && service.Further_contact_requirements__c == null)){
			fieldsNeedingValue += '<li>The Opening Times section - Please completely fill in the Opening times (Option A), the "Opening Times - Other" or the "Further Contact Requirements" fields</li>';
    	}
    	
    	
    	system.debug('Fields needing completed - '+fieldsNeedingValue);
    	
    	if(fieldsNeedingValue != ''){
    		
    		displayPageError('Before submission for Approval, the following fields still require completion: <ul>'+fieldsNeedingValue+'</ul>');
    		return null;
    	}
    	
    	sendForApproval(service);
    	
    	if(!pageErrorMessage){
    		
    		User u = new User(Id = service.ServiceOwner__c, firstName = service.ServiceOwner__r.FirstName);
    		
    		DCE_MailUtils.sendApprovalCommencedEmail(service.serviceid__c, service.Name, u);
    	}
    	
    	return null;
    }
    
    public pageReference recallApproval(){
    	system.debug('Getting recallApproval.');
    	recallFromApproval(service.id);
    	return null;
    }
    
    public pageReference discardDraft(){
    	system.debug('Getting discardDraft.');
    	if(service.serviceId__c != null){
	    	service.status__c = 'Accepted - Transfer Complete';
	    	save();
    	} else {
    		delete service;
    	}
    	
    	return page.DCE_Dashboard;
    }
    
    public pageReference reviewed(){
    	//We only want to update the "Last Reviewed" date, so only include those fields here
    	system.debug('ABOUT TO REVIEW');
    	system.debug('service - '+service);
    	system.debug('service.ServiceId__c - '+service.ServiceId__c);
    	
    	DCE_ServiceAmend__c tempAmend = [select id, lastReviewed__c, ServiceId__c from DCE_ServiceAmend__c where ServiceId__c = :service.ServiceId__c limit 1];
    	set<string> fieldsToTransfer = new set<string>{'LastReviewed__c', 'serviceid__c'};
    	
    	//Update Last reviewed Date in Extranet
    	tempAmend.lastReviewed__c = system.today();
    	genericUpsert(tempAmend);
    	service.lastReviewed__c = system.today();
    	
    	//Push the value back to Dementia Connect
    	map<string, string> reviewDateFieldMap = new map<string, string>();
    	
    	for(string s : DCE_ServiceAmendWrapper.portalToProductionFieldMap.keySet()){
    		if(fieldsToTransfer.contains(s)){
    			reviewDateFieldMap.put(s, DCE_ServiceAmendWrapper.portalToProductionFieldMap.get(s));
    		}
    	}
    	
    	if(!test.isRunningTest()){ system.enqueueJob(new DCE_RestCallout_Handler(new list<SObject>{tempAmend}, reviewDateFieldMap, false)); }
    	
    	system.debug('Acount to send email');
    	DCE_MailUtils.sendServiceReviewEmail(service.id);
    	system.debug('Email sent');
    	
    	return null;
    }
    
    
    /* LIGHTNIGHT CONNECT VERSION
    		list<DCE_ServiceAmend__c> existingAmendments = [select id, DCEPartner__c, Dementia_Connect_Service__c 
    															from DCE_ServiceAmend__c
    															where Dementia_Connect_Service__c = :serviceId];*/ 
    															
    /*Services_c__x externalService = [select id, Name__c, Service_Type_c__c from Services_c__x where externalId = :serviceId];//NEED TO POPULATE WITH ALL FIELDS
    			service = new DCE_ServiceAmendWrapper(externalService).amend;*/
}