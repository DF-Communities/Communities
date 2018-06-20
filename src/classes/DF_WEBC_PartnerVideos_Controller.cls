global without sharing class DF_WEBC_PartnerVideos_Controller {
    
    public Partner_Organisation__c partner {get;set;}
    public Partner_Organisation_Event__c event {get;set;}
    public String code {get;set;}
    
    public string PARTNER_ONLINE_RT = 'Partner_Online_Event';
    public final String ID_PARAM = 'Id';
    public string orgId {get;set;}
    public DF_WEBC_PartnerVideos_Controller() {
        
        partner = new Partner_Organisation__c();
        event = new Partner_Organisation_Event__c();
        

    }
  
  
  @RemoteAction
   global static boolean isPartnerFound(string pcode){
  	
  	if(pcode == '' || pcode==null){
  		return false;
  	}
  	
  	 List <Partner_Organisation__c> partners = [select id, name from Partner_Organisation__c where DFC_Code__c =:pcode];
  	
  	return !partners.isEmpty();
   }
 
    public void init() {

        system.debug('Videos : Init ' + code);
         system.debug('Videos : Init ' + code);
         List<Partner_Organisation__c> partners;
       if(orgId !=null && code == null){

        partners = [select id,DFC_Code__c, name from Partner_Organisation__c where id =:orgId];
        
        code = partners[0].DFC_Code__c;
        }
        
       
       else{
        partners = [select id, name from Partner_Organisation__c where DFC_Code__c =:code];
               	
       }
        if ( partners.isEmpty() ) {

             system.debug('Videos : Partner not found');    
             return;
        }

        partner = partners[0];
        event.Partner_Organisation__c = partner.id;
        event.Event_Date__c = System.now();
        event.RecordTypeId = DF_Utils.getsObjectRecordTypeId('Partner_Organisation_Event__c',PARTNER_ONLINE_RT);
        insert event;

        system.debug('Videos : Partner Inserted ' + event.id);

    }

}