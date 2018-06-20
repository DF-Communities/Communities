global abstract class CkePaymentController extends EdtPageController
{
    public static final String TYPE_PAYIN = 'Pay-in';
    public static final String TYPE_DONATION = 'Donation';
    
    private static final String PAYIN_FORM_ID = Community_Settings__c.getInstance('CKE_Payment_Progress_Id').Value__c;
    private static final String DONATION_FORM_ID = Community_Settings__c.getInstance('CKE_Donate_Progress_Id').Value__c;
    
   @RemoteAction    
   global static Object createPayment(Command cmd)
   {
       try {
          Continuation con = new Continuation(120);
          con.continuationMethod = 'createPaymentContinue';
          Cke_Payment__c pmt = buildPaymentRecord(cmd);
          PayPalClient paypal = new PayPalClient();
          String requestId = con.addHttpRequest(paypal.buildCreatePaymentRequest(cmd));
          con.state = new ContinuationData(requestId, pmt, paypal);
          return con;
       }
       catch (Exception e) {
          System.debug('Error is: ' + e.getMessage());
          CustomUtils.saveWebError('Cupcake Day Payment', e.getMessage());
          return new SysRestError(e, 550); 
       }
    }
    
   @RemoteAction    
   global static Object setExpressCheckout(Command cmd)
   {
      Cke_Payment__c pmt = buildPaymentRecord(cmd);
      try {
        String baseUrl = Site.getBaseCustomUrl()=='' ? Site.getBaseUrl() : Site.getBaseCustomUrl();
        if (baseUrl==null) throw new SysException('Must be in the context of a community or site');
        String description = 'Cupcake Day '+cmd.type;        
        String returnUrl = baseUrl+'/Cke_Checkout';
        String cancelUrl = baseUrl+(cmd.type==CkePaymentController.TYPE_DONATION?'/donate':'/pay-in');
        PayPalClient paypal = new PayPalClient();
        Map<String, String> ret = paypal.setExpressCheckout(cmd.amount, description, returnUrl, cancelUrl);
        pmt.Status__c = 'Checkout1';
        pmt.Paypal_Token__c = ret.get('TOKEN');
        return ret;
     }
     catch (Exception e) {
        pmt.Status__c = 'Failed';
        pmt.Extended_Status__c = '['+e.getMessage()+']['+e.getStackTraceString()+']';
        CustomUtils.saveWebError('Cupcake Day Payment', pmt.Extended_Status__c );
        return new SysRestError(e, 500); 
     }
     finally {
        try {
            pmt.Response_Time__c = System.currentTimeMillis() - pmt.Time_Submitted__c.getTime();
            insert pmt;         
        }
        catch (Exception e) {
            CustomUtils.saveWebError('Cupcake Day Payment', e.getMessage() );
        }
     }
    }

   private static Object createPaymentContinue(Object state)
   {
     ContinuationData data = (ContinuationData)state;
     Cke_Payment__c pmt = data.payment;
     try {
        PayPalClient paypal = data.paypal;
        CkeMailClient client = new CkeMailClient();
        HttpResponse resp = Continuation.getResponse(data.requestId);
        if (resp.getStatusCode()>=2000) throw new CkeException('Continuation error '+resp.getStatusCode());
        PayPalData.PaymentResponse ret = paypal.handleCreatePaymentResponse(resp);
        pmt.Status__c = 'Completed';
        pmt.Transaction_Id__c = ret.id;
        pmt.Transaction_Time__c = ret.create_time;
        if (isSandbox()) pmt.Extended_Status__c = ret.rawResponse;
        else ret.rawResponse = null;
        client.sendPaymentConfirmationMail(pmt);
        return ret;
     }
     catch (PayPalPaymentException e) {
        pmt.Status__c = 'Declined';
        pmt.Extended_Status__c = e.getMessage();
        CustomUtils.saveWebError('Cupcake Day Payment', pmt.Extended_Status__c );
        return new SysRestError(e, 400); 
     }
     catch (Exception e) {
        pmt.Status__c = 'Failed';
        pmt.Extended_Status__c = '['+e.getMessage()+']['+e.getStackTraceString()+']';
        CustomUtils.saveWebError('Cupcake Day Payment', pmt.Extended_Status__c );
        return new SysRestError(e, 560); 
     }
     finally {
        try {
            pmt.Response_Time__c = System.currentTimeMillis() - pmt.Time_Submitted__c.getTime();
            insert pmt;         
        }
        catch (Exception e) {
            CustomUtils.saveWebError('Cupcake Day Payment', e.getMessage() );
        }
     }
    }
    
    public static Cke_Payment__c buildPaymentRecord(Command cmd)
    {
        Cke_Payment__c pmt = new Cke_Payment__c();
        
        pmt.Cupcake_Code__c = cmd.cupcakeCode;
        pmt.Email__c = cmd.email;
        pmt.Title__c = cmd.title;
        pmt.First_Name__c = cmd.firstName;
        pmt.Last_Name__c = cmd.lastName;
        pmt.Address_Line1__c = cmd.addressLine1;
        pmt.Address_Line2__c = cmd.addressLine2;
        pmt.Address_Line3__c = cmd.addressLine3;
        pmt.City__c = cmd.city;
        pmt.County__c = cmd.county;
        pmt.Postcode__c = cmd.postcode;
        pmt.Phone__c = cmd.phone;
        pmt.Country_Code__c = cmd.countryCode;
        pmt.Proximity_to_Dementia__c = cmd.proximity;
        pmt.Optin_Email__c = cmd.optinEmail == true;
        pmt.Optin_SMS__c = cmd.optinSms == true;
        pmt.Optin_Phone__c = cmd.optinPhone == true;
        pmt.Optin_Social_Media__c = cmd.optinSocial == true;
        pmt.Optout_Post__c = cmd.optoutPost == true;
        pmt.Gift_Aid__c = cmd.giftaid == 'yes';
        pmt.Payment_Method__c = cmd.paymentMethod;
        pmt.Time_Submitted__c = DateTime.now();
        
        if(!Pattern.matches('^[0-9]+(\\.[0-9]{2})?$',cmd.amount)) throw new CkeException('Invalid amount:'+cmd.amount);
        pmt.Amount__c = Decimal.valueOf(cmd.amount);
        if (pmt.Amount__c <= 0) throw new CkeException('Invalid amount:'+cmd.amount);
        
        pmt.Type__c = cmd.type;
        if (cmd.type==TYPE_PAYIN) {
           pmt.Progress_Form_Id__c = PAYIN_FORM_ID;            
        }
        else if (cmd.type==TYPE_DONATION) {
           pmt.Progress_Form_Id__c = DONATION_FORM_ID;            
        }
        else {
          throw new CkeException('Invalid payment type:'+cmd.type);
        }
        System.debug('pmt: ' + pmt);
        return pmt;
    }
    
    private static Boolean isSandbox()
    {
        return [select IsSandbox from Organization][0].IsSandbox;
    }

    public Boolean getIsLiveSandbox()
    {
        PayPalClient paypal = new PayPalClient(true);
        return paypal.isLive() && isSandbox();
    }

    global class Command extends PayPalData.PaymentData
    {
        public String type { get; set; }
        public String email { get; set; }
        public String title { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String addressLine3 { get; set; }
        public String county { get; set; }
        public String phone { get; set; }
        public Boolean optinEmail { get; set; }
        public Boolean optinSms { get; set; }
        public Boolean optinPhone { get; set; }
        public Boolean optinSocial { get; set; }
        public Boolean optoutPost { get; set; }
        public String giftaid { get; set; }
        public String proximity { get; set; }
        public String paymentMethod { get; set; }
        public String cupcakeCode { get; set; }
    }    
    
    global class ContinuationData
    {
        public String requestId { get; set; }
        public PayPalClient paypal { get; set; }
        public Cke_Payment__c payment { get; set; }
        public ContinuationData(String requestId, Cke_Payment__c pmt, PayPalClient paypal)
        {
            this.payment = pmt;
            this.paypal = paypal;
            this.requestId = requestId;
        }
    }
    
   @TestVisible  
   private static Object createPaymentContinue()
   {
       CKE_Payment__c pmt = CkePaymentController.buildPaymentRecord(CkePaymentController_Test.getData());
       PayPalClient paypal = new PayPalClient();
       CkePaymentController.ContinuationData cd = new CkePaymentController.ContinuationData('xtest', pmt, paypal);
       return CkePaymentController.createPaymentContinue(cd);
   }

}