public class WEBC_Login_Controller extends WEBC_ControllerBase {

    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public final String INVALID_EMAIL_ADDRESS = 'The email ( or user name ) you have provided is not valid';
    public final String LOGIN_FAILED = 'Login Failed : please check your email ( or user name ) and password are correct';

    public String emailAddress {get; set;}
    public String password {get; set;}

    public String standardErrorMsg {get;set;}
    public String emailAddressError {get; set;}
    public String passwordError {get; set;}

    private Boolean isError = FALSE;

    public PageReference login() {

        emailAddressError = '';
        passwordError = ''; 
        standardErrorMsg = '';
        isError = FALSE;

        if ( emailAddress.length() == 0 ) {
             emailAddressError = INVALID_EMAIL_ADDRESS;
             isError = TRUE;
        }
        
        List<User> lis = [select id from User where UserName =: emailAddress];
        if ( lis.isEmpty() ) {
             emailAddressError = INVALID_EMAIL_ADDRESS;
             isError = TRUE;
        }
        

        if ( password.length() == 0 ) {
             passwordError = EMPTY_FIELD_VALUE_MSG;
             isError = TRUE;
        }

        if (isError){
            return null;
        }
            
        PageReference pr = null;

        try {
        
              pr = Site.login(emailAddress, password, WEBC_CommunityWrapper.COMMUNITY_USER_HOME);   
        
        } catch (Exception e) {
        
            standardErrorMsg = e.getMessage();
        }

        if (pr == null) {
            standardErrorMsg = LOGIN_FAILED;
            return null;
        }

        return Site.login(emailAddress, password, WEBC_CommunityWrapper.COMMUNITY_USER_HOME);       
    }

    public WEBC_Login_Controller() { 
        
        standardErrorMsg = '';
        emailAddressError = '';
        passwordError = ''; 
    
    }

}