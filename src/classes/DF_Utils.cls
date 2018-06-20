/******************************************************************************************
*  Alzheimer's Society
*  
*  Purpose : Useful Utils for the Dementia Friends application
*  Author  : Gary Grant
*  Date    : 07/02/2015
*  Version : 0.1 Unit Test
*    
*  Description: 
*               
*  Modification History
*  Date            Who         Description 
17/11/2015      Valerie     Added get DFContactForEmail 


*******************************************************************************************/

public without sharing class DF_Utils{
    
    public final static String NEWSLETTER_SIGNUP_SNIPPET_NAME = 'Newsletter_Signup_Snippet';
    public final static String REGISTER_FRIEND_SNIPPET_NAME = 'Register_Friend_Snippet';
    
    public final static String EMPTY_FIELD_VALUE_MSG = 'Value is required and can\'t be empty';
    public final static String INVALID_EMAIL_ADDRESS = 'The email address you have provided is not valid';
    public final static String STANDARD_ERROR_MSG = 'Please correct the highlighted mistakes';
    public final static String ALREADY_SIGNED_UP_MSG = 'Our records show you have already signed up for our e-Newsletter';
    public final static String PASSWORDS_DO_NOT_MATCH_MSG = 'Passwords did not match';
    public final static String EMAILS_DO_NOT_MATCH_MSG = 'Email addresses did not match';
    public final static String USER_ALREADY_EXISTS_MSG = 'A user already exists with this email address';
    public final static String BAD_PASSWORD_MSG = 'Please use at least 8 characters, with a mix of number and letters';
    public final static String COUNTRY_MSG = 'Sorry. We can only register Friends in England and Wales';
    public final static String AGE_MSG = 'Sorry. You must be over 16 to volunteer as a Dementia Friends Champion';
    public final static String INVALID_PHONE_MSG ='Please enter telephone number in correct  format';
    
    public final static String USER_TYPE_SUBSCRIBER = 'Subscriber';
    public final static String USER_TYPE_CHAMPION = 'Champion';
    public final static String USER_TYPE_FRIEND = 'Friend'; 
    public final static String USER_TYPE_DIGITAL_FRIEND = 'Digital Friend';
    
    public final static String RT_FRIEND = 'Dementia_Friend';
    public final static String RT_CHAMPION = 'Dementia_Friend_Champion';
    
    public static final String CHAMPION_TYPE_SUPER = 'Super Champion';
    
    public final static String RT_NEWSLETTER_CONTACT = 'E_Newsletter_Subscriber';
    public final static String RT_RSO = 'RSO';
    public final static String RT_REGISTRATION = 'Registration';
    public final static String RT_ADMIN = 'Admin';
    public final static String RT_ORG_ADMIN = 'DF_Partner_Organisation_Admin';
    
    public static final String STATUS_CONVERTED = 'Converted';
    public static final String STATUS_PROSPECTIVE = 'Prospective';
    public static final String STATUS_RETIRED = 'Retired';
    public static final String STATUS_DECLINED = 'Declined';
    public static final String STATUS_SUSPENDED = 'Suspended';
    public static final String STATUS_HIATUS = 'On Hiatus/Resting';
    public static final String EVENT_STATUS_COMPLETED = 'Completed';
    
    public static final String RT_CHAMPION_COURSE = 'Champion_Training_Course';
    public static final String RT_FRIENDS_SESSION = 'Dementia_Friend_Awareness_Session';
    public static final String ATTENDEE_STATUS_ATTENDED = 'Attended';
    public static final String ATTENDEE_STATUS_NOSHOW = 'No Show';
    
    public static final String EVENT_STATUS = 'Completed';
    
    private static Map<String, RecordType> mapDfcRecordTypes;
    private static Map<String, RecordType> mapDfcRecordTypesById;
    
    private static Map<String, RecordType> mapContactRecordTypes;
    private static Map<String, RecordType> mapContactRecordTypesById;
    private static Map<String, RecordType> mapObjectRecordTypes;
    private static Map<String, Map<String, RecordType>> mapObjectRT;  
    
    
    private static Map<String, RecordType> mapDfEventRecordTypes;
    private static Map<String, RecordType> mapDfEventRecordTypesById;
    
    public static Map<String, RecordType> getsObjectRecordTypesMap(String Obj) { 
        
        
        if ( mapObjectRT == null )  {
            mapObjectRT = new Map<String, Map<String, RecordType>>();             
        }
        
        if ( mapObjectRT.get(obj) !=null ) { return mapObjectRT.get(obj); }
        
        Map<String, RecordType> mapRT = new Map<String, RecordType>(); 
        List<RecordType> lis = [select id, DeveloperName, sObjectType from RecordType where sObjectType =:Obj and isActive=true];
        
        for (RecordType rt : lis) {                 
            mapRT.put(rt.DeveloperName, rt); 
        }
        
        mapObjectRT.put(obj, mapRT);
        return mapRT;
        
    }
    
    public static String getsObjectRecordTypeId(String sObjectName, String sDeveloperName) {
        
        system.debug(' Method getObjectRecordTypeId : ' + sDeveloperName);
        RecordType rt = getsObjectRecordTypesMap(sObjectName).get(sDeveloperName);
        if ( rt != null ) { return rt.id ; }
        return null;
    }  
    
    
    
    public static Map<String, RecordType> getDfEventRecordTypesMap() { 
        
        if ( mapDfEventRecordTypes != null) { return mapDfEventRecordTypes; }
        
        mapDfEventRecordTypes = new Map<String, RecordType>();
        List<RecordType> lis = [select id, DeveloperName, sObjectType from RecordType where sObjectType = 'DF_Event__c' and isActive=true];
        
        for (RecordType rt : lis) {             
            mapDfEventRecordTypes.put(rt.DeveloperName, rt);        
        }
        
        return mapDfEventRecordTypes;
        
    }    
    
    public static Map<String, RecordType> getDfEventRecordTypeIdMap() { 
        
        
        if ( mapDfEventRecordTypesById != null ) { return mapDfEventRecordTypesById; }
        
        mapDfEventRecordTypesById = new Map<String, RecordType>();
        for (RecordType rt : getDfEventRecordTypesMap().values()) {
            mapDfEventRecordTypesById.put(rt.id, rt);
        }
        
        return mapDfEventRecordTypesById;
        
    }
    
    public static Map<String, RecordType> getDfcRecordTypesMap() { 
        
        if ( mapDfcRecordTypes != null) { return mapDfcRecordTypes; }
        
        mapDfcRecordTypes = new Map<String, RecordType>();            
        List<RecordType> lis = [select id, DeveloperName, sObjectType from RecordType where sObjectType = 'DF_Contact__c' and isActive=true];
        
        for (RecordType rt : lis) {             
            mapDfcRecordTypes.put(rt.DeveloperName, rt);        
        }
        
        return mapDfcRecordTypes;
        
    }
    
    public static Map<String, RecordType> getDfcRecordTypeIdMap() { 
        
        
        if ( mapDfcRecordTypesById != null ) { return mapDfcRecordTypesById; }
        
        mapDfcRecordTypesById = new Map<String, RecordType>();
        for (RecordType rt : getDfcRecordTypesMap().values()) {
            mapDfcRecordTypesById.put(rt.id, rt);
        }
        
        return mapDfcRecordTypesById;
        
    }
    
    public static Map<String, RecordType> getContactRecordTypesMap() { 
        
        if ( mapContactRecordTypes != null) { return mapContactRecordTypes; }
        
        mapContactRecordTypes = new Map<String, RecordType>(); 
        List<RecordType> lis = [select id, DeveloperName, sObjectType from RecordType where sObjectType = 'Contact' and isActive=true];
        
        for (RecordType rt : lis) {                 
            mapContactRecordTypes.put(rt.DeveloperName, rt); 
        }
        
        return mapContactRecordTypes;
        
    }
    
    
    public static Map<String, RecordType> getContactRecordTypeIdMap() { 
        
        if ( mapContactRecordTypesById != null ) { return mapContactRecordTypesById; }
        
        mapContactRecordTypesById = new Map<String, RecordType>();
        for (RecordType rt : getContactRecordTypesMap().values()) {
            mapContactRecordTypesById.put(rt.id, rt);
        }
        
        return mapContactRecordTypesById;
        
    }
    
    public static String getContactRecordTypeId(String sDeveloperName) {
        
        system.debug('DF_Utils Requesting Contact RecordType id : ' + sDeveloperName);
        RecordType rt = getContactRecordTypesMap().get(sDeveloperName);
        if ( rt != null ) { return rt.id ; }
        return null;
    }    
    
    public static String getDfcRecordTypeId(String sDeveloperName) {
        
        RecordType rt = getDfcRecordTypesMap().get(sDeveloperName);
        if ( rt != null ) { return rt.id ; }
        return null;
    }  
    
    public static String getActionRecordTypeId(String sDeveloperName) {
        
        system.debug('DF_Utils Requesting Action RecordType id : ' + sDeveloperName);
        RecordType rt = getsObjectRecordTypesMap('Action__c').get(sDeveloperName);
        if ( rt != null ) { return rt.id ; }
        return null;
    }   
    
    
    
    public static String getContactRecordTypeName(String id) {
        
        RecordType rt = getContactRecordTypeIdMap().get(id);
        if ( rt != null ) { return rt.DeveloperName ; }
        return null;
    }    
    
    public static String getDfcRecordTypeName(String id) {
        
        RecordType rt = getDfcRecordTypeIdMap().get(id);
        if ( rt != null ) { return rt.DeveloperName ; }
        return null;
    }
    
    
    public static String getDfEventRecordTypeId(String sDeveloperName) {
        
        RecordType rt = getDfEventRecordTypesMap().get(sDeveloperName);
        if ( rt != null ) { return rt.id ; }
        return null;
    }    
    
    public static Contact getContactRecord(DF_Contact__c dfc)
    {
        try {
            
            
            /* TODO!! Find a better way of ensuring the correct contact is fetched than using RecordType on Contact
Can't use Portal_Contact__c because that is not initialised until after the create transation has completed (it's handled by an @Future).

That is an issue for the registration process
*/   
            
            String sRecordTypeName = dfc.RecordType.DeveloperName;
            if ( sRecordTypeName == null ) {
                sRecordTypeName = getDfcRecordTypeName(dfc.RecordTypeId);
            }           
            
            String sRecordTypeId = getContactRecordTypeId(sRecordTypeName); 
            
            system.debug( 'Fetching Contact for DF Contact for : '  + dfc.Email__c + ' / ' + sRecordTypeId );
            Contact c = [select Id, Firstname,Lastname,Name, Email,AccountId, Password_Reset_Key__c from Contact 
                         where email =: dfc.Email__c 
                         and RecordTypeId =: sRecordTypeId LIMIT 1];
            return c;
            
        } catch (Exception x) {
            
            system.debug('Contact not found for DF_Contact__c' + dfc.id);
            return null;
            
        }
        
    }
    
    public static Contact getContactRecordForDfcId(String dfcId)
    {
        try {
            
            
            system.debug( 'Fetching Contact for DF Contact for : '+ dfcid );
            Contact c = [select Id, Firstname, Lastname, Name, Email, AccountId, Password_Reset_Key__c 
                         from Contact 
                         where  DF_Contact__c =: dfcId LIMIT 1];
            return c;
            
        } catch (Exception x) {
            
            system.debug('Contact not found for DF_Contact__c' );
            return null;
            
        }
        
    }
    
    public static DF_Contact__c getDFContactForEmail (String email) {       
        
        List<DF_Contact__c> lis = [select id, DF_Contact__c.Title__c, 
                                   DF_Contact__c.First_Name__c, DF_Contact__c.Last_Name__c, Name, Email__c, Postcode__c, Contact_Number__c,
                                   RecordType.DeveloperName, Newsletters__c, Digital_Friend_Signup_Time__c, Has_Watched_Video__c,
                                   Number_of_Friends_Influenced__c, Code_Verefied__c, Session_Code_Verified__c, Status__c, Created_As_Type__c,
                                   Admin_block_from_requesting_info_session__c, Blocked_due_to_excessive_req_sessions__c, Type_of_Champion__c
                                   from DF_Contact__c 
                                   where Email__c =: email LIMIT 1];
        
        if ( lis.isEmpty() ) return null;
        return (DF_Contact__c)lis[0];                            
        
    }
    
    public static DF_Contact__c getDFContactForUser(String userid) {
        
        /* Don't user Email Address to get the Contact, because Org users may have 
registered a Champion account and an Org account with the same email address
The UserName will be the same as Email Address for DF Contacts, but not for 
Org Admin users. 
*/   

        User u = [Select id, ContactId, Contact.Email, UserName from User where id =: userid];    

        return getDFContactForUser(u);
        
    }
    
    public static DF_Contact__c getDFContactForUser(User u) {
        
        try { 
            
            DF_Contact__c dfc = [select id, DF_Contact__c.Title__c, 
                                 DF_Contact__c.First_Name__c, DF_Contact__c.Last_Name__c, Name, Email__c, Postcode__c, Contact_Number__c,
                                 RecordType.DeveloperName, Newsletters__c, Digital_Friend_Signup_Time__c, DF_Region__c,
                                 Number_of_Friends_Influenced__c, Total_No_of_Friends_Created__c, Code_Verefied__c, Session_Code_Verified__c, Status__c, Created_As_Type__c,
                                 Partner_Organisation_Id__c,Partner_Organisation_Id__r.Internal_purpose__c,Partner_Organisation_Id__r.Name,
                                 Watched_Video_Type__c,Block_champion_exchange_access__c, Type_of_Champion__c, Has_Watched_Video__c,
                                 Admin_block_from_requesting_info_session__c, Blocked_due_to_excessive_req_sessions__c, Info_Session_Search_Radius__c
                                 from DF_Contact__c 
                                 where Email__c =: u.UserName LIMIT 1];

            return dfc;
            
        } catch (Exception x) {             
            
            system.debug('DF UTILS User Contact Not Found : ' + u.id);
            system.debug(x.getMessage());
            return null;                
            
        }
        
    }
    
    
    public static User getUserRecord(DF_Contact__c dfc)
    {
        
        system.debug('Utils - querying For user Account : ' + dfc.Email__c);
        
        /* The Connection between DF_Contact and Contact is established
with a future method, so may not be immediately available */             
        try { 
            
            Contact c = getContactRecord(dfc);
            User u = [select id, Name, UserName, Email, ContactId from User where ContactId =: c.id LIMIT 1];
            
            system.debug('DF UTILS User Account Found : ' + c.id);
            return u;
            
        } catch (Exception x) {             
            
            system.debug('DF UTILS User Account Not Found : ' + dfc.Email__c);
            system.debug(x.getMessage());
            return null;                
            
        }
        
    }
    
    /* Has this DF_Contact registered a User record (for login) */  
    public static boolean hasUserRecord(DF_Contact__c dfc)
    {
        User u = getUserRecord(dfc);
        system.debug('Utils - User Account is null : ' + u == null);
        return u != null; 
    }
    
    public static boolean isChampion (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( dfc.RecordTypeId == DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION) ) { return true; }
        //if ( dfc.RecordType.DeveloperName == DF_Utils.RT_CHAMPION ) { return true ;}
        return false;
        
    }
    
    public static boolean isChampionConverted (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( !isChampion(dfc) ) { return false; }
        return ( STATUS_CONVERTED.equalsIgnoreCase(dfc.Status__c));// && dfc.Code_Verefied__c);
        
    }
    
    public static boolean isChampionVerified (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( !isChampion(dfc) ) { return false; }
        return ( dfc.Code_Verefied__c );
        
    }
    
    public static boolean isChampionRetired (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( !isChampion(dfc) ) { return false; }
        return ( STATUS_RETIRED.equalsIgnoreCase(dfc.Status__c));
        
    }
    
    public static boolean isChampionProspective (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( !isChampion(dfc) ) { return false; }
        return ( STATUS_PROSPECTIVE.equalsIgnoreCase(dfc.Status__c));
        
    }
    
    public static boolean isChampionDeclined (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( !isChampion(dfc) ) { return false; }
        return ( STATUS_DECLINED.equalsIgnoreCase(dfc.Status__c));
        
    }
    
    public static boolean isChampionSuspended (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( !isChampion(dfc) ) { return false; }
        system.debug('df utils suspended '+ STATUS_SUSPENDED.equalsIgnoreCase(dfc.Status__c));
        return ( STATUS_SUSPENDED.equalsIgnoreCase(dfc.Status__c));
        
    }
    
    public static boolean isChampionHiatus (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( !isChampion(dfc) ) { return false; }
        return ( STATUS_HIATUS.equalsIgnoreCase(dfc.Status__c));
        
    }
    
    public static Decimal getDefaultSearchRadius (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return null; }
        if ( !isChampion(dfc) ) { return null; }
        return ( dfc.Info_Session_Search_Radius__c);
        
    }
    
    
    public static boolean isFriend (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( dfc.RecordTypeId == DF_Utils.getDfcRecordTypeId(DF_Utils.RT_FRIEND) ) { return true; }
        //if ( dfc.RecordType.DeveloperName == DF_Utils.RT_FRIEND ) { return true ;}
        return false;
        
    }
    
    public static boolean isFriendConverted (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( !isFriend(dfc) ) { return false; }
        return ( STATUS_CONVERTED.equalsIgnoreCase(dfc.Status__c) && dfc.Session_Code_Verified__c );
        
    }
    
    public static List<Action__c> dfActions(DF_Contact__c dfc) {
        
        if ( dfc == null ) { return null; }
        List<Action__c> action = [SELECT Id, Action__c FROM Action__c WHERE DF_Contact__c = :dfc.id LIMIT 1];
        return action;
        
    }
    
    
    public static boolean isSubscriber (DF_Contact__c dfc) {
        
        if ( dfc == null ) { return false; }
        if ( dfc.Newsletters__c ) { return true ;}
        return false;
        
    }
    
    private static List<SelectOption> getOptionList(Schema.DescribeFieldResult res) {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '- Select a value - '));
        List<Schema.PicklistEntry> ple = res.getPicklistValues();       
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        
        return options;     
        
    }
    
    
    
    public static List<SelectOption> genderOptions {
        
        get {
            
            Schema.DescribeFieldResult res =  DF_Contact__c.Gender__c.getDescribe();
            return getOptionList(res);                                      
        }       
        set;                
    }
    
    public static List<SelectOption> ethnicGroupOptions {
        
        get {
            
            Schema.DescribeFieldResult res =  Demographic_Information__c.Ethnic_Group__c.getDescribe();
            return getOptionList(res);                                      
        }       
        set;                
    }
    public static String getCustomSetting(String sName) {
        
        if (Test.isRunningTest()) {
            
            if (sName == 'DF_Friend_Count_Baseline_Date') { 
                return '2015-4-18 00:00:00';
            }
            
            if (sName == 'DF_Friend_Count_Baseline') {
                return '1000000';
            }
        }
        
        return (String)Community_Settings__c.getInstance(sName).value__c;
        
    }
    
    public static Map<String, Partner_Organisation__c>  getPartnerOrgMap() {
        
        Map<String, Partner_Organisation__c> mapPartnerOrg = new Map<String, Partner_Organisation__c>();
        for (Partner_Organisation__c po : [Select p.Partner_External_Id__c, p.Name, p.Id, p.DFC_Code__c From Partner_Organisation__c p]){
            mapPartnerOrg.put(po.DFC_Code__c, po);          
        }
        
        return mapPartnerOrg;
        
    }
    
    public static String getOrgIdForChampionCode(String sCode) {
        
        if ( sCode == null || sCode == '' ) { return null; }
        
        List<Partner_Organisation__c> lis = [select id from Partner_Organisation__c where DFC_Code__c =:sCode limit 1];
        
        if ( lis.isEmpty() ) { return null; }
        return lis[0].id;
        
    }
    
    
    public static Integer totalFriendCount {
        
        get {                 
            
            
            /* June 2016. Change from Custom Setting to Editable Item */
            
            String sDate = '2015-4-18 00:00:00';
            String sBaseLine = '1000000';
            
            List<Edt_Item__c> items = [select Id, Text1__c, Text2__c from Edt_Item__c where Group__c = 'df-generic' and Key__c = 'total-friend-count' limit 1];
            if ( items.size() > 0 ) {
                sBaseLine = items[0].Text1__c;
                sDate = items[0].Text2__c;
            }
            
            /*
String sDate = getCustomSetting('DF_Friend_Count_Baseline_Date');            
if ( sDate ==null || sDate == '') {                  
sDate= '2015-4-18 00:00:00';
System.debug('Error: Friend Count Baseline Date Not Set');
}
*/
            
            Date dt = Date.valueOf(sDate);
            AggregateResult[] res = [select count(id) dc from DF_Contact__c 
                                     where Digital_Friend_Signup_Time__c !=null AND Digital_Friend_Signup_Time__c>:dt
                                     AND Created_As_Type__c ='Digital Friend'];
            
            Integer iDDF = (Integer)res[0].get('dc');
            
            /*
String sBaseLine = getCustomSetting('DF_Friend_Count_Baseline');
if ( sBaseLine ==null || sBaseLine == '') {
sBaseLine = '1000000';
System.debug('Error: Friend Count Baseline Not Set');
}
*/             
            
            Integer iBaseline = Integer.valueOf(sBaseLine);
            return iBaseline + iDDF;
            
        }
        
        private set;
        
    }
    
    
    public static final List<String> champcodes =new List <String >();
    public  static List<String> listchampionCodes{
        
        get {
            
            
            List<Champion_Codes__c> registrationCode = Champion_Codes__c.getall().Values();
            system.debug('list of champion codes++'+registrationCode);
            if (registrationCode.size()!= null) {
                for(Champion_Codes__c lisreg:registrationCode){
                    //         system.debug('code value'+lisreg.Code__c);
                    champcodes.add( lisreg.Code__c);
                    //         system.debug('list of champs codes++'+listchampionCodes);
                    
                }
                
            }
            return champcodes;
        }
        private set;
    }
    
    public static sObject objectWithAllFields(String sField, String sId, Schema.DescribeSObjectResult oDescribe)
    {
        
        
        
        List<String> lisIds = new List<String>();
        lisIds.add(sId);
        List<sObject> lisReturn = objectListWithAllFields(sField, lisIds, oDescribe);
        return lisReturn.isEmpty() ? null : lisReturn[0];      
        
    } 
    
    public static List<sObject> objectListWithAllFields(String sField, List<String> sIds, Schema.DescribeSObjectResult oDescribe)
    {
        
        //Put the field names into a List      
        Map<String, sObjectField> mapFields = oDescribe.fields.getMap();
        List<Schema.Sobjectfield> lisFields = mapFields.values();  
        
        // A string for the field names in the query   
        String sFields = '';   
        
        // Build the query string 
        String soql = 'select ';
        for(Schema.sObjectField f : lisFields ) {      
            if (sFields!='') { sFields = sFields + ','; }
            sFields = sFields + f.getDescribe().getName();      
        }
        
        soql = soql + sFields; 
        soql = soql + ' from ' + oDescribe.getName();
        soql = soql + ' where ' + sField + ' in: sIds';        
        
        system.debug('Object List with all Fields : ' + soql); 
        
        List<sObject> lis = new List<sObject>();       
        lis= Database.query(soql);      
        
        // Return the list of sObjects     
        return lis; 
        
    } 
    
    public static boolean  isDisabledTriggers()
    {
        Disable_Rules__c DisabledRules = Disable_Rules__c.getInstance();
        return  DisabledRules.Disable_Triggers__c;
    }
    
    public static Double offset{
        get{
            TimeZone tz = UserInfo.getTimeZone();
            //Milliseconds to Day
            return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        }
        
        set ;
        
    }
    
    public static Datetime getDatetimeforUnixTimeStamp(String unixdt){
        
        if(unixdt==null){ return null;}
        Integer unixTime = integer.valueof(unixdt);
        DateTime dateInstance = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
        DateTime dt =dateInstance.addSeconds(unixTime);
        
        return dt;
        
    }
    
    public static String listAsString(List<String> lis) {
        
        Integer c = 0;
        String sReturn = '';
        
        for (String s : lis) {
            if (c>0) {sReturn +=',';}
            sReturn += wrapApostrophe(s);
            c++;  
        }
        
        return sReturn;
        
    }  
    
    public static String  wrapApostrophe(String text) {
        String apo = '\'';
        return (  apo + string.escapeSingleQuotes(text) + apo );
    } 
    
    
    public static string getPermissionSetId(String permSetName){
        
        if(permSetName =='' && permSetName==null){ return null;}
        List<PermissionSet>  perm = new List<PermissionSet>(); 
        perm = [SELECT Id, name FROM PermissionSet where name =:permSetName and IsOwnedByProfile= FALSE limit 1];
        
        return (perm.size()>0?perm[0].Id:null);
    }
    
    public static string getCommunityId(String communityName){
        
        if(communityName =='' && communityName==null){ return null;}
        List<Network>  c = new List<Network>();
        c = [SELECT Id FROM Network where name =:communityName limit 1];
        
        return (c.size()>0?c[0].Id:null);
    }
    
    public static string getGroupId(String groupName,string communityId){
        
        if((groupName =='' && groupName==null)|| (communityId=='' && communityId==null)){ return null; }
        List<CollaborationGroup>  g = new List<CollaborationGroup>();
        g = [SELECT Id FROM CollaborationGroup where name =:groupName and networkId=: communityId limit 1];
        
        return (g.size()>0?g[0].Id:null);
    }
    
    public static Id getCommunityGroupId(String communityName, String groupName){
        
        if((groupName =='' && groupName==null)|| (communityName=='' && communityName==null)){ return null; }
        
        list<CollaborationGroup> g = [SELECT Id FROM CollaborationGroup where name =:groupName and network.Name =: communityName limit 1];
        
        return (g.size()>0?g[0].Id:null);
        
    }
    
    
    public static Boolean hasPermissionSetAccess(String userId,String permSetId){
        
        if(userId =='' && permSetId==''){ return null;}
        List<PermissionSetAssignment> pa = new List<PermissionSetAssignment>(); 
        pa =[select id from PermissionSetAssignment where AssigneeId =:userId and PermissionSetId=:permSetId limit 1];
        
        return (pa.size()>0);
    }
    
    public static string getNetworkId(String networkName){
        
        if(networkName =='' || networkName==null){ return null; }
        List<Network>  lisNetwork = new List<Network>();
        lisNetwork = [SELECT Id FROM Network where name =:networkName];
        
        return (lisNetwork.size()>0?lisNetwork[0].Id:null);
    }
    
    public static List<Push_Notifications__c> pushMessages(DF_Contact__c dfc) {
        
        if ( dfc == null ) { return null; }
        List<Push_Notifications__c> pushMsg = [SELECT Message__c,Id,title__c,button_title__c,Button_link__c FROM Push_Notifications__c WHERE DF_Contact__c = :dfc.id and Status__c='Unread'];
        return pushMsg;
        
    }
    
    /* Get the list of options from a field */ 
    public static List<SelectOption> getOptions(Schema.DescribeFieldResult field) 
    {
        
        List<SelectOption> options = new List<SelectOption>();
        for (Schema.PicklistEntry f : field.getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getLabel())); 
        }
        return options;
        
    }
    
    
}