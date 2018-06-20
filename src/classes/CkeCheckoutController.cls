global without sharing class CkeCheckoutController 
{
    transient String baseUrl;
    transient String errorStatus = null;
    transient Map<String, String> checkoutData = new Map<String, String>();
	
    public CkeCheckoutController()
    {
    }
    
    public void getCheckoutDetails()
    {
        baseUrl = Site.getBaseCustomUrl()=='' ? Site.getBaseUrl() : Site.getBaseCustomUrl();
        String token = ApexPages.currentpage().getParameters().get('token');
        if (token==null) {
            errorStatus = 'No token supplied in query string';
            return;
        }
    
        Cke_Payment__c pmt = getPaymentRecord(token);
        if (pmt==null) {
            errorStatus = 'No payment record for the supplied token ['+token+']';
            return;
        }
        if (pmt.Status__c != 'Checkout1'&&pmt.Status__c != 'Checkout2') {
            errorStatus = 'Payment for token '+token+' has incorrect state ('+pmt.Status__c+')';
            return;
        } 
        
        try {    
	        PayPalClient paypal = new PayPalClient();
            checkoutData = paypal.getExpressCheckoutDetails(token);
            pmt.Status__c = 'Checkout2';
        }
     	catch (PayPalPaymentException e) {
        	pmt.Status__c = 'Failed';
        	pmt.Extended_Status__c = e.getMessage();
        	errorStatus = 'PayPal cannot process the request at present';
     	}
     	catch (Exception e) {
        	pmt.Status__c = 'Failed';
        	pmt.Extended_Status__c = '['+e.getMessage()+']['+e.getStackTraceString()+']';
        	errorStatus = 'There was a problem contacting PayPal';
     	}
        finally {
        	try { update pmt; }	catch (Exception e) { errorStatus = e.getmessage(); }
     	}
    }
    
    public String getToken()
    {
        String tk = checkoutData.get('TOKEN');
        return tk == null ? '' : tk;
    }

    public String getErrorStatus()
    {
        return errorStatus;
    }

    public String getPayerId()
    {
        return checkoutData.get('PAYERID');
    }

    public String getAmount()
    {
        return checkoutData.get('AMT');
    }
        
    public String getCancelUrl()
    {
        return baseUrl+(isDonation()?'/donate':'/pay-in')+'?token='+EncodingUtil.urlEncode(getToken(), 'UTF-8');
    }
        
    public String getTitle()
    {
        return isDonation()?'Busy on Cupcake Day?':'Coins for Cupcake Day';
    }
        
    public String getCopy()
    {
        return isDonation()?'Click the button below to complete your donation and be part of Cupcake Day in your own way.':'You baked, you bought, you iced. Now to make every crumb count, click the button below to donate all the money you’ve raised to help defeat dementia.';
    }
    
    private Boolean isDonation()
    {
        String dec = checkoutData.get('PAYMENTREQUEST_0_DESC');
        return dec!=null && dec.toLowerCase().contains('donation');
    }

    public String getPaymentType()
    {
        return isDonation() ? CkePaymentController.TYPE_DONATION : CkePaymentController.TYPE_PAYIN;
    }
    
   @RemoteAction	
   global static Object createPayment(Command cmd)
   {
       try {
          Continuation con = new Continuation(120);
          con.continuationMethod = 'createPaymentContinue';
          Cke_Payment__c pmt = getPaymentRecord(cmd.token);
          if (pmt==null) throw new CkeException('No payment record for the supplied token ['+cmd.token+']');
          if (pmt.Status__c != 'Checkout2') throw new CkeException('Payment for token '+cmd.token+' has incorrect state ('+pmt.Status__c+')');
          PayPalClient paypal = new PayPalClient();
          String requestId = con.addHttpRequest(paypal.buildDoExpressCheckoutPaymentRequest(cmd.token, cmd.payerId, cmd.amount));
          con.state = new ContinuationData(requestId, pmt, paypal);
          return con;
       }
       catch (Exception e) {
          return new SysRestError(e, 550); 
       }
    }
   
   @TestVisible 
   private static Object createPaymentContinue(Object state)
   {
     ContinuationData data = (ContinuationData)state;
     Cke_Payment__c pmt = data.payment;
     try {
     	PayPalClient paypal = data.paypal;
        CkeMailClient mailer = new CkeMailClient();
        HttpResponse resp = Continuation.getResponse(data.requestId);
        if (resp.getStatusCode()>=2000) throw new CkeException('Continuation error '+resp.getStatusCode());
     	Map<String, String> ret = paypal.handleDoExpressCheckoutPaymentResponse(resp);
     	pmt.Status__c = 'Completed';
        pmt.Transaction_Time__c = ret.get('TIMESTAMP');
        pmt.Transaction_Id__c = ret.get('PAYMENTINFO_0_TRANSACTIONID');
        if (isSandbox()) pmt.Extended_Status__c = EncodingUtil.urlDecode(ret.get('XRESPDATA').replaceAll('&', ' '), 'UTF-8');
        else ret.put('XRESPDATA', '');
        mailer.sendPaymentConfirmationMail(pmt);
        return ret;
     }
     catch (PayPalPaymentException e) {
        pmt.Status__c = 'Declined';
        pmt.Extended_Status__c = e.getMessage();
        return new SysRestError(e, 400); 
     }
     catch (Exception e) {
        pmt.Status__c = 'Failed';
        pmt.Extended_Status__c = '['+e.getMessage()+']['+e.getStackTraceString()+']';
        return new SysRestError(e, 560); 
     }
     finally {
        try {
        	pmt.Response_Time__c = System.currentTimeMillis() - data.timestamp;
	    	update pmt;         
        }
        catch (Exception e) {}
     }
    }
    
    private static Cke_Payment__c getPaymentRecord(String token)
    {
        Cke_Payment__c[] data = [ select Id, Status__c, Type__c, Amount__c, First_Name__c, Last_Name__c, Email__c, Paypal_Token__c, Transaction_Id__c, Extended_Status__c from Cke_Payment__c where Paypal_Token__c = :token ];
        return data.isEmpty() ? null : data[0];
    } 
    
    global class Command
    {
        public String token { get; set; }
        public String payerId { get; set; }
        public String amount { get; set; }
    }  

    global class ContinuationData
    {
        public String requestId { get; set; }
        public PayPalClient paypal { get; set; }
        public Cke_Payment__c payment { get; set; }
        public Long timestamp { get; private set; }
        public ContinuationData(String requestId, Cke_Payment__c pmt, PayPalClient paypal)
        {
            this.payment = pmt;
            this.paypal = paypal;
            this.requestId = requestId;
            this.timestamp = System.currentTimeMillis();
        }
    }

    @TestVisible
    private static Boolean isSandbox()
    {
        return [select IsSandbox from Organization][0].IsSandbox;
    }

    @TestVisible  // Only run this in test mode. Don't call it in real code
    private static Object createPaymentContinue()
    {
       CKE_Payment__c pmt = CkeCheckoutController.getPaymentRecord('EC-4HD21310W5753063G');
       PayPalClient paypal = new PayPalClient();
       CkeCheckoutController.ContinuationData cd = new CkeCheckoutController.ContinuationData('xtest', pmt, paypal);
       return CkeCheckoutController.createPaymentContinue(cd);
    }
    
}