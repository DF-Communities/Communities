/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBChangePassword.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBChangePassword class.
 *                  Provides functionality for portal users to change their password
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public with sharing class WEBChangePassword extends WEBController {
    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public final String PASSWORDS_DO_NO_MATCH_MSG = 'Passwords did not match';
    public final String PASSWORD_WRONG_LENGTH_MSG = 'Password must be at least 8 characters in length';
    public final String PASSWORD_NOT_MIXED_CASE_MSG = 'Passwords must contain a mixture of upper and lower case';
    public final String PASSWORD_NO_NUMBERS_MSG = 'Passwords must contain at least 1 numeric character';
    
    public String currentPassword {get; set;}
    public String password {get; set;}
    public String password2 {get; set;}

    public String currentPasswordError {get; set;}
    public String passwordError {get; set;}
    public String password2Error {get; set;}
    public boolean isChampion {get; set;}

    public Boolean isError = FALSE;
    
    //Method to actually change the password
    public PageReference changePassword() {
        currentPasswordError = '';
        passwordError = '';
        password2Error = '';
        isError = false;
        isChampion = WEBController.isChampion;
        
        if (currentPassword.length() == 0) {
            currentPasswordError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }
        if (password.length() == 0) {
            passwordError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }
        if (password.length() < 8){
            passwordError = PASSWORD_WRONG_LENGTH_MSG;
            isError = TRUE;
        }
        
        //As we can have a combination of letters and numbers, we need to check each character
        //individually for CASE
        /*boolean isLower = false;
        boolean isUpper = false;
        for (integer i = 0 ; i < password.length() ; i++){
            if (password.substring(i, i + 1).isAlpha()){
                if (password.substring(i,i+1).isAllUpperCase()){
                    isUpper = true;
                }
                if (password.substring(i,i+1).isAllLowerCase()){
                    isLower = true;
                }
            }
        }*/
        
        //if ((!isLower && isUpper) || (isLower && !isUpper)){
        //  passwordError = PASSWORD_NOT_MIXED_CASE_MSG;
        //  isError = TRUE;
        //}
        
        if (!password.isAlphanumeric()){
            passwordError = PASSWORD_NO_NUMBERS_MSG;
            isError = TRUE;
        }
        if (password2.length() == 0) {
            password2Error = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }
        if (password2.length() < 8){
            password2Error = PASSWORD_WRONG_LENGTH_MSG;
            isError = TRUE;
        }
        
        //As we can have a combination of letters and numbers, we need to check each character
        //individually for CASE
        /*boolean isLower2 = false;
        boolean isUpper2 = false;
        for (integer i = 0 ; i < password2.length() ; i++){
            if (password2.substring(i, i + 1).isAlpha()){
                if (password2.substring(i,i+1).isAllUpperCase()){
                    isUpper2 = true;
                }
                if (password2.substring(i,i+1).isAllLowerCase()){
                    isLower2 = true;
                }
            }
        }*/
        
        //if ((!isLower2 && isUpper2) || (isLower2 && !isUpper2)){
        //  password2Error = PASSWORD_NOT_MIXED_CASE_MSG;
        //  isError = TRUE;
        //}
        
        if (!password2.isAlphanumeric()){
            password2Error = PASSWORD_NO_NUMBERS_MSG;
            isError = TRUE;
        }
        if (password2 != password) {
            password2Error = PASSWORDS_DO_NO_MATCH_MSG;
            isError = TRUE;
        }
        if (isError){
            return null;
        }

        PageReference pr = Site.changePassword(password, password2, currentPassword);
        
        if (pr == null){
            return null;
        }else {
            if (WEBController.isChampion){
                pr = Page.WEBChampionViewMyDetails;
            }else {
                pr = Page.WEBFriendViewMyDetails;
            }
            pr.setRedirect(true);
            return pr;
        }
        
    }     
    
    public PageReference doCancel(){
        if (WEBController.isChampion){
            return Page.WEBChampion;
        }else {
            return Page.WEBFriend;
        }
    }
    
    //Constructor
    public WEBChangePassword() {
        currentPasswordError = '';
        passwordError = '';
        password2Error = '';
    }
}