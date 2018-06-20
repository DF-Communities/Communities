/******************************************************************************************
 *    
 *  Purpose : APEX controller class for VF Page DF_WEBC_NewsletterArchives.
 *  Author  : CSL
 *  Date    : 22-03-2016
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the DF_WEBC_NewsletterArchives page.
 *                  Will return a list of Newsletter rchives to the Newsletter archives page
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public with sharing class DF_WEBC_NewsletterArchivesController extends DF_WEBC_ControllerBase {
	
	
	public Boolean isFriend {get;set;}
    public Boolean isChampion {get;set;}
    public Boolean isChampionConverted {get; set;}
    public Boolean isChampionRetired { get; set; }
    public Boolean isChampionProspective { get; set; }
    public Boolean isChampionDeclined { get; set; }
    public Boolean isChampionSuspended { get; set; }
    public Boolean isChampionHiatus { get; set; }   
    public Boolean isRestricted  {get;set;}
    public String Champions_Newsletters ='Champions Newsletters';
 	public String Friends_Newsletters ='Dementia Friends Newsletters';
 	
    public List<newsletterArchiveCategory> newsletterCategories {
        get {
            if (newsletterCategories == null) 
                newsletterCategories = new List<newsletterArchiveCategory>();
            return newsletterCategories;
        }
        set;
    }

    public Map<Integer, List< Newsletter_Archive__c>> newsletterArchives {
        get {
            if (newsletterArchives == null)
                newsletterArchives = new Map<Integer, List<Newsletter_Archive__c>>();

            return newsletterArchives;
        }
        set;
    }

    // Map of File Attachments
    public Map<Id, Attachment> att {
        get {
            if (att == null)
                att = new Map<Id, Attachment>();
            return att;
        }
        set;
    }

    //Constructor   
    public DF_WEBC_NewsletterArchivesController() {
        

        
        List<Newsletter_Archive_Category__c> newsCats;
        set<string> categoryType = new set<string>();
        isChampion =  DF_Utils.isChampion(currentDfc);
        isFriend = DF_Utils.isFriend(currentDfc);
        isChampionProspective = DF_Utils.isChampionProspective (currentDfc);
        isChampionConverted = DF_Utils.isChampionConverted(currentDfc);
        isChampionRetired  =DF_Utils.isChampionRetired(currentDfc);
        isChampionDeclined = DF_Utils.isChampionDeclined(currentDfc);
        isChampionSuspended =DF_Utils.isChampionSuspended(currentDfc);
        isChampionHiatus =DF_Utils.isChampionHiatus(currentDfc);
        isRestricted = ((isFriend || isChampionProspective || isChampionRetired ||isChampionDeclined ||isChampionSuspended|| isChampionHiatus )? True:False);
        //every DF can see friends newsletters
        categoryType.add(Friends_Newsletters);
        //Champions without a restricted status can see champions newsletter
        categoryType.add(!isRestricted ?Champions_Newsletters: '');
       
        
        if(categoryType!=null){
       
       
        newsCats = [SELECT Id, Name, Description__c FROM Newsletter_Archive_Category__c where Type__c in:categoryType];        
      
        	system.debug( 'newsCats '+ newsCats);
        	
        if (newsCats != null) {
        
        
        
            Integer r = 0;
        
            for (Newsletter_Archive_Category__c s : newsCats) {
        
                newsletterArchiveCategory nac = new newsletterArchiveCategory();
                nac.theId = s.Id;
                nac.name = s.Name;
                nac.description = s.Description__c;
                nac.rowNum = r;

                newsletterCategories.add(nac);

                List<Newsletter_Archive__c> newsletterTemp = [SELECT Id, Name__c, (Select Id, Name, BodyLength, ContentType From Attachments LIMIT 1) FROM Newsletter_Archive__c WHERE Newsletter_Archive_Category__r.Id = :s.Id ORDER BY Name__c];
                List<Newsletter_Archive__c> newsletters = new List<Newsletter_Archive__c>();

                // Grab the 1st (and hopefully only) attachement        
                for (Newsletter_Archive__c na : newsletterTemp) {

                    if (na.Attachments != null && na.Attachments.size() > 0) {
                        att.put(na.Id,na.Attachments[0]);
                        newsletters.add(na);
                        System.debug('*** Found Attachment - ' + na.Attachments[0].Name);
                    }
                
                }

                newsletterArchives.put(r,newsletters);

                r += 1;
            }
        }
    }
    
    }

    //Internal class representing a Session Resource Category
    public class newsletterArchiveCategory  {
        public Id theId {get;set;}
        public String name {get;set;}
        public String description {get;set;}
        public Integer rowNum {get;set;}
    }
    
   
}