public class GoogleMapsUtils {
    public String duration {get;set;}
    public Integer travelTime {get;set;}
    //public Decimal distance {get;set;}
    public String distance {get; set;}

    public GoogleMapsUtils(
            String address1,
            String address2) {
                
        String jsonResults = getJsonResults(address1, address2);
        jsonResults = formatJsonResults(jsonResults);
        updateJsonSections(jsonResults);
    }

    public String getJsonResults(
            String address1,
            String address2) {
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setMethod('GET');
        
        String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
            + '?origins=' + address1
            + '&destinations=' + address2
            + '&mode=driving'
            + '&sensor=false'
            + '&language=en'
            + '&units=imperial';
            
        req.setEndPoint(url);
        
        system.debug('*** -- About to send ' + req + ' -- ***');
        HTTPResponse resp = http.send(req);
        
        system.debug('*** -- returned body ' + resp.getBody() + ' -- ***');
        
        String jsonResults = resp.getBody().replace('\n', '');

        return jsonResults;
    }
    
    public String formatJsonResults(String value) {
        
        value = value.replace('{', ', ');
        value = value.replace('}', ', ');
        value = value.replace('[', ', ');
        value = value.replace(']', ', ');
        value = value.replace('"', '');
        
        return value;   
    }
    
    public void updateJsonSections(
        String jsonResults) {
        
        List<String> jsonSections = jsonResults.split(', ');
        
        
        for (Integer i = 0; i < jsonSections.size(); i++) {
            system.debug('*** -- jsonSection = ' + jsonSections[i].trim() + ' -- ***');
            jsonSections[i] = jsonSections[i].trim();
            
            if (jsonSections[i].contains('duration:')) {
                duration = parseDuration(jsonSections[i + 2]);
                travelTime = parseTravelTime(duration);
            }
            
            if (jsonSections[i].contains('distance:')) {
                //distance = parseDistance(jsonSections[i + 2]);
                //distance = parseDistance(jsonSections[i + 1]);
                distance = jsonSections[i + 1];
            }
        }
    }

    public Decimal parseDistance(String value) {
        value = value.replace('text: ', '');
        value = value.replace(' mi', '');
        value = value.replace(' ft', '');
        value = value.replace(',', '');
        value = value.trim();
        
        return Decimal.valueOf(value);
    }
    
    public String parseDuration(String value) {
        value = value.replace('text: ', '');
        
        return value;
    }
    
    public Integer parseTravelTime(String value) {
    
        Integer tmpMinutes = 0;
    
        List<String> durationNodes = value.split(' ');
        String prevDurationNode = '';
        
        for (String durationNode : durationNodes) {
            if (durationNode == 'day' || durationNode == 'days') {
                tmpMinutes += Integer.valueOf(prevDurationNode) * 1440;
            }
            if (durationNode == 'hour' || durationNode == 'hours') {
                tmpMinutes += Integer.valueOf(prevDurationNode) * 60;
            }
            if (durationNode == 'min' || durationNode == 'mins') {
                tmpMinutes += Integer.valueOf(prevDurationNode);
            }
            
            prevDurationNode = durationNode;
        }
    
        return tmpMinutes;  
    }
    
   public testmethod static void GoogleMapsTest()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        String address1='Los Angles';
        String address2='Dallas';
        String jsonResults ='';
        GoogleMapsUtils  Gmaputil=new GoogleMapsUtils(address1,address2);
        Gmaputil.parseDistance('1234');
        Gmaputil.parseTravelTime('12');
        Gmaputil.parseDuration('2');
        
    }
    
}