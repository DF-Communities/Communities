public virtual class LightningUtils {
    
    public static String ltngCmpOriginUrl {get;set;}
    
    public static void getLightningHostUrl() {
        // This method gets the origin from which Lightning components are loaded
        // Using this will allow us to make corss-domain calls usin gthe browser postMessage() API
        // This allows us to communicate from a VF page to a Lightning Component
        
        Map<String,String> environmentUrlMap = DFEventTriggerMethods.getEnvironmentDomains();
        ltngCmpOriginUrl = environmentUrlMap.get('ltngCmpOriginDomain');
        
    }
    
}