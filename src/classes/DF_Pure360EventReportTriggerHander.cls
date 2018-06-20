public class DF_Pure360EventReportTriggerHander{
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class contains the execution logic of the DF_Pure360EventReportTrigger .
 *  Author  : Lakshmi Vasudevan
 *  Date    : 27-10-2016
 *  Version : 0.1 Unit Test
 *               
 *  Modification History
 *  Date            Who         Description 
 *                           
*******************************************************************************************/

private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public DF_Pure360EventReportTriggerHander(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
  
  
  
  public void OnBeforeInsert(Pure360_Event_Report__c[] eventReportLis, Map<ID, Pure360_Event_Report__c> eventReportMap){
    
    Set<String> emailSet = new Set<String>();
    Set<Id> dfcIds= new Set<Id>();
    Map<String,String> dfcEmailMap = new Map<String,String>();
    List<Pure360_Event_Report__c> eventReportsToUpdate = new List<Pure360_Event_Report__c>();
    List<DF_Contact__c> dfcToUpdate = new List<DF_Contact__c>();
    
    for(Pure360_Event_Report__c event :eventReportLis)
    {
      if(event.email__c !=null){
         
         emailSet.add(event.email__c);
       }
     
    }
    
    for(DF_contact__c dfc: [select Id,email__c from DF_Contact__c where email__c in : emailSet])
    {
    
       dfcEmailMap.put(dfc.email__c,dfc.Id);
    
    }
    
    for(Pure360_Event_Report__c ev :eventReportLis)
    {
      if(dfcEmailMap.get(ev.email__c)!=null){
      ev.DF_Contact__c = dfcEmailMap.get(ev.email__c);
      eventReportsToUpdate.add(ev);
      
       if(ev.Type__c =='OPTOUT'){
        dfcIds.add(dfcEmailMap.get(ev.email__c));
       }
      }
         
    }
    
    if(dfcIds.size()>0){
     for(DF_Contact__c dfc :[select Newsletters__c from DF_Contact__c where id in:dfcIds])
     {
     
       dfc.Newsletters__c = False;
       dfcToUpdate.add(dfc);
     }
     
    }
    
    update dfcToUpdate;
   // update eventReportsToUpdate;
  }
 

}