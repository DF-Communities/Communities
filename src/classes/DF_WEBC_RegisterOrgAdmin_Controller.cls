/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for VF Page DF_WEBC_RegisterOrgAdmin
 *  Author  : Lakshmi Vasudevan
 *  Date    : 26/04/2016
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the DF_WEBC_RegisterOrg_Controller class.
 *                  Provides functionality for users to register a DF Organisation

                    There is no submit on this action. The submit is handled by 
                    js methods in the page to various services
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DF_WEBC_RegisterOrgAdmin_Controller extends WEBC_ControllerBase {
    
    private WEBC_CommunityWrapper community { get;set; }
    
    public List<SelectOption> titleList {
        get {
            if (titleList == null){
                titleList = new List<SelectOption>();
                titleList.add(new SelectOption('NULL','Select...'));
                titleList.add(new SelectOption('Mr.','Mr.'));
                titleList.add(new SelectOption('Mrs.','Mrs.'));
                titleList.add(new SelectOption('Miss','Miss'));
                titleList.add(new SelectOption('Ms.','Ms.'));
                titleList.add(new SelectOption('Other','Other'));
            }
            return titleList;
        }
        set;
    }
    
    public List<SelectOption> genderOptionList {
        
        get { return DF_Utils.genderOptions; }
        set;        
    }

    public List<SelectOption> ethnicGroupOptionList {
        
        get { return DF_Utils.ethnicGroupOptions; }
        set;        
    }
    
   
    public String orgName {get;set;}
    public String sector {get;set;}
    public String sectorOther {get;set;}
    public String emailDomain {get;set;}
    public String employees {get;set;}
    public String userName {get;set;}
    
    public String orgPostCode {get;set;}
    public String orgStreet {get;set;}
    public String orgcity {get;set;}
    public String orgcounty {get;set;}
    public String orgcountry {get;set;}
    public String orgTelephone {get;set;}
    
    public String userid {get;set;}
    public String title {get;set;}
    public String titleOther {get;set;}
    public String firstName {get;set;}
    public String lastName {get;set;}
    
    public String postCode {get;set;}
    public String street {get;set;}
    public String city {get;set;}
    public String county {get;set;}
    public String country {get;set;}
    
    public String telephone {get;set;}
    public String emailAddress {get;set;}
    public String emailAddress2 {get;set;}
    public String password {get;set {password = value == null ? value : value.trim();} }
    public String password2 {get;set {password2 = value == null ? value : value.trim();} }
    public Boolean newsletter {get;set;}
    public Boolean packRequest {get;set;}
    public String gender {get;set;}
    public String ethnicGroup {get;set;}
    public String ethnicOther {get;set;}
    public String proximity {get;set;}
    public User thisUser {
        get {
            return WEBController.thisUser;
        }
        set;
    }
    
    public User APIUser {get; set;}
    public WEBC_CommunityWrapper.RegistrationData inviteData {get;set;}
    public PO_Administrator__c invite { get; set; } 
    


    
    /* This method is called from the page */
   public PageReference handleInvite()
   {

    // If the user is logged in already, throw them out
    System.debug('Logged in user is trying to register: ');
   
    if ( WEBC_CommunityWrapper.isLoggedIn ) {
     
        System.debug('DF_WEBC_RegisterOrgAdmin_Controller  : User is Logged in');
        String p = ApexPages.currentPage().getUrl().split('/apex/')[1];
        PageReference pageReference;
        system.debug('p string'+p);
        if(p == 'DF_WEBC_RegisterOrgAdmin'){
           pageReference = new PageReference('/register-partner');  
         }
        else
        {
           pageReference = new PageReference('/user-home');  
                 
        //pageReference.getParameters().put('msg','E003');
        }
        return pageReference;    
    }  

    System.debug('DF_WEBC_RegisterOrgAdmin_Controller  : User is not Logged in');
    String inviteString = ApexPages.currentPage().getParameters().get('invite');    
    if ( inviteString == null ) { 

        System.debug('Dementia Friends Partner Organisation Registration : QueryString Parameter  - Invite String Not Found');
        return null; 

    }

    String key = community.secretKey;
    String sJson = WEBC_CryptoUtils.decryptValue(inviteString, key);  
    system.debug('sJSON = ' + sJson);
          
    inviteData = new WEBC_CommunityWrapper.RegistrationData();    
    
    if ( !sJson.startsWith('Error') ) {  
        inviteData = (WEBC_CommunityWrapper.RegistrationData)JSON.deserialize(sJson, WEBC_CommunityWrapper.RegistrationData.class);       
        system.debug('Invite Id is : ' + inviteData.id);
    }   
        
    List<User> lisUser = [select id from User where UserName =: inviteData.email];            

    if ( lisUser.size() > 0 ) {

        PageReference pageReference = new PageReference('/errorPage');
        pageReference.getParameters().put('msg','E002');
        pageReference.setRedirect(true);
        return pageReference;

    }

    system.debug('invite and no user found');

    List<PO_Administrator__c> lisInvite  = [select id, Partner_Organisation__r.Name, CreatedBy.FirstName, CreatedBy.LastName from PO_Administrator__c where id=:inviteData.id and Status__c != 'Inactive'];


    System.debug('DF_WEBC_RegisterOrgAdmin_Controller : Invite result : ' + lisInvite.size());
    if ( lisInvite.size() ==0 ) {


        System.debug('DF_WEBC_RegisterOrgAdmin_Controller : Invite not found');
        PageReference pageReference = new PageReference('/errorPage');
        pageReference.getParameters().put('msg','E006');
        pageReference.setRedirect(true);
        invite = new PO_Administrator__c();    
        return pageReference;

    } 

    invite = lisInvite[0];    
    system.debug('invite record fetched : ' + invite.id);

    return null; 

}  
    //Constructor
    public DF_WEBC_RegisterOrgAdmin_Controller() {

        system.debug('DF_WEBC_RegisterOrgAdmin_Controller : Entering Constructor');

        /* Set up utitlity objects */ 
        community = new WEBC_CommunityWrapper('DF');        
        newsletter = false;        
    
    }

    public PageReference reset() {
        return null; 
    } 
     
    

}