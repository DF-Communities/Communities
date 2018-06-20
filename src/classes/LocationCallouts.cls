public class LocationCallouts {
    
     @future (callout=true)  // future method needed to run callouts from Triggers
      static public void getLocation(id searchid){
        // gather saved search info
        Saved_Search__c savedsearch = [SELECT Post_Code__c FROM Saved_Search__c WHERE id =: searchid];
        system.debug('test input'+savedsearch);
        // create an address string
        String address = '';
        if (savedsearch.Post_Code__c != null)
            address += savedsearch.Post_Code__c +', ';
        system.debug('test address string'+address);
            
        address = EncodingUtil.urlEncode(address, 'UTF-8');
            
        // build callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCt8-YgkPglTjv7i7hWe01-M3JUZF1VshM&address='+address+'&sensor=false');
        req.setMethod('GET');
        req.setTimeout(60000);
      
        try{  
            // callout
           system.debug('Request http test'+req);
            HttpResponse res = h.send(req);
            system.debug('response http testt'+res);
            // parse coordinates from response
            system.debug('resposnse get body method'+res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            double lat = null;
            double lon = null;
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'location')){
                       parser.nextToken(); // object start
                       while (parser.nextToken() != JSONToken.END_OBJECT){
                           String txt = parser.getText();
                           parser.nextToken();
                           if (txt == 'lat')
                               lat = parser.getDoubleValue();
                           else if (txt == 'lng')
                               lon = parser.getDoubleValue();
                       }
                    
                }
            }
            
             system.debug('test address lat'+lat);
             system.debug('test address long'+lon);
            // update coordinates if we get back 
            if (lat != null){
                savedsearch.Geolocation__Latitude__s = lat;
                savedsearch.Geolocation__Longitude__s = lon;
                update savedsearch;        
            }    
           
        } catch (Exception e) {
        }   
    }
    
     @future (callout=true)  // future method needed to run callouts from Triggers
      static public void getLocationForEvent(id searchid){
      	List<DF_Event__c> eventList = new List<DF_Event__c>();
        // gather saved search info
        eventList = [SELECT Postcode__c FROM DF_Event__c WHERE id =: searchid LIMIT 1];
        DF_Event__c theEvent;
        if (eventList.size() > 0) {
        	theEvent = eventList[0];
        
	        system.debug('test input'+theEvent);
	        // create an address string
	        String address = '';
	        if (theEvent.Postcode__c != null)
	            address += theEvent.Postcode__c +', ';
	        system.debug('test address string'+address);
	            
	        address = EncodingUtil.urlEncode(address, 'UTF-8');
	            
	        // build callout
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        //req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
	        req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCt8-YgkPglTjv7i7hWe01-M3JUZF1VshM&address='+address+'&sensor=false');
	        req.setMethod('GET');
	        req.setTimeout(60000);
	      
	        try{  
	            // callout
	           system.debug('Request http test'+req);
	            HttpResponse res = h.send(req);
	            system.debug('response http testt'+res);
	            // parse coordinates from response
	            system.debug('resposnse get body method'+res.getBody());
	            JSONParser parser = JSON.createParser(res.getBody());
	            double lat = null;
	            double lon = null;
	            while (parser.nextToken() != null) {
	                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
	                    (parser.getText() == 'location')){
	                       parser.nextToken(); // object start
	                       while (parser.nextToken() != JSONToken.END_OBJECT){
	                           String txt = parser.getText();
	                           parser.nextToken();
	                           if (txt == 'lat')
	                               lat = parser.getDoubleValue();
	                           else if (txt == 'lng')
	                               lon = parser.getDoubleValue();
	                       }
	                    
	                }
	            }
	            
	             system.debug('test address lat'+lat);
	             system.debug('test address long'+lon);
	            // update coordinates if we get back 
	            if (lat != null){
	            	
	                theEvent.Location_Geographic_Details__Latitude__s = lat;
	                theEvent.Location_Geographic_Details__Longitude__s = lon;
	                update theEvent;        
	            }    
	           
	        } catch (Exception e) {
	        }   
        }
    }
}