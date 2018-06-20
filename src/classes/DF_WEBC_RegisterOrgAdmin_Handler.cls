/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX Handler for JSON data Org Registration
 *  Author  : Lakshmi Vasudevan
 *  Date    : 25/04/2016
 *  Version : 1.0
 *
 *  Description:    Handler for DF Org Registration. 
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
global without sharing class DF_WEBC_RegisterOrgAdmin_Handler extends DF_WEBC_RegisterBase_Handler {

  public DF_WEBC_RegisterOrgAdmin_Handler(String sJson) {
    
    init(sJson);

  }
  
  protected override boolean isExtendedRegistrationDataOK() {

    return true;

  }
  
   protected override void sendVerificationRequest() {

        if ( !isRequestVerification() ) { return; }

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');                 
        //Contact contact = DF_Utils.getContactRecord(dfc); 
        Contact contact=  DF_Utils.getContactRecordForDfcId(dfc.id); 
        if ( handleInvite(contact, community) ) { return; } 
        community.sendAdminVerificationRequest(contact,data.orgName, data.password, getStartUrl(), getEmailTemplateName());
        system.debug('DF_WEBC_RegisterBase_Handler : user registered');

    }
    
    
    private Boolean handleInvite(Contact contact, WEBC_CommunityWrapper community) {

        if ( data.inviteId == null ) { 

          System.debug('Invite Handling : No Invite');          
          return false; 

        }

        List<Po_Administrator__c> lisInvites = 
        [SELECT Id, Status__c, Invited_Email__c, DF_Contact__r.Email__c
         FROM Po_Administrator__c WHERE Id =: data.inviteId];        

        if ( lisInvites.size() == 0 ) { 

          System.debug('Invite Handling : no invites');          
          return false;  
        }

        Po_Administrator__c invite = lisInvites[0];

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

        string startUrl= '/user-home';
        responseHolder.redirectUrl = community.getVerifyUrl(contact, data.password, startUrl);
        system.debug('Invite Handling redirect Url: ' + responseHolder.redirectUrl);
        
        responseHolder.returnCode = 3;

        return true;

  }
  

  /* Extend these Methods for different classes of Friend */


  // Don't include the Community Prefix in the name  
  protected override String getEmailTemplateName() {

    return 'Partner_Admin_Verification_Request';

  }


  protected override  String getRecordTypeName() { 

    return DF_Utils.RT_FRIEND;

  }

  protected override String getCreatedAsValue() {

    return 'Partner Organisation Admin';

  }

  protected override String getStartUrl() {
    //display messsage on user dashboard
    string var ='?org-registered='+ EncodingUtil.urlEncode(data.orgName,'UTF-8')+'&'+'df_organisation_verified=true';
    return '/user-home'+ var ;

  }


  protected override void populateExtendedData() {

     dfc.BirthDate__c = getDate(data.birthDate); 

  }

  protected override void doPostRegistration() {

        system.debug('WEBC_RegisterFriend_Loggin : Handle Pack Request ' + data.packRequest);

        if ( data.packRequest!=null && data.packRequest) {
             String packStatus = handlePackRequest(dfc);
        }
       
        createOrgLead();

   }

   /* Create a new pack request if one does not already exist */
   private static String handlePackRequest(DF_Contact__c dfc) {
        
      /* TODO !!! Only two packs can be sent to each address - need some firm rules for that */
      
      system.debug('WEBC_RegisterFriend_Loggin : Handle Pack Request');
      DF_Pack_Request__c dfpr = null;
              
      List<DF_Pack_Request__c> lis = [select id, DF_Contact__c, Status__c,City__c,Street__c,PostCode__c,County__c,Country__c from DF_Pack_Request__c where DF_Contact__c = :dfc.id LIMIT 1];
      
      if ( lis.isEmpty() ) {
        
          system.debug('WEBC_RegisterFriend_Loggin : creating pack request');

          dfpr = new DF_Pack_Request__c();
          dfpr.Status__c= 'New';
          dfpr.DF_Contact__c = dfc.id;
          dfpr.City__c = dfc.City__c;
          dfpr.Street__c = dfc.Street__c;
          dfpr.PostCode__c = dfc.PostCode__c;
          dfpr.County__c = dfc.County__c;
          dfpr.Country__c = dfc.Country__c;
          
          insert dfpr;        
      
      }  else {        
      
          dfpr = lis[0]; 

      }          

      return dfpr.Status__c;
        
    }
    

  @TestVisible
   // create  partner organisation leads
  public void createOrgLead() {

    if ( dfc== null ){return;}
    // Contact contact = DF_Utils.getContactRecord(dfc); 
    Contact contact = DF_Utils.getContactRecordForDfcId(dfc.id); 
    if (contact==null) { return;}
     
    if(data.orgName==null || data.orgName.length()<=0){return;}
      
    // only one lead record can linked with dfcontact 
    Lead ld = new Lead();
    string LEAD_RT = 'Dementia_Friends_Website'; 
    list<Group> DFQueue = [select id, Name from Group where DeveloperName = 'DF_Website_Admins' and Type = 'Queue'];
            
    List<Lead > lis = [select Contact__c,Email,Number_of_Employees__c,Phone,RecordTypeId,LeadSource,Sector__c,Sector_other__c,Df_contact__c,Lastname,Company ,Street,State,City,
                          Country ,PostalCode  from Lead 
                                                where   Contact__c =: contact.Id                                               
                                                and df_contact__c =: dfc.Id
                                                limit 1 ];
      
    if ( !lis.isEmpty() ) { ld =lis[0];}
    
    
    if(DFQueue.size() > 0){ 
    
    ld.ownerId = DFQueue[0].id; 
    
    } else {
    
    ld.ownerId = [select id from User where isActive = true and Profile.Name = 'System Administrator' limit 1].id;
    }
    ld.LeadSource='Web';
    ld.Contact__c = contact.id;
    ld.Df_contact__c = dfc.id; 
    ld.Company = data.orgName;
    ld.Sector__c = data.sector;
    ld.Sector_other__c = data.sectorOther;
    ld.Number_of_Employees__c = data.employees; 
    ld.LastName = contact.LastName;  
    ld.FirstName= contact.FirstName; 
    ld.Email = data.emailAddress;       
    ld.Street = data.orgStreet;
    ld.State = data.orgCounty;
    ld.Phone=data.orgTelephone;
    ld.City = data.orgCity;
    ld.Country = data.orgCountry;
    ld.PostalCode = data.orgPostCode;
    ld.RecordTypeId = DF_Utils.getsObjectRecordTypeId('Lead',LEAD_RT);
 
    upsert ld;
        
      
     
  }
    
    


}