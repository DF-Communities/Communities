public with sharing class TestCallOutSpeed implements Queueable, Database.AllowsCallouts {

  public String urlOption {get;set;}
  public String dynamicUrl {get;set;}

	public TestCallOutSpeed() {
		
	}

	public void execute(QueueableContext context) {

		doCallOut();

	}

	public void doCallOut() {

    System.debug('Callout Test has Started : ' + System.Now());

  	   String s = '30';
       if ( !Test.isRunningTest() ) {
         	s = (String)Community_Settings__c.getInstance('Test_CallOutTestDelay').value__c; 
       } 

       String url = 'http://1.cuzillion.com/bin/resource.cgi?sleep=' + s;
       
       if ( dynamicUrl != null ) { url = dynamicUrl; }
       if ( urlOption == 'DAA' ) { 
            url = 'http://www.dementiaaction.org.uk/daa/list';
       }

       String body;
  
       // Instantiate a new http object
       Http h = new Http();

       // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
       HttpRequest req = new HttpRequest();

       req.setEndpoint(url);
       req.setMethod('GET');
       req.setTimeout(120000);
    
       // Send the request, and return a response
       HttpResponse res = h.send(req);  
   
       if (Test.isRunningTest()) { 
        
          // Do Nothing

       } else{
    
       	
          try{
            
              body = res.getBody();  

              System.debug('Req Url : ' + req.getEndpoint());
              System.debug('Body returned : ' + body.substring(0, 10));
    
          } catch (Exception e) { 

              System.debug('There is an error receiving the response ' + e.getMessage());

          }
  
      }    

      System.debug('Callout Test has Completed : ' + System.Now());

   }
    
    
}