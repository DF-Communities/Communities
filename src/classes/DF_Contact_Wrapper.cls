/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : A wrapper class for a DF_Contact__c object
 *  Author  : Gary Grant
 *  Date    : 07/02/2015
 *  Version : 0.1 Unit Test
 *
 *  Description: A wrapper class for a DF_Contact__c object
 *               
 *  Modification History
 *  Date            Who         Description 
                            
*******************************************************************************************/

public without sharing class DF_Contact_Wrapper {

    public boolean isChampion  {get;set;}
    public boolean isChampionConverted {get;set;}
    public boolean isChampionVerified {get;set;}
    public boolean isChampionProspective {get;set;}
    public boolean isChampionRetired {get;set;}
    public boolean isChampionHiatus {get;set;}
    public boolean isFriend  {get;set;}
    public boolean isFriendConverted  {get;set;}
    public boolean isFriendProspective {get;set;}

    public boolean isSubscriber {get;set;}

    public DF_Contact__c dfc {get;set;}

    public Action__c friendAction {get;set;}
    public Boolean hasActions {get;set;}
    
    public Contact contact {

            get { 

                if (contact!=null) { return contact;}
                contact = DF_Utils.getContactRecord(dfc);
                return contact;
            }

            set;
    }
    
    
    
    public User user {

        get{

            if (user!=null) { return user; }
            user = DF_Utils.getUserRecord(dfc);
            return user;
        }
        
        set;
    }

    public DF_Contact_Wrapper(DF_Contact__c dfc) {

        this.dfc = dfc;
        init(true);


    }

    public DF_Contact_Wrapper(String email) {

        this.dfc = DF_Utils.getDFContactForEmail(email);
        init(true);

    }

    // This constructor assumes the wrapper is for the current user
    public DF_Contact_Wrapper() {

        this.user = WEBC_CommunityWrapper.currentUser;
        this.dfc = DF_Utils.getDFContactForUser(this.user);
        if ( dfc != null ) { init(); }

    }


    public boolean isChampionActive {

        get {

            if ( isChampionConverted || isChampionProspective )  { return true; }
            return false;

        }

        private set;

    }

    public String championStatus
    {

        get {

            if ( !isChampion ) { return null; }
            if ( dfc == null ) { return null; }
            return dfc.Status__c;

        }

        private set; 

    }


    public void init()
    {
        init(false);
    }

    public void init(boolean bAction) {

        isChampion = DF_Utils.isChampion(dfc);
        isChampionConverted = DF_Utils.isChampionConverted(dfc);
        isChampionVerified = DF_Utils.isChampionVerified(dfc);
        isChampionProspective = DF_Utils.isChampionProspective(dfc);
        isChampionRetired =  DF_Utils.isChampionRetired(dfc);
        isChampionHiatus = DF_Utils.isChampionHiatus(dfc);
        isFriend = DF_Utils.isFriend(dfc);
        isFriendConverted = DF_Utils.isFriendConverted(dfc);

        isSubscriber = DF_Utils.isSubscriber(dfc);

        if ( bAction==False ) {
            hasActions = FALSE;
            
            List<Action__c> actions = [SELECT Id, Action__c FROM Action__c WHERE DF_Contact__c = :dfc.id ];
            if ( !actions.isEmpty() ) {
                  hasActions = TRUE;
                  friendAction = actions[0];
            } 
        }

    }


    public String confirmFriend(String sCode)
    {


        if ( isFriendConverted ) {
            return null;
        }

        if ( !isFriend ) { 
            return 'Contact is not a Friend';
        }


        if (sCode != WEBGlobalSettings.friendConvertCode) {
            return 'Friends Session Code is not recognised';
        }

        dfc.Session_Code_Verified__c = true;
        dfc.Status__c = DF_Utils.STATUS_CONVERTED;
        update dfc;

        init();

        return null;

    }

    
    /*  Commenting this out as user requested to remove champion code verification functionality 
    public String confirmChampion(String sCode)
    {

       boolean isFoundCode;
      

        if ( !isChampion ) { 
            return 'Contact is not a Champion';
        }
  
        //String sOrgId  = DF_Utils.getOrgIdForChampionCode(sCode);
        List<String> Code =  DF_Utils.listchampionCodes;
        for( string s:Code){
            if (sCode==s){
                 isFoundCode = true;
             }
            }
        if (isFoundCode == false ) {
        
         return 'Sorry, that code is not recognised'; 
         }
         if (isFoundCode == null ) {
        
         return 'Sorry, that code is not recognised'; 
         }
         
       
        
        if(isFoundCode == true){ 
         dfc.Code_Verefied__c = true;
         dfc.Status__c = DF_Utils.STATUS_CONVERTED;}
        
        update dfc;

        init();

        return null;


    }*/

    public Boolean convertToFriend()
    {

        if ( isFriend ) { 
            return true;
        }

        // A Converted Champion should be a converted friend
        if ( isChampionConverted ) {
            dfc.Session_Code_Verified__c = true;
        } 

        dfc.Status__c = ( dfc.Session_Code_Verified__c ? DF_Utils.STATUS_CONVERTED : DF_Utils.STATUS_PROSPECTIVE );
        dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_FRIEND);
        update dfc;

        init();

        return true;

    }

    public Boolean convertToChampion()
    {

        if ( isChampion ) { 
            return true;
        }

        dfc.Status__c = DF_Utils.STATUS_PROSPECTIVE ;
        dfc.RecordTypeId = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
        update dfc;

        init();

        return true;

    }

    // Returns the list of Dementia Friendly Communities this user is a Representative for
    public DFC_Community__c[] communities {
        
           get {

              return Dfc_Util.getCommunitiesForDfContact(dfc.id);
           }
           private set;

    }
    
    
    // Partner Organisations
    public List<Partner_Organisation__c> partners {    

        get { 

            return DFP_Utils.getOrgsForDFC(dfc.Id);      
         
            }
        set;

    }
    public class leadwrapper{
         public string company {get; set;}
         public string id {get; set;}
        
        public leadWrapper(String company ,String Id){
            this.company=company;
            this.id =Id;
        }
        
    }
    
    
    
    public List<DFP_Utils.Leadwrapper> orgLeads {    
      
        get {
            return DFP_Utils.getLeadsForDFC(dfc.Id);
            }
        set;

    }

    public Boolean hasPushMessages {

        get{
              return (DF_Utils.pushMessages(dfc)!= null && DF_Utils.pushMessages(dfc).size()>0?true:false);
           }
        set;

   }

   public Boolean hasExchangeAccess{

        get {

            return DF_Utils.hasPermissionSetAccess(user.Id, DF_Utils.getPermissionSetId('Exchange_User'));
         }

        set;
   }

}