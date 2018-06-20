/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for VF Page WEBEditMyDetailsAdmin.
 *  Author  : Gary Grant
 *  Date    : 17-3-15
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBFriendEditMyDetails page.
 *                  This controller will look after editing and viewing profile information 
 *                  from the DF_Contact__c record
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class WEBC_EditMyDetailsAdmin_Controller extends WEBC_ControllerBase{
    
    public final String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public final String EMAIL_FOUND_MSG = 'The email address you have entered already exists. If you own this email address please contact the Dementia Friends team.';
    public final String EMAIL_NOT_VALID = 'The email address you have entered is not a valid fomrat';
        
    public String standardErrorMsg {get;set;}
    public String emailError {get; set;}
    public String firstNameError {get; set;}
    public String lastNameError {get; set;}
    public String phoneError {get; set;}
    public Contact contact {get;set;}
    public Account account {get;set;}
    
    public Boolean isError = FALSE;

    public String displayUserName { 

           get {
                return currentUser.UserName.split('.admin@df_organisation.com')[0];
           }

           private set;         

    }


    public List<SelectOption> titleList {
        get {
            if (titleList == null){
                titleList = new List<SelectOption>();
                titleList.add(new SelectOption('-None-','-None-'));
                titleList.add(new SelectOption('Mr.','Mr.'));
                titleList.add(new SelectOption('Mrs.','Mrs.'));
                titleList.add(new SelectOption('Miss.','Miss.'));
                titleList.add(new SelectOption('Ms.','Ms.'));
                titleList.add(new SelectOption('Other','Other'));           
            }
            return titleList;
        }
        set;
    }

    public WEBC_EditMyDetailsAdmin_Controller() {
        
        system.debug('WEBC_EditMyDetailsAdmin : Entering Controller');
        
        standardErrorMsg = '';
        emailError = '';
        firstNameError = '';
        lastNameError = '';     
        phoneError = '';
        init();
            
    }

    public void init()
    {
        if ( currentUser == null ) { return; }
        system.debug('WEBC_EditMyDetailsAdmin : User ContactId ' + currentUser.ContactId);


        contact = WEBC_CommunityWrapper.getContactRecordForUser(currentUser);
        system.debug('WEBC_EditMyDetailsAdmin : Contact ' + contact.id);
                
        account = [select Id, Name, ShippingStreet, ShippingState, ShippingCity, ShippingCountry, ShippingPostalCode from Account where id =:contact.AccountId];
        system.debug('WEBC_EditMyDetailsAdmin : Account ' + account.id);

    }
    
    @Future
    //This needs to be a future call as you can't mix DML statements on setup objects & non setup objects
    public static void updateUserRecord(String userId, String emailAddress, String firstName, String lastName){
        try {
        
            User u = [select u.Email, u.UserName, u.CommunityNickname, u.Firstname, u.Lastname from User u where u.Id = :userId LIMIT 1];
            u.Firstname = firstName;
            u.Lastname = lastName;
            u.Email = emailAddress;
            u.CommunityNickname = emailAddress;
            
            update u;
        
        }catch (DMLException dmlEx){
        
            system.debug('*** -- Error saving user : ' + dmlEx + ' -- ***');
        
        }
    }
    
    public PageReference saveUserDetails(){
        
        standardErrorMsg = '';
        emailError = '';
        firstNameError = '';
        lastNameError = '';
        phoneError= '';
        
        if (contact.FirstName.length() == 0) {
            firstNameError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }

        if (contact.LastName.length() == 0) {
            lastNameError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }
        
        if (contact.Email.length() == 0) {
            emailError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        }
        
        if ( !WEBC_CommunityWrapper.isEmailAddressOK(contact.Email) ) {
            emailError = EMAIL_NOT_VALID;
            isError = TRUE;         
        }

        /*
        if (contact.Phone == null || contact.Phone.length() == 0){
            phoneError = EMPTY_FIELD_VALUE_MSG;
            isError = TRUE;
        } else {
               
         if ( !WEBC_CommunityWrapper.isPhoneOK(contact.Phone) ) {
          
            phoneError = 'Please enter phone number in correct format';
            isError = TRUE;
         }
        
        }
        */
        
        
        if (isError){
            return null;
        }
        
        update contact;     
        update account;     
                
        //Check to see if core data has been changed and if so, update the user record
        if (currentUser.Email != contact.Email ||
            currentUser.Firstname != contact.FirstName ||
            currentUser.Lastname != contact.LastName){
            system.debug('*** -- About to call the user save future method -- ***');
            updateUserRecord(currentUser.Id, contact.Email, contact.FirstName, contact.LastName);                                           
        }
        
        PageReference pr = new PageReference(WEBC_CommunityWrapper.COMMUNITY_USER_HOME);
        return pr;
    }

}