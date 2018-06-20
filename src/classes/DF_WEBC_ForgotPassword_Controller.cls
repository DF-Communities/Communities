public without sharing class DF_WEBC_ForgotPassword_Controller {
    
    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';

    public boolean resetSent {get;set;}
    public boolean noUserFound {get; set;}
    public boolean userIsNewsletter {get; set;}

    public String emailAddress {get;set;}
    public String emailAddressError {get;set;}
    
    public boolean isOrgAdminAccount {get; set;}

    private WEBC_CommunityWrapper community = null;

    public Page_Snippet__c forgotPasswordSnippet {
        get {
            if (forgotPasswordSnippet == null){
                List<Page_Snippet__c> lis = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'forgotpasswordsnippet' LIMIT 1];
                if ( !lis.isEmpty() ) { 
                    forgotPasswordSnippet = lis[0];
                }

            }
            return forgotPasswordSnippet;
        }
        set ;
    }

    public DF_WEBC_ForgotPassword_Controller() {
        
        emailAddress = '';
        emailAddressError = '';
        
        resetSent = false;
        userIsNewsletter = false;
        noUserFound = false;
        isOrgAdminAccount = false;

        community = new WEBC_CommunityWrapper('DF');
        
    }
        
    public PageReference forgotPassword() {
        
        resetSent = false;
        userIsNewsletter = false;
        noUserFound = false;
                
        if (emailAddress.length() == 0) {
            emailAddressError = EMPTY_FIELD_VALUE_MSG;
            return null;
        }
        
        emailAddress = emailAddress.toLowerCase();
        
        List<User> lisUser = new List<User>();
        if ( !isOrgAdminAccount ) {
	        
	        /* For friends and champions, username and email address will match */
    	    lisUser = [select Id, Name, Email, ContactId, UserName from User d where UserName =:emailAddress and Email =:emailAddress LIMIT 1];
        
        }
        
        if ( isOrgAdminAccount ) {
	        
	       lisUser = getLisForOrgAdmin(emailAddress);
        
        }
        
        
        if ( lisUser.size() == 0 ){
        
            noUserFound = TRUE;
            return null;
        
        } 
        
        handleLis(lisUser);
        resetSent = true;
        
        return null;

    }

    @TestVisible
    private void handleLis(List<User> lisUser)
    {

        User user = (User)lisUser[0];
        community.sendForgotPasswordEmail(user);
        
    }

    @TestVisible
    private List<User> getLisForOrgAdmin(String emailAddress)
    {

        /* For admin accounts, user name and email address will not match 
           Try both the user name and email address options */          
        
        /* Try first for email address */
        List<User> lisUser = [select Id, Name, Email, ContactId, UserName from User d where UserName != :emailAddress and Email =:emailAddress LIMIT 1];
        if (!lisUser.isEmpty()) { return lisUser; }        

        /* If not found, try user name */

        String sUserName = community.getOrgAdminUserName(emailAddress, null);
        lisUser = [select Id, Name, Email, ContactId, UserName from User d where UserName = :sUserName LIMIT 1];         
        if (!lisUser.isEmpty()) { return lisUser; }        
        
        return new List<User>();


    }


        
}