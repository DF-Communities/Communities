public class PayPalData 
{
    public static final String VISA = 'visa';
    public static final String AMEX = 'amex';
    public static final String MASTERCARD = 'mastercard';

    public virtual class PaymentData
    {
        public String cardType { get; set; }
        public String cardNumber { get; set; }
        public String cardholderName { get; set; }
        public String expiryMonth { get; set; }
        public String expiryYear { get; set; }
        public String cvv { get; set; }
        public String addressLine1 { get; set; }
        public String addressLine2 { get; set; }
        public String city { get; set; }
        public String postcode { get; set; }
        public String countryCode { get; set; }
        public String description { get; set; }
        public String amount { get; set; }
    }
    
    public class OAuthResponse
    {
        //Scopes expressed in the form of resource URL endpoints. The value of the scope parameter is expressed as a list of space-delimited, case-sensitive strings. 
        public String scope;
        //The access token issued by PayPal. The access token will expire (see expires_in), after which you’ll have to request a new access token. 
		public String access_token;
		//The type of the token issued as described in OAuth2.0 RFC6749, Section 7.1. Value is case insensitive. 
		public String token_type;
		//The lifetime in seconds of the access token. 
		public Integer expires_in;
    }
    
	public class CardPayment
    {
        //Payment intent. Must be set to sale for immediate payment, authorize to authorize a payment for capture later, or order to create an order. Required.
        private String intent = 'sale';	
        public String getIntent() { return intent; }
        public void setIntent(String value) { intent = value; }

        //Source of the funds for this payment. Required.
	    private CardPayer payer;
        public CardPayer getPayer() { return payer; }
        public void setPayer(CardPayer value) { payer = value; }

        //Transactional details including the amount and currency. Required.
		private SterlingTransaction[] transactions;
        public SterlingTransaction[] getTransactions() { return transactions; }
        public void setTransactions(SterlingTransaction[] value) { transactions = value; }
    }
    
    public class SterlingTransaction
    {
        //Amount being collected . Required.
        private Map<String, String>	amount = new Map<String, String>();	
        public String getTotal() { return amount.get('total'); }
        public void setTotal(String value) { amount.put('total', value); }
 
        //Description of transaction. 127 characters max.
		private String description = '';
        public String getDescription() { return description; }
        public void setDescription(String value) { description = value; }
        
        public SterlingTransaction()
        {
            amount.put('currency', 'GBP');
        }

        public SterlingTransaction(String total)
        {
            this();
            setTotal(total);
        }
        public SterlingTransaction(String total, String description)
        {
            this(total);
            if (description!=null) setDescription(description);
        }
    }
    
    public class CardPayer
    {
		//Payment method used. Must be either credit_card or paypal. Required.
		private String payment_method = 'credit_card';

        //array of funding_instrument objects	A list of funding instruments for the current payment
		private CreditCard[] funding_instruments;
        public CreditCard[] getFundingInstruments() { return funding_instruments; }
        public void setFundingInstruments(CreditCard[] value) { funding_instruments = value; }
        
        public CardPayer(CreditCard card)
        {
            funding_instruments = new List<CreditCard> {card};
        }
    }

    public class Address
    {
        //Line 1 of the Address (eg. number, street, etc). Required.
        private String line1 = '';
        public String getLine1() { return line1; }
        public void setLine1(String value) { line1 = value; }

        //Optional line 2 of the Address (eg. suite, apt #, etc.).
		private String line2 = '';
        public String getLine2() { return line2; }
        public void setLine2(String value) { line2 = value; }

        //City name. Required.
		private String city = '';
        public String getCity() { return city; }
        public void setCity(String value) { city = value; }

        //2 letter country code. Required.
		private String country_code = 'GB';
        public String getCountryCode() { return country_code; }
        public void setCountryCode(String value) { country_code = value; }

        //Zip code or equivalent. Required.
		private String postal_code = '';
        public String getPostcode() { return postal_code; }
        public void setPostcode(String value) { postal_code = value; }
    }
    
    public virtual class CreditCard
    {
        protected Map<String, Object> credit_card = new Map<String, Object>();
        
        //ID of the credit card. This ID is provided in the response when storing credit cards. Required if using a stored credit card.
        public String getId() { return (String)credit_card.get('id'); }
        public void setId(String value) { credit_card.put('id', value); }
        
        //Credit card number. Numeric characters only with no spaces or punctuation. The string must conform with modulo and length required by each credit card type. Redacted in responses. Required.
        public String getCard_number() { return (String)credit_card.get('number'); }
        public void setCard_number(String value) { credit_card.put('number', value); }
        
        //Credit card type. Valid types are: visa, mastercard, discover, amex Required.
        public String getCardType() { return (String)credit_card.get('type'); }
        public void setCardType(String value) { credit_card.put('type', value); }
        
        //Expiration month with no leading zero. Acceptable values are 1 through 12. Required.
        public Integer getExpireMonth() { return (Integer)credit_card.get('expire_month'); }
        public void setExpireMonth(Integer value) { credit_card.put('expire_month', value); }
        
        //4-digit expiration year. Required.
        public Integer getExpireYear() { return (Integer)credit_card.get('expire_year'); }
        public void setExpireYear(Integer value) { credit_card.put('expire_year', value); }
        
        //3-4 digit card validation code.
        public String getCvv2() { return (String)credit_card.get('cvv2'); }
        public void setCvv2(String value) { credit_card.put('cvv2', value); }
        
        //Cardholder’s first name.
        public String getFirstName() { return (String)credit_card.get('first_name'); }
        public void setFirstName(String value) { credit_card.put('first_name', value); }
        
        //Cardholder’s last name.
        public String getLastName() { return (String)credit_card.get('last_name'); }
        public void setLastName(String value) { credit_card.put('last_name', value); }
        
        //Billing address associated with card.
        public Address getAddress() { return (Address)credit_card.get('billing_address'); }
        public void setAddress(Address value) { credit_card.put('billing_address', value); }
    }
  
    public class AmountData
    {
         public String total { get; set; }
    }
    
    public class TransactionData
    {
         public AmountData amount { get; set; }
    }
    
    public class PaymentResponse
    {
         public String id { get; set; }
         public String state { get; set; }
         public String intent { get; set; }
         public String create_time { get; set; }
         public TransactionData[] transactions { get; set; }
         public String rawResponse { get; set; }
    }
    
}