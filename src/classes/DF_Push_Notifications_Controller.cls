public class DF_Push_Notifications_Controller{

 
  transient private String soql {get;set;}
  
  public List<String> type_selection {get;set;}
  public List<String> interests_selection {get;set;}
  public Date champtraining {get;set;}
  public Date champtraining2 {get;set;}
  public Date latestsession {get;set;}
  public Date latestsession2 {get;set;}
  public string newsletter {get;set;}
  public string region_selection {get;set;}
  public string totalfriendsmin {get;set;}
  public string totalfriendsmax {get;set;}
  public string totalsessionsmin {get;set;}
  public string totalsessionsmax {get;set;}
  public string totalincompletesessionsmin {get;set;}
  public string totalincompletesessionsmax {get;set;}
  public string postcodeout {get;set;}
  public Id rt = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
  public String STATUS_CONVERTED = DF_Utils.STATUS_CONVERTED;
  public List<DF_Contact__c> searchResults {get;set;}
  public Integer resultCount = 0;
  public List<DFCWrapper> DFCWrappersList {get;set;}
  public Map<Id,DF_Contact__c> selectedDFCs{get;set;}
  public string pushMessage {get;set;}
  public string title {get;set;}
  public string btnTitle {get;set;}
  public string btnLink {get;set;}
  public Push_Notifications__c  pn{get;set;}
  public List<Push_Notifications__c>  lispn{get;set;}  
  public string emailaddress {get;set;}
  public integer minfr;
  public integer maxfr;
   public integer minsessions;
  public integer maxsessions;
   public integer minincomplete;
  public integer maxincomplete;
  public Integer noOfRecords {get;set;}
  public Boolean sValue ;

  
  public  DF_Push_Notifications_Controller(){
    interests_selection = new List<String>();
    type_selection = new List<String>();
    

  }
 
  /* Type */
  public List<SelectOption> getTypeOptions() {
    
    Schema.DescribeFieldResult field = DF_Contact__c.Type_Of_Champion__c.getDescribe();
      return DF_Utils.getOptions(field);
       
  }

  public List<SelectOption> getInterestsOptions() {
    
    Schema.DescribeFieldResult field = DF_Contact__c.Interests__c.getDescribe();
     return DF_Utils.getOptions(field);
  }


  /* Region*/
public List<SelectOption> getRegionOptions() {
    list<selectoption> options = new list<selectoption>();
    options.add(new selectoption('none','--Select--')); 
      for(DF_Region__c a:[select name,Id from DF_Region__c] ){
        
                 
        options.add(new SelectOption(a.Id,a.Name));
    }  
       return options;
  }

    /** The current sort direction. Defaults to desc as most people want to see the new ones first */
  public String sortDir {
    get  { 
        if (sortDir == null) {  
            sortDir = 'asc'; 
        } 
        return sortDir;  
        }
    set;
  }
 

 /** Toggles the sorting of query from asc<-->desc */
  public void toggleSort() {

    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';        
    runQuery();     // Run the query again

  }


  public Integer recordsPerPage {
        get {
            if (recordsPerPage == null)
                recordsPerPage = 1000;
            return recordsPerPage;
        }
        set;
    }
    public Integer startRecord {
        get {
            if (startRecord == null)
                startRecord = 0;
            return startRecord;
        }
        set;
    }
    public void nextPage() {
        startRecord += recordsPerPage;
        if (startRecord > noOfRecords)
            startRecord = startRecord - recordsPerPage;

  }
    public void previousPage() {
        startRecord = startRecord - recordsPerPage;
        if (startRecord < 0)
            startRecord = 0;
       
    }  
    public void changeRecordsPerPage() {
        startRecord = 0;
  
    }


   /** Init the controller and display some sample data when the page loads */
  public void init() {
    
    
    searchResults=new List<DF_Contact__c>();
    DFCWrappersList = new List<DFCWrapper>();
    selectedDFCs = new Map<Id,DF_Contact__c>();
    region_selection ='';
    emailaddress='';
    totalfriendsmax ='';
    totalfriendsmin = '';
    totalsessionsmin = '';
    totalsessionsmax = '';
    interests_selection = new List<String>();
    type_selection = new List<String>();
     newsletter ='';
     postcodeout ='';
     totalincompletesessionsmin = '';
     totalincompletesessionsmax='';
     runQuery();
  }
  /** The current field to sort by. Defaults to name */
  public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
  }
 /** Run the query */
  public void runQuery() {

    noOfRecords=0;
    generateQueryString();
    
    searchResults=new List<DF_Contact__c>();
    DFCWrappersList = new List<DFCWrapper>();
    try {
        
        searchResults = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' LIMIT ' + recordsPerPage + ' OFFSET ' + startRecord);   
        noOfRecords=searchResults.size();
        system.debug('No of records@@'+noOfRecords);
        if( searchResults.size()>0){
         
        for (DF_Contact__c dfc: searchResults){
         
            DFCWrappersList.add(new DFCWrapper(dfc));

             system.debug('DFCWrappersList@@'+DFCWrappersList.size());
         }
         
       }
    
        
       
    } catch (Exception e) {

      String sMsg = e.getMessage();  
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, sMsg ));
      resultCount=0;
    
    }

    
  }

   public PageReference processSelected(){     
        
        if(selectedDFCs==null){
           selectedDFCs = new Map<Id,DF_Contact__c>();
          }
          
          
        for(DFCWrapper dfw : DFCWrappersList) {
            if(dfw.selectedDFC == true){
                selectedDFCs.put(dfw.dfc.Id,dfw.dfc);
               
            }
            else{
              selectedDFCs.remove(dfw.dfc.Id);
             
            }
            
        }  
           
        return null;
   }
  
 public PageReference runSearch() {
    
    //Map of PageParameters 
    Map<string,string> pageParams=ApexPages.currentPage().getParameters(); 
    
    // Run the query again
    runQuery();
    system.debug('soql search@'+soql);
    return null;
  }
  

  /** Generate the soql query string */ 
  public void generateQueryString()
  {
   
    
   soql = 'select Id, ' +
                'Name, ' +
                'Status__c,' +
                'Selected_to_receive_message__c,'+
                'Type_of_champion__c, ' +
                'Champion_newsletters__c, ' +
                'DF_Region__c ' +                
                'from DF_Contact__c  where '+
                'RecordtypeId =: rt and ' +
                'Status__c =:STATUS_CONVERTED ';

   
    

    if (!type_selection.isEmpty())  {       

        soql += ' AND Type_of_champion__c includes (';    
        soql += DF_Utils.listAsString(type_selection);
        soql += ')';
    
    }  
   if (!interests_selection.isEmpty())  {       
        system.debug('interests list@@'+DF_Utils.listAsString(interests_selection));
        soql += ' AND Interests__c includes (';    
        soql += DF_Utils.listAsString(interests_selection);
        soql += ')';
    
    }  


   if (region_selection!=null && region_selection!='none' && region_selection!='')  {       

        soql += ' AND DF_Region__c = :region_selection';
       
    
    }    

    if(postcodeout!=null && postcodeout.length()>0){
        soql += ' AND Postcode_Sector__c = :postcodeout';
    }  

    if (emailaddress!=null && emailaddress.length()>0 && emailaddress!='')  {       
        
        soql += ' AND Email__c = :emailaddress';
       
    
    } 

    if( totalfriendsmin.length()>0 && totalfriendsmax.length()>0){
      
    minfr = (totalfriendsmin!= null & totalfriendsmin.length()>0?integer.valueof( totalfriendsmin ):null);
    maxfr =  (totalfriendsmax!= null & totalfriendsmax.length()>0?integer.valueof( totalfriendsmax ):null);
    soql += ' AND Total_No_of_Friends_Created__c >=:minfr and Total_No_of_Friends_Created__c <=: maxfr'; 
      
    }

    if( totalsessionsmin.length()>0 && totalsessionsmax.length()>0){
      
    minsessions = (totalsessionsmin!= null & totalsessionsmin.length()>0?integer.valueof( totalsessionsmin ):null);
    maxsessions =  (totalsessionsmax!= null & totalsessionsmax.length()>0?integer.valueof( totalsessionsmax ):null);
    soql += ' AND Total_No_of_Completed_Info_Sessions__c >=:minsessions and Total_No_of_Completed_Info_Sessions__c <=: maxsessions'; 
      
    }
   
    if( totalincompletesessionsmin.length()>0 && totalincompletesessionsmax.length()>0){
      
    minincomplete = (totalincompletesessionsmin!= null & totalincompletesessionsmin.length()>0?integer.valueof( totalincompletesessionsmin ):null);
    maxincomplete =  (totalincompletesessionsmax!= null & totalincompletesessionsmax.length()>0?integer.valueof( totalincompletesessionsmax ):null);
    soql += ' AND Total_No_of_Available_Info_Sessions__c >=:minincomplete and Total_No_of_Available_Info_Sessions__c <=: maxincomplete'; 
      
    }

     if (champtraining!=null && champtraining2!=null)  {       
        
        soql += ' AND Date_of_Champion_Training__c >=:champtraining and Date_of_Champion_Training__c <=:champtraining2 ';
       
    
    }

     if (latestsession!=null && latestsession2!=null)  {       
        
        soql += ' AND Latest_Friends_Session_Date__c >=:latestsession and Latest_Friends_Session_Date__c <=:latestsession2 ';
       
    
    }

    if (newsletter!=null && newsletter!='' && newsletter!= 'None')  {  
        svalue=(newsletter=='True'? True:False );     
        system.debug('svalue' +  newsletter+ svalue );
        soql += ' AND Champion_newsletters__c =: sValue ';
       
    
    }
  }

public void clicked()
  {
      // do nothing
  }
  public class DFCWrapper

  {
     public DF_Contact__c dfc {get; private set;}
     public Boolean selectedDFC {get; set;}

     public DFCWrapper(DF_Contact__c a){
     selectedDFC = false;
     dfc = a;
    
     }

  }
  




public PageReference addMessages(){

  lispn = new List<Push_Notifications__c>();
  Boolean isError=false ;
  if (pushMessage == null || pushMessage.length() == 0 )
{
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter message '));
    isError = true;
    
} 
  if (title == null || title.length() == 0 )
{
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter message title '));
    isError = true;
    
} 
if(isError){
  return null;
}

 

  for(DF_Contact__c dfc:selectedDFCs.values() ){
  //if(dfw.selectedDFC==true){
     pn= new Push_Notifications__c();
     
      pn.Message__c = pushMessage;
      pn.DF_Contact__c=dfc.id ;
      pn.Status__c = 'Unread';
      pn.Title__c = title;
      pn.Button_title__c = btnTitle;
      pn.Button_link__c = btnLink;

      lispn.add(pn);
      

   // } 
  }
  system.debug('list size to insert :'+lispn.size());
  if(lispn.size()>0){
  insert lispn;
  selectedDFCs.clear();
  pushMessage ='';
  title='';
  btnTitle='';
  btnLink='';
  }
  


return null;
}

public void rerender()

 {

 }




}