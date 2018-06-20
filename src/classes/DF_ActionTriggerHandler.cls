public class DF_ActionTriggerHandler{


  private boolean m_isExecuting = false;
  private integer BatchSize = 0;    
 
  public DF_ActionTriggerHandler(boolean isExecuting, integer size){

     m_isExecuting = isExecuting;
     BatchSize = size;

  }


  public void OnBeforeInsert(List<Action__c> newActions, Map<ID, Action__c> actionOldMap){

     limitNoOfActions(newActions,null);
  }
  
  public void OnBeforeUpdate(List<Action__c> updatedActions, Map<ID, Action__c> actionOldMap){
     
        
  }


  public void limitNoOfActions( List<Action__c> updatedActions, Map<ID, Action__c> actionOldMap){
   
   List<Action__c> listoinsert = new List<Action__c> ();
   string pValue5 =  'Carry out own action';
   
   set<Id> contactIds = new set<Id>();
   set<Id> partnerIds = new set<Id>();
   Map<String,Action__c> contactAcMap= new Map<String,Action__c>();
    
   for ( Action__c a : updatedActions){    
     
     contactIds.add(a.df_contact__c);     
     partnerIds.add(a.partner_organisation__c);
   }
   
   List< Action__c> lisactions = [select partner_organisation__c,df_contact__c,standard_actions__c,action__c,public__c,homepage__c from action__c 
   where df_contact__c in:contactids and partner_organisation__c in:partnerIds ];
   
   for(action__c ac :lisactions){
   String key;
   if( ac.DF_Contact__c !=null){
    key= ac.DF_Contact__c +'~'+ ac.Standard_Actions__c;
    }
    
    if(ac.partner_organisation__c != null){
    key= ac.partner_organisation__c +'~'+ ac.Standard_Actions__c;
    }
    contactAcMap.put(key,ac);
    
    
    system.debug('ACTION MAP'+contactAcMap);
   
   }
   
   for ( Action__c a : updatedActions){
    
    if(actionOldMap==null){ 

        if(contactAcMap.get(a.DF_Contact__c +'~'+ a.Standard_Actions__c )!=null || contactAcMap.get(a.partner_organisation__c +'~'+ a.Standard_Actions__c )!=null ){
         system.debug('action  already exist'+contactAcMap.get(a.DF_Contact__c +'~'+ a.Standard_Actions__c));
         a.addError('The standard action you have selected already exists for the contact');
        }
         
    
     }
   
 
   }
  
  }



}