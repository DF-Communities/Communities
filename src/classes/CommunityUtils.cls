/*
* Class with certain utility methods for Salesforce communities
*/
public class CommunityUtils {
    
    public class CommunityUtilsException extends Exception {}
    
    public static Map<String,String> getEnvironmentDomains() {
        
        Map<String, String> domainMap = new Map<string, String>();
        // Get the Dementia Friends communtiy base URL
        Network[] network = [SELECT Id, Name, UrlPathPrefix 
                             FROM Network 
                             WHERE Name ='Dementia Friends'];
        System.debug(network);
        
        Domain[] domains = [SELECT Domain, DomainType FROM Domain];
        System.debug(domains);
        
        for(Domain d : domains) {
            if(d.Id == network[0].Id) {
                System.debug('Selecting Community URL as: ' + d.Domain);
                domainMap.put('communityDomain', d.Domain);
            }
        }
        
        // Get the internal domain
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        domainMap.put('internalDomain', baseUrl);
        System.debug('baseUrl =' + baseUrl);
        
        System.debug('Returning map: ' + domainMap);
        
        return domainMap;
        
    }
    
    /*
     * Info sessions must have hte session organiser field populated.
     * This is set to a placeholder contact until a champion signs up to the session
    */
    public static Id getDfCommunityPlaceholderContactId() {
        
        Id dfContactId = null;
        Community_Settings__c[] setting = [SELECT Value__c 
                                           FROM Community_Settings__c 
                                           WHERE Name = 'DF_Placeholder_InfoSessionOrganiser'];
        
        if(setting.size() != 1) {
            throw new CommunityUtilsException('Please set the DF_Placeholder_InfoSessionOrganiser ' + 
                                              'setting to the Community Settings custom setting');
        } else {
            dfContactId = setting[0].Value__c;
        }
        
        return dfContactId;
        
    }
    
    public static Boolean createCommunityUserAndSendWelcomeEmail(Id dfContactId, String password) {
        
        try {
            string var = '?cp=true';
            string startUrl='/change-password'+var;
            string templateName ='Custom_Verification_Request';
            WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');                 
            Contact contact=  DF_Utils.getContactRecordForDfcId(dfContactId);  
            community.sendVerificationRequest(contact, password, startUrl, templateName);
            
            return true;
        } catch(Exception e) {
            
            return false;
        }
        
    } 
	
    public static String getInternalSalesforceUrl() {
        
        String instanceInternalUrl = null;
        Organization orgDetails = [SELECT Name, InstanceName, NamespacePrefix, IsSandbox FROM Organization];
    
        if(orgDetails.IsSandbox) {
            
            System.debug('Determinging Sandbox name: ' + URL.getSalesforceBaseUrl().getHost());
            String sandboxName = URL.getSalesforceBaseUrl().getHost().substringBetween('--','.');
            
            if(sandboxName == null) {
                sandboxName = URL.getSalesforceBaseUrl().getHost().substringBefore('-');
            }
            
            if(sandboxName == null) {
                throw new CommunityUtilsException('Could not determine the internal URL from the CommunityUtils class method');
            }
            instanceInternalUrl = 'alzheimerscommunities--' + sandboxName + '.' + orgDetails.InstanceName + '.my.salesforce.com';
        
        } else {
            instanceInternalUrl = 'alzheimerscommunities.' + orgDetails.InstanceName + '.my.salesforce.com';
        }
    
        return instanceInternalUrl;    
    }
    
    /*public static void setPageLoadModalNotification(Id champDfContactId, Integer noEventsInChampRadius) {
        
        String TITLE = 'There are info sessions in your area';
        String MESSAGE = 'There are info sessions without an assigned champion within your search radius';
        
        Push_Notifications__c[] existingInfoSessionModal = [SELECT Id 
                                                            FROM Push_Notifications__c
                                                            WHERE Title__c = :TITLE];
        
        / Create the push notification to be presented to the user on next page load in
        if(noEventsInChampRadius > 0) {
        pn= new Push_Notifications__c();
        
        pn.Message__c = MESSAGE;
        pn.DF_Contact__c=champDfContactId;
        pn.Status__c = 'Unread'; // Should pop up every time
        pn.Title__c = TITLE;
        pn.Button_title__c = BTN_TITEL;
        pn.Button_link__c = btnLink;
    }*/
}