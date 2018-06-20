/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : controller class for DF_LeadConvert page
 *  Author  : Lakshmi Vasudevan
 *  Date    : Jun 2016
 *  Version : 0.1 Unit Test
 *
 *  Description : logic for DF_LeadConvert page called by custom button on lead record
 *               
 *  Modification History
 *  Date            Who         Description 

*******************************************************************************************/ 

public with sharing class DF_LeadConvert_Controller {

private final Lead lead {get;set;}	
public string partnercode {get;set;}


	public DF_LeadConvert_Controller(ApexPages.StandardController stdController){
		if(!test.isRunningTest()){
		stdController.addFields(new List<String>{'partner_code__c','Org_code__c'});
	}
		 this.Lead = (Lead)stdController.getRecord();
		 if(lead.partner_code__c==null)
         {
           partnercode=lead.company.substring(0,3)+lead.Org_code__c;

         }
		 
         if(lead.partner_code__c!=null){ partnercode = lead.partner_code__c; }
	}
	
	public pageReference convertLead(){
		

    
    if(partnercode.length()<0 || partnercode=='' ||partnercode==null){	
    	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Partner code is required');
        ApexPages.addMessage(myMsg);
        
		return null;  
	}
    List<Partner_Organisation__c> lispartner;
   	
	lispartner = [select id from Partner_Organisation__c where DFC_Code__c = :partnercode];
	if(!lispartner.isEmpty()){ 
		
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The partner code entered already exist');
         ApexPages.addMessage(myMsg);	
		
	    return null; 
	}
		
	lead.Partner_code__c = partnercode;
	update lead;
       
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setDoNotCreateOpportunity(true);
        lc.setLeadId(lead.Id);
        lc.setOwnerId(UserInfo.getUserId());  
        lc.setSendNotificationEmail(false);           
               
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

        lc.setConvertedStatus(convertStatus.MasterLabel); 

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        System.assert(lcr.isSuccess());

        Id accId = lcr.getAccountId();

        PageReference page =  new pagereference('/'+accId);
             
        page.setRedirect(true);

        return page;
        

        }
        
    
    public pageReference cancel(){
      
        PageReference page =  new pagereference('/'+lead.Id);             
        page.setRedirect(true);
        return page;
        	
    }

    
	
    
}