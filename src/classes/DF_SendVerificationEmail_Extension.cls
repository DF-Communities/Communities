/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : This can be use to send verify email to users who hasn't recieved the verify email
 *          :this sets a password for user so user must change their password
 *  Author  : Lakshmi Vasudevan
 *  Date    : July 2016
 *  Version : 
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 

*******************************************************************************************/ 

public class DF_SendVerificationEmail_Extension {

private final DF_Contact__c dfc{get;set;}  
private string password = 'dfReg1234';
    public DF_SendVerificationEmail_Extension(ApexPages.StandardController stdController) {    
      
       this.dfc = (DF_Contact__c)stdController.getRecord();
        
    }
    
    public pagereference sendVerificationEmail() {
      //as we are setting the password for user redirected to change password
        string var = '?cp=true';
        string startUrl='/change-password'+var;
        string templateName ='Custom_Verification_Request';
        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');                 
        Contact contact=  DF_Utils.getContactRecordForDfcId(dfc.id);  
        community.sendVerificationRequest(contact, password, startUrl, templateName);
        system.debug('DF_SendVerificationRequest_Extention: send verification request');
        PageReference page =  new pagereference('/'+dfc.Id);
             
        page.setRedirect(true);

        return page;
        

    }
}