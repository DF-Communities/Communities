public class DF_Pack_RequestTriggerHandler{


    private boolean m_isExecuting = false;
    private integer BatchSize = 0;    
    private Map<String, String> mapRegionPostcodes;
    private String RT_Champion;
 
  public DF_Pack_RequestTriggerHandler(boolean isExecuting, integer size){

        m_isExecuting = isExecuting;
        BatchSize = size;

  }


  public void OnBeforeInsert(List<DF_Pack_Request__c> dfPackRequests, Map<ID, DF_Pack_Request__c> DFPackRequestMap){

  UpdateAddressInfo(dfPackRequests,DFPackRequestMap);
    
  }
  
  public void OnBeforeUpdate(List<DF_Pack_Request__c> dfPackRequests, Map<ID, DF_Pack_Request__c> DFPackRequestMap){

 
    
  }


  public void UpdateAddressInfo( List<DF_Pack_Request__c> dfPackRequests, Map<ID, DF_Pack_Request__c> DFPackRequestMap){
   
   List<DF_Pack_Request__c> lisPackRequests = new List<DF_Pack_Request__c> ();
   
   Set<Id>  contactIds  = new Set<Id> ();
   for ( DF_Pack_Request__c pack : dfPackRequests ){
     contactIds.add(pack.DF_Contact__c);
    
   }
   
 List< DF_Contact__c> lisDFContact = [Select Id,City__c,Street__c,PostCode__c,County__c,Country__c from DF_Contact__c where Id in:contactIds];
   
   for ( DF_Pack_Request__c pack : dfPackRequests ){
   
    for(DF_Contact__c con :lisDFContact){
   
          pack.City__c = con.City__c;
          pack.Street__c = con.Street__c;
          pack.PostCode__c = con.PostCode__c;
          pack.County__c = con.County__c;
          pack.Country__c = con.Country__c;
    
       lisPackRequests.add(pack);
    
   }
   
   }
   
}



}