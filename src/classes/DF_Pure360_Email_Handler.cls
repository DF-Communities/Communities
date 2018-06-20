public class DF_Pure360_Email_Handler extends Pure360_Email_Handler {
    
    public static final string MESSAGE_VERIFY_STANDARD = 'Verification_Email';
    public static final string MESSAGE_VERIFY_DIGITAL = 'Verification_Email_Digital';
    public static final string NEW_REQUESTER_VERIFICATION = 'New_Requester_Verification_Email';
    public static final string FRIEND_SESSION_REQUEST_CONFIRMATION = 'Requester_Confirmation_Email';
    public static final string SESSION_REQUEST_APPROVED = 'Session_Request_Approved';
    public static final string FRIEND_CHAMP_SIGNUP_CONFIRMATION = 'Requester_Confirm_Champ_Signup';
    public static final string CHAMP_SELF_SIGNUP_CONFIRMATION = 'Champion_Receipt_Of_Signup';
    public static final string FRIEND_CHAMP_DROPOUT_CONFIRMATION_LESS7 = 'Dropout_7_days_or_less_before_event';
    public static final string FRIEND_CHAMP_DROPOUT_CONFIRMATION_MORE6 = 'Dropout_greater_than_7_days_before_event';
    public static final string CHAMP_SELF_DROPOUT_CONFIRMATION = 'Champion_Receipt_Of_Dropout';
    public static final string CHAMP_SESSION_CANCELLATION_CONFIRMATION = 'Champion_Confirmation_of_Cancellation';
    public static final string DF_ADMIN_SESSION_NOTIFICATION = 'New_Info_Session_Request_DF_Team';
    public static final string ADMIN_DISTRIBUTION_LIST = 'dementiafriends@alzheimers.org.uk';
    
    
    public String message {get;set;}
    
    public override String getUserName() {
        
        return 'webd.sys';
    }
    
    public override String getPassword() {
        
        return 'Dementia50';
    }
    
    
    public DF_Pure360_Email_Handler() {
        
    }
    
    public boolean sendVerificationRequest(String toAddress, String linkUrl, String name, String sTemplate ) {
        
        String body = bodyBase;
        body +='&toAddress=';
        body += EncodingUtil.urlEncode(toAddress, 'UTF-8');
        
        body +='&message_messageName='; 
        body += sTemplate; 
        
        body +='&message_subject='; 
        body += EncodingUtil.urlEncode('Thanks for registering with Dementia Friends. Please verify your email', 'UTF-8');
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        // Remove http// and https://
        Url oUrl = new URL(linkUrl);
        String sUrl = oUrl.getHost() + oUrl.getPath() + '?' + oUrl.getQuery();
        body +='&customData[VerifyURL]='; 
        body += EncodingUtil.urlEncode(sUrl, 'UTF-8');
        
        system.debug('Request Body:' + body);
        
        return doRequest(body);
        
    }
    
    public void sendAnonymousSessionRequestUserVerification(String toAddress, String name, Contact contact, String newUserPassword, String startPage) {
        
        System.debug('PPP: ' + 'in sendAnonymousSessionRequestUserVerification');
        String body = bodyBase;
        body +='&toAddress=';
        body += toAddress; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += NEW_REQUESTER_VERIFICATION; 
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');    
        
        // Remove http// and https://
        String sVerifyUrl = new WEBC_CommunityWrapper('DF').getVerifyUrl(contact, newUserPassword, startPage); 
        // Remove http// and https://
        System.debug('PPP: ' + 'sVerifyUrl: ' + sVerifyUrl);
        Url oUrl = new URL(sVerifyUrl);
        String sUrl = oUrl.getHost() + oUrl.getPath() + '?' + oUrl.getQuery();
        body +='&customData[VerifyURL]='; 
        body += EncodingUtil.urlEncode(sUrl, 'UTF-8');
        
        system.debug('Request Body for new user:' + body);
        
        //return doRequest(body);
        Pure360_Email_Handler.doRequestFromTrigger(body); 
        
    }
    
    public void sendFriendConfirmationOfNewInfoSessionRequest(String toAddress, String name) {
        
        String body = bodyBase;
        body +='&toAddress=';
        body += toAddress; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += FRIEND_SESSION_REQUEST_CONFIRMATION; 
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');    
        
        Pure360_Email_Handler.doRequestFromTrigger(body); 
        //return doRequest(body); 
        
    }
    
     public void sendAdminsNewSessionRequestNotification(Id eventId) {
        
        String body = bodyBase;
        body +='&toAddress=';
        body += ADMIN_DISTRIBUTION_LIST; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += DF_ADMIN_SESSION_NOTIFICATION; 
           
        String sUrl = CommunityUtils.getInternalSalesforceUrl() + '/' + eventId;
         System.debug('sUrl is: ' + sUrl);
        body +='&customData[eventUrl]='; 
        body += EncodingUtil.urlEncode(sUrl, 'UTF-8'); 
        
        Pure360_Email_Handler.doRequestFromTrigger(body); 
        //return doRequest(body); 
        
    }
    
    public void sendFriendConfirmationOfSessionApproval(String toAddress, String linkUrl, String name, DF_Event__c event) {
        
        String body = bodyBase;
        body +='&toAddress=';
        body += toAddress; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += SESSION_REQUEST_APPROVED; 
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');
        
        body +='&customData[VerifyURL]='; 
        body += formulateLink(linkUrl); 
        
        body +='&customData[SessionDate]='; 
        body += event.Event_Date__c.format();
        
        System.debug('Attempting to send out: ' + SESSION_REQUEST_APPROVED);
        Pure360_Email_Handler.doRequestFromTrigger(body);
        //return doRequest(body); 
        
    }
    
    
    
    public void sendFriendConfirmationOfChampSignup(String toAddress, String linkUrl, String name, DF_Event__c event) {
        
        String body = bodyBase;
        body +='&toAddress=';
        body += toAddress; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += FRIEND_CHAMP_SIGNUP_CONFIRMATION; 
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');
        
        body +='&customData[VerifyURL]='; 
        body += formulateLink(linkUrl); 
        
        body +='&customData[Sessiondateandtime]='; 
        body += event.Event_Date_Time__c.format();
        
        body +='&customData[Sessionaddress]='; 
        body +=(event.Street__c != null) ? event.Street__c  + '<br/>': '';
        body +=(event.City__c != null) ? event.City__c + '<br/>' : '';
        body +=(event.County__c != null) ? event.County__c + '<br/>' : ''; 
        body +=(event.Postcode__c != null) ? event.Postcode__c + '<br/><br/>' : '';
        
        body +='&customData[Championfirstname]='; 
        body += event.Trainer_Firstname__c;
        
        body +='&customData[Championlastname]='; 
        body += event.Trainer_lastname__c;
        
        body +='&customData[ChampionEmailAddress]='; 
        body += event.Trainer_Email__c;
        
        Pure360_Email_Handler.doRequestFromTrigger(body); 
        //return doRequest(body); 
        
    }
    
    public void sendChampConfirmationOfSignup(String toAddress, String linkUrl, String name, DF_Event__c event) {
        
        String body = bodyBase;
        body +='&toAddress=';
        body += toAddress; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += CHAMP_SELF_SIGNUP_CONFIRMATION; 
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');
        
        body +='&customData[VerifyURL]='; 
        body += formulateLink(linkUrl); 
        
        body +='&customData[Sessiondateandtime]='; 
        body += event.Event_Date_Time__c.format();
        
        body +='&customData[Sessionaddress]='; 
        body +=(event.Street__c != null) ? event.Street__c + '<br/>' : '';
        body +=(event.City__c != null) ? event.City__c + '<br/>' : '';
        body +=(event.County__c != null) ? event.County__c + '<br/>' : ''; 
        body +=(event.Postcode__c != null) ? event.Postcode__c + '<br/><br/>' : '';
        
        body +='&customData[RequesterFirstName]='; 
        body += event.Session_Requester_Name__c.split(' ')[0];
        
        body +='&customData[RequesterLastName]='; 
        body += event.Session_Requester_Name__c.split(' ')[1];
        
        body +='&customData[RequesterEmailAddress]='; 
        body += event.Session_Requester_Email__c;
        
        Pure360_Email_Handler.doRequestFromTrigger(body);
        //return doRequest(body); 
        
    }
    
    public void sendFriendConfirmationOfChampDropOut(String toAddress, String name, DF_Event__c event) {
        
        
        String body='';
        String templateName = '';
        
        if(Date.today().addDays(7) > event.Event_Date__c) {   
            templateName = FRIEND_CHAMP_DROPOUT_CONFIRMATION_LESS7;
        } else {
            templateName = FRIEND_CHAMP_DROPOUT_CONFIRMATION_MORE6;
        }
        
        
        body = bodyBase;
        body +='&toAddress=';
        body += toAddress; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += templateName; 
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');
        
        Pure360_Email_Handler.doRequestFromTrigger(body);
        //return doRequest(body); 
        
    }
    
    public void sendChampConfirmationOfChampDropOut(String toAddress, String name, DF_Event__c event) {
        
        
        String body='';
        String templateName = CHAMP_SELF_DROPOUT_CONFIRMATION;
        
        body = bodyBase;
        body +='&toAddress=';
        body += toAddress; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += templateName; 
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');
        
        Pure360_Email_Handler.doRequestFromTrigger(body);
        //return doRequest(body); 
        
    }
    
    /*public void sendFriendConfirmationOfSessionCancellation(String toAddress, String name) {

String body = bodyBase;
body +='&toAddress=';
body += toAddress; 

body +='&customFromDesc='; 
body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');

body +='&message_messageName='; 
body += FRIEND_SESSION_CANCELLATION_CONFIRMATION; 

body +='&customData[firstName]='; 
body += EncodingUtil.urlEncode(name, 'UTF-8');

Pure360_Email_Handler.doRequestFromTrigger(body);
//return doRequest(body); 

}*/
    
    public void sendChampConfirmationOfSessionCancellation(String toAddress, String name) {
        
        String body = bodyBase;
        body +='&toAddress=';
        body += toAddress; 
        
        body +='&customFromDesc='; 
        body += EncodingUtil.urlEncode('Dementia Friends', 'UTF-8');
        
        body +='&message_messageName='; 
        body += CHAMP_SESSION_CANCELLATION_CONFIRMATION; 
        
        body +='&customData[firstName]='; 
        body += EncodingUtil.urlEncode(name, 'UTF-8');
        
        Pure360_Email_Handler.doRequestFromTrigger(body);
        //return doRequest(body); 
        
    }
    
    public boolean sendFriendRequestForFeedback(String toAddress, String name) {
        
        String content = 'Request from the session host for feedback: Your info session ' + 'infoSessionObj.Name' + ' has been and gone, please leave feedback';
        return false; //return commonRequest(toAddress, linkUrl, name, sTemplate, content); 
        
    }
    
    public boolean sendChampRequestForFeedback(String toAddress, String name) {
        
        String content = 'Champ feedback request: Your info session ' + 'infoSessionObj.Name' + ' is due for review and feedback';
        return false; //return commonRequest(toAddress, linkUrl, name, sTemplate, content); 
        
    }
    
    private String formulateLink(String linkUrl) {
        
        // Remove http// and https://
        Url oUrl = new URL(linkUrl);
        String sUrl = oUrl.getHost() + oUrl.getPath();
        sUrl += (oUrl.getQuery() != null) ? '?' + oUrl.getQuery() : '';
        
        return sUrl;
    }
    
    
}