public without sharing class DF_WEBC_InboundChangesToDFCController extends DF_WEBC_ControllerBase {
   
    public Boolean isChampion {get;set;}
    public DF_Contact__c master{get;set;}
    public DF_Contact_Inbound_Change__c child{
     get{
        if( child==null)
        child = new DF_Contact_Inbound_Change__c();      
        return child;
    
        }  
     set;
    }
   
    
    public DF_WEBC_InboundChangesToDFCController(){
        master =  new DF_Contact__c();
        currentDfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());            
        dfcW = new DF_Contact_Wrapper(currentDfc);
        isChampion = DF_Utils.isChampion(currentDfc);  
            
        
        child = [Select Name,First_Name__c,Last_Name__c ,Postcode__c,City__c ,Street__c,
               County__c,Birthdate__c,Title__c,Contact_Number__c 
               from DF_Contact_Inbound_Change__c
               where Related_DF_Contact__c =:currentdfc.id limit 1];
               system.debug('child record'+child);
        master = [Select Name,First_Name__c,Last_Name__c ,Postcode__c,City__c ,Street__c,
               County__c,Birthdate__c,Title__c,Contact_Number__c 
               from DF_Contact__c
               where id =:currentdfc.id limit 1];
               
       
    }
    
    
    
    
    public pageReference autoRunCopyChanges(){
        
    pageReference pr;
    Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
     Map<String, Schema.SObjectField> tFields = schemaMap.get('DF_Contact__c').getDescribe().fields.getMap();
     Map<String, Schema.SObjectField> sFields = schemaMap.get('DF_Contact_Inbound_Change__c').getDescribe().fields.getMap();
     DF_Contact__c obTarget = master;     

    DF_Contact_Inbound_Change__c obSource = ( DF_Contact_Inbound_Change__c )DF_Utils.objectWithAllFields('id',child.id, Schema.sObjectType.DF_Contact_Inbound_Change__c );
  // for (String fieldName: cFields.keySet()) {
    for (Schema.SObjectField f : tFields.values()) {

        Schema.DescribeFieldResult fd = f.getDescribe(); 
         if ( !fd.isUpdateable() ) continue;
        if ( sFields.get(fd.getName())==null ) continue;
        if ( fd.getName()== 'ownerid' ) continue;
        if ( fd.getName()=='RecordTypeId' ) continue;
        if ( fd.getName()=='Name' ) continue;
        if (obSource.get(fd.getName())==null) continue;
        obTarget.put(f,obSource.get(fd.getName()));
   
      }
      update obTarget;
   
        delete child;
        pr = page.DF_WEBC_ViewMyDetails;
        return pr;
    }
    
    public DF_Contact__c getDFContactDetails(String Id){
        return [Select Name,First_Name__c,Last_Name__c ,Postcode__c,City__c ,Street__c,
               County__c,Birthdate__c,Title__c,Contact_Number__c from DF_Contact__c
               where Id =:Id];
        
    }
    
    public pagereference reject(){
        try{
        delete child;
        }catch (Exception e){}
        
        return new PageReference('/user-home');
        
    }
    
    
    
}