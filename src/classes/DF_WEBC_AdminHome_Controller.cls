/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX class for the Admin User Home VF Page
 *			  
 *  Author  : Gary Grant
 *  Date    : 13-03-15
 *  Version : 1.0
 *
 *  Description:    	
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DF_WEBC_AdminHome_Controller extends DF_WEBC_ControllerBase {
   
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


    public Partner_Organisation__c partner {get;set;}
	
    public DF_WEBC_AdminHome_Controller() {

        User u = WEBC_CommunityWrapper.currentUser;

        try {

            if ( u!= null ) {
               partner = [select Id, Name, Number_of_Friends_Created__c, Number_of_Champions_Identified__c, DFC_Code__c 
                            from Partner_Organisation__c where Account__c =: u.Accountid ];
            }

        } catch (Exception x) {
            system.debug('No partner org found for User : ' + UserInfo.getUserId());
            return;
        }

                    
    }

    public void clicked(){}

    public Decimal friendCount {

        get {
            return partner.Number_of_Friends_Created__c;
        }

        set {

            if ( partner != null ) {
                partner.Number_of_Friends_Created__c = value;
                update partner;
            }
        }



    }


}