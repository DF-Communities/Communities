global without sharing class CkePackRequestController extends EdtPageController {
   
   private static final String PACK_FORM_ID = Community_Settings__c.getInstance('CKE_Pack_Progress_Id').Value__c;
   public class RequestException extends Exception{}

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
       Boolean isPartialSubmission = false;
       try {
       
           
            
            /*// Removed Captcha for 2017
            if ( cmd.submitted == true ) {
                          
                         WEBC_Recaptcha2Handler cpt = new WEBC_Recaptcha2Handler(captchaSecret, cmd.captchaResponse );
              
                if ( !cpt.verify() ) {
                        return new CkeException('Google Captcha Failed');
                     }
             }*/
                
            Cke_Pack_Request__c item = buildRecord(cmd, isPartialSubmission);
            if ( item.Email__c != '' && item.Email__c != null && item.Email__c != 'undefined' 
              && item.First_Name__c != '' && item.First_Name__c != null && item.First_Name__c != 'undefined') {       
            Database.UpsertResult dur = Database.upsert(item, true);
            
            if(!dur.isSuccess()) {
            
                List<Database.Error> errors = dur.getErrors();
                String combinedErrorMsgs = '';
                for(Database.Error err : errors) {
                    combinedErrorMsgs+=err.getMessage();
                    CustomUtils.saveWebError('Cupcake Day Pack Request', combinedErrorMsgs);
                }
                return new RequestException(); 
                            
            } else {
                          
                //if ( cmd.submitted == true ) {
                
                      sendEmailConfirmation(item.Email__c, item.First_Name__c, 3);
                //}
    
                System.debug('Item Id : ' + item.id);
                cmd.id = item.id;
                return cmd;
            }
            } else {
             String errMsg = 'Issues with email (' + item.Email__c + ') and/or firstname (' + item.First_Name__c + ')';
             CustomUtils.saveWebError('Cupcake Day', errMsg);
            return new RequestException(); 
            }
       }

       catch (Exception e) {
          return new SysRestError(e, 550); 
       }
    }

    @RemoteAction        
   global static Object processPartialSubmit(Command cmd)
   {        
       Boolean isPartialSubmission = true;
       try {
                
             Cke_Pack_Request__c item = buildRecord(cmd, isPartialSubmission);       
             System.debug('item is: ' + item );

           // June 2018 - GG - THIS IF STATEMENT NOT YET DEPLOYED as of June 2018
           if ( item.Status__c == null || item.Status__c != 'Completed') {

               // Prevent recording personal identifiable data before a full page submit
               if (item.Email__c != null) {
                   item.Email__c = 'partialsubmission@mailinator.com';
               }
               if (item.First_Name__c != null) {
                   item.First_Name__c = 'Anon';
               }
               if (item.Last_Name__c != null) {
                   item.Last_Name__c = 'Anon';
               }
               if (item.Phone__c != null) {
                   item.Phone__c = '077777777777';
               }
               if (item.Address_Line1__c != null) {
                   item.Address_Line1__c = 'Anon';
               }

           }

            Database.UpsertResult dsr = Database.upsert(item, false);
           
           if(!dsr.isSuccess()) {
               String allErrs = '';
               for(Database.Error err : dsr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    allErrs += err.getStatusCode() + ': ' + err.getMessage() + ' | ';
                }
               CustomUtils.saveWebError('Cupcake Day Payment', 'All errors recorded as: ' + allErrs);
           }
                          
            if ( cmd.submitted == true ) {
                sendEmailConfirmation(item.Email__c, item.First_Name__c, 3);
            }

            System.debug('Item Id : ' + item.id);
            cmd.id = item.id;
            return cmd;

       }

       catch (Exception e) {
          CustomUtils.saveWebError('Cupcake Day Payment', e.getMessage()); 
          return new SysRestError(e, 550); 
       }
    }
    
    @Future(callout=true)
    public static void sendEmailConfirmation(String email, String name, Integer d) {
    
        CkeMailClient client = new CkeMailClient();
        client.sendPackConfirmationMail(email, name, d);
    
    }

    public static Cke_Pack_Request__c buildRecord(Command cmd, Boolean isPartialSubmission)
    {

        System.debug('Submitted cmd:' + cmd);

        Cke_Pack_Request__c item;
        if ( cmd.id != null && cmd.id != '' ) {

            item = (Cke_Pack_Request__c)CustomUtils.ObjectWithAllFields('id', cmd.id, Schema.sObjectType.CKE_Pack_Request__c);

        } else { 

            item = new Cke_Pack_Request__c();

        }
        
        // If the item is already completed don't do any updates
        if ( item.Status__c == 'Completed') { return item; }

        item.Email__c = cmd.email;
        item.Title__c = cmd.title;
        item.First_Name__c = cmd.firstName;
        item.Last_Name__c = cmd.lastName;
        item.Address_Line1__c = cmd.addressLine1;
        item.Address_Line2__c = cmd.addressLine2;
        item.Address_Line3__c = cmd.addressLine3;
        item.City__c = cmd.city;
        item.County__c = cmd.county;
        item.Postcode__c = cmd.postcode;
        item.Country__c = cmd.country;
        item.Phone__c = cmd.phone;
        item.Optin_Email__c = cmd.optinEmail == true;
        item.Optin_Phone__c = cmd.optinPhone == true;
        item.Optin_Sms__c = cmd.optinSms == true;
        //item.Optin_TermsConditions__c = cmd.optinTc == true;
        item.Optin_TermsConditions__c = true;  // implied by requesting the pack
        item.Optout_Post__c = cmd.optoutPost == true;
        item.Optin_Social_Media__c = cmd.optinSocial == true;
        item.Event_Location__c = cmd.location;
        item.Proximity_to_Dementia__c = cmd.proximity;  
        item.Referer_Header__c = cmd.refererHeader;
        item.Progress_Form_Id__c = PACK_FORM_ID;
        item.Company_Name__c = cmd.companyName;
        
        if(cmd.dob != '') {

            Datetime dobDt = Datetime.newInstance(Long.valueOf(cmd.dob));
            item.BirthDate__c = dobDt.date();
        }

        item.Time_Submitted__c = DateTime.now();         
        //if ( cmd.submitted == true ) { item.Status__c = 'Completed'; }
        if (!isPartialSubmission) { 
          item.Status__c = 'Completed';
          item.Optin_TermsConditions__c = true;  // implied by requesting the pack 
        }

        return item;
    
    }

    /*
    private static Date getDate(String sDate) {

        try { 

            String[] partsMajor = sDate.split('T');                
            String[] parts = partsMajor[0].split('-');
            System.debug(parts);
            
            Date dt = null;
            dt = Date.newInstance(Integer.valueOf(parts[0]),Integer.valueOf(parts[1]),Integer.valueOf(parts[2]));       
            return dt;
            
        } catch (Exception x) { 
          System.Debug('Date Error : ' + x.getCause() + ' ' + x.getMessage());
          return null; 

        }

    }
    */

    
    global class Command 
    {

        public String dob { get;set; }
        public String captchaResponse { get;set; }      
      
        public String id { get;set; }
        public Boolean submitted { get; set;}  
        public String email { get; set; }
        public String title { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String phone { get; set; }

        public Boolean optinEmail { get; set;}  
        public Boolean optinPhone { get; set;}          
        public Boolean optinSms { get; set;} 
        public Boolean optoutPost { get; set;} 
        public Boolean optinSocial { get; set;}         
        public Boolean optinTc{ get; set;}  

        public String postcode { get; set; }
        public String county { get; set; }
        public String city { get; set; }
        public String addressLine1 { get; set; }
        public String addressLine2 { get; set; }
        public String addressLine3 { get; set; }
        public String country { get; set; }
        
        public String location { get; set; }
        public String proximity { get; set; }
        public String refererHeader { get; set; }
        
        public String companyName {get;set;}
        
        public String requestCode { get; set; }

    }    


}