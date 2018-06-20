/* Apply for Dementia Friendly Community Recognition 


   This controller is used by all the dfc oages
   dfc_apply
   dfc_view
   dfc_manage
   dfc_submitted




*/
public without sharing class Dfc_ApplyController 
{




    // Returns the Numberof Dementia Friendly Communities this user is a Representative for
    public Integer getCommunityCount() {

        DFC_Community__c[] communities = Dfc_Util.getCommunitiesForCurrentUser();
        return communities==null ? 0 : communities.size();
    }

    public Integer getDraftCommunityCount() {

        DFC_Community__c[] communities = Dfc_Util.getCommunitiesForCurrentUser();
        Integer count = 0;
        if (communities==null) return 0;
        for (DFC_Community__c comm : communities) {
          if (comm.Status__c.equals('New') || comm.Status__c.equals('Draft') || comm.Status__c.equals('Requested')) {
              count++;
          }
        }

        return count;
    }





    public String getCommunitiesExistMessage() {

        Integer count = getCommunityCount();
        if (count==1) return 'You are already a representative for a Dementia Friendly Community.';
        if (count>1) return 'You are currently a representative for ' + count + ' Dementia Friendly Communities. Continue below if you wish to apply for the recognition process for another community.';
        return '';
    }
    
    
 
    public DFC_Community__c getCommunity()
    {
      String communityId = ApexPages.currentPage().getParameters().get('dfcid');
      if (communityId==null) {
        return null;
      }
      return Dfc_Util.readCommunity(communityId);
    }
 
    
    public String getIntroText() 
    {
        return Dfc_Util.readSnippet('dfc-apply-intro');                
    }

    
    public String getSubmitText() 
    {
      return Dfc_Util.readSnippet('dfc-apply-submit-intro');          
    }

    @RemoteAction
    public static String createNewCommunity() {
         
          DFC_Community__c comm = Dfc_Util.createNewCommunity() ;
          return comm.Id;
    }

}