/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for VF Page Register Friend Form Component
 *  Author  : Gary Grant
 *  Date    : 16/02/2015
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBRegisterFriend component.
  *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DF_WEBC_RegisterFriend_Form_Controller {

	public List<SelectOption> genderOptionList {
		
		get { return DF_Utils.genderOptions; }
		set;		
	}

	public List<SelectOption> ethnicGroupOptionList {
		
		get { return DF_Utils.ethnicGroupOptions; }
		set;		
	}

	public String gender {get;set;}
	public String ethnicGroup {get;set;}


}