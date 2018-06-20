@isTest
public class DCE_TestDataFactory {

    public static list<Community_Settings__c> communitySettings;
    public static list<Account> partners;
    public static Account partner1;
    public static DCE_OrgAmend__c partner1orgAmend;
    public static list<Contact> partner1Contacts;
    public static list<Contact> partnerContacts;
    public static list<User> partner1Users;
    public static list<User> partnerUsers;
    public static list<DCE_ServiceAmend__c> partner1Amends;
    public static list<DCE_ServiceAmend__c> partnerServiceAmends;
    
    public static void setUpDataWithAmends(){
    	createCustomSettings();
    	createPartnerServiceAmends();//createPartner1ServiceAmends();
    	createPartner1OrgAmend();
    }
    
    public static void setUpDataWithAmendsAsync(){
    	createCustomSettings();
    	createPartnerServiceAmendsAsync();//createPartner1ServiceAmends();
    	createPartner1OrgAmend();
    }
    
    public static void setUpDataWithoutAmends(){
    	createCustomSettings();
    	createPartnerUsers();//createPartner1ServiceAmends();
    }

    public static list<Community_Settings__c> createCustomSettings(){
    	
    	if(communitySettings != null){ return communitySettings; }
    	
    	OrgWideEmailAddress owe = [select id from OrgWideEmailAddress where DisplayName = 'Dementia Connect'];
    	Profile DCEProfile = [select id from Profile where Name = 'Customer Community Login User'];//
    	
    	
    	communitySettings = new list<Community_Settings__c>();
    	
    	communitySettings.add(new Community_Settings__c(Name='DCE_Stub_Url', Value__c='https://Instance.salesforce.com/'));
    	communitySettings.add(new Community_Settings__c(Name='DCE_RestEndpoint', Value__c='https://Instance.salesforce.com'));
    	communitySettings.add(new Community_Settings__c(Name='DCE_OrgWideEmail_Id', Value__c=owe.id));
    	communitySettings.add(new Community_Settings__c(Name='DCE_Secret_Key', Value__c=WEBC_CryptoUtils.createCryptoKey()));
    	communitySettings.add(new Community_Settings__c(Name='DCE_Default_Profile_Id', Value__c=DCEProfile.id));
    	communitySettings.add(new Community_Settings__c(Name='DCE_SendEmailsTo', Value__c='akudhawkdhakwdd@akdawkduhawkduhawkuh.com'));
    	
    	insert communitySettings;
    	
    	return communitySettings;
    }
    
    
    
    public static Account createPartner1(){
    	
    	if(partner1 != null){ return partner1; }
    	
    	partner1 = CreatePartners(5)[0];
    	
    	return partner1;
    }
    
	public static list<Account> CreatePartners(integer numOfPartners){
    	if(partners != null){ return partners; }
    	
    	partners = new list<Account>();
    	
    	for(integer i = 1 ; i <= numOfPartners; i++){
    		
    		string fakeId = '001'+i+'234567890ABCDE';
    		
    		if(fakeId.length() > 18){ fakeId = fakeId.substring(0,18); }
    		
    		partners.add(new Account(Name = 'PartnerAccount'+i, DCEProdOrgID__c=fakeId));
    		
    	}
    	
    	insert partners;
    	
    	partner1 = partners[0];
    	
    	return partners;
	}

    public static list<Contact> newPartner1Contacts(integer numOfContacts){
    	if(partner1 == null){ createPartner1(); }
    	
    	list<Contact> newPartner1Contacts = new list<Contact>();
    	
    	for(integer i=1 ; i <= numOfContacts; i++){
    		
    		newPartner1Contacts.add(new Contact(FirstName = 'John', LastName = 'TestPerson'+i, AccountId=partner1.id, email = 'DCE48637654'+i+'@DCEhoijhadwkuhd.com'));
    		
    	}
    	
    	return newPartner1Contacts;
    }
    
    public static list<Contact> createPartner1Contacts(integer numOfContacts){
    	
    	if(partner1Contacts != null){ return partner1Contacts; }
    	
    	partner1Contacts = newPartner1Contacts(numOfContacts);
    	
    	insert partner1Contacts;
    	
    	return partner1Contacts;
    }
    
    public static list<Contact> createPartnerContacts(integer numOfContactsPerPartner){
    	
    	if(partnerContacts != null){ return partnerContacts; }
    	
    	partnerContacts = new list<Contact>();
    	
    	if(partners == null){ CreatePartners(5); }
    	
    	integer accNum = 1;
    	
    	for(Account a : partners){
    		
			for(integer i=1 ; i <= numOfContactsPerPartner; i++){
    		
	    		partnerContacts.add(new Contact(FirstName = 'John - '+a.Name, LastName = 'TestPerson'+i, AccountId=a.id, email = 'DCE48637654'+accNum+i+'@DCEhoijhadwkuhd.com'));
	    		
	    	}
	    	accNum++;
    	}
    	
    	insert partnerContacts;
    	return partnerContacts;
    	
    }

	public static list<User> createPartner1Users(){
    	
    	if(partner1Users != null){ return partner1Users; }
    	
    	if(partnerUsers == null){ createPartnerUsers(); }
    	
    	return partner1Users;
    }
    
    
    public static User createNonDCEPartnerUser(){
		
		Account freshPartner = new Account(name='Brand New Account');
		insert freshPartner;
    	
    	Contact freshContact = new Contact(FirstName = 'John - '+freshPartner.Name, LastName = 'TestPerson', AccountId=freshPartner.id, email = freshPartner.Name.deleteWhitespace()+'@DCEhoijhadwkuhd.com');
    	insert freshContact;
    	
    	Profile DCEProfile = [select id from Profile where Name = 'Customer Community Login User' ];
    	
		string sAlias = freshContact.firstName.substring(0,1)+freshContact.lastName;
    		
		if(sAlias.length() > 5){
			sAlias = sAlias.substring(0,6);
		}
    		
    	string nickname = sAlias+system.today().year()+system.today().month()+system.today().day()+integer.valueOf(Math.random()*1000)+integer.valueOf(Math.random()*1000);
    		
    	User u = new User(isActive = true, FirstName = freshContact.firstName, lastName = freshContact.lastName, userName = freshContact.email, email=freshContact.email, alias = sAlias, contactId = freshContact.id, CommunityNickname=nickname,TimeZoneSidKey='GMT', LocaleSidKey='en_GB', EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US', ProfileId = DCEProfile.id, userRoleId = null);
    	
    	insert u;
		
		return u;
		
	}
	
	
	public static list<User> createPartnerUsers(){
		
		if(partnerUsers != null){ return partnerUsers; }
		
		partnerUsers = new list<User>();
		
		if(partnerContacts == null){ createPartnerContacts(5); }
		
		Profile DCEProfile = [select id from Profile where Name = 'Customer Community Login User' ];
    	
    	for(Contact c : partnerContacts){
    		string sAlias = c.firstName.substring(0,1)+c.lastName;
    		
    		if(sAlias.length() > 5){
    			sAlias = sAlias.substring(0,6);
    		}
    		
    		string nickname = sAlias+system.today().year()+system.today().month()+system.today().day()+integer.valueOf(Math.random()*1000)+integer.valueOf(Math.random()*1000);
    		
    		
    		User u = new User(isActive = true, FirstName = c.firstName, lastName = c.lastName, userName = c.email, email=c.email, alias = sAlias, contactId = c.id, CommunityNickname=nickname,TimeZoneSidKey='GMT', LocaleSidKey='en_GB', EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US', ProfileId = DCEProfile.id, userRoleId = null);
    		system.debug('Username - '+u.username);
    		
    		partnerUsers.add(u);
    		
    		if(c.AccountId == partner1.id){
    			if(partner1Users == null){ partner1Users = new list<User>(); }
    			
    			partner1Users.add(u);
    		}
    	}
    	
    	insert partnerUsers;
    	
    	User uAdmin = new User (Id = UserInfo.getUserId());
    	
    	system.runAs(uAdmin){
	    	PermissionSet DCESet = [select id, Name from PermissionSet where Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME];
		    		
		    		
	    	list<PermissionSetAssignment> pmaList = new list<PermissionSetAssignment>();
	    	list<DCEProfile__c> profileList = new list<DCEProfile__c>(); 
	    	
	    	for(User u : partnerUsers){
	    		system.debug('u - '+u);
	    		system.debug('DCESet - '+DCESet);
	    		PermissionSetAssignment DCEPSA = new PermissionSetAssignment(AssigneeId=u.id, PermissionSetId=DCESet.id);
		    	pmaList.add(DCEPSA);
		    	
		    	profileList.add(new DCEProfile__c(Contact__c = u.ContactId, Active__c = true));
		    	
	    	}
	    	
	    	insert pmaList;
	    	insert profileList;
	    }
	    
		return partnerUsers;
		
	}
    
    public static list<DCE_ServiceAmend__c> createPartnerServiceAmends(){
    	
		if(partnerServiceAmends != null){ return partnerServiceAmends;}
    	if(partnerUsers == null){ createPartnerUsers();}
    	
    	
		partnerServiceAmends = new list<DCE_ServiceAmend__c>();
    	
		integer i = 1;
		for(User u : [select id, Name, AccountId from User where Id IN :partnerUsers]){ //Need to requery to get the accountid
			
			for(integer j = 1 ; j<=5 ; j++){
				DCE_ServiceAmend__c newService = new DCE_ServiceAmend__c(Name='New Service '+i+j, DCEPartner__c=u.AccountId, ServiceOwner__c=u.id, lastReviewed__c = system.today().addMonths(-1-(j*3)), service_status__c = 'Open', Opening_times_Other__c = 'Example opening times');
				
				//The below will give 1 - New service, 2, 3 & 5 - Live services, 4 - Live service with Amends in progress
				
				if(j==1 || j == 4){
					newService.status__c = 'Draft';
				} else {
					newService.status__c = 'Accepted - Transfer Complete';
				}
				
				if(j != 1){
					
					string fakeServiceId = 'a0z'+j+i+'34567890ABCDE';
					newService.serviceId__c = fakeServiceId.length() > 18 ? fakeServiceId.substring(0,18) : fakeServiceId; 
				}
				
				partnerServiceAmends.add(newService);
			}
			i++;
		}
    	
		insert partnerServiceAmends;
		
		return partnerServiceAmends;
    }
    
    public static list<DCE_ServiceAmend__c> createPartnerServiceAmendsAsync(){
    	
		if(partnerServiceAmends != null){ return partnerServiceAmends;}
    	//if(partnerUsers == null){ createPartnerUsers();}
    	
    	list<User> partnerUsersAsync = [select id, Name, AccountId from User where isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 15];
    	
		partnerServiceAmends = new list<DCE_ServiceAmend__c>();
    	
		integer i = 1;
		for(User u : partnerUsersAsync){ //NEed to requery to get the accountid
			
			for(integer j = 1 ; j<=5 ; j++){
				DCE_ServiceAmend__c newService = new DCE_ServiceAmend__c(Name='New Service '+i+j, DCEPartner__c=u.AccountId, ServiceOwner__c=u.id, lastReviewed__c = system.today().addMonths(-1-(j*3)), service_status__c = 'Open', Opening_times_Other__c = 'Example opening times');
				
				//The below will give 1 - New service, 2, 3 & 5 - Live services, 4 - Live service with Amends in progress
				
				if(j==1 || j == 4){
					newService.status__c = 'Draft';
				} else {
					newService.status__c = 'Accepted - Transfer Complete';
				}
				
				if(j != 1){
					
					string fakeServiceId = 'a0z'+j+i+'34567890ABCDE';
					newService.serviceId__c = fakeServiceId.length() > 18 ? fakeServiceId.substring(0,18) : fakeServiceId; 
				}
				
				partnerServiceAmends.add(newService);
			}
			i++;
		}
    	
		insert partnerServiceAmends;
		
		return partnerServiceAmends;
    }
	
	/*public static list<DCE_ServiceAmend__c> createPartner1ServiceAmends(){
    	
		if(partner1Amends != null){ return partner1Amends;}
    	
		if(partner1Users == null){createPartnerUsers(); }
    	
		return createPartnerServiceAmends(partner1Users);
    }*/
    
    /*public static list<DCE_ServiceAmend__c> createPartner1ServiceAmends(list<User> users){
    	
		if(partner1Amends != null){ return partner1Amends;}
    	
    	partner1Amends = new list<DCE_ServiceAmend__c>();
    	
		integer i = 1;
		for(User u : users){
			
			for(integer j = 1 ; j<=5 ; j++){
				DCE_ServiceAmend__c newService = new DCE_ServiceAmend__c(Name='New Service '+i+j, DCEPartner__c=partner1.id, ServiceOwner__c=u.id, lastReviewed__c = system.today().addMonths(-1-(j*3)), service_status__c = 'Open');
				partner1Amends.add(newService);
				i++;
			}
		}
    	
		insert partner1Amends;
		
		return partner1Amends;
    }*/
    
    public static DCE_OrgAmend__c createPartner1OrgAmend(){
    	
    	if(partner1orgAmend != null){ return partner1orgAmend;}
    	
    	if(partner1 == null){ createPartner1(); } 
    	
    	partner1orgAmend = newPartnerOrgAmend(partner1);
    	insert partner1orgAmend;
    	
    	return partner1orgAmend;
    }
    
    public static DCE_OrgAmend__c newPartnerOrgAmend(Account acc){
    
    	return new DCE_OrgAmend__c(Organisation__c = acc.id, status__c='Draft', Name__c=acc.Name, OrganisationId__c=acc.DCEProdOrgID__c);
    		
    }
    

}