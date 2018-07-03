/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : Main APEX class for all DF Specific WEB* classes
 *            
 *  Author  : Gary Grant
 *  Date    : 07-02-2015
 *  Version : 1.0
 *
 *  Description:    WEBController holds all methods / functionality that is common
 *                  for all DF Specific WEB* classes. 
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/

public abstract class DF_WEBC_ControllerBase extends WEBC_ControllerBase {
    
    public class ControllerBaseException extends Exception{}
    public DF_WEBC_ControllerBase() {
    }

    /* May 2015 This is deprecated in favour of dfcW... remove where possible */
    public DF_Contact__c currentDfc {

        get {

            if (!isLoggedIn) { return null;}
			
            if (currentDfc !=null ) { return currentDfc; }          
            currentDfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());
            if (currentDfc == null) { return null; }

            return currentDfc;
    
        }

        set;
    }


    public DF_Contact_Wrapper dfcW { 

        get {

            if (!isLoggedIn) { return null;}

            if (dfcW !=null ) { return dfcW; }                                  
            dfcW = new DF_Contact_Wrapper();

            // If this user does not have a DF Profile, return null;
            if (dfcW.dfc == null) { return null; }

            return dfcW;
    
        }

        set;


    }

    public String totalFriendCount {

        get {
                if ( totalFriendCount != null ) { return totalFriendCount; }
                Integer i = DF_Utils.totalFriendCount;
                return i.format();
        }
        private set;

    }

    public List<String> totalFriendCountList {

        get {

            List<String> lis = new List<String>();
            String s = totalFriendCount;
            for (Integer n = 0; n<s.length(); n++) {
                lis.add(s.substring(n, n+1));
            }

            return lis;
        }

        private set;

    }
    
     public PageReference orgAdminLoginRedirect()
    {       
       string partnerId = ApexPages.currentPage().getParameters().get('Id');
      
       boolean isExistingAdmin = DFP_Utils.isExistingAdmin(currentUser.email,partnerId);
       
        if ( isExistingAdmin ) {return null;}
        
        String sRedirect = null;
        String sUrl = Apexpages.currentPage().getUrl().replace('apex/','');
        sRedirect = EncodingUtil.urlEncode(sUrl, 'UTF-8');      

        return new PageReference ('/user-home');
    }
}