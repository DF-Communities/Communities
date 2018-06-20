/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX Handler for JSON data Subscriber Registration
 *  Author  : Gary Grant
 *  Date    : 17/11/2015
 *  Version : 1.0
 *
 *  Description:    Handler for DF Subscriber Registration.
                    registration process
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
global without sharing class DF_WEBC_RegisterSubscriber_Handler extends DF_WEBC_RegisterBase_Handler {


  public DF_WEBC_RegisterSubscriber_Handler(String sJson) {
        
        init(sJson);

  }

  protected override Boolean handleExistingUser() {
      
        return true;

  }

  protected override void doHandleForm()
    {
            
        if ( !validate() ) { return; }        
  
        doRegistration();
          
        system.debug('RegisterBase_Remote_Log : returning PR');
        responseHolder = new ResponseHolder(dfc);
        return;

  }

  protected override boolean doRegistration() {

        dfc = DF_Utils.getDFContactForEmail(data.emailAddress);

        if ( dfc!= null ) {

            dfc.NewsLetters__c = true;
            update dfc;
            return true;

        }

        if ( dfc == null ) { 
    
            dfc = new DF_Contact__c();                          

            /* Only update the email address if this is a new Record */ 
            dfc.Email__c = data.emailAddress.toLowerCase();
            dfc.Created_As_Type__c = getCreatedAsValue();

        }

        dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(getRecordTypeName());
        dfc.Status__c = DF_Utils.STATUS_PROSPECTIVE;

        populateData();
        return true;


  }

    protected override void populateData() {
        
        dfc.Last_Name__c = data.lastName;
        dfc.First_Name__c = data.firstName;
        dfc.NewsLetters__c = true;
        dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(getRecordTypeName());
        Database.UpsertResult dsr = Database.upsert(dfc, true);
        if(dsr.isSuccess()) {
            populateIndvData();
        } else {
            throw new RegisterBaseException('Contact could not be created correctly');
        } 
        
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

    return DF_Utils.RT_NEWSLETTER_CONTACT;

  }

  protected override String getCreatedAsValue() {

    return 'Subscriber';

  }
  
  protected override void populateDgData() {
    
    return;	
    	
    }

}