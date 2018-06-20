/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX Handler for JSON data Digital Friend Registration
 *  Author  : Gary Grant
 *  Date    : 17/11/2015
 *  Version : 1.0
 *
 *  Description:    Handler for DF Digital Friend Registration.
                    registration process
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
global without sharing class DF_WEBC_RegisterDigitalFriend_Handler extends DF_WEBC_RegisterBase_Handler {


  public DF_WEBC_RegisterDigitalFriend_Handler(String sJson) {
       init(sJson);    
  }

  public override boolean isRequestVerification() {
        return false;
  }

  @TestVisible
  public override ResponseHolder handleJson() { 
    
    if ( data.action == 'makeDDF') { 
         doHandleMakeDDF(); 
         return responseHolder;
    }
    
    doHandleForm();
    return responseHolder;

   }

   protected override Boolean validate() {
       
        if ( !isRegistrationDataOK() ) {

            system.debug('RegisterBase_Remote_Log : isRegistrationDataOk Failed');
            responseHolder.returnCode = 0; 
            return false;

        }

        return true;

    }
    

    @TestVisible
    private void doHandleMakeDDF() { 

        if ( data.userid == null || data.userid == '') { 
            
            responseHolder.returnCode = 0;
            responseHolder.message = 'User Id not specified or not valid: ' + data.userid;
            system.debug('User Id Not Specified or not Valid in call to ConvertToDDF: ' + data.userid);  
            return;
        }       
      
        DF_Contact__c dfc = null;      
        List<DF_Contact__c> lisDfc = [select id, Created_As_Type__c, Digital_Friend_Signup_Time__c, RecordType.DeveloperName from DF_Contact__c where id =: data.userid LIMIT 1];
      
        if ( lisDfc.isEmpty() ) {

            responseHolder.returnCode = 0;
            responseHolder.message = 'User Id not specified or not valid: ' + data.userid;
            system.debug('User Id Not Specified or not Valid in call to ConvertToDDF: ' + data.userid);  
            return;

        }
                    
        dfc = lisDfc[0];
        if ( dfc.RecordType.DeveloperName == DF_Utils.RT_REGISTRATION ) {
           
             dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_FRIEND);
             dfc.Created_As_Type__c = DF_Utils.USER_TYPE_DIGITAL_FRIEND;
             dfc.Digital_Friend_Signup_Time__c = DateTime.now();           
             upsert dfc;
             system.debug('make-ddf - dfc updated ' + dfc.id);
        }

        responseHolder.returnCode = 1;
      
        system.debug('make-ddf - returning response ');
        return;

    }

    
    
    protected override void populateData() {

        dfc.Last_Name__c = data.lastName;
        dfc.First_Name__c = data.firstName;
        dfc.NewsLetters__c = data.newsLetter;
        dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(getRecordTypeName());
        dfc.Status__c = DF_Utils.STATUS_PROSPECTIVE;
        upsert dfc;
        populateDgData();
        populateIndvData();

    }


    protected override boolean isRegistrationDataOK() {
    
        boolean b = true;    

        if ( data.firstName == null || data.firstName.length() == 0 ) {
            responseHolder.firstNameError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }        
        
        if ( data.lastName == null || data.lastName.length() == 0 ) {
            responseHolder.lastNameError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;
        }

        if ( data.emailAddress == null || data.emailAddress.trim().length() == 0 ){

            responseHolder.emailAddressError = DF_Utils.EMPTY_FIELD_VALUE_MSG;
            b=false;

        }
        
        if ( data.emailAddress != data.emailAddress2 ){

            responseHolder.emailAddressError = DF_Utils.EMAILS_DO_NOT_MATCH_MSG;
            b=false;

        }

        if ( data.emailAddress != null && data.emailAddress.trim().length() > 0 ) {
            
            if ( !WEBC_CommunityWrapper.isEmailAddressOK(data.emailAddress) ) {
                responseHolder.emailAddressError = DF_Utils.INVALID_EMAIL_ADDRESS;
                b=false;
            }
            
        }

        return b;

   }

   protected override  String getRecordTypeName() { 

    return DF_Utils.RT_REGISTRATION;

  }
  
  @TestVisible
  protected override String getCreatedAsValue() {

       return 'Registration';

  }
    

}