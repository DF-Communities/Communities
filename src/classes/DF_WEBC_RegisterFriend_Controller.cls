/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for VF Page WEBRegisterFriend.
 *  Author  : Gary Grant
 *  Date    : 16/02/2015
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBRegisterFriend class.
 *					Provides functionality for users to register as a Dementia Friend

					There is no submit on this action. The submit is handled by 
					js methods in the page to various services
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DF_WEBC_RegisterFriend_Controller extends WEBC_ControllerBase {
	
	private WEBC_CommunityWrapper community { get;set; }
    //public Boolean shortFormEmailPref{get;set;}
	
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
	
	
	public User APIUser {get; set;}

	//Constructor
	public DF_WEBC_RegisterFriend_Controller() {

		system.debug('WEBC_RegisterFriend_Loggin : Entering Constructor');

	    /* Set up utitlity objects */ 
        community = new WEBC_CommunityWrapper('DF');        
		
		// Set the default value to true	
        newsletter = false;        
	
	}

    public PageReference reset() {
        return null; 
    }   

}