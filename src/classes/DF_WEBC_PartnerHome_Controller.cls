/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX class for the DF_WEBC_PartnerHome VF Page
 *        
 *  Author  : Lakshmi Vasudevan
 *  Date    : Apr 2016
 *  Version : 1.0
 *
 *  Description:      
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DF_WEBC_PartnerHome_Controller extends DF_WEBC_ControllerBase {
   public final String ID_PARAM = 'Id';
   public Boolean hasActions {get; set;}
   public Partner_Organisation__c selectedPartner {get;set;}
   public List<Partner_Organisation__c> lisPartners {get;set;}
   public string partnerCode {get;set;}
   public Boolean actionRecordSaved {get;set;}
   public Boolean orgDetailsUpdated { get;set;}
   public Page_Snippet__c totalFriendsSnippet {
        get {
            if (totalFriendsSnippet == null) {                            
                List<Page_Snippet__c> lis = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'DementiaFriendsTotalSnippet' LIMIT 1];
                if ( !lis.isEmpty() ) {
                    totalFriendsSnippet = lis[0];
                }
            }
            return totalFriendsSnippet;
        }
        set ;
    }

    public boolean showSaveConfirmation {

        get {
            return ApexPages.currentPage().getParameters().get('ds') != null;
        }

        set;
    }


  
  
    public DF_WEBC_PartnerHome_Controller() {

        currentDfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());  
        Set<Id> partnerIds = new Set<Id>();
        
        

          if ( currentDfc!= null ) {
              
           for( po_administrator__c a:[select partner_organisation__c from po_administrator__c where df_contact__c =:currentDfc.id ]){
              
           partnerIds.add(a.partner_organisation__c);
              
           }
           lisPartners = [select Id, Name, Number_of_Friends_Created__c, Number_of_Champions_Identified__c, DFC_Code__c 
                            from Partner_Organisation__c where Id in : partnerIds ];
            
            
           if (ApexPages.currentPage().getParameters().get(ID_PARAM) != null){
           selectedPartner =[select Id,DFC_code__c,Total_Number_Of_Friends_by_Champions__c,Name,Number_Of_Friends_Created_By_Champions__c,Number_Of_Offline_Friends_Created__c,Number_Of_Online_Friends_Created__c,Total_Number_Of_Friends_Created__c, Number_of_Champions_Identified__c,Number_of_Friends_Created__c from Partner_Organisation__c where Id=:ApexPages.currentPage().getParameters().get(ID_PARAM)];
          
            hasActions = DFP_Utils.hasActions(selectedPartner.Id);
            partnerCode =selectedPartner.DFC_code__c;
         }

      }    

    if (ApexPages.currentPage().getParameters().get('record-saved') != null){
        
       actionRecordSaved = true;        
     
     } 

    if (ApexPages.currentPage().getParameters().get('details-updated') != null){
        
       orgDetailsUpdated = true;        
     
     } 

    }
    
    

    

}