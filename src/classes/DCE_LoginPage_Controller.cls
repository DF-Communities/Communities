public without sharing class DCE_LoginPage_Controller extends DCE_ControllerUtils {
    
	//public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
	public final String INVALID_EMAIL_ADDRESS = 'The email you have provided is not valid';
	public final String LOGIN_FAILED = 'Login Failed : Invalid email address/password OR you may be locked out due to too many attempts. Please retry your details or wait 15 minutes for the lock-out period to end.';

	public String emailAddress {get; set;}
	public String password {get; set;}
	public string userNameForReset{get; set;}

	public String standardErrorMsg {get;set;}
	public String emailAddressError {get; set;}
	public String passwordError {get; set;}

	private Boolean isError = FALSE;
	
	public DCE_LoginPage_Controller(){
		system.debug('Here I am!');
		system.debug('Url - '+apexPages.currentPage());
		
		if(apexPages.currentPage().getParameters().get('u') != null){
			emailAddress = encodingUtil.urlDecode(apexPages.currentPage().getParameters().get('u'), 'UTF-8');
			displayPageSuccess('Congratulations! You have been signed up as a member of Dementia Connect Portal. Please enter your details to log-in.');
		}
	}
	
	public PageReference login() {

        emailAddressError = '';
        passwordError = ''; 
        standardErrorMsg = '';
        isError = FALSE;

		system.debug('LOGGING IN');
		
		if ( emailAddress.length() == 0 ) {
			
			system.debug('Email address length is zero');
			
			emailAddressError = INVALID_EMAIL_ADDRESS;
			isError = TRUE;
			
			displayPageError(standardErrorMsg);
			return null;
		}

		String sUserName = emailAddress.trim();
		system.debug('WEB LOGIN Init: ' + sUserName);

		system.debug('WEB LOGIN Afterwards: ' + sUserName);        

		list<User> lis = [select id from User where UserName =: sUserName];
		if ( lis.isEmpty() ) {
			isError = TRUE;
		}
        

		if ( password.length() == 0 ) {
			isError = TRUE;
		}

		if (isError){
			standardErrorMsg = LOGIN_FAILED;
			
			displayPageError(standardErrorMsg);
			return null;
        }
            
		PageReference pr = null;

		string startUrl = '/home';
		
		system.debug('Start Url - '+apexPages.currentPage().getParameters().get('startURL'));
		
		if(apexPages.currentPage().getParameters().get('startURL') != null){startUrl=apexPages.currentPage().getParameters().get('startURL');}
		
        system.debug('Start Url = '+startUrl);
        
        pr =  Site.login(sUserName, password, startUrl); 
        
        if (pr == null) {
            standardErrorMsg = LOGIN_FAILED;
            //apexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, standardErrorMsg));
            displayPageError(standardErrorMsg);
            return null;
        }

        return pr;
    }
    
    public pageReference resetPassword(){
    	
    	list<User> U = [select id from User where userName = :userNameForReset and isActive = true and Id IN (select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_PERMISSION_SET_NAME)];
    	
    	if(U.size() > 0){
    		system.debug('User found - will reset');
    		if(!test.isRunningTest()){ Site.forgotPassword(userNameForReset); }
    	}
    	
    	return null;
    }

}