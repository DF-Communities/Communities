public with sharing class DCE_UserDetailsController extends DCE_ControllerUtils{
    
    public User user{
    	public get{
    		
    		if(user != null){ return user;}
    		
    		user = [select id, FirstName, LastName, title, email, Phone, Street, City, State, Country, PostalCode, ContactId
    					from User
    					where id = :userInfo.getUserId()];
    		
    		return user;
    	}
    	
    	public set;
    }
    
    private Contact userContact{
    	private get{
    		
    		if(userContact!= null){ return userContact;}
    		if(user == null || user.ContactId == null){return null;}
    		    		
    		userContact = [select id, FirstName, LastName, title, email, phone, mailingStreet, mailingCity, mailingState, mailingCountry, mailingPostalCode
    						from Contact where Id = :user.contactId];
    		
    		return userContact;
    	}
    	
    	private set;
    }
    
    public pageReference save(){
    	
    	user.username = user.email;
    	
    	genericUpsert(user);
    	
    	if(pageErrorMessage){ return null; }
    	if(userContact == null){ return null; }
    	
		userContact.FirstName = user.FirstName;
    	userContact.LastName = user.LastName;
    	userContact.Email = user.Email;
    	userContact.Phone = user.Phone;
    	userContact.mailingStreet = user.Street;
    	userContact.mailingCity = user.City;
    	userContact.mailingState = user.State;
    	userContact.mailingCountry = user.Country;
    	userContact.MailingPostalCode = user.PostalCode;
    	
    	
    	//if(!test.isRunningTest()){ system.enqueueJob(new DCE_UserDetailsController_Queued(userContact)); }
    	system.enqueueJob(new DCE_UserDetailsController_Queued(userContact));
    	//genericUpsert(userContact);
    	
    	return null;
    	
    }
    
}