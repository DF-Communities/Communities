public without sharing class DF_WEBC_PartnerOfflineSessions_Ctr extends DF_WEBC_ControllerBase{

  public String dateVideoError { get; set; }
  public String howVideoError { get; set; }
  public String partcipantsError { get; set; }
  public String howVideoOtherError { get; set; }
  public final String ID_PARAM = 'Id';
  public boolean hasActions {get; set;} 
  public Id partnerId{get; set;}
  public Partner_Organisation__c partner {get;set;}
  public string howVideo {get;set;}
  public string howVideoOther {get;set;}
  public List<Partner_Organisation_Event__c> events {get;set;}
  public string PARTNER_OFFLINE_RT = 'Partner_Offline_Event';
  public Boolean isError ;
  public Boolean offlineRecordSaved {get;set;}
  
     public List<selectoption> getHowVideoOptions()
    {           
        list<selectoption> options = new list<selectoption>();
        options.add(new selectoption('none','--Select--'));            
        try 
        {               
                  
        Schema.DescribeFieldResult fieldResult = Partner_Organisation_Event__c.How_did_you_watch_the_videos__c.getDescribe();

        list<schema.picklistentry> values = fieldResult.getPickListValues();               
        for (Schema.PicklistEntry a : values) 
        {     
                 
        options.add(new SelectOption(a.value,a.label));
        }
       
       
                   
        }  
        catch (Exception e) 
        {             
        ApexPages.addMessages(e);           
        }
        system.debug('## Product Name Options'+ options);          
        return options; 
    }
    
  public Partner_Organisation_Event__c event {
    
  get{
    if(event ==null){
        
        event= new Partner_Organisation_Event__c();
        
    }
    return event;
    
  }
    
    
  set;
  
  }
  
  public DF_WEBC_PartnerOfflineSessions_Ctr(){
    
  
   partnerId = ApexPages.currentPage().getParameters().get('Id');
   hasActions = DFP_Utils.hasActions(partnerId);
   partner = DFP_Utils.currentOrg(partnerId); 
   event= new Partner_Organisation_Event__c();

   if(events==null && partnerId != null ){
   	events = new List<Partner_Organisation_Event__c>();
   //get existing records df offline records(10 max)
   for(Partner_Organisation_Event__c e :[select Event_Date__c,Other_please_specify__c,Participant_Count__c,How_did_you_watch_the_videos__c from Partner_Organisation_Event__c where Partner_Organisation__c=:partnerId and recordtypeId=:DF_Utils.getsObjectRecordTypeId('Partner_Organisation_Event__c',PARTNER_OFFLINE_RT) order by Event_Date__c desc limit 10]){
   	events.add(e);
   	
   
  }
  }
   //display save message on the current page
  if (ApexPages.currentPage().getParameters().get('record-saved') != null){
        
       offlineRecordSaved = true;        
     
   }
  
 }  
   
   public PageReference save() {
     
     isError = False;
     partcipantsError='';
     howVideoError ='';
     howVideoOtherError ='';
     dateVideoError ='';  
   // page validations
     if ( partner == null ){return null;}
     
     if(event.Participant_Count__c ==null){
        
        partcipantsError ='Please enter number of people watched videos';
        isError=true;
     }
     if(howVideo == 'none'){
        howVideoError= 'Please select from the list';
        isError=true;
     }
     if(howVideo.contains('Other') && howVideoOther.length()<=0 ){
        howVideoOtherError= 'Field cannot be empty';
        howVideo = this.howVideo;
        isError=true;
     }
     if(event.Offline_Event_Date__c == null){
        
        dateVideoError ='Please enter date';
        isError=true;
     }
    
     if(event.Offline_Event_Date__c > date.today()){
        
        dateVideoError ='Date cannot be in future';
        isError=true;
     }
    // if validation errors not save the records
    if(isError)    { 
        
        return null;}
    //no validation errors insert DF event RT type offline record    
    else{
      Date d = event.Offline_Event_Date__c;
      Datetime dt = datetime.newInstance(d.year(), d.month(),d.day(),3,0,0);
    	   
      event.RecordTypeId = DF_Utils.getsObjectRecordTypeId('Partner_Organisation_Event__c',PARTNER_OFFLINE_RT);
      event.How_did_you_watch_the_videos__c = howVideo;
      event.Other_please_specify__c = howVideoOther;
      event.Partner_Organisation__c =partnerId;
      event.Event_Date__c = dt;
      insert event;
            
             
     PageReference pg = new PageReference('/DF_WEBC_PartnerOfflineSessions?Id='+partnerId);
     pg.getParameters().put('record-saved','true');
     return pg;
       
    }
    }
    
    public pageReference cancel(){
    	
    return new PageReference('/partner-home?Id='+partnerId); 
    }
    
     
}