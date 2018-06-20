/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : This is a controller for the VF page which the Dementia Connect Team use during the sign-up process.
 				This page is available from a button on the Contact record and will be clicked on for Contacts who've just been converted from a Lead.
 				The Contact will relate to an Organisation within the Portal and this Organisation should also have a record set-up in Live CRS (manually, if it isn't already in live CRS)
 				The user then enters the ID of the Organisation in Live CRS and confirms that these two records in the different systems represent the same Organisation
 				Once the 2 Organisations have been linked, a button is made available that sends an email to the Contact asking them to confirm their sign-up. 
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
public with sharing class DCE_UserCreateKickOff {
    
    private static Id OrgWideEmailId = Community_Settings__c.getInstance('DCE_OrgWideEmail_Id').value__c;
    
    /*Used to show/hide some content on the page*/
    public boolean emailSent{
    	public get{
    		if(emailSent != null){ return emailSent;}
    		
    		emailSent = false;
    		
    		return emailSent;
    	}
    	
    	private set;    
    }
    
    @testVisible private final Contact person;
    
    /*Used to check if there is already a Community/Portal User for this Contact*/
	private User DCEUser{
		private get{
			if(DCEUser != null){ return DCEUser;}
			
			list<User> DCEUsers = [select id, isActive, email from User where ContactId = :person.id];
		
			if(DCEUsers.size() > 0){ DCEUser = DCEUsers[0]; }
		
			return DCEUser;
		}
		
		private set;
	}
	
	private boolean lookedForExistingPortalUser = false;
	
	/*Has to use DCE_Utils as THIS class obeys sharing. We need to override Sharing to find potential matches.*/
	public User existingPortalUser{
		
		public get{
			if(existingPortalUser != null ){ return existingPortalUser; }
			
			if(lookedForExistingPortalUser){ return null; }
			
			existingPortalUser = DCE_Utils.getExistingPortalUser(person.email, person.Id);
			
			lookedForExistingPortalUser = true; 
			
			return existingPortalUser;
			
		}
		
		private set;
		
		
	}
	
	/*Is there already a portal user with the same email address?*/
	public boolean alreadyPortalUser{
		public get{
    		if(alreadyPortalUser != null){ return alreadyPortalUser; }
    		
    		alreadyPortalUser = (existingPortalUser != null) ? true : false;
    		
    		return alreadyPortalUser;
    	}
    	private set;
	}
	
	
	public boolean alreadyDCEUser{
		public get{
    		if(alreadyDCEUser != null){ return alreadyDCEUser; }
    		
    		alreadyDCEUser = (DCEUser != null) ? true : false;
    		
    		return alreadyDCEUser;
    	}
    	private set;
    }
    
    public string userStatus{
		public get{
    		if(userStatus != null){ return userStatus; }
    		
    		userStatus = 'inactive';
    		
    		if(DCEUser != null && DCEUser.IsActive){ userStatus = 'active'; }
    		
    		return userStatus;
    	}
    	private set;
    }
    
    public Account partnerOrg{
    	public get{
    		if(partnerOrg != null){ return partnerOrg; }
    		
    		partnerOrg = [select id, Name, DCEProdOrgID__c from Account where Id = :person.accountId];
    		
    		return partnerOrg;
    	}
    	
    	public set;
    }
    
    /*This getter returns Account/Organisation details from live CRS based on the supplied Id, so that the User has some details on screen to confirm that they're definitely linking to the right Organisation in live CRS*/
    public DCE_OrgAmend__c prodAccount{
    	public get{
    		if(prodAccount != null){ return prodAccount; }
    		
    		if(partnerOrg.DCEProdOrgID__c == null){ return null; }	
    		
    		try{
    			partnerOrg.DCEProdOrgID__c = Id.valueOf(partnerOrg.DCEProdOrgID__c);
    		} catch (exception e) {
    			apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There is an issue with the Partner Org ID you have chosen. Please check that and try again. - '+e.getMessage()));
    			return null;
    		}
    		
    		string queryEndPoint = WEBC_CommunityWrapper.getCustomSetting('RestEndpoint','DCE')+'/services/data/v35.0/query';
			queryEndPoint += '?q='+EncodingUtil.urlEncode('select '+DCE_OrgAmendWrapper.fieldsOfInterestProduction+' from Account where Id = \''+partnerOrg.DCEProdOrgID__c+'\' LIMIT 1', 'UTF-8');//:CRSAccountId LIMIT 1', 'UTF-8'); //where Operated_By__c = \'0013E000001QUSy\'
			
			DCE_RestConnector request = new DCE_RestConnector(queryEndPoint, 'GET');
			
			if(!request.restError){
				prodAccount = new DCE_OrgAmendWrapper(request.res.getbody()).partner;
			} else {
				apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error getting details - '+request.restErrorMessage));
			}
			
			return prodAccount;
    	}
    	
    	private set;
    }
    
    public DCE_UserCreateKickOff(ApexPages.StandardController controller){
    	
    	if(!test.isRunningTest()){controller.addFields(new list<string>{'Id','AccountId','FirstName','email'});}
    	
    	person = (Contact)controller.getRecord();
    	
    	if(person.email == null){ apexPages.addMessage(new apexPages.Message(ApexPages.SEVERITY.INFO, 'This Person record has no email address. You will not be able to set them up as a User.')); }
    	if(alreadyDCEUser){apexPages.addMessage(new apexPages.Message(ApexPages.SEVERITY.INFO, 'This Contact already has a portal license. If you want them to be a Dementia Connect Partner Portal User, please talk to your salesforce administrator.')); }
    	
    	if(partnerOrg.DCEProdOrgID__c != null){ partnerConfirmed = true; }
    	
    }
    
    
    /*Nulls the "prodAccount" variable, so that it will refetch the details from Live CRS in the next screen refresh*/
    public pageReference searchPartner(){
    	
    	try{
			partnerOrg.DCEProdOrgID__c = Id.valueOf(partnerOrg.DCEProdOrgID__c);
		} catch (exception e) {
			apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There is an issue with the Partner Org ID you have chosen. Please check that and try again. - '+e.getMessage()));
			return null;
		}
    	
    	prodAccount = null;
    	partnerConfirmed = false;
    	
    	return null;
    }
    
    public boolean partnerConfirmed{
    	get{
    		
    		if(partnerConfirmed == null){ partnerConfirmed = false; }
    		
    		return partnerConfirmed;
    	}
    	
    	
    	private set;
    } 
    
    /* Confirms that the Organisation is being linked to the correct Organisation in Live CRS */
    public pageReference confirmPartner(){
    	
    	try{
	    	partnerOrg.DCEProdOrgID__c = Id.valueOf(partnerOrg.DCEProdOrgID__c);
	    	update partnerOrg;
	    	partnerConfirmed = true;
    	} catch (exception e){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There is an issue with the Partner Org ID you have chosen. Please check that and try again. - '+e.getDmlMessage(0)));
    		return null;
    	}
    	
    	return null;
    }
    
    /* Sends an email to the Contact informing them that their request to join the portal has been approved and they can follow a link to sign-up. */
    public pageReference sendEmail(){
    	
    	if(partnerOrg.DCEProdOrgID__c == null){ return null; }
    	
    	if(person.email == null || alreadyDCEUser || emailSent){ return null; }
    	
    	EmailTemplate email = [select id, Body, subject from EmailTemplate where DeveloperName = 'DCE_Verification_Request' limit 1];
    	
    	string cryptoKey = WEBC_CommunityWrapper.getCustomSetting('Secret_Key','DCE');
    	
    	string encodedId = WEBC_CryptoUtils.encryptValue(person.id, cryptoKey);
    	
    	string emailBody = email.Body.replace('{{contact_name}}', person.FirstName);
    	emailBody = emailBody.replace('{{verifyLink}}', WEBC_CommunityWrapper.getCustomSetting('Stub_Url','DCE')+'sign-up/'+EncodingUtil.urlEncode(encodedId, 'UTF-8'));
    	
    	return deliverEmail(emailBody, email.subject);
    	
    }
    
    private pageReference deliverEmail(string emailBody, string subject){
    	
    	Messaging.reserveSingleEmailCapacity(1);
    	
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	mail.setPlainTextBody(emailBody);
    	mail.setSubject(subject);
    	//mail.setToAddresses(new list<string>{person.email});
    	mail.setTargetObjectId(person.id);
    	
    	if(OrgWideEmailId != null){ mail.setOrgWideEmailAddressId(OrgWideEmailId); }
    	
    	list<Messaging.SendEmailResult> result = messaging.sendEmail(new list<Messaging.Email>{mail});
    	
    	if(!result.get(0).isSuccess()){
    		emailSent = false;
    		
    		string errors = 'There were issues sending the email to this Contact: <ul>';
    		
    		for(messaging.SendEmailError err : result.get(0).getErrors()){
    			errors += '<li><b>'+err.StatusCode+'</b> '+err.Message+'</li>'; 
    		}
    		
    		errors += '</ul>';
    		
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errors));
    		
    	} else {
    		emailSent = true;
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'An email has been sent to this Contact. They will be given a link to log-in and create a new user.'));
    	}
    	
    	return null;
    	
    }
    
	public boolean getExistingContactMoved(){

		boolean existingContactMoved = false;

		if(existingPortalUser != null && existingPortalUser.Contact.AccountId == person.AccountId){ existingContactMoved = true; }
		
		return existingContactMoved;
    
	}
    
    /* Moves an existing Portal User Contact into this Organisation record, so that they can be merged (if necessary) */
    public void assignExisting(){
    	
    	system.debug('About to move the Contact to - '+person.AccountId);
    	
    	if(existingPortalUser == null){ return; }
    	
    	DCE_Utils.moveContact(existingPortalUser.ContactId, person.AccountId, existingPortalUser.Contact.Owner.IsActive);
    	
    	system.debug('Contact moved');
    	
    	insert new DCEProfile__c(Contact__c = existingPortalUser.ContactId, Active__c=true);
    	
    	system.debug('DCE Profile Assigned');
    	
    	lookedForExistingPortalUser = false;
    	existingPortalUser = null;
    	
    	EmailTemplate email = [select id, Body, subject from EmailTemplate where DeveloperName = 'DCE_Existing_User' limit 1];
    	
    	string emailBody = email.Body.replace('{{contact_name}}', person.FirstName);
    	
    	deliverEmail(emailBody, email.subject);
    	
    }
    
}