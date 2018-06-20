public without sharing class DemographicInfoTriggerHandler {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the Demographic_Information__c Trigger.
 *  Author  : Lakshmi Vasudevan
 *  Date    : 07-03-2016
 *  Version : 0.1 Unit Test
 *
 *  Description:    Apex Class prevents duplicate Demographic Info records being added to the 
 *                  Contact Record. 
 *               
 *  Modification History
 *  Date            Who         Description 
 *                                         
*******************************************************************************************/

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public DemographicInfoTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    

    public void OnBeforeInsert(Demographic_Information__c[] demoInfo, Map<ID, Demographic_Information__c> demoInfoMap){
        System.debug('****** DemographicInfoTriggerHandler.OnBeforeInsert  ******');

      
        Map<String, Demographic_Information__c> mapDemoInfo = new Map<String, Demographic_Information__c>();

        for(Demographic_Information__c d : demoInfo){
            if(d != null){
             //   demoInfoIds.add(d.Id);
                
                if(d.Contact__c != null){
                    mapDemoInfo.put(d.Contact__c,d);
                }
            }
        }
      
        
        if(mapDemoInfo != null && !mapDemoInfo.isEmpty()){
            for(Demographic_Information__c di : [SELECT Id, Contact__c FROM Demographic_Information__c WHERE Contact__c IN : mapDemoInfo.KeySet()]){
                if(di != null){
                    Demographic_Information__c newDemoInfo = mapDemoInfo.get(di.Contact__c);
                    newDemoInfo.Contact__c.addError('A Demographic Information record for this Person already exists!');                                      
                }               
            }           
        }
    }

   public void OnAfterInsert(Demographic_Information__c[] demoInfo, Map<ID, Demographic_Information__c> demoInfoMap){
   
   
   Map< string,Demographic_Information__c> mapDemo = new Map< string,Demographic_Information__c>();
   List<Contact> liscon  = new List<Contact>();
   List<Contact> liscontoupdate  = new List<Contact>();
   
     for(Demographic_Information__c d : demoInfo){
       
       mapDemo.put( d.contact__c,d );
     
      } 
      
      liscon = [select id,Demographic_record__c from contact where id in: mapDemo.keyset()];
     
     for( Contact c : liscon ){
       
       c.Demographic_record__c = mapDemo.get(c.id).id;
       liscontoupdate.add(c);
     
      }
      
      update liscontoupdate;
 
  }

}