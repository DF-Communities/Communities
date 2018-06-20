/***********************************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX controller class for VF Page DF_WEBC_EditPartnerDetails.
 *  Author  : Lakshmi Vasudevan
 *  Date    : 23-09-2016
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the DF_WEBC_EditPartnerDetails page.
 *                  Will return a list of Session Resources to the Session Resources page
 *               
 *  Modification History
 *  Date            Who         Description 

************************************************************************************************************/
public without sharing class DF_WEBC_EditPartnerDetailsController extends DF_WEBC_ControllerBase {
	
public final String ID_PARAM = 'Id'; 
public Partner_Organisation__c partner {get;set;}
public Account partnerAcc {get;set;}
public Id partnerId {get;set;}
public String postcode {get;set;}
public String city {get;set;}
public String street {get;set;}
public String county {get;set;}
public String country {get;set;}
public String phone {get;set;}
public String sector{get;set;}
public List<SelectOption> sectorList {
        get {
            if (sectorList == null){
            	                    sectorList = new List<SelectOption>();
                                    sectorList.add(new SelectOption('NULL','-- Select one option --')) ;
                                    sectorList.add(new SelectOption('Health & Social Care','Health & Social Care'));
                                    sectorList.add(new SelectOption('Local Authority','Local Authority'));
                                    sectorList.add(new SelectOption('Government','Government'));
                                    sectorList.add(new SelectOption('Public Service','Public Service'));
                                    sectorList.add(new SelectOption('Retail','Retail'));
                                    sectorList.add(new SelectOption('Finance','Finance'));
                                    sectorList.add(new SelectOption('Law','Law'));
                                    sectorList.add(new SelectOption('Housing','Housing'));
                                    sectorList.add(new SelectOption('Transport','Transport'));
                                    sectorList.add(new SelectOption('Arts','Arts'));
                                    sectorList.add(new SelectOption('Sport & Leisure','Sport & Leisure'));
                                    sectorList.add(new SelectOption('Technology','Technology'));
                                    sectorList.add(new SelectOption('Power & Utilities','Power & Utilities'));
                                    sectorList.add(new SelectOption('Allied Healthcare Professionals','Allied Healthcare Professionals'));
                                    sectorList.add(new SelectOption('Other(please specify)','Other(please specify)'));          
            }
            return sectorList;
        }
        set;
    }
public String sectorOther{get;set;}
public String employees {get;set;}
public List<SelectOption> empnoList {
        get {
               if (empnoList == null){
        	                        empnoList = new List<SelectOption>();
                                    empnoList.add(new SelectOption('NULL','-- Select a range --')) ;
                                    empnoList.add(new SelectOption('0-10','0-10'));
                                    empnoList.add(new SelectOption('11-250','11-250'));
                                    empnoList.add(new SelectOption('251-1001','251-1001'));
                                    empnoList.add(new SelectOption('1001-5000','1001-5000'));
                                    empnoList.add(new SelectOption('5001-20000','5001-20000'));
                                    empnoList.add(new SelectOption('20001+','20001+'));
         
          }
         return  empnoList;
        }                          
        

        set;
}

	
	public DF_WEBC_EditPartnerDetailsController(){
		
		partnerId = ApexPages.currentPage().getParameters().get(ID_PARAM);
		partner = [select id,Account__c,Number_of_Employees__c,Sector__c,Sector_other__c,name from Partner_Organisation__c  where Id = :partnerId];
		partnerAcc = [select id,BillingPostalCode,BillingCity,BillingStreet,BillingState,BillingCountry,Phone from Account where id =:partner.Account__c];
	    SYSTEM.debUG('partner.Sector__c@@'+partner.Sector__c);
	    sector = partner.Sector__c;//(partner.Sector__c!=null? sector=partner.Sector__c :'---none----');
	    sectorOther = (partner.Sector_other__c!=null? sectorOther=partner.Sector_other__c:null);
        employees = partner.Number_of_Employees__c ;
        postcode = partnerAcc.BillingPostalCode;
        street = partnerAcc.BillingStreet ;
        city =partnerAcc.BillingCity;
        county = partnerAcc.BillingState ;
        country = partnerAcc.BillingCountry ;
        phone = partnerAcc.phone ;
	}

	public pageReference cancel(){
    	
    return new PageReference('/partner-home?id='+partnerId);
    }

	public pageReference saveDetails(){

		if(partner != null){

			partner.Number_of_Employees__c = employees;
			partner.Sector__c = sector ;
			partner.Sector_other__c = sectorOther;
           
			update partner;
		}

		if(partnerAcc != null){

			partnerAcc.BillingPostalCode = postcode;
			partnerAcc.BillingCity = city ;
			partnerAcc.BillingStreet =street;
			partnerAcc.BillingState = county;
			partnerAcc.BillingCountry = country;
			partnerAcc.phone = phone ;

			update partnerAcc;
		
       }

        return new PageReference('/partner-home?id='+partnerId+'&details-updated=true');
	}
    
}