global class DCE_UrlReWriter implements Site.UrlRewriter {

	global PageReference mapRequestUrl(PageReference shortUrl ) {
		
        try {
        
			system.debug('ShortUrl - '+shortUrl);
            
			String url = shortUrl.getUrl();
			system.debug('DCE_UrlReWriter : ' + url);

			String[] splitURL = url.split('/');
            
            system.debug('splitURL - '+splitURL);
            
            String redirectUrl = urlMappings.get('/'+splitURL[1]);
            
            system.debug('redirectUrl - '+redirectUrl);
            system.debug('splitURL.size() - '+splitURL.size());
            if(redirectUrl == null){ return null;}
            
            if ( splitURL.size() == 2 ) { return new PageReference(redirectUrl); }
            
            if(redirectUrl == '/DCE_NewUserRegister'){
				return signUpHandler(shortUrl);
            }
            
            system.debug('Not /DCE_NewUserRegister');
            
            if(redirectUrl.startsWith('/DCE_Service')){
				system.debug('It is a service');
				return servicePageHandler(shortUrl);
            }
            
            system.debug('Something else happened here');
            return new pageReference('/DCE_Dashboard');
            
		} catch ( Exception x ) {

            //system.debug('DF_WEBC_UrlRewriter' + x.getMessage());
            //return new pageReference('/DCE_Dashboard');
            return null;

        }
       
		return null;
    }

	private pageReference signUpHandler(PageReference shortUrl){
		system.debug('About to get the user contactId');
		
		String url = shortUrl.getUrl();
		
		string contactId = url.replace('/sign-up/','');
		
		url = 'DCE_NewUserRegister?cid='+EncodingUtil.urlEncode(contactId, 'UTF-8');
		
		system.debug('HERE IS THE URL RETURNED - '+url);
		
		return new PageReference(url);
		
	}
	
	private pageReference servicePageHandler(PageReference shortUrl){
		
		String[] splitURL = shortUrl.getUrl().split('/');
		
		String redirectUrl = urlMappings.get('/'+splitURL[1]);
		
		list<DCE_ServiceAmend__c> amends = [select id from DCE_ServiceAmend__c where portalServiceNumber__c = :splitURL[2]];
            	
		if(amends.size() == 0){ return new pageReference('/DCE_Dashboard'); }
            	
		system.debug('returned - '+redirectUrl+'?aid='+amends[0].id); 
		return new PageReference(redirectUrl+'?aid='+amends[0].id);
	
	}
	
	/*Mappings to convert user friendly urls into VF Page names*/
    public static map<string, string> urlMappings{
    	private get{
    		if(urlMappings != null){ return urlMappings; }
    		
    		urlMappings = new map<string, string>();
    		
    		urlMappings.put('/home', '/DCE_Dashboard');
    		urlMappings.put('/login', '/DCE_LoginPage');
    		urlMappings.put('/Request', '/DCE_newOrgRequest');
    		urlMappings.put('/Thank-you', '/DCE_NewOrgRequestConfirm');
    		urlMappings.put('/sign-up', '/DCE_NewUserRegister');
    		urlMappings.put('/our-details', '/DCE_OrgDetails');
    		urlMappings.put('/ServiceEdit', '/DCE_ServiceEdit');
    		urlMappings.put('/ServiceView', '/DCE_ServiceView');
    		urlMappings.put('/my-details', '/DCE_UserDetails');
            urlMappings.put('/privacy', '/DCE_privacyNotice');
    		
    		
    		return urlMappings;
    	}
    	
    	private set;
    }
    
    /*Mappings to reverse the above*/
    public static map<string, string> reverseUrlMappings{
    	private get{
    		if(reverseUrlMappings != null){ return reverseUrlMappings; }
    		
    		
    		reverseUrlMappings = new map<string, string>();
    		
    		for(string s : urlMappings.keySet()){
    			
    			string value = urlMappings.get(s);
    			reverseUrlMappings.put(value, s);
    		}
    		
    		
    		return reverseUrlMappings;
    	}
    	
    	private set;
    }

    /*This method takes all of the VF page references on the page and converts them into user friendly URLs*/
    global list<PageReference> generateUrlFor(list<PageReference> mySalesforceUrls) {
        
        list<PageReference> myFriendlyUrls = new list<PageReference>();

        list<Id> sIds = new list<Id>();
        
        //Find any references to a specific service id and put them into a list
        for(PageReference mySalesforceUrl : mySalesforceUrls){
        	
        	if(mySalesforceUrl.getUrl().contains('aid=')){
        		
        		integer urlStart = mySalesforceUrl.getUrl().indexOf('aid=')+4;
        		
        		if(mySalesforceUrl.getUrl().substringAfter('aid=').length()<18){ continue; }
        		
        		system.debug('Here is the portion of URL = '+mySalesforceUrl.getUrl().substring(urlStart, urlStart+18));
        		sIds.add(mySalesforceUrl.getUrl().substring(urlStart, urlStart+18));
        		
        	}
        	
        }
        
        //From the above loop, get all of the services and their Autonumbers
        map<id, DCE_ServiceAmend__c> services = new map<id, DCE_ServiceAmend__c>([select id, portalServiceNumber__c from DCE_ServiceAmend__c where id IN :sIds]);
        
        //convert the VF page references into their friendly counterparts
        for(PageReference mySalesforceUrl : mySalesforceUrls){
        
        	string url = mySalesforceUrl.getUrl();
        	
        	system.debug('DCE_UrlReWriter : ' + url);

			String[] vUrl = url.split('\\?');
            
            String baseUrl = vUrl[0];
            
            system.debug('vUrl - '+vUrl);
            system.debug('baseUrl - '+baseUrl);
            
            if(reverseUrlMappings.containsKey(baseUrl)){
            	
            	string redirectUrl = reverseUrlMappings.get(baseUrl);
            	
            	if ( vUrl.size() == 1 ) {
					myFriendlyUrls.add(new pageReference(redirectUrl));
					system.debug('Returned url 1 - '+redirectUrl);
					continue;
	            }
	            
	            if(mySalesforceUrl.getUrl().contains('aid=')){
	            	
	            	integer urlStart = mySalesforceUrl.getUrl().indexOf('aid=')+4;
	            	
	            	if(mySalesforceUrl.getUrl().substringAfter('aid=').length()<18){ 
	            		myFriendlyUrls.add(new pageReference('/home'));
	            		continue; 
	            	}
	            	
	            	string aid = mySalesforceUrl.getUrl().substring(urlStart, urlStart+18);
	            	
	            	if(!services.containsKey(aid)){
	            		myFriendlyUrls.add(new pageReference('/home'));
	            		continue; 
	            	}
	            	
	            	String sNewUrl = redirectUrl + '/' + services.get(aid).portalServiceNumber__c;
	            	
	            	myFriendlyUrls.add(new pageReference(sNewUrl));
					system.debug('Returned url 1.5 - '+redirectUrl);
					continue;
	            }
	            
				String sNewUrl = redirectUrl + '?' + vUrl[1];
            	
            	system.debug('Returned url 2 - '+sNewUrl);
            	myFriendlyUrls.add(new pageReference(sNewUrl));
            	continue;
			} 
            
            system.debug('Returned url 3 - '+mySalesforceUrl);
            myFriendlyUrls.add(mySalesforceUrl);
            	
        }
        
        system.debug('HEre are the friendly URLS - '+myFriendlyUrls);
        return myFriendlyUrls;
		//return null;
		
    }
    
}