public without sharing class DF_WEBC_PartnerActions_Controller extends DF_WEBC_ControllerBase {
  
    public Boolean isChampion {get;set;}
    public final String ID_PARAM = 'Id';  
    public Id partnerId{get; set;}  
    public String oldAction ;   
    public Boolean partnerhasActions {get;set;}
    public Action__c act {get; set;}
    public String action5 {get;set;}
    List<Action__c> lisAct{get;set;}
    List<Action__c> lisActDelete{get;set;}
    List<Action__c> lisActUpsert{get;set;}
    Map <String,Action__c> actionMap ; 
    Map <String,String> selectedActions ;    
    public List<string> Actionname{get;set;}
    public string pOption1 =  'Sign up to a Local Dementia Action Alliance';
    public string pOption2 =  'Explore in depth dementia training for staff';
    public string pOption3 =  'Send the Dementia Friendly Employers Guide to my HR team';
    public string pOption4 =  'Fundraise for Alzheimer’s Society';
    public string pOption5 =  'Carry out own action';
    public string pValue1 =  'Join our local Dementia Action Alliance';
    public string pValue2 =  'Explore Alzheimer’s Society in-house training packages for our staff';
    public string pValue3 =  'Improve our HR processes by implementing recommendations in the Guide for Employers';
    public string pValue4 =  'Fundraise for Alzheimer’s Society and support the fight against dementia';
   
    public List<string> standardActions = new List<string> {pOption1,pOption2,pOption3,pOption4,pOption5 };
    public static final String DFACTION_RT = 'Partner_Action';
    
     
    

    public PageReference cancel() {
        return new PageReference('/partner-home?Id='+partnerId);
    }
    
    public List<selectoption> getActionNames()
    {           
        list<selectoption> options = new list<selectoption>();            
        try 
        {               
                  
        Schema.DescribeFieldResult fieldResult = Action__c.Standard_Actions__c.getDescribe();

        list<schema.picklistentry> values = fieldResult.getPickListValues();               
        for (Schema.PicklistEntry a : values) 
        {     
        if(a.getValue() == pOption1){             
        options.add(new SelectOption(a.getlabel(),pValue1));
        }
        if(a.getValue() == pOption2){             
        options.add(new SelectOption(a.getLabel(),pValue2));
        }
        if(a.getValue() == pOption3){             
        options.add(new SelectOption(a.getLabel(),pValue3));
        }
        if(a.getValue() == pOption4){             
        options.add(new SelectOption(a.getLabel(),pValue4));
        }
       
        }           
        }  
        catch (Exception e) 
        {             
        ApexPages.addMessages(e);           
        }
        system.debug('## Product Name Options'+ options);          
        return options; 
    }

   public PageReference save() {
   
   lisActUpsert=new List<Action__c>();
   lisActDelete=new List<Action__c>();
   selectedActions = new Map<String,String>();
   system.debug('captured check box'+actionname);
   system.debug('ACTION MAP'+actionMap);
   system.debug('friendActRT RECORDTYPE '+ DF_Utils.getsObjectRecordTypeId('Action__c',DFACTION_RT));
      
  for(string s : actionname){
      selectedActions.put(s,s);
    
    if(actionMap.get(s) == null ){
          
             //insert standard actions
            act = new Action__c(Partner_Organisation__c = partnerId,Standard_Actions__c = s,RecordTypeId = DF_Utils.getsObjectRecordTypeId('Action__c',DFACTION_RT));   
            lisActUpsert.add(act);         
            
       }
     
     }
    
    for( Action__c  a:  lisAct ){
    //delete actions other than personal action
    if( selectedActions.get(a.Standard_Actions__c)==null && a.Standard_Actions__c!=pOption5){
    
    lisActDelete.add(a);
    
    
    } 
    //delete personal action
    if(a.action__c !=null  && action5==''){
    
    lisActDelete.add(a);
    }
    //update personal action
   if(a.action__c !=null  && action5!=a.action__c  && action5.length()>0 ){
    a.Action__c = action5;
  
   
     update a;
    }
    
  }
     //insert personal action 
    if(action5.length()>0 && actionMap.get(pOption5)==null){
      system.debug('update pOption5');
       act = new Action__c(Partner_Organisation__c = partnerId,Standard_Actions__c = pOption5,Action__c = action5,RecordTypeId = DF_Utils.getsObjectRecordTypeId('Action__c',DFACTION_RT));   
            lisActUpsert.add(act); 
        
         }  
       
      
   try{    
        insert lisActUpsert ;
         
       }catch(exception e){
        
       } 
        delete lisActDelete; 
        
        PageReference pg = new PageReference('/partner-home?Id='+partnerId);
        pg.getParameters().put('record-saved','true');
        return pg;
    }
   
 public DF_WEBC_PartnerActions_Controller() {
   
   partnerId = ApexPages.currentPage().getParameters().get(ID_PARAM);
   system.debug('ACTION 5 '+ ACTION5);
   Actionname =new List<String>();
   isChampion = DF_Utils.isChampion(currentDfc);
   system.debug('ID RETURN' +ApexPages.currentPage().getParameters().get(ID_PARAM));
       
       
  // if (currentdfc != null){    
     lisAct = [select Public__c,Standard_Actions__c,DF_Contact__c, Action__c  from Action__c  where Partner_Organisation__c =:ApexPages.currentPage().getParameters().get(ID_PARAM) LIMIT 5];
     actionMap = new Map <String,Action__c> ();
     
     for(Action__c  a : lisAct){
      actionMap.put(a.Standard_Actions__c,a);
      
      for (String s:standardActions){  
       
        if(a.Standard_Actions__c==s && a.Action__c==null){
             
             Actionname.add(s);
             partnerhasActions = true;
            SYSTEM.DEBUG('STANDARD ACTION'+Actionname );
           }
              
        if(a.Standard_Actions__c==s && a.Action__c!=null){  
            
            Actionname.add(s);
            action5 = a.Action__c;
            a.Standard_Actions__c=pOption5;
            oldAction=a.Action__c;
            partnerhasActions = true;
         }  
            
      }
    }
  //}
 } 

}