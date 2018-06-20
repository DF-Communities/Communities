public class CkeMailClient 
{
	private static final String ENDPOINT = 'https://api.notificationmessaging.com/NMSXML';
    
    public static final Template TEST_TEMPLATE = new Template('D2A402000131A169', 'EdX7Cqkmlzt08SA9MOPvHX-jKj1-HK_D-jjceKhHWcbQKB4');
    public static final Template PAYIN_CONFIRM_TEMPLATE = new Template('98080000D6D8C712', 'EdX7CqkmlyJc8SA9MOPvHX_eIExyHK3D-kzbD6FFX8HbKMQ');
    public static final Template DONATION_CONFIRM_TEMPLATE = new Template('C54C3DC4A6020C54', 'EdX7CqkmlyJb8SA9MOPvHX-kLUgJH9mw_knbe6s2K8XdKP0');
    public static final Template PACK_CONFIRM_TEMPLATE = new Template('9B09FCE153010009', 'EdX7CqkmlyJA8SA9MOPvHX_eWkxzat62-z3ee6g2WMDQKN8');
    
    // THIS IS USING THE NEW EMAIL FOR 2017 REGISTERING INTEREST
    public static final Template REGISTER_INTEREST_TEMPLATE = new Template('867F5B1554040000', 'EdX7CqkmlxXs8SA9MOPvHX_fLksMGd_C_z3Ze602WMDZK5o'); 

    public String sendTestMail(String email, String firstName, Decimal amount)
    {
        Map<String, String> dyn = new Map<String, String>();
        dyn.put('firstname', firstName);
        dyn.put('amount', amount.format());
        return sendMail(email, TEST_TEMPLATE, dyn);
    }
    
    public String sendPackConfirmationMail(String email, String firstName, Integer etaDays)
    {
        Map<String, String> dyn = new Map<String, String>();
        dyn.put('firstname', firstName);
        dyn.put('etadays',etaDays.format());
        return sendMail(email, PACK_CONFIRM_TEMPLATE, dyn);
    }

    public String sendPayinConfirmationMail(String email, String firstName, Decimal amount, String tranref)
    {
        Map<String, String> dyn = new Map<String, String>();
        dyn.put('firstname', firstName);
        dyn.put('amount',amount.format());
        dyn.put('tranref', tranref);
        return sendMail(email, PAYIN_CONFIRM_TEMPLATE, dyn);
    }
    
    public String sendDonationConfirmationMail(String email, String firstName, Decimal amount, String tranref)
    {
        Map<String, String> dyn = new Map<String, String>();
        dyn.put('firstname', firstName);
        dyn.put('amount',amount.format());
        dyn.put('tranref', tranref);
        return sendMail(email, DONATION_CONFIRM_TEMPLATE, dyn);
    }

    public void sendPaymentConfirmationMail(Cke_Payment__c pmt)
    {
       try {
          CkeMailClient.Template template;
          if (pmt.Type__c == CkePaymentController.TYPE_PAYIN) template = CkeMailClient.PAYIN_CONFIRM_TEMPLATE;
          else if (pmt.Type__c == CkePaymentController.TYPE_DONATION) template = CkeMailClient.DONATION_CONFIRM_TEMPLATE;
          else throw new CkeException('Invalid payment type:'+pmt.Type__c);
          Map<String, String> dyn = new Map<String, String>();
       	  dyn.put('firstname', pmt.First_Name__c);
          dyn.put('amount', formatAmount(pmt.Amount__c));
          dyn.put('tranref', pmt.Transaction_Id__c);
          sendMail(pmt.Email__c, template, dyn);
          pmt.Confirmation_Sent__c = true;
       }
       catch (Exception e){
          pmt.Extended_Status__c += '||EMAIL SEND FAILURE:['+e.getMessage()+']['+e.getStackTraceString()+']';   
       }
    }

  public String sendRegisterInterestConfirmationMail(String email, String firstName)
    {
        Map<String, String> dyn = new Map<String, String>();
        dyn.put('firstname', firstName);
        return sendMail(email, REGISTER_INTEREST_TEMPLATE, dyn);
    }


	private String formatAmount(Decimal amt)
    {
        String s = amt.format();
        if (s.contains('.') && s.indexOf('.')==s.length()-2) s += '0';
        return s;
    }
    
    public String sendMail(String email, Template msg, Map<String, String> dyn)
    {
        SendRequest req = new SendRequest(email, msg, dyn);
        return sendMail(req);
    }
    
    public String sendMail(SendRequest request)
    {
        return sendMail(new List<SendRequest>{ request });
    }
    
    public String sendMail(SendRequest[] requests)
    {
		String xml = '<?xml version="1.0" encoding="UTF-8"?>';
		xml += '<MultiSendRequest>';
        for (SendRequest req : requests) {
            xml += req.toXml();
        }
		xml += '</MultiSendRequest>';
    	return postRequest(xml);
    }
    
    public class SendRequest
    {
        public String email { get; set; }
        public Template template { get; set; }
        public Map<String, String>  dyn { get; set; }
        
        public SendRequest(String email, Template template, Map<String, String> dyn)
        {
            this.email = email;
            this.template = template;
            this.dyn = dyn;
        }
        
        public String toXml()
        {
			String buf = '';            
            buf += '<sendrequest>';
			buf += '<dyn>';
            for (String key : dyn.keySet()) {
				buf += '<entry>';
		        buf += '<key>'+key+'</key>';
		        buf += '<value>'+dyn.get(key)+'</value>';
				buf += '</entry>';
            }            
            buf += '</dyn>';
           	buf += '<email>'+email+'</email>';
           	buf += '<encrypt>'+template.securityTag+'</encrypt>';
           	buf += '<random>'+template.uniqueId+'</random>';
           	buf += '<senddate>2010-01-01T00:00:00</senddate><synchrotype>NOTHING</synchrotype>';
           	buf += '</sendrequest>';
           return buf;
        }
    }
    
    public class Template
    {
        public String UniqueId { get; private set; }
        public String SecurityTag { get; private set; }
        
        public Template(String id, String tag)
        {
            this.UniqueId = id;
            this.SecurityTag = tag;
        }
    }
    
    private String postRequest(String xml)
    {
    	HttpRequest req = new HttpRequest();
    	req.setMethod('POST');
        req.setTimeout(4000);
    	req.setEndpoint(ENDPOINT);
     	req.setHeader('Content-Type', 'application/xml');
        req.setBody(xml);

	    Http h = new Http();
    	HttpResponse res = h.send(req);
        if (res.getStatusCode()!=200) {
          String body = res.getBody() == null ? res.getStatus() : res.getBody();
          throw new CkeException('Request failed ('+res.getStatusCode()+'):'+body);  
        } 
        
   		return res.getBody();
    }
    
}