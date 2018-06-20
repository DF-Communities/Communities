public without sharing class Dfc_PublicResources  {
  

    // Constructor
    public Dfc_PublicResources() {


        List<DFC_Resource__c> resourcesList = 

        [SELECT Id, 
             (Select Id, Name, BodyLength, ContentType From Attachments LIMIT 1) 
         FROM DFC_Resource__c where Display_on_home_page__c = true ORDER BY Sequence__c];

              //  system.debug('>>>>  Number of DFC Resources'+ resources.size());

                Integer r = 0;
                    
                for (DFC_Resource__c resource : resourcesList) {

                    // Get the 1st attachement  
                    if (resource.Attachments != null && resource.Attachments.size() > 0) {

                        // Add File Attachment to  - attachments map
                        attachmentsMap.put(resource.Id, resource.Attachments[0]);

                        
                        attachmentTypesMap.put(resource.Id, resource.Attachments[0].ContentType);
                         
                       // System.debug('*** Found Attachment - ' + resource.Attachments[0].Name);
                    }

                     r += 1;
                }
        }            


    public List<DFC_Resource__c> resources {
        get {
            if (resources == null)
                resources = new List<DFC_Resource__c>();

                resources =   [SELECT Id, Title__c,  Description__c FROM DFC_Resource__c where Display_on_home_page__c = true ORDER BY Sequence__c];
            return resources;
        }
        set;
    }

    // Key-Value Map of File Attachments
    public Map<Id, Attachment> attachmentsMap {
        get {
            if (attachmentsMap  == null)
                attachmentsMap  = new Map<Id, Attachment>();
            return attachmentsMap ;
        }
        set;
    }

        // Key-Value Map of File Attachment Content Type
    public Map<Id, String> attachmentTypesMap {
        get {
            if (attachmentTypesMap  == null)
                attachmentTypesMap  = new Map<Id, String>();
            return attachmentTypesMap ;
        }
        set;
    }
}