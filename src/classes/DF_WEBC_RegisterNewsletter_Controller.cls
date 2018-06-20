/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Handler Class for Newsletter Sign up
 *  Author  : Gary Grant
 *  Date    : 07/02/2015
 *  Version : 0.1 Unit Test
 *
 *  Description: 
 *               
 *  Modification History
 *  Date            Who         Description 
                            
*******************************************************************************************/

 public without sharing class DF_WEBC_RegisterNewsletter_Controller extends WEBC_ControllerBase {
   
    public Page_Snippet__c newsletterSignupText {
    
        get {
            if (newsletterSignupText == null){
            	
            	system.debug( 'Got Newsletter Sign up Snipptet : ' + DF_Utils.NEWSLETTER_SIGNUP_SNIPPET_NAME);            	
                List<Page_Snippet__c> lisTexts = [Select p.Unique_Name__c, p.Name__c, p.Name, p.Id, p.Body_Text__c From Page_Snippet__c p where p.Unique_Name__c = : DF_Utils.NEWSLETTER_SIGNUP_SNIPPET_NAME LIMIT 1];

				if ( !lisTexts.isEmpty() ) { 
					newsletterSignupText = lisTexts[0];
				}
                
            }
            
            return newsletterSignupText;
        }
        set;
    
    }
    
  	private WEBC_CommunityWrapper community { get;set; }

	public String userid {get;set;}
	public String firstName {get;set;}
	public String lastName {get;set;}
	
	public String emailAddress {get;set;}
	public String emailAddress2 {get;set;}

	public Boolean newsletter {get;set;}
	public User APIUser {get; set;}

	//Constructor
	public DF_WEBC_RegisterNewsletter_Controller() {

		system.debug('WEBC_RegisterFriend_Loggin : Entering Constructor');

	    /* Set up utitlity objects */ 
        community = new WEBC_CommunityWrapper('DF');        
		
		// Set the default value to true	
        newsletter = true;        
	
	}

    public PageReference reset() {
        return null; 
    }   

}