public without sharing class DCE_RestConnector{
    
    /*
    	MOVE THE REST STUFF INTO SEPARATE CLASS AND THEN ALSO MOVE THE FOLLOWING
    	1) The endpoint URL
    	3) Find out if there's an issue with multiple requests in quick succession - i.e. when moving between pages - Or if the extranet is used by multiple people
    */
    
    private set<integer> successCodes = new set<integer>{200,201,202,203,204,205,206,207,208,226};
    
    public Http http {get; private set;}
    public HttpRequest req{get; private set;}
    public httpResponse res{get; private set;}
    public boolean restError{
    	get{
    		if(restError != null){ return restError; }
    		
    		restError = false;
    		return restError;
    		
    	} 
    	private set;
    }
    public string restErrorMessage{get; private set;}
    
    public string authenticationToken{
    	
    	public get{
    		
    		if(authenticationToken != null) { return authenticationToken; }
    		
    		system.debug('HERE IS THE CURRENT PAGE - '+ApexPages.currentPage());
    		if(ApexPages.currentPage() != null && ApexPages.currentPage().getCookies() != null){
    			system.debug('HERE IS THE AUTHTOKEN AS A COOKIE - '+ApexPages.currentPage().getCookies().get('authToken'));
    		
	    		Cookie authCookie = ApexPages.currentPage().getCookies().get('authToken');
	    		
	    		if(authCookie != null && authCookie.getValue() != null && authCookie.getValue() != ''){
	    			authenticationToken = ApexPages.currentPage().getCookies().get('authToken').getValue();
	    			return authenticationToken;
	    		}
    		}
    		
    		Http http = new Http();
    		
    		HttpRequest login = new HttpRequest();
    		
    		string endpoint = Community_Settings__c.getInstance('DCE_RestEndpoint').value__c+'/services/oauth2/token?';
    		
    		endpoint+='grant_type=password&';
    		endpoint+='client_id='+WEBC_CommunityWrapper.getCustomSetting('Client_ID','DCE')+'&';
    		endpoint+='client_secret='+WEBC_CommunityWrapper.getCustomSetting('Client_Secret','DCE')+'&';
    		endpoint+='username='+EncodingUtil.urlEncode(WEBC_CommunityWrapper.getCustomSetting('Username','DCE'), 'UTF-8')+'&';
    		endpoint+='password='+EncodingUtil.urlEncode(WEBC_CommunityWrapper.getCustomSetting('Password','DCE'), 'UTF-8');
    		
    		login.setEndPoint(endpoint);
    		login.setMethod('POST');
    		
    		system.debug('Are we here?');
    		HttpResponse res = http.send(login);
    		
    		if(res.getStatusCode() != 200){
    			
    			system.debug('Authentication Error');
    			
    			restErrorMessage = 'There has been an error authenticating this session with the Dementia Connect database. Please contact your administrator with the following error details:<ul><li><strong>Error Code: </strong>'+res.getStatusCode()+'</li><li><strong>Error Message: </strong>'+res.getStatus()+'</li>';  			
    			restError = true;
    			return 'AUTHERROR';
    		}
    		
    		try{
	    		system.debug('Here is the response - '+res);
	    		system.debug('Here is the response body - '+res.getbody());
	    		
	    		map<string, Object> m = (map<string, Object>)JSON.deserializeUntyped(res.getbody());
	    		
	    		system.debug('Here is the map - '+m);
	    		
	    		authenticationToken = (string)m.get('access_token');
    		} catch (Exception e){
    			restErrorMessage = '<strong>Error Code: [DCE-554]</strong> There has been an error authenticating this session with the Dementia Connect database. Please contact your administrator.';  			
    			restError = true;
    			return 'AUTHERROR';
    		}
    		
    		system.debug('Here is the token - '+authenticationToken);
    		
    		if(ApexPages.currentPage() != null){
	    		Cookie authCookie = new Cookie('authToken', authenticationToken, null, -1, true);
	    		
	    		system.debug('SETTING THE COOKIE - '+authCookie);
	    		ApexPages.currentPage().setCookies(new list<Cookie>{authCookie});
    		}
    		
    		return authenticationToken;
    	}
    	
    	private set;  	
    	
    }
    
    
    //Constructor for get requests
    public DCE_RestConnector(string endpoint, string requestType){
    	
    	res = response(endpoint, requestType, null, null);
	    	
    	if(!restError){
	    	if(successCodes.contains(res.getStatusCode())){
	    		restError = false;
	    	} else {
	    		restError = true;
	    		restErrorMessage = 'There has been an error contacting the Dementia Connect database. Please contact your administrator with the following error details:<ul><li><strong>Error Code: </strong>'+res.getStatusCode()+'</li><li><strong>Error Message: </strong>'+res.getStatus()+'</li>';
			}
    	}
    	
    }
	
	//Constructor for POST requests to update records in Dementia Connect
	public DCE_RestConnector(string endpoint, string requestType, SObject recordForUpdate, map<string, string> fieldmappings){
    	
		map<string, string> headers = new map<string, string>();
    	headers.put('Content-Type', 'application/json; charset=UTF-8');
    	headers.put('Accept','application/json');
    	
    	JSONGenerator gen = JSON.createGenerator(true);
		
		gen.writeStartObject();
		
		gen.writeObjectField('Sobject', SObjectNameMap.get(recordForUpdate.id.getSObjectType().getDescribe().getName()));
		gen.writeFieldName('Fields');
		gen.writeStartObject();
		
		for(string fieldName : fieldmappings.keySet()){
			system.debug('Amends field - '+fieldName);
			system.debug('Value in field - '+recordForUpdate.get(fieldName));
			system.debug('Field in production - '+fieldmappings.get(fieldName));
			
			string field = fieldmappings.get(fieldName);
			
			if(recordForUpdate.get(fieldName) != null){
				gen.writeObjectField(field, recordForUpdate.get(fieldName));
			} else {
				gen.writeNullField(field);
			}
		}
		
		gen.writeEndObject();
		gen.writeEndObject();
		
		system.debug('HERE IS THE GENERATED JSON - '+gen.getAsString());
    	
    	res = response(endpoint, requestType, gen.getAsString(), headers);
    	
    	if(!restError){
	    	if(successCodes.contains(res.getStatusCode())){
				restError = false;
	    	} else {
				restError = true;
				restErrorMessage = res.getBody();
			}
    	}
	}
	
	HttpResponse response (string endpoint, string requestType, string body, map<string, string> headers){
		http = new Http();
    	req = new HttpRequest();
    	
    	req.setEndPoint(endpoint);
    	req.setMethod(requestType);
    	req.setHeader('Authorization', 'OAuth '+authenticationToken);
    	
    	if(headers != null){
	    	for(string key : headers.keySet()){
	    		req.setHeader(key, headers.get(key));
	    	}
    	}
    	
    	if(body != null){ req.setBody(body); }
    	
    	if(authenticationToken == 'AUTHERROR'){ return null; }
			
		HttpResponse response =  http.send(req);
		
		if(response.getStatusCode()==401){
			
			//Clear the authentication token
			authenticationToken = null;
			
			//Clear the authcookie
			Cookie authCookie = new Cookie('authToken', null, null, -1, true);
    		system.debug('CLEARING THE COOKIE - '+authCookie);
    		ApexPages.currentPage().setCookies(new list<Cookie>{authCookie});
    		
    		//Re-Set authentication token
    		req.setHeader('Authorization', 'OAuth '+authenticationToken);
    		
    		response =  http.send(req);
		}
		
		system.debug('HERE IS THE REQUEST - '+req);
		system.debug('HERE IS THE BODY - '+req.getbody());
		
		return  response;
    	
	}
	
	//Maps the Portal SObjects to the SObjects they will be updating in Dementia Connect
	private map<string, string> SObjectNameMap{
		
		private get{
			if(SObjectNameMap != null){ return SObjectNameMap; }
			
			SObjectNameMap = new map<string, string>();
			SObjectNameMap.put('DCE_ServiceAmend__c', 'Services__c');
			SObjectNameMap.put('DCE_OrgAmend__c', 'Account');
			
			return SObjectNameMap;
		}
		
		private set;
	}
}