/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX controller class for VF Page DF_WEBC_ManageOrganisations.
 *  Author  : Lakshmi Vasudevan
 *  Date    : 05-2016
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the DF_WEBC_ManageOrganisations page.
 *                  Will return a list of organisations that the user is an administrator
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/

public with sharing class DF_WEBC_ManageOrganisations_Controller extends DF_WEBC_ControllerBase {
  
public Boolean isChampion {get;set;}
public User thisUser {
        get {
            return WEBController.thisUser;
        }
        set;
    }

//constructor

public DF_WEBC_ManageOrganisations_Controller() {
	
	isChampion = WEBConversionClass.isChampion(thisUser.ContactId);
   

}  
  
}