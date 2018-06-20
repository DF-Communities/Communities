/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX controller class for VF Page DF_WEBC_RegisterPartner
 *  Author  : Lakshmi Vasudevan
 *  Date    : 26/04/2016
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the DF_WEBC_RegisterPartner_Controller class.
 *                  Provides functionality for users to register a DF Organisation

                    There is no submit on this action. The submit is handled by 
                    js methods in the page to various services
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
global without sharing class DF_WEBC_RegisterPartner_Controller extends DF_WEBC_ControllerBase {
    
    public Boolean isChampion {get;set;}
    public Boolean isChampionConverted {get;set;}
    public String orgName{get;set;}   
    public String sector{get;set;}
    public String sectorOther{get;set;}
    public String employees {get;set;}
    
    public String orgPostCode {get;set;}
    public String orgStreet {get;set;}
    public String orgcity {get;set;}
    public String orgCounty {get;set;}
    public String orgCountry {get;set;}
    public String orgTelephone {get;set;}
    public string orgNameError {get;set;}
    public string employeesError {get;set;}
    public string orgCountryError {get;set;}
    public string orgPostCodeError {get;set;}
    public string orgStreetError {get;set;}
    public string orgCityError {get;set;}
    public string orgCountyError {get;set;}
    public string orgTelephoneError {get;set;}
    public Boolean isError = FALSE;
    public string friendoptionsselect {get;set;}
    public string LEAD_RT = 'Dementia_Friends_Website';
    
    public User thisUser {
        get {
            return WEBController.thisUser;
        }
        set;
    }
    
    //Constructor
    public DF_WEBC_RegisterPartner_Controller() {
    	currentDfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());            
        dfcW = new DF_Contact_Wrapper(currentDfc);
        orgNameError ='';
		employeesError='';
		orgCountryError='';
		orgPostCodeError='';
		orgStreetError='';
		orgCityError='';
		orgCountyError='';
		orgTelephoneError='';
           
        isChampion = WEBConversionClass.isChampion(thisUser.ContactId);
        isChampionConverted = DF_Utils.isChampionConverted(currentDfc);    
    
    }

    @RemoteAction
    global static boolean isExistingOrg(String orgName) {

        List<Partner_Organisation__c> lisOrg = [select id from Partner_Organisation__c where name = :orgName];
        return (!lisOrg.isEmpty());

    }
    
    public PageReference register() {
    	
   
     Contact contact = DF_Utils.getContactRecordForDfcId(currentDfc.Id); 
     list<Group> DFQueue = [select id, Name from Group where DeveloperName = 'DF_Website_Admins' and Type = 'Queue'];
     if (contact==null) { return null;}
     system.debug( 'ORGANISATION NAME '+orgName + employees);
     if ( currentDfc== null ){return null;}
     
      // only one lead record can linked with dfcontact 
      Lead ld = new Lead();
     /* List<Lead > lis = [select contact__c,Email, df_contact__c,Phone,RecordTypeId,LeadSource,Number_of_employees__c,Sector__c,Sector_other__c,lastname,Company ,Street,State,City,
                          Country ,PostalCode  from Lead 
                                                where   Contact__c =: contact.id                                               
                                                and df_contact__c =: currentDfc.id
                                                and IsConverted = false
                                                limit 1 ];
      
      if ( !lis.isEmpty() ) { ld =lis[0];}*/
      
            if(DFQueue.size() > 0){ 
    
    		ld.ownerId = DFQueue[0].id; 
    
    		} else {
    
   			 ld.ownerId = [select id from User where isActive = true and Profile.Name = 'System Administrator' limit 1].id;
    		}
            ld.contact__c = contact.id;
            ld.df_contact__c = currentDfc.id; 
            ld.Company = orgName; 
            ld.LastName = contact.LastName;  
            ld.FirstName= contact.FirstName;     
            ld.Email = contact.Email;      
            ld.Street = orgStreet;
            ld.Phone = orgTelephone;
            ld.State = orgCounty;
            ld.City = orgCity;
            ld.Country = orgCountry;
            ld.PostalCode = orgPostCode;
            ld.Number_of_employees__c = employees;
            ld.Sector__c = sector;
            ld.Sector_other__c = sectorOther;
            ld.RecordTypeId = DF_Utils.getsObjectRecordTypeId('Lead',LEAD_RT);
            ld.LeadSource='Web';
            
          insert ld;
        
       return new PageReference('/user-home?org-registered=true');
     
    } 
    
    public pageReference cancel(){
    	
    return new PageReference('/user-home');
    }

}