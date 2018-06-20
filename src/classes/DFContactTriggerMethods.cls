/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX method class for VF Trigger DF_ContactTrigger
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class that will hold methods called by the DF_ContactTrigger
 *                  
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public without sharing class DFContactTriggerMethods {
    
    public static final String DUPLICATE_DETECTED_ERROR = 'Already Registered';

    private static Map<String, RecordType> CONTACT_RT_MAP =  DF_Utils.getContactRecordTypesMap();
    private static Map<String, RecordType> CONTACT_RT_ID_MAP = DF_Utils.getContactRecordTypeIdMap();
    private static Map<String, RecordType> DFC_RT_ID_MAP = DF_Utils.getDfcRecordTypeIdMap();

    private static Set<ID> ALLOWABLE_RECORD_TYPES;
  
    private static void setAllowableRecordTypes() {

        ALLOWABLE_RECORD_TYPES = new Set<Id>();
        ALLOWABLE_RECORD_TYPES.add(CONTACT_RT_MAP.get(DF_Utils.RT_FRIEND).id);
        ALLOWABLE_RECORD_TYPES.add(CONTACT_RT_MAP.get(DF_Utils.RT_CHAMPION).id);
        ALLOWABLE_RECORD_TYPES.add(CONTACT_RT_MAP.get(DF_Utils.RT_NEWSLETTER_CONTACT).id);
        ALLOWABLE_RECORD_TYPES.add(CONTACT_RT_MAP.get(DF_Utils.RT_REGISTRATION).id);

    }


    //This method will check for duplicate DF Contact records and if it finds any
    //will add an error to the record to stop the insert.
    public static void dedupeDFContacts(List<DF_Contact__c> lisDfcNew){
        
        system.debug('DF Contact DeDupe - Start');

        Set<String> dfContactEmails = new Set<String>();
        Map<String, DF_Contact__c> existingDFContacts = new Map<String, DF_Contact__c>();

        // Get the list of email addresses being updated
        for (DF_Contact__c dfc : lisDfcNew){
            dfContactEmails.add(dfc.Email__c);
        }
        
        // Get the list of existing contacts with those email
        for (DF_Contact__c dfc : [select d.Id, d.Email__c from DF_Contact__c d where d.Email__c in :dfContactEmails]){
            existingDFContacts.put(dfc.Email__c, dfc);  
        }
        
        for (DF_Contact__c dfc : lisDfcNew){
         
             DF_Contact__c existingDFContact = existingDFContacts.get(dfc.Email__c);
         
             if (existingDFContact != null){
                dfc.addError(DUPLICATE_DETECTED_ERROR);
             }
        }
        
    }

    //This method will take any incoming DF_Contact__c records (insert only) and create corresponding Contact records
    public static void createContacts(List<DF_Contact__c> lisDfcNew){
        
        System.debug('DF Contact Trigger - Start');
       
        List<Contact> contactsToSave = new List<Contact>();
        
        Set<String> emailSet = new Set<String>();
        Set<String> lastNameSet = new Set<String>();
        Set<Id> contactIdSet = new Set<Id>();

        setAllowableRecordTypes();
        
        for (DF_Contact__c dfc : lisDfcNew){
            emailSet.add(dfc.Email__c);
            lastNameSet.add(dfc.Last_Name__c);
        }
        
        /* September 2017
           The check on record type here ensures that any other teams using the DF Org can create duplicate contacts
           that are not Dementia Friends record type. The registration process will ignore any 
           Contacts that do not have the correct Record Type. 
           This allows multiple teams to have parallel data sets that do not interfer with each other

        */   
        Map<String, Contact> contactMap = new Map<String, Contact>();
        for (Contact c : [select c.LastName, c.Email, c.RecordTypeId, C.RecordType.DeveloperName 
                          from Contact c where 
                          c.LastName in: lastNameSet 
                          and c.Email in: emailSet 
                          and c.RecordTypeId in: ALLOWABLE_RECORD_TYPES ]) {
             
        
             system.debug('DF Contact Trigger - contact ' + c==null);
             contactMap.put(c.Email.toLowerCase(), c);
        
        }
        
        for (DF_Contact__c dfc : lisDfcNew){

             Contact ct = contactMap.get(dfc.Email__c.toLowerCase());
             if ( ct != null ) { 
                system.debug('DF Contact Trigger : ' + ct.Id + ' ' + ct.Email + '  ' + ct.RecordType.DeveloperName);
             }
            
             if ( ct == null ) {

                system.debug('DF Contact Trigger - Creating New Contact: ' + dfc);
                Contact c = createContact(dfc);
                contactsToSave.add(c);
            
             }            

        }
        
        system.debug('DF Contact Trigger - Saving ' + contactsToSave.size());
        Database.SaveResult[] dsr = new List<Database.SaveResult>();
        if ( contactsToSave.size() > 0 ) {
            dsr = Database.insert(contactsToSave, true);
        }
        for(Database.SaveResult ds : dsr) {
            System.debug('Was insertion successful?: ' + ds.isSuccess());
            if(!ds.isSuccess()) {
                System.debug(ds.getErrors());
            } else {
                System.debug('Createed portal contact: ' +  ds.getId());
            }
        }
        
    }
    
    /*
        This method will make sure the DF_Contact has a link to the Portal Contact
        September 2017 
        This method will only connect Contact records that have the correct Record Type for a 
        Dementia Friend

    */    
    @future(callout=false)
    public static void assignPortalContact(Set<Id> dfContactIDs){
        
        System.debug('Contact Trigger : Assigning Portal Contact');
        List<DF_Contact__c> lisDfcNew = new List<DF_Contact__c>();
        List<DF_Contact__c> saveDFContacts = new List<DF_Contact__c>();
        setAllowableRecordTypes();
        
        lisDfcNew = [select d.Email__c, d.Last_Name__c, d.Id, d.RecordTypeId from DF_Contact__c d where d.Id in :dfContactIDs];
        
        if (lisDfcNew.size() > 0){
            
            Set<String> emailSet = new Set<String>();
            Set<String> lastNameSet = new Set<String>();
            
            for (DF_Contact__c dfc : lisDfcNew){
                emailSet.add(dfc.Email__c);
                lastNameSet.add(dfc.Last_Name__c);
            }
            
            Map<String, Contact> contactMap = new Map<String, Contact>();
            for (Contact c : [select c.Id, c.LastName, c.Email, c.RecordTypeId from Contact c 
                                where c.LastName in :lastNameSet 
                                and c.Email in :emailSet
                                and c.RecordTypeId in: ALLOWABLE_RECORD_TYPES])
            {
                
                contactMap.put(c.Email.toLowerCase(), c);

            }
            
            for (DF_Contact__c dfc : lisDfcNew){
            
             Contact c = contactMap.get(dfc.Email__c.toLowerCase());
             
             if ( c != null ){
                 System.debug('Contact Trigger : Contact Found ' + c.id + ' ' + c.Email);
                 dfc.Portal_Contact__c = c.Id;
                 saveDFContacts.add(dfc);
             }

            }
            
            if (saveDFContacts.size() > 0){
                update saveDFContacts; 
            }

        }
        
    }
    
    public static void updateContacts(List<DF_Contact__c> lisDfcNew){

        system.debug('DF Contact Trigger - Entering Update with: ' + lisDfcNew);     
              
        Set<Id> contactIdSet = new Set<Id>();
        Set<String> contactEmailSet = new Set<String>();
        List<Contact> contactsToSave = new List<Contact>();
        
        Set<Id> dfContactIdsToUpdate = new Set<Id>();
        boolean contactFound;
        
        List<Contact> contactsToInsert = new List<Contact>();

        setAllowableRecordTypes();
        
        // Create sets of Ids and Emails for the updated DF records        
        for (DF_Contact__c dfc : lisDfcNew){
        	System.debug('dfc.Portal_Contact__c: ' + dfc.Portal_Contact__c);
            if (dfc.Portal_Contact__c != null){

                system.debug('DF Contact Trigger - Set Portal Contact on DFC');     
                contactIdSet.add(dfc.Portal_Contact__c);

            } else {

                contactEmailSet.add(dfc.Email__c.toLowerCase());

            }
        
        }

        /* Two different maps used here. One for records with a Contact Id
           and one where that value has not been set yet
        */    
        Map<Id, Contact> contactMap = new Map<Id, Contact>([select c.RecordTypeId, c.FirstName, c.LastName, c.Email, c.Salutation, c.Phone, c.Newsletters__c, c.MailingPostalCode 
            from Contact c where c.Id in :contactIdSet]);
        
        Map<String, Contact> contactByEmailMap = new Map<String, Contact>();
        
        // Get a map of existing email addresses
        for (Contact c : [select c.RecordTypeId, c.FirstName, c.LastName, c.Email, c.Salutation, c.Phone, c.Newsletters__c, c.MailingPostalCode 
                            from Contact c 
                            where c.Email in :contactEmailSet
                            and c.RecordTypeId in: ALLOWABLE_RECORD_TYPES
                            ]){

            contactByEmailMap.put(c.Email.toLowerCase(), c);

        }
        
        // loop thru the updated records
        for (DF_Contact__c dfc : lisDfcNew){

            contactFound = false;   
        
            // Portal_Contact is already populated
            if (dfc.Portal_Contact__c != null){
				System.debug('SECOND TIME dfc.Portal_Contact__c: ' + dfc.Portal_Contact__c);
                Contact c = contactMap.get(dfc.Portal_Contact__c);

                // Contact not found by Portal_Contact__c
                if (c != null){

                    contactFound = true;

                    if (copyData(dfc, c)) { 
                        contactsToSave.add(c);
                        dfContactIdsToUpdate.add(dfc.id);
                    }
                
                }
            
            // Portal Contact is not yet populated, so use email address
            } else {

                Contact c = contactByEmailMap.get(dfc.Email__c.toLowerCase());

                if ( c != null ) {
System.debug('THIRD TIME dfc.Portal_Contact__c: ' + dfc.Portal_Contact__c);
                    system.debug('DF Contact Trigger - Updating Contact 2 ' + contactsToSave.size() + ' //// ' + c.Email);     
                    contactFound = true;
                   
                    if ( copyData(dfc, c)) { 
                         contactsToSave.add(c);
                        System.debug('contactsToSave has Portal Contact: ' + c.Id);
                    }
                }
            }
            
            if (!contactFound){

                System.debug('Contact Trigger - create new Contact ' + dfc.Email__c);
                Contact c = createContact(dfc);
                contactsToInsert.add(c);
                dfContactIdsToUpdate.add(dfc.Id);

            }
            
        }
    
        if (contactsToSave.size() > 0){

            system.debug('DF Contact Trigger - Saving Contacts ' + contactsToSave.size());     
            update contactsToSave;
        
        }
        
        if (contactsToInsert.size() > 0){
 
            system.debug('DF Contact Trigger - Inserting Contacts ' + contactsToInsert.size());     
            insert contactsToInsert;        
        
        }

        if (dfContactIdsToUpdate.size() > 0){

            system.debug('DF Contact Trigger - Assign Portal Contacts ' + dfContactIdsToUpdate.size());     
            assignPortalContact(dfContactIdsToUpdate);
        
        }
    
    }

    private static Contact createContact(DF_Contact__c dfc) {

        RecordType dfcRT = DFC_RT_ID_MAP.get(dfc.RecordTypeId);

        // Don't instantiate the entire Commnunity to save SOQL queries
        String accountId = WEBC_CommunityWrapper.getCustomSetting('Default_Account_Id', 'DF'); 

        if ( Test.isRunningTest() ) {
            accountId = DF_DataFactory_Test.getCustomSettingTestValue('Default_Account_Id');    
        }

        Contact c = new Contact();
        c.RecordTypeId = CONTACT_RT_MAP.get(dfcRT.DeveloperName).Id;
        c.LastName = dfc.Last_Name__c;
        c.FirstName = dfc.First_Name__c;
        c.Email = dfc.Email__c;
        c.MailingPostalCode = dfc.Postcode__c;
        c.Phone = dfc.Contact_Number__c;
        
        c.Salutation = dfc.Title__c;
        c.Newsletters__c = dfc.Newsletters__c;
        c.AccountId = accountId;
        c.DF_Contact__c = dfc.id;
        
        return c;


    }


    private static boolean copyData(DF_Contact__c dfc, Contact c) {

        Boolean contactChanged = false;

        if (c.Email != dfc.Email__c){
            c.Email = dfc.Email__c;
            contactChanged = true;
        }
        if (c.LastName != dfc.Last_Name__c){
            c.LastName = dfc.Last_Name__c;
            contactChanged = true;
        }
        if (c.FirstName != dfc.First_Name__c){
            c.FirstName = dfc.First_Name__c;
            contactChanged  = true;
        }
        if (c.Salutation != dfc.Title__c){
            c.Salutation = dfc.Title__c;
            contactChanged = true;
        }
        if (c.Phone != dfc.Contact_Number__c){
            c.Phone = dfc.Contact_Number__c;
            contactChanged = true;
        }
        if (c.Newsletters__c != dfc.Newsletters__c){
            c.Newsletters__c = dfc.Newsletters__c;
            contactChanged = true;
        }
        if (c.MailingPostalCode != dfc.Postcode__c){
            c.MailingPostalCode = dfc.Postcode__c;
            contactChanged = true;
        }
        
        RecordType dfcRT = DFC_RT_ID_MAP.get(dfc.RecordTypeId);
        RecordType cRT = CONTACT_RT_ID_MAP.get(c.RecordTypeId);

        if (cRT.DeveloperName != dfcRT.DeveloperName){
            c.RecordTypeId = CONTACT_RT_MAP.get(dfcRT.DeveloperName).Id;
            contactChanged = true; 
        }
		System.debug('Was contact changed?: ' + contactChanged);
        return contactChanged;

    }



}