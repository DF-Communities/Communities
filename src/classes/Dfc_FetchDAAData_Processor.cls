/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : Web Service DAA API Integration
 *  Author  : Lakshmi Vasudevan
 *  Date    : 20/01/2016
 *  Version : 1.0
 *
 *  Description:    Web Service - DAA API Integration to get data from Action Alliance website 
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/

 public class Dfc_FetchDAAData_Processor {

   @future(callout=true)
   public static void fetchData() {

       String url = 'http://www.dementiaaction.org.uk/daa/list';
       string body;
       String updatedbody;
       DAARemoteObject remoteob =  new DAARemoteObject();
       List<DAARemoteObject> ro2 = new List<DAARemoteObject>();
  
       // Instantiate a new http object
       Http h = new Http();

       // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
       HttpRequest req = new HttpRequest();

       req.setEndpoint(url);
       req.setMethod('GET');
    
       // Send the request, and return a response
       HttpResponse res = h.send(req);  
   

       if (Test.isRunningTest()) { 
        
           DAARemoteObject d = new DAARemoteObject();
           d.url = 'http://www.dementiaaction.org.uk/local_alliances/15807_haywards_heath_dementia_action_alliance';
           d.region = 'South East';
           d.contact = 'Dawn Fairbrother' ;
           d.name = 'Haywards Heath Dementia Action Alliance';
           d.id = '15807';
           d.email = 'dawn.fairbrother@alzheimers.org.uk';
           d.description = 'The Haywards Heath Dementia Action Group was set up in December 2014 with the intention of helping the community become more dementia-friendly.';
           ro2.add(d);
     
       } else{
    

          try{
            
              body = res.getBody();  
              system.debug('RESPONSE'+res.getBody());
    
          } catch (Exception e) { System.debug('There is an error receiving the response ' + e.getMessage());}
  
            updatedbody = body.replace ('abstract' ,'description');
            system.debug('test abstract '+updatedbody);
   
          try{
              
              ro2= ( List<DAARemoteObject> )System.JSON.deserialize(updatedbody,List<DAARemoteObject>.class);
    
            } catch (Exception e){ System.debug('There is an error on JSON deserialization ' + e.getMessage());}
    
 
      }    
 
      List<DFC_Alliance__c> listoupsert = new List <DFC_Alliance__c>();
      Map <String,DFC_Alliance__c> exAlliancesMap = new Map <String,DFC_Alliance__c> ();
 
      for(DFC_Alliance__c da: [select DAA_Id__c,name, Url__c,DAA_Region__c,Description__c,Email__c,Region__c,Contact_name__c from DFC_Alliance__c]) {
              
         exAlliancesMap.put(da.DAA_Id__c,da);          
          
      }
      
      SYSTEM.DEBUG('REMOTE OBJECT'+REMOTEOB);
      
      for (DAARemoteObject daa : ro2) {  
                         
             DFC_Alliance__c d = exAlliancesMap.get(daa.id);
             if(d == null) { d = new DFC_Alliance__c(); }                         
             if ( copyData(daa, d) ) { listoupsert.add(d); }         
      
      }
      
     // if ( listoupsert.size()>0) { upsert listoupsert; }
      
      //change 15/02/2016 send an email after upsert fail
      
      Database.upsertResult[]  results = Database.upsert( listoupsert, false );
      List <String> errorlis = new List <String>();
      for(Integer ida = 0; ida < results.size(); ida++) {
        if(results[ida].isSuccess()) {
         continue;
        } else {
        for(Database.Error theError:results[ida].getErrors()) {
         errorlis = theError.getFields();
         
          }
        }
      }
     
         
    //*****************
       if(errorlis.size()>0){ //sendemail
       }
   }
   
     
 
    // Return a boolean that represents whether as update has happened
    public static boolean copyData(DAARemoteObject daa, DFC_Alliance__c o) {
      
      if ( daa.name==null || daa.region == null) { return false; }      
      
      if( 
           (o.Url__c == daa.url ) && 
           (o.name == daa.name ) && 
           (o.Region__c == daa.region ) && 
           ( o.Email__c == daa.email) && 
           (o.Contact_name__c == daa.contact) && 
           (o.Description__c == daa.Description) ) {

           return false;
      } 

      
      o.name = daa.name ;
      o.Description__c = daa.Description;
      o.Email__c=daa.email   ;
      o.Region__c=daa.region   ;
      o.Contact_name__c= daa.contact;
      o.DAA_Id__c = string.valueof(daa.id);
      o.Url__c = daa.url;       
        
      return true; 
    
    }
   
     /* The object returned in the JSON */
 
     /* GG change the name of this to DAARemoteObject */
    public class DAARemoteObject
    {
        Integer returnCode;
        public String region = '';
        public String email = '';
        public String  id = '';
        public String contact = '';
        public String name = '';
        public String description = '';
        public String url ='';
        
       
    }
    
    
}