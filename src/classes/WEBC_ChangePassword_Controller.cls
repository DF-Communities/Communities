/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for VF Page WEBChangePassword.
 *  Author  : Gary Grant
 *  Date    : 17-03-15
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBChangePassword class.
 *                  Provides functionality for portal users to change their password
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class WEBC_ChangePassword_Controller extends WEBC_ControllerBase {
    
    public String currentPassword {get; set;}
    public String password {get; set;}
    public String password2 {get; set;}

    public String currentPasswordError {get; set;}
    public String passwordError {get; set;}
    public String password2Error {get; set;}

    public Boolean isError = FALSE;
    
    public PageReference changePassword() {

        currentPasswordError = '';
        passwordError = '';
        password2Error = '';
        isError = false;
        
        if (currentPassword.length() == 0) {
            currentPasswordError = WEBC_CommunityWrapper.EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }
        if (password.length() == 0) {
            passwordError = WEBC_CommunityWrapper.EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }
        if (password.length() < 8){
            passwordError = WEBC_CommunityWrapper.PASSWORD_WRONG_LENGTH_MSG;
            isError = TRUE;
        }
        
        if (!WEBC_CommunityWrapper.isPasswordOK(password)){
            passwordError = WEBC_CommunityWrapper.PASSWORD_NO_NUMBERS_MSG;
            isError = TRUE;
        }

        if (password2 != password) {
            password2Error = WEBC_CommunityWrapper.PASSWORDS_DO_NO_MATCH_MSG;
            isError = TRUE;
        }
        if (isError){
            return null;
        }

        PageReference pr = Site.changePassword(password, password2, currentPassword);
        system.debug('Change Password PR : ' + (pr==null ? 'pr is null' : pr.getUrl()));

        if (pr == null){

            return null;

        } else {

             pr = new PageReference('/user-home?ds=true');           
             pr.setRedirect(true);
             return pr;
        }
        
    }     
    
    public PageReference doCancel(){
    
           return new PageReference('/user-home');
    }
    
    public WEBC_ChangePassword_Controller() {
    
        currentPasswordError = '';
        passwordError = '';
        password2Error = '';
    
    }
}