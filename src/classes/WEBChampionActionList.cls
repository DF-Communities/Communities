/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBChampionActionList.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class loads Page Content, Snippets and Sections for Website content.
 *               
 *  Modification History
 *  Date            Who         Description 
                   
*******************************************************************************************/
public without sharing class WEBChampionActionList extends DF_WEBC_ControllerBase {
    
    public Boolean isChampion {get;set;}
    public Boolean isChampionConverted {get;set;}
    
    
    public List<Action__c> actions {
        get {
            if (actions == null)
                actions = new List<Action__c>();
            return actions;
        }
        set;
    }

    public User thisUser {
        get {
            return WEBController.thisUser;
        }
        set;
    }

    public Page_Snippet__c totalFriendsSnippet {
        get {
            if (totalFriendsSnippet == null){
                totalFriendsSnippet = [select p.Body_Text__c, p.Unique_Name__c from Page_Snippet__c p where p.Unique_Name__c = 'DementiaFriendsTotalSnippet' LIMIT 1];
            }
            return totalFriendsSnippet;
        }
        set ;
    }

    //Constructor
    public WEBChampionActionList() {

        isChampion = WEBConversionClass.isChampion(thisUser.contactId);
        isChampionConverted = WEBConversionClass.isChampionConverted(thisUser.contactId);
        List<Action__c> allactionslis = new List<Action__c>();
        
        
        List<DF_Event__c> events = [SELECT Id FROM DF_Event__c WHERE Session_Organiser__r.Portal_Contact__r.Id = :WEBController.thisUser.ContactId LIMIT 1000];

        List<DF_EventAttendee__c> myEventContacts = [SELECT DF_Contact__r.Id FROM DF_EventAttendee__c WHERE DF_Event__c = :events LIMIT 1000];

        List<Id> myEventContactsId = new List<Id>();
        
        if (myEventContacts != null && !myEventContacts.isEmpty()) {
        
            for (DF_EventAttendee__c att : myEventContacts) {
                myEventContactsId.add(att.DF_Contact__r.Id);
            }

            allactionslis = [SELECT DF_Contact__r.Name, DF_Contact__r.Id, Id, Action__c, Public__c, Homepage__c FROM Action__c WHERE DF_Contact__r.Id = :myEventContactsId LIMIT 20];
       
           Set<String> sNames = New Set<String>();
           for(Action__c  a :allactionslis){
           
           if (sNames.Contains(a.DF_Contact__r.Id) == FALSE){
           
           sNames.add(a.DF_Contact__r.Id);

              actions.add(a);

           
           }

           
           
           }
        
        }
    }
}