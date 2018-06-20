public class DF_GoogleMapsController {
    
    public String mapsApiKey {get;set;}
    
    public class DF_GoogleMapsControllerException extends Exception{}
    
    public DF_GoogleMapsController() {
        
        //getMapsApiKey();
        mapsApiKey = 'AIzaSyC6dHKnrwyIbJcqW4CS9VPlYF4LBNJywg0';
        
    }
    
    public void getMapsApiKey() {
        
        try {
            // Get the API Key from custom settings
            String key = [SELECT Name, Value__c 
                          FROM Global_Setting__c
                          WHERE Name='GoogleMapsApiKey'].Value__c;
            
            mapsApiKey = key;
            
        } catch(Exception e) {
            throw new DF_GoogleMapsControllerException('The GoogleMapsApiKey entry could not be found in the Global Settings custom setting. Please add it');
        }
    }
    
}