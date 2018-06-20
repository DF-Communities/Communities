/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : Main APEX class for all WEB* classes
 *            
 *  Author  : Gary Grant
 *  Date    : 07-02-2015
 *  Version : 1.0
 *
 *  Description:    WEBController holds all methods / functionality that is common
 *                  for all WEB* classes.  
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/

global abstract class WEBC_ControllerBase {


    public WEBC_ControllerBase() {
        
    }
    
    public string partnerId{
        
    get{
        if(partnerId == null){
        partnerId = ApexPages.currentPage().getParameters().get('id');
            
        }
        return partnerId;
        
    }
    
    set;    
        
    }
    
    
    public boolean isLoggedIn {
        
        get { 
                return WEBC_CommunityWrapper.isLoggedIn; 
            }
        private set;
    } 

    public boolean isOrgAdmin {

        get {
            return WEBC_CommunityWrapper.isOrgAdmin();
        }
        private set;

    }
    
    public User currentUser {
        
        get {
              if ( currentUser != null ) { return currentUser; } 
              currentUser = WEBC_CommunityWrapper.currentUser;
              return currentUser;
        }   
        set;        

    }

    public Contact currentContact {

        get {
              if ( currentContact != null ) { return currentContact; } 
              if ( currentUser == null ) { return null; }   
              currentContact =  WEBC_CommunityWrapper.getContactRecordForUser(currentUser);
              return currentContact;
        }   
        set;                

    }

    public PageReference loginRedirect()
    {       
        if ( isLoggedIn ) return null;
        
        String sRedirect = null;
        //String sHost  = ApexPages.currentPage().getHeaders().get('Host');
        String sUrl = Apexpages.currentPage().getUrl().replace('apex/','');
        sRedirect = EncodingUtil.urlEncode(sUrl, 'UTF-8');      

        return new PageReference ('/login');
        
    
    }
    
    public Double currentUserOffset {

        get {

         return DF_Utils.offset;
        }
        set;
    }

}