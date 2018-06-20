/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX functionality class for all conversion processes
 *            (Friend to Champion / Champion to Friend).
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    WEBConversionClass will hold static methods called when converting 
 *                  Dementia Friends members from a Registration to a Friend, 
 *                  from a Friend to a Champion, and from a Champion to a Friend 
 *                  
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class WEBConversionClass extends WEBController {

    public static Map<String, RecordType> contactRecordTypes {get; set;}
    public static Map<String, RecordType> dfContactRecordTypes {get; set;}
    public static Map<String, Profile> profileMap {get; set;}
    public static final String PAGE_WHAT_IS_A_CHAMPION = 'what-is-a-champion'; 
    public static final String RT_CONTACT_FRIEND = 'Dementia_Friend';
    public static final String RT_CONTACT_CHAMPION = 'Dementia_Friend_Champion';
    public static final String RT_DFCONTACT_FRIEND = 'Dementia_Friend';
    public static final String RT_DFCONTACT_CHAMPION = 'Dementia_Friend_Champion';
    public static final String STATUS_CONVERTED = 'Converted';
    public static final String STATUS_PROSPECTIVE = 'Prospective';
    //public static final String DEFAULT_FRIEND_CODE = 'DEMENTIAFRIEND123';
    //public static final String DEFAULT_CHAMPION_CODE = 'ABC123';
    public static final String DEFAULT_FRIEND_CODE = WEBGlobalSettings.friendConvertCode;
    public static final String DEFAULT_CHAMPION_CODE = WEBGlobalSettings.championConvertCode;
    
    public static String friendConvertCode {get; set;}
    public static String championConvertCode {get; set;}
    public static Contact contactToBeConverted {get; set;}
    public static DF_Contact__c dfContactToBeConverted {get; set;}
    public static Map<String, Partner_Organisation__c> partnerOrgCodeMap {get; set;}
    
    public static String whatIsAChampionPage {
        get {
            return PAGE_WHAT_IS_A_CHAMPION;
        }
        set ;
    }
    //public static String contactId {get; set;}
    //public static String conversionCode {get; set;}

    public static boolean isFriend (String contactId ) {
        init();
        getContactRecords(contactId);

        if (contactToBeConverted != null && dfContactToBeConverted != null) {
            if (dfContactToBeConverted.RecordTypeId == dfContactRecordTypes.get(RT_DFCONTACT_FRIEND).Id) {
                return true;
            }
        }
        System.debug('*** Contact is not a Friend');
        return false;
    }
    
    public static boolean isFriendConverted (String contactId ) {
        init();
        getContactRecords(contactId);
        
        if (contactToBeConverted != null && dfContactToBeConverted != null) {
            if (dfContactToBeConverted.RecordTypeId == dfContactRecordTypes.get(RT_DFCONTACT_FRIEND).Id) {
                if (STATUS_CONVERTED.equalsIgnoreCase(dfContactToBeConverted.Status__c) && dfContactToBeConverted.Session_Code_Verified__c){
                    //We cannot convert a contact to a Champion if it's not a Friend first
                    return true;
                }
            }
        }
        System.debug('*** Contact is not a Friend');
        return false;
    }

    public static boolean isChampion (String contactId ) {
        init();
        getContactRecords(contactId);

        if (contactToBeConverted != null && dfContactToBeConverted != null) {
            if (contactToBeConverted.RecordTypeId == contactRecordTypes.get(RT_CONTACT_CHAMPION).Id || 
            dfContactToBeConverted.RecordTypeId == dfContactRecordTypes.get(RT_DFCONTACT_CHAMPION).Id) {
                return true;
            }
        }
        System.debug('*** Contact is not a Champion');
        return false;
    }
    
    public static boolean isChampionConverted (String contactId ) {
        init();
        getContactRecords(contactId);

        if (contactToBeConverted != null && dfContactToBeConverted != null) {
            if (contactToBeConverted.RecordTypeId == contactRecordTypes.get(RT_CONTACT_CHAMPION).Id || 
            dfContactToBeConverted.RecordTypeId == dfContactRecordTypes.get(RT_DFCONTACT_CHAMPION).Id) {
                if (STATUS_CONVERTED.equalsIgnoreCase(dfContactToBeConverted.Status__c) && dfContactToBeConverted.Code_Verefied__c){
                    //We cannot convert a contact to a Champion if it's not a Friend first
                    return true;
                }
            }
        }
        return false;
    }
    
    
    //This method converts a Contact & DF_Contact__c record from an initial registration to a Friend
    public static boolean convertToFriend(String contactId, String conversionCode){
        init();
        getContactRecords(contactId);

        boolean isSuccess = false;

        if (dfContactToBeConverted.Session_Code_Verified__c){
            contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_FRIEND).Id;
            dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_FRIEND).Id;
            update contactToBeConverted;
            update dfContactToBeConverted;
            isSuccess = true;
        }else {
            system.debug('*** -- Session Code Not Verified Already -- ***');
            if (conversionCode == null) {
                //We can't continue without a conversion code
                isSuccess = false;
            } else {
                system.debug('*** -- We have a conversion code ' + conversionCode + ' and its being compared against ' + friendConvertCode + '-- ***');
                //2014-05-14 : CSL : Changing the comparison line, to be equalsIgnoreCase, as per defect DF_LIVE15
                //if (!conversionCode.equals(friendConvertCode)) {
                if (!conversionCode.equalsIgnoreCase(friendConvertCode)) {
                    //We can't continue without a correct conversion code
                    isSuccess = false;
                } else {
                    //We can convert
                    //TODO : We may also need to change the Profile ID
                    if (contactToBeConverted != null && dfContactToBeConverted != null) {
                        contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_FRIEND).Id;
                        dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_FRIEND).Id;
                        dfContactToBeConverted.Status__c = STATUS_CONVERTED;
                        dfContactToBeConverted.Session_Code_Verified__c = true;
                        try {
                            update contactToBeConverted;
                            update dfContactToBeConverted;
                            isSuccess = true;
                        } catch (DmlException dmlEx) {
                            //Error handling
                        }
                    } 
                }
            }
        }
        
        return isSuccess;
    }

    // This method is used when registering as a Champion directly
    public static boolean registerAsChampion(String contactId) {
        init();
        getContactRecords(contactId);
        boolean isSuccess = false;

        contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_CHAMPION).Id;
        dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_CHAMPION).Id;
        
        dfContactToBeConverted.Status__c = STATUS_PROSPECTIVE;
        //2014-03-24 : SM : This field doesn't need to be set because the code isn't registered straight away.
        //dfContactToBeConverted.Code_Verefied__c = true;
        System.debug('*** Converting to Champion');
        try {
            update contactToBeConverted;
            update dfContactToBeConverted;
            isSuccess = true;
        }catch (DmlException dmlEx){
            //Error handling
        }

        return isSuccess;       
    }
    
    //This method converts a Contact & DF_Contact__c record from a Friend to a Champion with a Champion Code - called from WEBChampion.registerCode
    public static boolean convertFriendToChampion(String contactId, String conversionCode){
        system.debug('*** -- into convertFriendToChampion -- ***');
        init();
        getContactRecords(contactId);
        boolean isSuccess = false;

        //If the DF_Contact__c has already been converted, they can go back and forth between Friend and Champion
        //without a code
        if (dfContactToBeConverted.Code_Verefied__c){
            contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_CHAMPION).Id;
            dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_CHAMPION).Id;
            update contactToBeConverted;
            update dfContactToBeConverted;
            isSuccess = true;
        }else {
            if (conversionCode == null){
                //We can't continue without a conversion code
                isSuccess = false;
            }else {
                //system.debug('*** -- the code ' + conversionCode + ' is not verified -- ***');
                //2014-03-11 : SM : We are using the Partner Organisation records to check the Champions codes
                Partner_Organisation__c po = partnerOrgCodeMap.get(conversionCode);
                
                if (po == null){
                    //We can't continue without a correct conversion code
                    isSuccess = false;
                } else {
                    system.debug('*** -- po = ' + po.Id + ' -- ***');
                    if (contactToBeConverted != null && dfContactToBeConverted != null){
                        //2014-03-28 : SM : We do not need to check if they are already a Friend, as they can go straight to a Champion
                        //if (contactToBeConverted.RecordTypeId != contactRecordTypes.get(RT_CONTACT_FRIEND).Id || 
                        //dfContactToBeConverted.RecordTypeId != dfContactRecordTypes.get(RT_DFCONTACT_FRIEND).Id){
                            //We cannot convert a contact to a Champion if it's not a Friend first
                            //isSuccess = false;
                            //System.debug('*** Not a Friend already');
                        //} else {
                            //We can convert
                            //TODO : We may also need to change the Profile ID
                            contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_CHAMPION).Id;
                            dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_CHAMPION).Id;
                            dfContactToBeConverted.Code_Verefied__c = true;
                            dfContactToBeConverted.Status__c = STATUS_CONVERTED;
                            dfContactToBeConverted.Partner_Organisation_ID__c = po.Id;
                            System.debug('*** Converting to Champion');
                            update contactToBeConverted;
                            update dfContactToBeConverted;
                            isSuccess = true;
                        //} 
                    }
                }
            }
        }
        
        return isSuccess;
    }
    
    //This method converts a Contact & DF_Contact__c record from a Friend to a Champion during initial convertion process
    public static boolean convertToChampion(String contactId){
        system.debug('*** -- into convertFriendToChampion -- ***');
        init();
        getContactRecords(contactId);
        boolean isSuccess = false;

        //If the DF_Contact__c has already been converted, they can go back and forth between Friend and Champion
        //without a code
        if (dfContactToBeConverted.Code_Verefied__c){
            contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_CHAMPION).Id;
            dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_CHAMPION).Id;
            update contactToBeConverted;
            update dfContactToBeConverted;
            isSuccess = true;
        }else {
            //if (conversionCode == null){
                //We can't continue without a conversion code
                //isSuccess = false;
            //}else {
                //system.debug('*** -- the code ' + conversionCode + ' is not verified -- ***');
                //2014-03-11 : SM : We are using the Partner Organisation records to check the Champions codes
                //Partner_Organisation__c po = partnerOrgCodeMap.get(conversionCode);
                //system.debug('*** -- po = ' + po.Id + ' -- ***');
                //if (po == null){
                    //We can't continue without a correct conversion code
                    //isSuccess = false;
                //} else {
                    if (contactToBeConverted != null && dfContactToBeConverted != null){
                        //2014-03-28 : SM : We do not need to check if they are already a Friend, as they can go straight to a Champion
                        //if (contactToBeConverted.RecordTypeId != contactRecordTypes.get(RT_CONTACT_FRIEND).Id || 
                        //dfContactToBeConverted.RecordTypeId != dfContactRecordTypes.get(RT_DFCONTACT_FRIEND).Id){
                            //We cannot convert a contact to a Champion if it's not a Friend first
                            //isSuccess = false;
                            //System.debug('*** Not a Friend already');
                        //} else {
                            //We can convert
                            //TODO : We may also need to change the Profile ID
                            contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_CHAMPION).Id;
                            dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_CHAMPION).Id;
                            //dfContactToBeConverted.Code_Verefied__c = true;
                            dfContactToBeConverted.Status__c = STATUS_PROSPECTIVE;
                            System.debug('*** Converting to Champion');
                            update contactToBeConverted;
                            update dfContactToBeConverted;
                            isSuccess = true;
                        //} 
                    }
                //}
            //}
        }
        
        return isSuccess;
    }
    
    //This method converts a Contact & DF_Contact__c record from a Champion back to a Friend
    public static boolean convertChampionToFriend(String contactId, String conversionCode){
        system.debug('*** -- into convertChampionToFriend -- ***');
        init();
        getContactRecords(contactId);

        system.debug('*** -- finished initialization -- ***');

        boolean isSuccess = false;
        if(dfContactToBeConverted != null){
        system.debug('*** -- We have a contact record -- ***');
        if (dfContactToBeConverted.Code_Verefied__c){
            system.debug('*** -- Code is verified -- ***');
            contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_FRIEND).Id;
            dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_FRIEND).Id;
            if (dfContactToBeConverted.Session_Code_Verified__c){
                 dfContactToBeConverted.Status__c = STATUS_CONVERTED;
            }else {
                dfContactToBeConverted.Status__c = STATUS_PROSPECTIVE;
            }
            update contactToBeConverted;
            update dfContactToBeConverted;
            isSuccess = true;
        }else {
        
            if (contactToBeConverted != null && dfContactToBeConverted != null){
                system.debug('*** -- We have a contact record part 2 -- ***');
                if (dfContactToBeConverted.RecordTypeId != dfContactRecordTypes.get(RT_DFCONTACT_CHAMPION).Id){
                    system.debug('*** -- They are not a champion already -- ***');
                    //We cannot convert a contact back to a Friend if its not a Champion first
                    isSuccess = false;
                }else {
                    //We can convert
                    //TODO : We may also need to change the Profile ID
                    contactToBeConverted.RecordTypeId = contactRecordTypes.get(RT_CONTACT_FRIEND).Id;
                    dfContactToBeConverted.RecordTypeId = dfContactRecordTypes.get(RT_DFCONTACT_FRIEND).Id;
                    if (dfContactToBeConverted.Session_Code_Verified__c){
                         dfContactToBeConverted.Status__c = STATUS_CONVERTED;
                    }else {
                        dfContactToBeConverted.Status__c = STATUS_PROSPECTIVE;
                    }
                        
                    system.debug('*** -- About to save -- ***');
                    try {
                        update contactToBeConverted;
                        update dfContactToBeConverted;
                        isSuccess = true;
                    }catch (DmlException dmlEx){
                        system.debug('*** -- DML Exception from convertChampionToFriend: ' + dmlEx + ' -- ***');
                    }       
                                
                }   
            }
        }
        }
        return isSuccess;
    }
    
    //Method init() will populate all the data and lookup records we need
    public static void init(){


        System.debug('Web Controller - Init Started');

        contactRecordTypes = new Map<String, RecordType>();
        for (RecordType r : [select r.Id, r.Name, r.DeveloperName from RecordType r where r.SObjectType = 'Contact' and IsActive = true]){
            contactRecordTypes.put(r.DeveloperName, r);
        }
        
        dfContactRecordTypes = new Map<String, RecordType>();
        for (RecordType r : [select r.Id, r.Name, r.DeveloperName from RecordType r where r.SObjectType = 'DF_Contact__c' and IsActive = true]){
            dfContactRecordTypes.put(r.DeveloperName, r);
        }
        
        profileMap = new Map<String, Profile>();
        for (Profile p : [select p.Id, p.Name from Profile p]){
            profileMap.put(p.Name, p);
        }
        //2014-03-11 : SM : Changing this code from using a custom setting, to Partner Organisations for Champions
        Registration_Code__c friendRC = Registration_Code__c.getInstance('Friend');
        //Registration_Code__c championRC = Registration_Code__c.getInstance('Champion');
        partnerOrgCodeMap = new Map<String, Partner_Organisation__c>();
        for (Partner_Organisation__c po : [Select p.Partner_External_Id__c, p.Name, p.Id, p.DFC_Code__c From Partner_Organisation__c p LIMIT 50000]){ // Short-term "fix". Limit was exceeded in live. Correct this properly!!
            partnerOrgCodeMap.put(po.DFC_Code__c, po);          
        }
        
        //2014-03-11 : SM : Is it only Champions coversion code that uses Partner Orgs?
        friendConvertCode = (friendRC == null ? DEFAULT_FRIEND_CODE : friendRC.Code_Value__c);
        //championConvertCode = (championRC == null ? DEFAULT_CHAMPION_CODE : championRC.Code_Value__c);
        
        system.debug('WebConversionClass : init run complete');

        
    }
    
    //Helper method to set Contact & DF_Contact__c records for conversion
    public static void getContactRecords(String contactId){

        List<Contact> contactList = new List<Contact>();
        List<DF_Contact__c> dfContactList = new List<DF_Contact__c>();

        contactList = [Select c.RecordTypeId, c.Name, c.Id, c.DF_Contact__r.Id From Contact c where c.Id = :contactId LIMIT 1];

        if (contactList.size() > 0){
            contactToBeConverted = contactList[0];  

            System.debug('*** Member Found : ' + contactToBeConverted.Name + ' ' + contactToBeConverted.DF_Contact__r.Id);

            dfContactList = [Select d.RecordTypeId, d.Name__c, d.Id,d.Code_Verefied__c, d.Session_Code_Verified__c, d.Status__c From DF_Contact__c d where d.Portal_Contact__c = :contactId LIMIT 1];
        
            System.debug('*** -- dfContactList size in getContactRecords = ' + dfContactList.size() + ' -- ***');
        
            if (dfContactList.size() > 0){
            
                dfContactToBeConverted = dfContactList[0];  
            
            } else {
            
                System.debug('*** DF Member NOT Found : ');
            
            }           

        }       

        system.debug('Web Conversion Class : getContactRecords Complete' );

    }
}