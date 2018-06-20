public without sharing class DF_WEBC_Login_Controller extends WEBC_ControllerBase {

    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public final String INVALID_EMAIL_ADDRESS = 'The email ( or user name ) you have provided is not valid';
    public final String LOGIN_FAILED = 'Login Failed : please check your email ( or user name ) and password are correct';

    public String emailAddress {get; set;}
    public String password {get; set;}

    public String standardErrorMsg {get;set;}
    public String emailAddressError {get; set;}
    public String passwordError {get; set;}

    public String startUrl {get;set;}

    private Boolean isError = FALSE;

    public DF_WEBC_Login_Controller() {

        String sUrl = ApexPages.currentPage().getParameters().get('startUrl');
        startUrl = (sUrl == null ? WEBC_CommunityWrapper.COMMUNITY_USER_HOME : EncodingUtil.urlDecode(sUrl, 'UTF-8'));

        standardErrorMsg = '';
        emailAddressError = '';
        passwordError = ''; 
    }

    public PageReference login() {

        emailAddressError = '';
        passwordError = ''; 
        standardErrorMsg = '';
        isError = FALSE;

        if ( emailAddress.length() == 0 ) {
             emailAddressError = INVALID_EMAIL_ADDRESS;
             isError = TRUE;
        }

        String sUserName = emailAddress.trim();
        system.debug('WEB LOGIN Init: ' + sUserName);

        // Check for an admin user name and transform if provided
        if ( emailAddress.indexOf('@') == -1 ) {
            WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');
            sUserName = community.getOrgAdminUserName(emailAddress.trim(), null);
            system.debug('WEB Login  - trying Admin User Name : ' + sUserName); 
        }

        system.debug('WEB LOGIN Afterwards: ' + sUserName);        

        List<User> lis = [select id from User where UserName =: sUserName];
        if ( lis.isEmpty() ) {
             isError = TRUE;
        }
        

        if ( password.length() == 0 ) {
             isError = TRUE;
        }

        if (isError){
            standardErrorMsg = LOGIN_FAILED;
            return null;
        }
            
        PageReference pr = null;     
        pr =  Site.login(sUserName, password, startUrl);   
        
        if (pr == null) {
            standardErrorMsg = LOGIN_FAILED;
            return null;
        }

        return pr;
    }

}