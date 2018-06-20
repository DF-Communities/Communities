public without sharing class DCE_newUserRegisterController extends DCE_ControllerUtils{
    
	public string password1{get; set;}
    public string password2{get; set;}
   
	private string ContactId{
    	private get{
    		if(ContactId != null){ return ContactId; }
    		
    		ContactId = '';
    		
    		if(ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get('cid') != null){
				string cryptoKey = Community_Settings__c.getInstance('DCE_Secret_Key').value__c;
    			system.debug('Here is the crypto key - '+cryptoKey);
				ContactId = WEBC_CryptoUtils.decryptValue(ApexPages.currentPage().getParameters().get('cid'), cryptoKey);
    			
    			if(ContactId.startsWith('Error :')){throw new DCE_Exception('Failure to find Contact from Id - '+ContactId);}
    			
    			system.debug('ContactId - '+ContactId);
    			
    		} else {
    			throw new DCE_Exception('This page requires correct parameters to function correctly. Please check your URL.');
    		}
    		
    		return ContactId;
    	}
    	
    	private set;
    }
    
    
    @testVisible private Contact person{
    	private get{
    		if(person != null){ return person;}
    			
    		if(ContactId == null || ContactId == ''){ return null; }
    		if(userAlreadyExists){ return null;}
    		
    		
    		list<Contact> pList = [select id, AccountId, Contact.Account.Name, FirstName, LastName, Email, Phone, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode 
    								from Contact 
    								where Id = :ContactId];
    		
    		if(pList.size() > 0){
    			person = pList[0];
    			return person;
    		}
    		
    		system.debug('Here is the person - '+person);
    		return person;
    	}
    	
    	private set;
    }
    
    public boolean userAlreadyExists{
    	public get{
    		if(userAlreadyExists != null){ return userAlreadyExists; }
    		
    		userAlreadyExists = false;
    		
    		list<User> existingUsers = [select id, Name from User where ContactId = :ContactId];
    		
    		if(existingUsers.size() > 0){
    			
    			displayPageError('This link has already been used to create a User. If you would like to create another user, please contact the Dementia Connect Team, or use the request form.');
    			userAlreadyExists = true;
    		}
    		
    		return userAlreadyExists;
    	}
    	
    	private set;
    }
    
    public user user{
    	public get{
    		if(user != null){ return user; }
    		
    		if(userAlreadyExists){
    			return null;
    		}
    		
    		if(person == null){ 
    			system.debug('Contact record was null.');
    			displayPageError('This link does not relate to a recognised record. Please check link included in your new user registration email.');
    			return null; 
    		}
    		
    		string sAlias = person.firstName.substring(0,1)+person.lastName;
    		
    		if(sAlias.length() > 5){
    			sAlias = sAlias.substring(0,6);
    		}
    		
    		string nickname = sAlias+system.today().year()+system.today().month()+system.today().day()+integer.valueOf(Math.random()*1000);
    		
    		User = new User(FirstName = person.firstName, lastName = person.lastName, userName = person.email, email=person.email, alias = sAlias, contactId = person.id, CommunityNickname=nickname, CompanyName = person.Account.Name, TimeZoneSidKey='GMT', LocaleSidKey='en_GB', EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US', ProfileId = Community_Settings__c.getvalues('DCE_Default_Profile_Id').value__c, phone=person.phone, street = person.mailingstreet, city=person.mailingcity, state=person.mailingstate, country = person.mailingcountry, postalCode=person.mailingpostalcode);//Community_Settings__c.getvalues('DCE_Default_Profile_Id').value__c); //, Accountid=person.accountId,UserType='CspLitePortal'
    		
			system.debug('Here is the user - '+user);
    		
    		return User;
    	}
    	
    	public set;
    }
    
    public DCE_newUserRegisterController(){
    	
    	userAlreadyExists = userAlreadyExists;
    	user = user;
    	
    }
    
    public pageReference autoLogin(){
    	if(isLoggedIn){ return Page.DCE_Dashboard;}
    	
    	if(userAlreadyExists){ return page.DCE_LoginPage;}
    	
    	return null;
    }
    
    public pageReference registerUser(){
    	
    	//update person;
    	
    	if(userAlreadyExists){ return null;}
    	
    	user.username = user.email;
    	
    	list<User> emailAlreadyUsed = [select id from User where username = :user.Email limit 1];
    	
    	if(emailAlreadyUsed.size() > 0){
    		displayPageError('This email address is already in use - Please talk to the Dementia Connect team about getting that email set up for use on the Portal.');
    		return null;
    	}
    	
    	if(!test.isRunningTest()){
	    	site.validatePassword(user, password1, password2);
	    	//CANNOT TEST - Salesforce System Error: 1199713453-68094 (-1123129540) (-1123129540)
    	}
    	
    	if(ApexPages.getMessages().size() > 0){
    		//CANNOT TEST - Salesforce System Error: 1199713453-68094 (-1123129540) (-1123129540)
    		
    		string passwordErrors = '';
    		
    		for(ApexPages.Message message : ApexPages.getMessages()){
    			passwordErrors += message.getSummary();
    		}
    		
    		displayPageError(passwordErrors);
    		
    		return null;
    	}
    	
    	
    	system.debug('About to create a new user');
    	try{
    		system.debug('Here is the user - '+user);
    		system.debug('Here is the accountId - '+person.accountId);
    		system.debug('Here is the password1 - '+password1);
    		
    		id newUserId = site.createExternalUser(user, person.accountId, password1, false);
    		
    		system.debug('User created - '+user);
    		system.debug('created a new user - '+newUserId);
    		
    		if(newUserId != null){
	    		//Cannot test - createExternalUser doesn't return an id value
	    		
	    		//if(!test.isRunningTest()){ system.enqueueJob(new DCE_newUserRegister_Queuable(newUserId)); }
	    		try{
	    			
	    			insert new DCEProfile__c(Contact__c = person.id, Active__c=true);
	    		
	    			PageReference LoginPage = page.DCE_LoginPage;
	    			LoginPage.getParameters().put('u', EncodingUtil.urlEncode(user.username, 'UTF-8'));
	    		
	    			system.debug('Redirect to login page TEST - '+LoginPage.getUrl());
	    		
	    			return LoginPage;
	    		} catch (exception e) {
	    			genericError();
	    		}
	    		
	    	} else {
	    		genericError();
	    	}
    	} catch (Site.ExternalUserCreateException ex) {
    		//Cannot test - createExternalUser doesn't throw an exception.
    		system.debug('There was an error');
    		
    		string userError = 'There were one or more errors creating your user:<ul>';
    		
    		for(string s : ex.getDisplayMessages()){
    			userError += '<li>'+s+'</li>';
    		}
    		
    		userError += '</ul>';
    		
    		displayPageError(userError);
    		
    		system.debug('Page message - '+userError);
    	} catch (Exception e){
    		genericError(e.getMessage());
    	}
    	
    	return null;
    }
    
    private pageReference genericError(){
    	 return genericError(null);
    }
    
    private pageReference genericError(string e){
    	system.debug('Generic Error');
    	
    	string errormessage = 'There was an error creating your user. Please contact the Dementia Connect administration team on XXXXXXXXXXXXXX and provide your details to be set up manually.';
    	
    	if(e != null){ errormessage += ' ERROR: '+e; }
    	
    	displayPageError(errormessage);
    	return null;
    }
    
}