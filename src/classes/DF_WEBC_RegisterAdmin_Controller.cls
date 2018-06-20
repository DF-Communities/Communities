/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for VF Page DF_WEBC_RegisterChampion
 *  Author  : Gary Grant
 *  Date    : 16/02/2015
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the DF_WEBC_RegisterChampion class.
 *					Provides functionality for users to register as a Dementia Friend

					There is no submit on this action. The submit is handled by 
					js methods in the page to various services
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DF_WEBC_RegisterAdmin_Controller extends WEBC_ControllerBase {
	
	private WEBC_CommunityWrapper community { get;set; }

	public String firstName {get;set;}
	public String lastName {get;set;}
	public String orgName {get;set;}
	public String emailDomain {get;set;}
	public String employees {get;set;}
	public String userName {get;set;}
	
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
	public Boolean newsLetter {get;set;}

	//Constructor
	public DF_WEBC_RegisterAdmin_Controller() {

		system.debug('WEBC_RegisterFriend_Loggin : Entering Constructor');

	    /* Set up utitlity objects */ 
        community = new WEBC_CommunityWrapper('DF');        
	
	}

    public PageReference reset() {
        return null; 
    }   

}