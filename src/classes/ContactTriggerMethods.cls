/*
* 2014-02-13 : SM : ContactTriggerMethods class will hold any methods that need to be called from the ContactTrigger.trigger
*/
public class ContactTriggerMethods {
    public static final String RT_DF_FRIEND = 'Dementia_Friend';
    public static final String RT_DF_CHAMPION = 'Dementia_Friend_Champion';
    public static final String RT_NEWSLETTER = 'E_Newsletter_Subscriber';
    public static final String RT_REGISTRATION = 'Registration';
    

    //This method will take all incoming contacts and either create or update a corresponding DF_Contact__c record
    public static void createDFContacts(List<Contact> inContacts){
        Map<String, RecordType> rtMap = DF_Utils.getDfcRecordTypesMap();
        Map<String, RecordType> rtMapContact = DF_Utils.getContactRecordTypesMap();
      /*  
        for (RecordType rt : [select r.Id, r.Name, r.DeveloperName from RecordType r where r.SObjectType = 'DF_Contact__c']){
            rtMap.put(rt.DeveloperName, rt);
        }
        
        for (RecordType rt : [select r.Id, r.Name, r.DeveloperName from RecordType r where r.SObjectType = 'Contact']){
            rtMapContact.put(rt.DeveloperName, rt);
        }*/
        Set<String> emailSet = new Set<String>();
        Set<String> lastNameSet = new Set<String>();
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id, User> userMap = new Map<Id, User>();
        //We need to check if any of the DF_Contact__c records exist to stop duplicate value errors in other classes
        for (Contact c : inContacts){
            contactIdSet.add(c.Id);
            emailSet.add(c.Email);
            lastNameSet.add(c.LastName);
        }
        
        for (User u : [select u.Id, u.ContactId, u.Title, u.Newsletters__c, u.Phone from User u where u.ContactId in :contactIdSet]){
            userMap.put(u.ContactId, u);
        }
        
        Map<String, DF_Contact__c> dfContactMap = new Map<String, DF_Contact__c>();
        for (DF_Contact__c dfc : [select d.Portal_Contact__c, d.Last_Name__c, d.Email__c from DF_Contact__c d where d.Last_Name__c in :lastNameSet and d.Email__c in :emailSet]){
            //dfContactMap.put(dfc.Last_Name__c + '~' + dfc.Email__c, dfc);
            dfContactMap.put(dfc.Email__c.toLowerCase(), dfc);
        }
        
        Map<Id, DF_Contact__c> dfContactsToSave = new Map<Id, DF_Contact__c>();
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (Contact c : inContacts){
            User u = userMap.get(c.Id);
            DF_Contact__c dfContact;
            //if (dfContactMap.get(c.LastName+'~'+c.Email) == null){
            if (dfContactMap.get(c.Email.toLowerCase()) == null){
                dfContact = new DF_Contact__c();
                if (c.RecordTypeId == rtMapContact.get(RT_NEWSLETTER).Id){
                    dfContact.RecordTypeId = rtMap.get(RT_NEWSLETTER).Id;
                }else if (c.RecordTypeId == rtMapContact.get(RT_REGISTRATION).Id){
                    dfContact.RecordTypeId = rtMap.get(RT_DF_FRIEND).Id;    
                }
                dfContact.Portal_Contact__c = c.Id;
                if (u != null){
                    dfContact.Title__c = (c.Title == null ? u.Title : c.Title);
                    dfContact.Contact_Number__c = (c.Phone == null ? u.Phone : c.Phone);    
                }else {
                    dfContact.Title__c = c.Title;
                    dfContact.Contact_Number__c = c.Phone;  
                }
                dfContact.First_Name__c = c.FirstName;
                dfContact.Last_Name__c = c.LastName;
                dfContact.Name = c.FirstName + ' ' + c.LastName;
                dfContact.Email__c = c.Email;
                dfContact.Newsletters__c = c.Newsletters__c;
                dfContactsToSave.put(c.Id, dfContact);  
            }else {
                dfContact = dfContactMap.get(c.Email.toLowerCase());
                if (dfContact.Portal_Contact__c == null){
                    dfContact.Portal_Contact__c = c.Id;
                    dfContactsToSave.put(c.Id, dfContact);
                }
            }
        }
        
        if (dfContactsToSave.size() > 0){
            upsert dfContactsToSave.values();
        }
        
    }
    
    /*
    //This method will take all the contacts being updated, and make sure the corresponding DF_Contact__c record is updated
    public static void updateDFContacts(List<Contact> inContacts){
        Map<String, RecordType> rtMap = new Map<String, RecordType>();
        Map<String, RecordType> rtMapContact = new Map<String, RecordType>();
        
        for (RecordType rt : [select r.Id, r.Name, r.DeveloperName from RecordType r where r.SObjectType = 'DF_Contact__c']){
            rtMap.put(rt.DeveloperName, rt);
        }
        
        for (RecordType rt : [select r.Id, r.Name, r.DeveloperName from RecordType r where r.SObjectType = 'Contact']){
            rtMapContact.put(rt.DeveloperName, rt);
        }
        List<DF_Contact__c> dfContactsToInsert = new List<DF_Contact__c>();
        List<DF_Contact__c> dfContactsToUpdate = new List<DF_Contact__c>();
        Set<Id> contactIds = new Set<Id>();
        Map<Id, DF_Contact__c> dfContactMap = new Map<Id, DF_Contact__c>();
        for (Contact c : inContacts){
            contactIds.add(c.Id);
        }
        
        for (DF_Contact__c dfc : [select d.First_Name__c, d.Last_Name__c, d.Email__c, d.Portal_Contact__c, Newsletters__c from DF_Contact__c d where d.Portal_Contact__c in :contactIds]){
            dfContactMap.put(dfc.Portal_Contact__c, dfc);
        }
        
        for (Contact c : inContacts){
            DF_Contact__c dfContact = dfContactMap.get(c.Id);
            if (dfContact != null){
                if (c.FirstName != dfContact.First_Name__c) dfContact.First_Name__c = c.FirstName;
                if (c.LastName != dfContact.Last_Name__c) dfContact.Last_Name__c = c.LastName;
                if (c.Email != dfContact.Email__c) dfContact.Email__c = c.Email;
                if (c.Newsletters__c != dfContact.Newsletters__c) dfContact.Newsletters__c = c.Newsletters__c;  
                dfContactsToUpdate.add(dfContact);
            }else {
                dfContact = new DF_Contact__c();
                if (c.RecordTypeId == rtMapContact.get(RT_NEWSLETTER).Id){
                    dfContact.RecordTypeId = rtMap.get(RT_NEWSLETTER).Id;
                }else if (c.RecordTypeId == rtMapContact.get(RT_REGISTRATION).Id){
                    dfContact.RecordTypeId = rtMap.get(RT_REGISTRATION).Id; 
                }
                dfContact.Portal_Contact__c = c.Id;
                dfContact.First_Name__c = c.FirstName;
                dfContact.Last_Name__c = c.LastName;
                dfContact.Name = c.FirstName + ' ' + c.LastName;
                dfContact.Email__c = c.Email;
                dfContact.Newsletters__c = c.Newsletters__c;
                dfContactsToInsert.add(dfContact);
            }

        }
        
        if (dfContactsToInsert.size() > 0){
            insert dfContactsToInsert;
        }
        if (dfContactsToUpdate.size() > 0){
            update dfContactsToUpdate;
        }
    }
    */

}