/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX controller class for VF Page DF_WEBC_PartnerResourses.
 *  Author  : Lakshmi Vasudevan
 *  Date    : 05-2016
 *  Version : 1.0
 *
 *  Description:    Apex Class controller for the DF_WEBC_PartnerResources_Ctr class.
 *                  Will return a list of Session Resources to the Session Resources page
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
public with sharing class DF_WEBC_PartnerResources_Ctr extends DF_WEBC_ControllerBase {
    
    public final String ID_PARAM = 'Id';
    public Boolean isChampion {get;set;}
    public Boolean isConverted {get; set;}
    public Boolean isChampionConverted {get; set;}
    public Id partnerId{get; set;}
    public boolean hasActions {get; set;}
    public Partner_Organisation__c partner {get;set;}
    public String messageArea {get;set;}
    public String messageAreaClass {get;set;}

    public string sector {get;set;}
       
    public List<Partner_Organisation_Resources__c> partnerResources {
        get {
            if (partnerResources == null)
                partnerResources = new  List<Partner_Organisation_Resources__c>();

            return partnerResources;
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
    public DF_WEBC_PartnerResources_Ctr() {
        

        isChampion = WEBController.isChampion;
        isConverted = WEBController.isChampionConverted;
        isChampionConverted = WEBController.isChampionConverted;
        partnerId = ApexPages.currentPage().getParameters().get(ID_PARAM);
        partner = DFP_Utils.currentOrg(partnerId); 
        hasActions = DFP_Utils.hasActions(partnerId);       
        sector = partner.Sector__c;
        if (sector != null) {
        
            Integer r = 0;
        //select all session resources where category match to selected org sector 
                List<Partner_Organisation_Resources__c> resourceTemp = [SELECT Id,Name, Name__c,date_added__c,(Select Id, Name, BodyLength, ContentType From Attachments LIMIT 1) FROM Partner_Organisation_Resources__c WHERE Category__c = :sector  ORDER BY Name__c];
                List<Partner_Organisation_Resources__c> resources = new List<Partner_Organisation_Resources__c>();

                // Grab the 1st (and hopefully only) attachement        
                for (Partner_Organisation_Resources__c sr : resourceTemp) {

                    if (sr.Attachments != null && sr.Attachments.size() > 0) {
                        att.put(sr.Id,sr.Attachments[0]);
                        partnerResources.add(sr);
                        System.debug('*** Found Attachment - ' + sr.Attachments[0].Name);
                    }
                
                }

        }
    }     


       
}