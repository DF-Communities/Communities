public class DF_Pure360_AutomatedListUpdate {

public string Endpoint= 'https://response.pure360.com/interface/list.php?accName=webD.sys&listName=Welcome+Email&doubleOptin=FALSE&successUrl=NO-REDIRECT&errorUrl=NO-REDIRECT';  

 public void postRequest(Map<string,List<String>> sbody){
  system.debug('SBODY@@@'+ sbody);
  string firstName ;
  string lastName;
  string email;
  string body; //= 'accName=webD.sys&listName=Welcome+Email&doubleOptin=FALSE&successUrl=NO-REDIRECT&errorUrl=NO-REDIRECT';
   for(String s :sbody.keyset()){
     
     for(string sfields : sbody.get(s)){
      body = body +'&'+ sfields;
     }

   //String body= 'accName=web&listName=Welcome+Email&doubleOptin=FALSE&successUrl=NO-REDIRECT&errorUrl=NO-REDIRECT&firstName=Test&email=la2@mailinator.com';
      HttpRequest req = new HttpRequest();
      req.setMethod('POST');
      req.setTimeout(4000);
      req.setEndpoint(Endpoint);
      
      
       req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
       system.debug('body@@'+body );
        req.setBody(body);
       
      Http h = new Http();
      system.debug('Req@@'+req );
    try {
    
      HttpResponse res = h.send(req);
        if (res.getStatusCode()!=200) {
          String cbody = res.getBody() == null ? res.getStatus() : res.getBody();
                   
        } 
    }catch(System.CalloutException e) {

        //Exception handling goes here....

     }
    
    }
  }
}