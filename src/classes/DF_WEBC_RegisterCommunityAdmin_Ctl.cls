/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for VF Page DF_WEBC_RegisterCommunityAdmin.
 *  Author  : Valerie Dunphy
 *  Date    : 17/11/2015
 *
 *  Description:    
 *  Apex Class controller for the DF_WEBC_RegisterCommunityAdmin page.
 *  Provides functionality for users to register as a Dementia Friend
 *   as part of the Community Admin registration process
 *
 *  There is no submit on this action. 
 *  The submit is handled by js methods in the page to various services
 *
 *                   The register-community-admin action can be called 'stand-alone' or from an email invite
 *                   Where it is called from an email invite, the url will have the invite data
 *
 *                   https://dfdev-dfdev.cs18.force.com/register-community-admin?invite=RUgfooDGgCQ4w3Qixj6eummRvahfcKVYxUpsl017KONAkb%2BeH%2BgrwRwaAaRqze7kvFInrgkBw%2FZ8%2BAN1Bw%2BE68pTosBhRb7uQnW2bgikpTn%2BGCWVeiaiOr7wi28F9aTcl7TSk03yEq4BakE2yUJ1cwzF7LDkNU6Ql%2BdtpzULZiJEJ%2FrqKA%2BocbICQRNrfdXtu4Z0bAgWFHR8uY5oXLPB%2BA%3D%3D
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DF_WEBC_RegisterCommunityAdmin_Ctl extends DF_WEBC_ControllerBase {

private WEBC_CommunityWrapper community { get;set; }
public WEBC_CommunityWrapper.RegistrationData inviteData {get;set;}
public DFC_Community_Representative__c invite { get; set; } 

//Constructor
public DF_WEBC_RegisterCommunityAdmin_Ctl() {

    /* Set up utility objects */ 
    community = new WEBC_CommunityWrapper('DF');

 }

 /* This method is called from the page */
 public PageReference handleInvite()
 {

    // If the user is logged in already, redirect to the dashboard
    System.debug('Logged in user is trying to register: ');
    if ( WEBC_CommunityWrapper.isLoggedIn ) { 
        System.debug('DF_WEBC_RegisterCommunityAdmin : User is Logged in');
        PageReference pageReference = new PageReference('/dfc_apply_app');            
        //pageReference.getParameters().put('msg','E003');
        return pageReference;    
    }  

    System.debug('DF_WEBC_RegisterCommunityAdmin : User is not Logged in');
    String inviteString = ApexPages.currentPage().getParameters().get('invite');    
    if ( inviteString == null ) { 

        System.debug('Dementia Friendly Communities Registration : QueryString Parameter  - Invite String Not Found');
        return null; 

    }

    String key = community.secretKey;
    String sJson = WEBC_CryptoUtils.decryptValue(inviteString, key);  
    System.debug('sJSON = ' + sJson);
          
    inviteData = new WEBC_CommunityWrapper.RegistrationData();    
    
    if ( !sJson.startsWith('Error') ) {  
        inviteData = (WEBC_CommunityWrapper.RegistrationData)JSON.deserialize(sJson, WEBC_CommunityWrapper.RegistrationData.class);       
        system.debug('Invite Id is : ' + inviteData.id);
    }   
        
    List<User> lisUser = [select Id from User where UserName =: inviteData.email];            

    if ( lisUser.size() > 0 ) {

        PageReference pageReference = new PageReference('/errorPage');
        pageReference.getParameters().put('msg','E002');
        pageReference.setRedirect(true);
        return pageReference;

    }

    System.debug('invite and no user found');

    List<DFC_Community_Representative__c> lisInvite  = [select Id, Community__r.Name__c, CreatedBy.FirstName, CreatedBy.LastName from DFC_Community_Representative__c where id=:inviteData.id];


    System.debug('DF_WEBC_RegisterCommunityAdmin_Ctl : Invite result : ' + lisInvite.size());
    if ( lisInvite.size() ==0 ) {

        System.debug('DF_WEBC_RegisterCommunityAdmin_Ctl : Invite not found');
        PageReference pageReference = new PageReference('/errorPage');
        pageReference.getParameters().put('msg','E004');
        pageReference.setRedirect(true);
        invite = new DFC_Community_Representative__c();    
        return pageReference;

    } 

    invite = lisInvite[0];    
    System.debug('invite record fetched : ' + invite.id);

    return null; 

}  


}