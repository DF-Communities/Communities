public without sharing class DCE_MailUtils extends DCE_ControllerUtils{
    
    //Id partnerId;
    private static Id OrgWideEmailId = Community_Settings__c.getInstance('DCE_OrgWideEmail_Id').value__c;
    private static string emailRecipient = Community_Settings__c.getInstance('DCE_SendEmailsTo').value__c;
    
    
	//string stubUrl = Community_Settings__c.getInstance('DCE_Stub_Url').value__c;

	/*
	public DCE_MailUtils(Id partnerId){
    	this.partnerId = partnerId;
    }
    
    public DCE_MailUtils(){
    	
    }*/
    
    /*
    private list<User> recipients{
		private get{
			if(recipients != null){ return recipients;}
    		
			recipients = [select id, FirstName, LastName, Name 
    							from User 
    							where isActive = true and Contact.AccountId = :partnerId and  id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME)];
    	
    		return recipients;
    	}
    	
    	private set;
    }*/
    
	public static boolean sendApprovalCommencedEmail(Id recordId, string serviceName, User u){
    	
    	try{
    	
			u = [select id, firstName from User where Id = :u.Id limit 1];
			//Messaging.reserveSingleEmailCapacity(recipients.size());
			
			list<Messaging.singleEmailMessage> emails = new list<Messaging.singleEmailMessage>();
	    	
	    	map<String,String> mapValues = new map<string, string>();
	    	mapValues.put('FirstName', u.FirstName);
	    	mapValues.put('serviceName', serviceName);
	    		
	    	emails.add(Mail_Utils.getEmailWithData('ApprovalAmendmentSubmitted', u.id, null, OrgWideEmailId,false,null, mapValues));
	    		    	
	    	if(emails.size() > 0){
	    		Messaging.sendEmail(emails);
	    	}
	    	
	    	return true;
    	} catch (Exception e){
    		system.debug('ERROR - '+e);
    		return false;
    	}
    }
    
    public static boolean sendUserActiveUpdate(list<DCEProfile__c> users){
    	
    	try{
    	
			list<Messaging.singleEmailMessage> emails = new list<Messaging.singleEmailMessage>();
	    	
	    	set<id> contactId = new set<id>();
	    	
	    	for(DCEProfile__c u : users){
	    		contactId.add(u.Contact__c);
	    	}
	    	
	    	map<Id, Id> contactToUserMap = new map<Id, Id>();
	    	
	    	for (User u : [select id, Name, ContactId from User where ContactId IN :contactId]){
	    		contactToUserMap.put(u.ContactId, u.id);
	    	}
	    	
	    	for(DCEProfile__c u : users){
	    		system.debug('Here are the user details - '+u);
	    		
	    		if(!contactToUserMap.containsKey(u.Contact__c)){ continue; }
	    		
	    		map<String,String> mapValues = new map<string, string>();
	    		mapValues.put('FirstName', u.Contact__r.FirstName);
	    		mapValues.put('Status', u.Active__c ? 'Active' : 'Suspended');
	    		
	    		emails.add(Mail_Utils.getEmailWithData('User_Management_Active_status_changed', contactToUserMap.get(u.Contact__c), null, OrgWideEmailId,false,null, mapValues));
	    	}
	    	
	    		    	
	    	if(emails.size() > 0){
	    		Messaging.sendEmail(emails);
	    	}
	    	
	    	return true;
    	} catch (Exception e){
    		system.debug('ERROR - '+e);
    		return false;
    	}
    	
    	
    }
    
	public static boolean mailOwnerChanged(list<Id> recordIds, map<Id, DCE_ServiceAmend__c> oldMap, map<Id, DCE_ServiceAmend__c> newMap){
    	
		try{
    	
	    	//Messaging.reserveSingleEmailCapacity(recordIds.size());
				
			set<Id> UserIds = new set<Id>();
			
			for(Id record : recordIds){
				UserIds.add(oldMap.get(record).serviceOwner__c);
				UserIds.add(newMap.get(record).serviceOwner__c);
			}
			
			map<Id, User> userMap = new Map<Id, User>([select id, FirstName, LastName from User where Id IN :UserIds]);
			
			list<Messaging.singleEmailMessage> emails = new list<Messaging.singleEmailMessage>();
	    	
	    	for(Id record : recordIds){
	    		Map<String,String> mapValues = new map<string, string>();
		    	mapValues.put('FirstName', userMap.get(oldMap.get(record).serviceOwner__c).FirstName);
		    	mapValues.put('ServiceName', oldMap.get(record).Name);
		    	mapValues.put('NewOwner', userMap.get(newMap.get(record).serviceOwner__c).FirstName+' '+userMap.get(newMap.get(record).serviceOwner__c).LastName);
		    		
		    	emails.add(Mail_Utils.getEmailWithData('DCEService_Ownership_Change', oldMap.get(record).serviceOwner__c, null, OrgWideEmailId,false,null, mapValues));
	    	}
	    	
	    	if(emails.size() > 0){
	    		Messaging.sendEmail(emails);
	    	}
	    	
	    	return true;
	    	
		} catch (Exception e){
    		system.debug('ERROR - '+e);
    		return false;
		}
    	
	}
	
	public static boolean monthlyMailDigest(list<User> users){
		try{
    	
	    	if(OrgWideEmailId == null){throw new DF_Mail_Exception ('[U-50] Custom Setting called \'DCE_OrgWideEmail_Id\' did not return an org-wide email address');}
	    	
	    	//Messaging.reserveSingleEmailCapacity(userIds.size());
			list<Messaging.singleEmailMessage> emails = new list<Messaging.singleEmailMessage>();
	    	
	    	Id templateId; 

	        try {
	            
				templateId = [select id, name from EmailTemplate where developername = 'DCEServiceReviewDigest'].id;
	        
			} catch (Exception e) {
	
	               throw new DF_Mail_Exception ('[U-03] Unable to locate EmailTemplate using name: DCEServiceReviewDigest refer to Setup | Communications Templates ');
			}
	        
	        for(User u : users){
	        	Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
		        
				email.setTargetObjectId(u.id);
				email.setorgWideEmailAddressId(orgWideEmailId);
				email.setTemplateId(templateId);
				email.setSaveAsActivity(false);
		    	
		    	system.debug('Here is the email - '+email);
		    	emails.add(email);
		    }
	    	
	    	if(emails.size() > 0){
	    		system.debug('We have '+emails.size()+' emails to send');
	    		
	    		try{
	    		
	    			list<Messaging.SendEmailResult> results = Messaging.sendEmail(emails);
	    		} catch (EmailException e) {throw new DF_Mail_Exception('[U-51] DCE email sending error ' + e.getMessage());}
	    			
	    	}
	    	
	    	return true;
	    	
		} catch (Exception e){
    		system.debug('ERROR - '+e);
    		return false;
		}
	}
	
	public static boolean sendServiceReviewEmail(ID ServiceId){
		
		DCE_ServiceAmend__c service = [select id, Name, DCEPartner__r.Name, LastModifiedBy.Name from DCE_ServiceAmend__c where id = :ServiceId limit 1];
		
		
		try{
    	
	    	if(OrgWideEmailId == null){throw new DF_Mail_Exception ('[U-50] Custom Setting called \'DCE_OrgWideEmail_Id\' did not return an org-wide email address');}
	    	
	    	if(emailRecipient == null){throw new DF_Mail_Exception ('[U-51] Custom Setting called \'DCE_SendEmailsTo\' did not return an delivery address');}
	    	
	    	string emailString = 'Dear Dementia Connect Team\r\r'+
	    						'The following service in the portal has had its Review date updated.\r\r'+ 
								'Name: '+service.Name+'\r'+ 
								'Organisation: '+service.DCEPartner__r.Name+'\r'+ 
								'Updated by: '+service.LastModifiedBy.Name+'\r\r'+ 
								'Link: '+system.URL.getSalesforceBaseUrl().toExternalForm()+'/'+service.id+'\r\r'+ 
								'With thanks,';
	    	
	    	//Messaging.reserveSingleEmailCapacity(userIds.size());
			list<Messaging.singleEmailMessage> emails = new list<Messaging.singleEmailMessage>();
	    	
	    	Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
		    
		    
		    email.setPlainTextBody(emailString);    
			email.setorgWideEmailAddressId(orgWideEmailId);
			email.setToAddresses(new list<string>{emailRecipient});
			email.setSaveAsActivity(false);
			email.setSubject('Dementia Connect Portal - Review date updated');
		    	
		    system.debug('Here is the email - '+email);
		    emails.add(email);
		   
	    	
	    	if(emails.size() > 0){
	    		system.debug('We have '+emails.size()+' emails to send');
	    		
	    		try{
	    		
	    			list<Messaging.SendEmailResult> results = Messaging.sendEmail(emails);
	    		
	    		} catch (EmailException e) {throw new DF_Mail_Exception('[U-51] DCE email sending error ' + e.getMessage());}
	    			
	    	}
	    	
	    	return true;
	    	
		} catch (Exception e){
    		system.debug('ERROR - '+e);
    		return false;
		}
	}
    
}