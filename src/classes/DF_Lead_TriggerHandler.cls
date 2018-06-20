/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Trigger Handler converting DF leads
 *  Author  : Lakshmi Vasudevan
 *  Date    : Apr 2016
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 

*******************************************************************************************/ 

public without sharing  class DF_Lead_TriggerHandler {

    public void OnBeforeUpdate(Lead[] leadsUpdated, Map<ID, Lead> leadsUpdatedMap){
        
    DFLeadConvertionProcess(leadsUpdated,leadsUpdatedMap);  
    
    }
    
    //this method only works for converting leads one at a time    
    public void DFLeadConvertionProcess(Lead[] leadsUpdated, Map<ID, Lead> leadsUpdatedMap){
        
    List<Partner_Organisation__c> lisOrgToInsert = new List<Partner_Organisation__c>();
    List<Account> lisAccInserted = new List<Account>();
    List<Contact> lisContoDelete = new List<Contact>();
    List<Contact> lisContoUpdate = new List<Contact>();
    Set <Id> convertedAcIds = new Set <Id>();
    Set <Id> convertedConIds = new Set <Id>();
    Set <Id> dfIds = new Set <Id>();
    Map <Id,String> mapAdmins = new Map <Id,String>();
    Map <Id,String> mapAccountContactIds = new Map <Id,string>();
    Map <Id,Lead> mapLeadAcId = new Map <Id,Lead>();
    string LEAD_RT = 'Dementia_Friends_Website';
    
    Map<String, User> mapUsers = new Map<String, User>();
    for (Lead lead : leadsUpdated) {
    //only runs for dementia friends lead convertion
    if(lead.RecordTypeId == DF_Utils.getsObjectRecordTypeId('Lead',LEAD_RT) && lead.IsConverted && lead.DF_Contact__c!=null ){
      //converted accounts
      convertedAcIds.add(lead.ConvertedAccountId);
      //converted contacts
      convertedConIds.add(lead.ConvertedContactId);
      dfIds.add(lead.DF_Contact__c);
      //map of dfc and converted account Ids to insert partner admin 
      mapAdmins.put(lead.DF_Contact__c,lead.ConvertedAccountId);
      mapLeadAcId.put(lead.ConvertedAccountId,lead);
      mapAccountContactIds.put(lead.Contact__c,lead.ConvertedAccountId);
 
     }
   
    }
        
      //accounts inserted  
     lisAccInserted =[Select Id,Name,Description  From Account a Where Id = :convertedAcIds and Id not in (select Account__c from Partner_Organisation__c)];
      //delete contacts that created part of the lead conversion
     lisContoDelete =[Select Id From Contact a Where Id = :convertedConIds ]; 
     List<Messaging.SingleEmailMessage> lisMails = new List<Messaging.SingleEmailMessage>();
     
     for(Account a :lisAccInserted){
     //create partner organisations for inserted accounts
     Partner_Organisation__c po = new Partner_Organisation__c();
     po.Name = a.Name;
     po.Account__c= a.Id;     
     po.Number_Of_Employees__c = mapLeadAcId.get(a.Id).Number_Of_Employees__c;
     po.Sector__c = mapLeadAcId.get(a.Id).Sector__c;
     po.Sector_other__c = mapLeadAcId.get(a.Id).Sector_other__c;
     po.DFC_Code__c = mapLeadAcId.get(a.Id).Partner_code__c;
     lisOrgToInsert.add(po); 
   
    // lisMails.add(sendPartnerCode(po,a.contacts.name,a.contacts.Id));
   }
   //lead.contact__c list
   List<Contact> liscon = [select Id,AccountId,Name from Contact where Id in:mapAccountContactIds.keyset()];
   for(Contact c : liscon){
    //link lead.contact_c with the inserted account
      c.AccountId = mapAccountContactIds.get(c.Id);     
      lisContoUpdate.add(c);
      //send email to the contact that regstered the partner organisation
      //lisMails.add(sendPartnerCode(lisOrgToInsert[0] ,c.name,c.Id));
      
      for(Partner_Organisation__c partner:lisOrgToInsert){
        
        if(c.AccountId == partner.Account__c) {
            
           lisMails.add(sendPartnerCode(partner,c.FirstName,c.Id));
        }
        
      }
   }

   
   
   if(lisOrgToInsert.size() >0){
    //insert accounts
   insert lisOrgToInsert;
    
   }
   
   if(lisMails.size() >0){
    //insert accounts
   Messaging.sendEmail(lisMails);
   
   }
   
   if(lisContoUpdate.size() >0){
   //update contacts with partner account
   update lisContoUpdate;
   
   }
   
   //delete created contacts part of the lead convertion.if the lead merged with an existing account and  existing contact on lead conversion ,this may fail 
   if(lisContoDelete.size()>0){
    try{
    delete lisContoDelete;
    }
    catch(Exception e){
        
        system.debug('Error'+e);
    }
   }
   
   if(!mapAdmins.isEmpty()){
    //call future methods to insert partner admins 
   assignPOAdmins(mapAdmins);
   system.debug('ASSIGN PO ADMINS' + mapAdmins);
   }
   }
   
   private Messaging.SingleEmailMessage  sendPartnerCode(Partner_Organisation__c partner,String contactname,Id contactId){
    
     String sTemplateName = 'New_DF_Partner_Organisation';
     String ORG_WIDE_EMAIL_ADDRESS_ID = WEBC_CommunityWrapper.getOrgWideEmailId('DF');
                                                            
                                                        
         
             Map<String, String> mapValues = new Map<String, String>();
             mapValues.put('contact_name', contactname);
             mapValues.put('partner_code', partner.DFC_Code__c); 
             mapValues.put('partner_name', partner.Name); 
            
           
             Messaging.SingleEmailMessage mail = Mail_Utils.getEmailWithData(sTemplateName, 
                                                   contactId, 
                                                   partner.Id, 
                                                   ORG_WIDE_EMAIL_ADDRESS_ID, 
                                                   false, 
                                                   null, 
                                                   mapValues);
             return mail;
            
   }
   
  
   @future(callout=false)
    public static void assignPOAdmins(Map<Id,String> mapDfcAc){
    //create  partner admins for inserted partner organisations
    SYSTEM.DEBUG('MAPDFCAC '+mapDfcAc);
    List<PO_Administrator__c> lisAdminsToInsert = new List<PO_Administrator__c>();
    
    Set<Id> partnerIds = new Set<Id> ();
    Map<Id,String> mapCurrentAdmins = new Map<Id,String> ();
    //get the partner orgs that coverted account list with
    for(Partner_Organisation__c  po:[ select id,Account__c from Partner_Organisation__c where Account__c in : mapDfcAc.values()]){
     partnerIds.add(po.Id);
     
    }
    //get the existing admins linked with partner orgs
    for(PO_Administrator__c pa :[select Id,DF_Contact__c,Partner_Organisation__r.Account__c from PO_Administrator__c where Partner_Organisation__c =: partnerIds]){
        
        mapCurrentAdmins.put(pa.DF_Contact__c,pa.Partner_Organisation__r.Account__c);
    }
    //loop through partner organisations on the trigger and create po admin records 
    for(Partner_Organisation__c  po:[ select id,Account__c from Partner_Organisation__c where Account__c in : mapDfcAc.values()]){
     
     for(DF_Contact__c dfc :[ select Id from DF_Contact__c where Id in:mapDfcAc.keyset()]){
        
        if((mapDfcAc.get(dfc.Id) != mapCurrentAdmins.get(dfc.Id)||mapCurrentAdmins.size()<0) && po.Account__c == mapDfcAc.get(dfc.Id)){
        
        PO_Administrator__c pa = new PO_Administrator__c();
        
        pa.DF_Contact__c = dfc.Id;
        pa.Partner_Organisation__c = po.Id;
        pa.Status__c = 'Registered';
        pa.IsAddedThroughLoadProcess__c = true;
       
       lisAdminsToInsert.add(pa);
     }
     }
    }
    
    system.debug('lisT OF po TO INSERT ' + lisAdminsToInsert);
    if(lisAdminsToInsert.size()>0){
    
    insert lisAdminsToInsert;
    
    }
   
   }
   }