/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Useful Utils for the Partner Organisation
 *  Author  : Lakshmi Vasudevan
 *  Date    : 04/05/2016
 *  Version : 0.1 Unit Test
 *    
 *  Description: 
 *               
 *  Modification History
 *  Date            Who         Description 
  
 
                            
*******************************************************************************************/

public without sharing class DFP_Utils {

  public static Partner_Organisation__c currentOrg(Id partnerId) 
   
    {
      List<Partner_Organisation__c> partners = new List<Partner_Organisation__c>();
      
      partners = [select Id,Name,Sector__c,Number_Of_Employees__c,Sector_Other__c from Partner_Organisation__c where Id=: partnerId];       
      if(partners.isEmpty()){ return null;}
       
      return partners[0];
      
    }

 public static Boolean hasActions(String Id) 
    {
     List<Action__c> actions = [SELECT Id, Action__c FROM Action__c WHERE partner_organisation__c = :Id ];
            if ( !actions.isEmpty() ) {
                 return true;
                  
            }
        return false;
    }
    
  // Called by after insert Trigger DF_ContactTrigger - which is run when a new user registers
    public static void updatePartnerAdministrators(DF_Contact__c[] dfContacts)
    {
       List<String> emailAddresses = new List<String>();

       for (DF_Contact__c dfContact : dfContacts) {
              emailAddresses.add( dfContact.Email__c );
        }
    
       // Get a list of Invited Administrators for these email addresses
       PO_Administrator__c[] admins = 
            [  select Id, DF_Contact__c, Invited_Email__c 
               from PO_Administrator__c 
               where Status__c = 'Invited' and Invited_Email__c in :emailAddresses ]; 

       // Update the Administrator record with the Id of th DFC Contact
       for (PO_Administrator__c admin : admins) {
            if (admin.DF_Contact__c==null) {
                admin.DF_Contact__c = findIdForEmail(admin.Invited_Email__c, dfContacts);
              }
            // Change the status of the administrator from 'Invited' to 'Registered'
            admin.Status__c = 'Registered';

            // Now that the Invited user has a registered account, clear the Invite data
            admin.Invited_Email__c = null;
            admin.Invited_Name__c = null;
        }

        if (admins.size()>0) {update admins;}
    }
  

   @TestVisible
    // Returns the id of the DF_Contact__c record for a given email address in a list of DF_Contact__c s
    private static String findIdForEmail(String emailAddress, DF_Contact__c[] dfContacts)
    {
        for (DF_Contact__c dfc : dfContacts) {
            if (dfc.Email__c == emailAddress) {
              return dfc.Id;
            }
        }
        return null;
    }
    
   
  /*  public static void updateLeadStatus(User[] insertedUsers)
    {
     Set<Id> conIds = new  Set<Id>();
     List<Lead> lisLead = new  List<Lead>();

       for (User u : insertedUsers) {
              conIds.add( u.contactId);
        }
     
         // leads created by dfcontacts in the trigger context
       for(Lead le :[select status, DF_Contact__c from lead where Contact__c in : conIds]){
        if(le.Status == 'Open' && le.DF_Contact__c != null){
        le.Status = 'Qualified';
        lisLead.add(le);
        }
        
       }
       
        if(!lisLead.isEmpty()){ update lisLead; }
    }*/

   
  public static Boolean validEmail(String semail) {
  	

  String InputString = semail;
  String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
  Pattern MyPattern = Pattern.compile(emailRegex);

// Then instantiate a new Matcher object "emailMatcher"
   Matcher emailMatcher = MyPattern.matcher(InputString);

  if (!emailMatcher.matches()) {
     return FALSE;
   }
   else {
    return TRUE;
    }
  
 }
 
 public static Boolean isExistingAdmin(String email,String partnerId){
 
  
    PO_Administrator__c[] admins = 

          [ select Id,DF_Contact__r.Email__c  from PO_Administrator__c 
            where (DF_Contact__r.Email__c = :email.toLowerCase() or 
                   Invited_Email__c = :email.toLowerCase())
                   and Partner_Organisation__c =:partnerId
                   and Status__c != 'Inactive'
            ];

      return admins.size()>0 ;     
 }
 
  public static Boolean isExistingAdminbyOrgName(String email,String partnername){
 
  
    PO_Administrator__c[] admins = 

          [ select Id,DF_Contact__r.Email__c  from PO_Administrator__c 
            where (DF_Contact__r.Email__c = :email.toLowerCase() or 
                   Invited_Email__c = :email.toLowerCase())
                   and Partner_Organisation__r.Name =:partnername
                   and Status__c != 'Inactive'
            ];

      return admins.size()>0 ;     
 }
 
 
 
  public static PO_Administrator__c inviteAdministrator(String partnerId, String email, String name) 
   
    {
          
      PO_Administrator__c admin = new PO_Administrator__c();
      admin.Partner_Organisation__c = partnerId;
      admin.Status__c = 'Invited';
      admin.Invited_Name__c = name;
      admin.Invited_Email__c = email.toLowerCase();
      insert admin;
      
      return admin;
    }
    
    public static PO_Administrator__c addAdministrator(Id partnerId, Id dfcId) 
   
    {
    PO_Administrator__c admin = new PO_Administrator__c();
    List<PO_Administrator__c> lispo = [select Id,Status__c from PO_Administrator__c where DF_Contact__c =: dfcId and Partner_Organisation__c =: partnerId];
    
     if(!lispo.isEmpty()) { admin = lispo[0];}       
     
      admin.Partner_Organisation__c = partnerId;
      admin.Status__c = 'Registered';
      admin.DF_Contact__c = dfcId ;
      upsert admin;
     
     return admin;
    }
    
    public static boolean isInvite(String email){
        
      List<DF_Contact__c> dfclis = new List<DF_Contact__c>();
        
       dfclis = [select email__c,id from DF_Contact__c where email__c =:email limit 1];
       return dfclis.isEmpty();
    
    }
    
    public static List <Partner_Organisation__c> getOrgsForDFC(string dfcId){
    	
    	   	
    	 Set <Id> pIds = new Set<Id>();
           for( PO_Administrator__c poa : [
                select Partner_Organisation__r.Id from PO_Administrator__c  
                where DF_Contact__c = :dfcId and Status__c = 'Registered'
            ]){
               pIds.add(poa.Partner_Organisation__r.Id);
            }

            if ( pIds.size() ==0 ) { return null; }            
             

            Partner_Organisation__c [] org = [
                SELECT Id, Name                 
                FROM Partner_Organisation__c WHERE Id in :pIds
            ];              
            
            return (org.size() == 0?null:org);
    	
    	
    }

    public class LeadWrapper{
       public string company {get; set;}
       public string id {get; set;}
      
      public LeadWrapper(String company ,String Id){
        this.company=company;
        this.id =Id;
      }
      
    }
    
  public static List <LeadWrapper> getLeadsForDFC(string dfcId){
    List<LeadWrapper> wrapper = new List<LeadWrapper>();

    for(Lead lead:[
                SELECT Id, Name,company                 
                FROM Lead WHERE DF_Contact__c = :dfcId and isConverted=false
            ]){  
              LeadWrapper wrap = new LeadWrapper(lead.company,lead.Id);
              //wrap.company=lead.company;
             // wrap.id=lead.id;
              wrapper.add(wrap);

        }

         return wrapper;

  }

   

}