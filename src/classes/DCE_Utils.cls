public without sharing class DCE_Utils {
    
    private static User existingPortalUser;
    
    public static User getExistingPortalUser(string PersonEmail, string notContact){
		
		if(existingPortalUser != null ){ return existingPortalUser; }
			
		list<User> existingPortalUsers = [select id, Name, isActive, email, 
											Contact.MailingPostalCode, Contact.Phone, ContactId, Contact.Account.Id, Contact.Account.Name,
											Contact.Owner.IsActive,
											(Select NetworkId, Network.Name From NetworkMemberUsers)
											from User
											where email = :PersonEmail and ContactId != null and ContactId != :notContact];
	
		if(existingPortalUsers.size() > 0){ existingPortalUser = existingPortalUsers[0]; }
	
		return existingPortalUser;
			
		
	}
    
    public static void moveContact(string contact, string newAccount, boolean currentOwnerActive){
    	
    	Contact contToMove = new Contact(Id = contact, AccountId = newAccount);
    	
    	if(!currentOwnerActive){ contToMove.OwnerId = userInfo.getUserId(); }
    	
    	update contToMove;
    	
    	system.debug('Contact moved to - '+newAccount);
    	
    }
}