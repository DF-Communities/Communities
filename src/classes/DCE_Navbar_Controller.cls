public without sharing class DCE_Navbar_Controller {
    
    private string helpFileId;
    
    public string getHelpFile(){
    	
    	if(helpFileId != null){ return helpFileId; }
    	
    	/*list<Document> docs = [select id from Document where DeveloperName = 'Dementia_Connect_Portal_Guidance_pdf' limit 1];
    	
    	if(docs.size() == 1){ helpFileId = docs[0].id; }*/
    	
    	system.debug('Is the custom setting there - '+Community_Settings__c.getInstance('DCE_HelpFile'));
        
        if(Community_Settings__c.getInstance('DCE_HelpFile') == null){ return null; } 
    	
        system.debug('Here is the help file id - '+Community_Settings__c.getInstance('DCE_HelpFile').value__c);
        
		list<ContentDocument> helpFiles = [select id, LatestPublishedVersionId 
											from ContentDocument
											where Id = :Community_Settings__c.getInstance('DCE_HelpFile').value__c
											limit 1];
		
		if(helpFiles.size() == 1){ helpFileId = helpFiles[0].LatestPublishedVersionId; }
		
		
		return helpFileId;


    }
    
}