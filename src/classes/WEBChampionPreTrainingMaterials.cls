/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX controller class for VF Page WEBChampionPreTrainingMaterials.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the WEBChampionPreTrainingMaterials class.
 *          Will return a list of Session Resources to the Session Resources page
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public with sharing class WEBChampionPreTrainingMaterials extends DF_WEBC_ControllerBase {
    
    public Boolean isChampion {get;set;}
    public Boolean isConverted {get; set;}
    public Boolean isChampionConverted {get; set;}
    
    
    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}

    public List<sessionResourceCategory> sessionCategories {
        get {
            if (sessionCategories == null) 
                sessionCategories = new List<sessionResourceCategory>();
            return sessionCategories;
        }
        set;
    }

    public Map<Integer, List<Session_Resource__c>> sessionResources {
        get {
            if (sessionResources == null)
                sessionResources = new Map<Integer, List<Session_Resource__c>>();

            return sessionResources;
        }
        set;
    }

    public Map<Id, Attachment> att {
        get {
            if (att == null)
                att = new Map<Id, Attachment>();
            return att;
        }
        set;
    }

  //Constructor  
    public WEBChampionPreTrainingMaterials() {
        

        isChampion = WEBController.isChampion;
        isConverted = WEBController.isChampionConverted;
        isChampionConverted = WEBController.isChampionConverted;
        
        List<Session_Category__c> sessCats = [SELECT Id, Name, Description__c FROM Session_Category__c where Type__c includes('Pre')  ORDER BY Name DESC];        

        if (sessCats != null) {
        
            Integer r = 0;
        
            for (Session_Category__c s : sessCats) {
        
                sessionResourceCategory src = new sessionResourceCategory();
                src.theId = s.Id;
                src.name = s.Name;
                src.description = s.Description__c;
                src.rowNum = r;

                sessionCategories.add(src);

                List<Session_Resource__c> resourceTemp = [SELECT Id, Name__c, Type__c, (Select Id, Name, BodyLength, ContentType From Attachments LIMIT 1) FROM Session_Resource__c WHERE Session_Resource_Category__r.Id = :s.Id and Type__c='Pre' ORDER BY Name__c];
                List<Session_Resource__c> resources = new List<Session_Resource__c>();

                // Grab the 1st (and hopefully only) attachement        
                for (Session_Resource__c sr : resourceTemp) {

                    if (sr.Attachments != null && sr.Attachments.size() > 0) {
                        att.put(sr.Id,sr.Attachments[0]);
                        resources.add(sr);
                        System.debug('*** Found Attachment - ' + sr.Attachments[0].Name);
                    }
                
                }

                sessionResources.put(r,resources);

                r += 1;
            }
        }
    }

  //Internal class representing a Session Resource Category
    public class sessionResourceCategory {
        public Id theId {get;set;}
        public String name {get;set;}
        public String description {get;set;}
        public Integer rowNum {get;set;}
    }
    
   
}