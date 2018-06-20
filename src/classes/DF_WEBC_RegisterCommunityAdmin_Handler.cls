/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX Handler for JSON data Community Registration
 *  Author  : Valerie Dunphy
 *  Date    : 17/11/2015
 *  Version : 1.0
 *
 *  Description:    Handler for DF Community Admin Registration. First Step in the Community
                    registration process
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
global without sharing class DF_WEBC_RegisterCommunityAdmin_Handler extends DF_WEBC_RegisterBase_Handler {

  public DF_WEBC_RegisterCommunityAdmin_Handler(String sJson) {
        
    init(sJson);

  }

   protected override void sendVerificationRequest() {

      /* Don't send the verification link if there is an invite
         put the verification link into the response instead */

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');                 
        Contact contact = DF_Utils.getContactRecord(dfc);   

        if ( handleInvite(contact, community) ) { return; }

        community.sendVerificationRequest(contact, data.password, getStartUrl(), getEmailTemplateName());
        System.debug('RegisterBase_Remote_Log : user registered');

  }

  private Boolean handleInvite(Contact contact, WEBC_CommunityWrapper community) {

        if ( data.inviteId == null ) { 

          System.debug('Invite Handling : No Invite');          
          return false; 

        }

        List<DFC_Community_Representative__c> lisInvites = 
        [SELECT Id, Role__c, Invited_Email__c, DF_Contact__r.Email__c, Community__r.Status__c, Community__c
         FROM DFC_Community_Representative__c WHERE Id =: data.inviteId];        

        if ( lisInvites.size() == 0 ) { 

          System.debug('Invite Handling : no invites');          
          return false;  
        }

        DFC_Community_Representative__c invite = lisInvites[0];

        // The invite is set to registered when the DFC record is created
        //if ( invite.Role__c != 'Invited' || invite.Invited_Email__c != dfc.Email__c ) {  return false; }
        if ( WEBC_CommunityWrapper.hasUserRecord(contact) ) { 

          System.debug('Invite Handling : has user record');          
          return false; 
        }        

        if ( invite.DF_Contact__r.Email__c != data.emailAddress ) { 

            system.debug('Email Address does not match');          
            return false; 
        }  

        // Get the current status of the Dementia Friendly Community
        String status = invite.Community__r.Status__c;

        // Go to the appropriate page for that status
        String dfcPage = '/dfc_apply_app?dfcid=' + invite.Community__c;

        if (status=='New' || status=='Draft') {
          dfcPage = '/dfc_apply_app?dfcid=' + invite.Community__c + '&go=1';
        } 

        else if (status=='Active') {
          dfcPage = '/dfc_manage_app?dfcid=' + invite.Community__c;  
        }

        else if (status=='Requested') {
            dfcPage = '/dfc_view_app?dfcid=' + invite.Community__c; 
        }


        responseHolder.redirectUrl = community.getVerifyUrl(contact, data.password, dfcPage);
        system.debug('Invite Handling redirect Url: ' + responseHolder.redirectUrl);
        
        responseHolder.returnCode = 3;

        return true;

  }

  protected override boolean isExtendedRegistrationDataOK() {

    return true;

  }

  /* Extend these Methods for different classes of Friend */


  // Don't include the Community Prefix in the name  
  protected override String getEmailTemplateName() {

    return 'Community_Admin_Verification_Request';

  }


  protected override  String getRecordTypeName() { 

    return DF_Utils.RT_FRIEND;

  }

  protected override String getCreatedAsValue() {

    return 'Community Representative';

  }

  protected override String getStartUrl() {

    /* This takes the selection from the original registration form 
       and passes it through to the application form
       England, Guernsey or Wales
    */    
    
    Map<String, String> m = new Map<String, String>();
    m.put('1', 'e');
    m.put('3', 'w');
    m.put('2', 'g');

    String p = '';
    if ( data.communityCountry!=null && data.communityCountry.length()>0 ) {
      p = '?country=' + m.get(data.communityCountry); 
    }

    return '/dfc_apply_app' + p;

  }


  protected override void populateExtendedData() {

     return;

  }
  
  protected override void populateDgData() {
    
    return; 
        
    }


}