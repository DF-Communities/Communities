/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : Main APEX class for all WEB* classes
 *            
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    THIS CLASS TO BE REMOVED WHEN ALL DEPENDENT CLASSES ARE UPDATED
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
    Superceded DF_WEBC_ControllerBase
    To be deleted when all dependenent classes have been updated. 

*******************************************************************************************/
global abstract class WEBController {
    
    public static final String pageId_PARAM = 'pageId';
    public static final String USER_TYPE_CHAMPION = 'Champion';
    public static final String USER_TYPE_FRIEND = 'Friend';
    public static final String RT_DFCONTACT_CHAMPION = 'Dementia_Friend_Champion';
    public static final String RT_DFCONTACT_FRIEND = 'Dementia_Friend';
    
    public static String pageId {
        get {
            return ApexPages.currentPage().getParameters().get(pageId_PARAM);
        }
    }

    public static final String showPreview_PARAM = 'preview';
    public static Boolean showPreview {
        get {
            Boolean showPreview = false;

            if (ApexPages.currentPage().getParameters().get(showPreview_PARAM) != null
                && ApexPages.currentPage().getParameters().get(showPreview_PARAM).equalsIgnoreCase('true')) {

                showPreview = true;
            }

            return showPreview;
        }
    }

    public Boolean showCookiePolicy {
        get {
            if (showCookiePolicy == null) {
                showCookiePolicy = true;
            }

            return showCookiePolicy;
        }
        private set;
    }

    public static Boolean isLoggedIn {
        get {
            system.debug('Controller Base: User Type' + UserInfo.getUserType());
            return (UserInfo.getUserType() == 'Guest' ? false : true);
        }
    }

    public static Boolean isChampion {
        get { 

            if (thisUser != null && thisUser.contactId != null)
                return WEBConversionClass.isChampion(thisUser.contactId);

            return FALSE;
        }
    }
    
    public static Boolean isChampionConverted {
        get {
            if (thisUser != null && thisUser.contactId != null)
                return WEBConversionClass.isChampionConverted(thisUser.contactId);
            
            return false;
        }
    }

    public static Boolean userAlreadyExists {
        get {
            if (userAlreadyExists == null){
                userAlreadyExists = false;
            }
            return userAlreadyExists;
        }
        set;
    }

    public static User thisUser {
        get {
            if (thisUser == null
                    && isLoggedIn) {

                thisUser = [SELECT Id, Email, Username, AccountId, ContactId, firstName, lastName, title, CommunityNickname
                                FROM User
                                WHERE Id = :UserInfo.getUserId()];

            }

            return thisUser;
        }
        private set;
    }

    public static Id userAccountId {
        get {
            return (thisUser == null ? null : thisUser.AccountId);
        }
    }

    public DF_Contact__c dfContact {get; set;}

    private static final String XUACompatible_PARAM = 'X-UA-Compatible';
    private static final String XUACompatible_VALUE = 'IE=edge';
   
    //Constructor
    public WEBController() {
  
        isChampion = false;
        system.debug('*** -- Into WEBController constructor -- ***');
  
        ApexPages.currentPage().getHeaders().put(XUACompatible_PARAM, XUACompatible_VALUE);

        Cookie cookiePolicyAcceptance = ApexPages.currentPage().getCookies().get('cookiePolicyAcceptance');

        if (cookiePolicyAcceptance == null) {

            showCookiePolicy = true;

            List<Cookie> cookies = new List<Cookie>();
            cookies.add(new Cookie('cookiePolicyAcceptance', 'true', null, 15552000, false));

            ApexPages.currentPage().setCookies(cookies);
     
        } else {
     
            showCookiePolicy = false;
     
        }

        system.debug('Web Controller Constructor - cookie done');
        
        //2014-04-03 : SM : We also need to return the DF_Contact__c record
        if (test.isRunningTest()){

            DF_Contact__c dfContactRecord = new DF_Contact__c();
            dfContactRecord.RecordTypeId = [select r.Id from RecordType r where r.DeveloperName = :RT_DFCONTACT_CHAMPION and r.SObjectType = 'DF_Contact__c' LIMIT 1].Id;
            dfContactRecord.First_Name__c = 'Test';
            dfContactRecord.Last_Name__c = 'Contact';
            dfContactRecord.Email__c = 'test.contact@myemail.com';
            
            isChampion = true;
            
            dfContact = dfContactRecord;
    
        } else {
    
            if (thisUser != null){
    
                system.debug('Web Controller Constructor - User is not Null');

    
                List<DF_Contact__c> dfContactList = [select d.Postcode__c, d.Contact_Number__c, d.Digital_Friend_Signup_Time__c, d.Created_As_Type__c from DF_Contact__c d where d.Portal_Contact__c = :thisUser.ContactId LIMIT 1];                    

                if ( !dfContactList.isEmpty() ){
    
                    dfContact = dfContactList[0];
    
                }
    
            }   
        }

        system.debug('Webcontroller Constructor - Complete');

        
    }
    
    public String baseSiteSecureURL {
        get {            
             return '';   
        }
        private set;
    }

    public PageReference loginRedirect() {
        PageReference returnReference;

        if (isLoggedIn == false) {
            returnReference = loginReference;
        }

        return returnReference;
    }

    public PageReference loginReference {
        get {
            PageReference loginReference = Page.WEBLogin;
            loginReference.setRedirect(true);

            return loginReference;
        }
    }

    public String loginUrl {
        get {
            return loginReference.getUrl();
        }
    }

    public String homepageUrl {
        get {
            return Page.WEBHome.getUrl();
        }
    }

    public static Boolean checkUserExists(String emailAddress) {
        List<User> users = [SELECT UserType
                                FROM User
                                WHERE Email = :emailAddress
                                        AND IsActive = true];

        return (users.size() > 0);
    }

    //Registration method
    public static PageReference registerUser(String title, String firstName, String lastName, String telephone, String emailAddress, String postCode, String password, String password2, String userType, boolean newsletters) {
        return null;
    }

}