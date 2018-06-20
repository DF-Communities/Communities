public class PayPalClient 
{
    private String mode;
    private static final String MODE_LIVE = 'LIVE';
    private static final String MODE_SANDBOX = 'SANDBOX';
    private static final String TYPE_PAYIN = 'Pay-in';
    private static final String TYPE_DONATION = 'Donation';

	private PayPal_Settings__c settings;

    public PayPalClient() 
    {
        this(false);
    }
    
    public PayPalClient(Boolean delayAuth) 
    {
        settings = PayPal_Settings__c.getOrgDefaults();
        mode = settings.Live_Payments__c ? MODE_LIVE : MODE_SANDBOX;
        if (!delayAuth) getOAuthToken();
    }
    
    public Boolean isLive()
    {
        return mode == MODE_LIVE;
    }
    
    public PayPalData.PaymentResponse createPayment(PayPalData.PaymentData data)
    {
		httpRequest req = buildCreatePaymentRequest(data);
   	    Http h = new Http();
        HttpResponse resp = h.send(req);
        return handleCreatePaymentResponse(resp);
    }
    
    public Map<String, String> setExpressCheckout(String amount, String description, String returnUrl, String cancelUrl)
    {
		httpRequest req = buildSetExpressCheckoutRequest(amount, description, returnUrl, cancelUrl);
   	    Http h = new Http();
        HttpResponse resp = h.send(req);
        return handleSetExpressCheckoutResponse(resp);
    }
    
    public Map<String, String> getExpressCheckoutDetails(String token)
    {
		httpRequest req = buildGetCheckoutDetailsRequest(token);
   	    Http h = new Http();
        HttpResponse resp = h.send(req);
        return handleGetCheckoutDetailsResponse(resp);
    }
    
    public HttpRequest buildCreatePaymentRequest(PayPalData.PaymentData data)
    {
        PayPalData.Address ba = new PayPalData.Address();
        ba.setLine1(data.addressLine1);  
        ba.setLine2(data.addressLine2);
        ba.setCity(data.city);
        ba.setPostcode(data.postcode);
        ba.setCountryCode(data.countryCode);
   
        PayPalData.CreditCard cc = new PayPalData.CreditCard();
        cc.setCardType(data.cardType);
        cc.setCvv2(data.cvv);
        cc.setAddress(ba);

		String cardNumber = data.cardNumber;
		cardNumber = cardNumber==null?'':cardNumber.replaceAll('[ ]+','');
        cc.setCard_number(cardNumber);

        String[] names = data.cardholderName.split('[ ]+');
        cc.setFirstName(names[0]);
        cc.setLastName(names[names.size()-1]);
        
        cc.setExpireMonth(Integer.valueOf(data.expiryMonth));
        Integer ey = Integer.valueOf(data.expiryYear);
        cc.setexpireYear(ey<100?ey+2000:ey);
        
        PayPalData.SterlingTransaction tran = new PayPalData.SterlingTransaction(data.amount, data.description);
        
        PayPalData.CardPayment payment = new PayPalData.CardPayment();
        payment.setPayer(new PayPalData.CardPayer(cc));
        payment.setTransactions(new List<PayPalData.SterlingTransaction>{ tran });
        
        String endpoint = getPaymentEndpoint();
        return buildJsonRequest(endpoint, payment);
    }
    
    
    public HttpRequest buildSetExpressCheckoutRequest(String amount, String description, String returnUrl, String cancelUrl)
    {	
        Map<String, String> payment = createNvpData();
        
        payment.put('METHOD', 'SetExpressCheckout');
        payment.put('SOLUTIONTYPE', 'Mark');
        payment.put('NOSHIPPING', '1');
        payment.put('REQCONFIRMSHIPPING', '0');
        payment.put('ALLOWNOTE', '0');
        payment.put('BRANDNAME', description);
        payment.put('PAYMENTREQUEST_0_DESC', description);
        payment.put('PAYMENTREQUEST_0_AMT', amount);
        payment.put('PAYMENTREQUEST_0_CURRENCYCODE', 'GBP');
        payment.put('PAYMENTREQUEST_0_PAYMENTACTION', 'SALE');
        
        payment.put('RETURNURL', returnUrl);
        payment.put('CANCELURL', cancelUrl);
                
        String endpoint = getCheckoutEndpoint();
        return buildNvpRequest(endpoint, payment);
    }
    
    
    public Map<String, String> handleSetExpressCheckoutResponse(HttpResponse resp)
    {
        Map<String,String> data = parseNvpResponse(resp);
        data.put('XCOURL', getCheckoutRedirectUrl(data.get('TOKEN')));
      	return data;
    }
    
    
    public HttpRequest buildDoExpressCheckoutPaymentRequest(String token, String payerId, String amount)
    {	
        Map<String, String> payment = createNvpData();

        payment.put('METHOD', 'DoExpressCheckoutPayment');
        payment.put('PAYERID', payerId);
        payment.put('TOKEN', token);
        payment.put('PAYMENTREQUEST_0_AMT', amount);
        payment.put('PAYMENTREQUEST_0_CURRENCYCODE', 'GBP');
        payment.put('PAYMENTREQUEST_0_PAYMENTACTION', 'SALE');
                
        String endpoint = getCheckoutEndpoint();
        return buildNvpRequest(endpoint, payment);
    }
    
    
    public Map<String, String> handleDoExpressCheckoutPaymentResponse(HttpResponse resp)
    {
      	return parseNvpResponse(resp);
    }
   
    public HttpRequest buildGetCheckoutDetailsRequest(String token)
    {	
        Map<String, String> payment = createNvpData();
        payment.put('METHOD', 'GetExpressCheckoutDetails');
        payment.put('TOKEN', token);
        String endpoint = getCheckoutEndpoint();
        return buildNvpRequest(endpoint, payment);
    }

    public Map<String, String> handleGetCheckoutDetailsResponse(HttpResponse resp)
    {
      	return parseNvpResponse(resp);
    }
   
    public Map<String, String> parseNvpResponse(HttpResponse resp)
    {
        Integer status = resp.getStatusCode();
        
        if (status!=200) {
          String body = resp.getStatus()+' ';
          if (resp.getBody()!=null) body += resp.getBody();
          throw new PayPalException('Request failed ('+resp.getStatusCode()+'):'+body);  
        } 
        
        Map<String, String> data = new Map<String, String>();
        
        String ret = resp.getBody();
        data.put('XRESPDATA', ret);
        
        for (String nvp : ret.split('&')) {
            String[] a = nvp.split('=');
            data.put(a[0], EncodingUtil.urlDecode(a[1], 'UTF-8'));
        }

        if (data.get('ACK')!='Success') {
            String msg = '[Request Failed ('+data.get('ACK')+')]['+ret+']';
            throw new PayPalException(msg);
        }
        
      	return data;
    }
    
    
    public PayPalData.PaymentResponse handleCreatePaymentResponse(HttpResponse resp)
    {
        Integer status = resp.getStatusCode();
        
        if (status==201) {
            String responseData = resp.getBody();
        	PayPalData.PaymentResponse pr = (PayPalData.PaymentResponse)JSON.deserialize(responseData, PayPalData.PaymentResponse.class);
        	pr.rawResponse = responseData;
        	return pr;
        }
        else if (status==400||status==402) {
          String body = resp.getBody() == null ? resp.getStatus() : resp.getBody();
          throw new PayPalPaymentException ('PaymentDeclined ('+resp.getStatusCode()+'):'+body);  
        } 
        else {
          String body = resp.getStatus()+' ';
          if (resp.getBody()!=null) body += resp.getBody();
          throw new PayPalException('Request failed ('+resp.getStatusCode()+'):'+body);  
        } 
    }
    
    public Map<String, String> createNvpData()
    {	
        Map<String, String> payment = new Map<String, String>();
        payment.put('USER', settings.Gateway_Data_5__c);
        payment.put('PWD', settings.Gateway_Data_3__c);
        payment.put('SIGNATURE', settings.Gateway_Data_4__c);
        payment.put('VERSION', '93');
        return payment;
    }
    
    private HttpRequest buildRequest(String endpoint)
    {
    	HttpRequest req = new HttpRequest();
    	req.setMethod('POST');
        req.setTimeout(80000);
    	req.setEndpoint(endpoint);
     	req.setHeader('Content-Type', 'application/json');
     	req.setHeader('Authorization', 'Bearer '+getOAuthToken()); 
    	return req;
    }

    private HttpRequest buildJsonRequest(String endpoint, Object data)
    {
    	HttpRequest req = buildRequest(endpoint);
        req.setBody(JSON.serialize(data));
    	return req;
    }

    private HttpRequest buildNvpRequest(String endpoint, Map<String, String> data)
    {
    	HttpRequest req = buildRequest(endpoint);
        String nvp = '';
        for (String key : data.keySet()) {
            if (nvp.length()>0) nvp += '&';
            nvp += key + '=' + EncodingUtil.urlEncode(data.get(key), 'UTF-8'); 
        }
        req.setBody(nvp);
    	return req;
    }

    @TestVisible
    private String token = null;
    
    private String getOAuthToken()
    {
        if (token==null) {
            
            String client = settings.Gateway_Data_1__c;
            String secret = settings.Gateway_Data_2__c;
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setTimeout(4000);
            req.setEndpoint(getAuthEndpoint());
            req.setHeader('Accept', 'application/json');
            req.setHeader('Accept-Language', 'en_US');
            req.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(client+':'+secret)));
            req.setBody('grant_type=client_credentials');
    
            if ( Test.isRunningTest() ) { 
            
                token = 'xxx';
            
            } else {  	
            
                Http h = new Http();
                HttpResponse res = h.send(req);
                if (res.getStatusCode() != 200) throw new PayPalException('Authorization failed ('+res.getStatusCode()+'):'+res.getBody());
                
                JSONParser parser = JSON.createParser(res.getBody());
                PayPalData.OAuthResponse auth = (PayPalData.OAuthResponse)parser.readValueAs(PayPalData.OAuthResponse.class); 
                token = auth.access_token;
            
            }                
        }
        
        return token;
    }
    
    @testVisible
    private String getAuthEndpoint()
    {
        return getApiEndpointRoot()+'/v1/oauth2/token';
    }

    @testVisible
    private String getPaymentEndpoint()
    {
        return getApiEndpointRoot()+'/v1/payments/payment';
    }

    @testVisible
    private String getCheckoutEndpoint()
    {
        return getNvpEndpointRoot();
    }

    @testVisible
    private String getApiEndpointRoot()
    {
        return mode == MODE_LIVE ? 'https://api.paypal.com' : 'https://api.sandbox.paypal.com';
    }
    
    @testVisible
    private String getNvpEndpointRoot()
    {
        return mode == MODE_LIVE ? 'https://api-3t.paypal.com/nvp' : 'https://api-3t.sandbox.paypal.com/nvp';
    }
    
    @testVisible
    private String getCheckoutRedirectUrl(String token)
    {
        token = EncodingUtil.urlEncode(token, 'UTF-8');
        if (mode==MODE_LIVE) return 'https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token='+token;  
		return 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token='+token; 
    }
    
}