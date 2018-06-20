global without sharing class CkeHomeHoldingController extends EdtPageController {

	public final Static String PROGRESS_CODE = 'EVCD17_ENQ';

	public CkeHomeHoldingController() {
		
	}

    public static String captchaSite{

    get {

        String s = '6Lc8lxkTAAAAABWgV2BcYEDEsy6Ff9IU8iEAxpyO';
        try { 
                String sCap = (String)Community_Settings__c.getInstance('Cke_Captcha_Site').value__c;
                if ( sCap != null && sCap.length() > 0) { s = sCap; }
                } catch (Exception x) { }

        return s;        

    }

    set;}

   public static String captchaSecret {

    get {

        String s = '6Lc8lxkTAAAAAKhi7vXZgBKHxZ96hkXRuMr2kJzD';
        try { 
                String sCap = (String)Community_Settings__c.getInstance('Cke_Captcha_Secret').value__c;
                if ( sCap != null && sCap.length() > 0) { s = sCap; }
                } catch (Exception x) {}

        return s;        

    }

    set;}


   @RemoteAction	
   global static Object processSubmit(Command cmd)
   {
       try {
            
             WEBC_Recaptcha2Handler cpt = new WEBC_Recaptcha2Handler(captchaSecret, cmd.captchaResponse );
              
             if ( !cpt.verify() ) {
                   return new CkeException('Google Captcha Failed');
             }

             List<CKE_Pack_Request__c> lisPr = [select id, Last_Name__c, First_Name__c, Email__c from Cke_Pack_Request__c where 
             									Email__c =: cmd.Email.toLowerCase() 
             									and Progress_Form_Id__c =: PROGRESS_CODE 	
             									];
			 Cke_Pack_Request__c item;       

             if ( !lisPr.isEmpty() ) {


             		for ( Cke_Pack_Request__c pr : lisPr ) {

             			if ( pr.Last_Name__c.equalsIgnoreCase(cmd.lastName) && 
 							 pr.First_Name__c.equalsIgnoreCase(cmd.firstName) )

             			item = pr;
             			break;

             		}
             
             }

             if ( item == null ) { 
    
             	item = buildRecord(cmd);
	            upsert item;		    

	         }      

             sendEmailConfirmation(item.Email__c, item.First_Name__c, 3);

		     System.debug('Item Id : ' + item.id);
		     cmd.id = item.id;
		     return cmd;

       }

       catch (Exception e) {
          return new SysRestError(e, 550); 
       }
    }
    
    @Future(callout=true)
    public static void sendEmailConfirmation(String email, String name, Integer d) {
    
        CkeMailClient client = new CkeMailClient();
        //client.sendPackConfirmationMail(email, name, d);
        client.sendRegisterInterestConfirmationMail(email, name);
    
    }
    public static Cke_Pack_Request__c buildRecord(Command cmd)
    {

        Cke_Pack_Request__c item;
        item = new Cke_Pack_Request__c();
        item.Email__c = cmd.email.toLowerCase();
        item.First_Name__c = cmd.firstName;
        item.Last_Name__c = cmd.lastName;
        //item.Optin_TermsConditions__c = true; 
        //item.Optin_Email__c = true;
        item.Progress_Form_Id__c = PROGRESS_CODE;
        item.Status__c = 'Completed';

        List<RecordType> lisRt= [select id from RecordType where DeveloperName = 'Register_Interest' and sObjectType = 'Cke_Pack_Request__c'];
        RecordType rt = lisRt[0];
        item.RecordTypeId = rt.id;

        item.Time_Submitted__c = DateTime.now();         
        if ( cmd.submitted == true ) { item.Status__c = 'Completed'; }

        return item;
    
    }
 
    global class Command 
    {
     
      	public String id { get;set; }
      	public Boolean submitted { get; set;}  
        public String email { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String captchaResponse { get;set; }  

    }    


}