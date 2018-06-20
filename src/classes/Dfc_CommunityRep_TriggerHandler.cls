public class Dfc_CommunityRep_TriggerHandler {


    public Dfc_CommunityRep_TriggerHandler() {
        
    }

    public void OnAfterInsert(DFC_Community_Representative__c[] itemsNew, Map<ID, DFC_Community_Representative__c> itemsNewMap){

        sendInvites(itemsNew);

    }

    /* Send email to Invited Dementia Friendly Community Representative */
    private void sendInvites(DFC_Community_Representative__c[] itemsNew) {
     
        // Reserves email capacity to send single email to the specified number of email addresses, after the current transaction commits.
        Messaging.reserveSingleEmailCapacity(itemsNew.size());

        String sTemplateName = 'DF_Community_Admin_Invite';
        List<EmailTemplate> lisTemplates = 
                [  SELECT Id, Subject, HtmlValue, Body 
                   FROM EmailTemplate 
                   WHERE DeveloperName = :sTemplateName];               

        if ( lisTemplates.size() ==0 ) { return ; }
        EmailTemplate emailTemplate = lisTemplates[0];

        String sReplyTo = 'TestValue';
        OrgWideEmailAddress[] owea = null;
        
        if ( !Test.isRunningTest() ) {           
           sReplyTo = (String)Community_Settings__c.getInstance('DF_Default_Reply_To_Address').value__c;
           owea = [select Id from OrgWideEmailAddress where Address =:sReplyTo];
        }

        List<Messaging.SingleEmailMessage> lisMails = new List<Messaging.SingleEmailMessage>();

        for ( DFC_Community_Representative__c item : itemsNew ) {

            if ( item.Role__c == 'Invited' && item.Invited_Email__c != null ) {

                Messaging.SingleEmailMessage mail = getInviteEmail(item, emailTemplate, owea);
                lisMails.add(mail);

            }

        }

        if ( lisMails.size() > 0 ) {
           Messaging.SendEmailResult[] results = Messaging.sendEmail(lisMails);
           
        }



    }

    private Messaging.SingleEmailMessage getInviteEmail(DFC_Community_Representative__c rep, 
                                                        EmailTemplate emailTemplate, 
                                                        OrgWideEmailAddress[] owea)
    {

        // Create a new SingleEmailMessag object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Email recipient address
        List<String> emailAddresses = new List<String>();
        emailAddresses.add(rep.Invited_Email__c);
        mail.setToAddresses(emailAddresses);

        mail.setSubject(emailTemplate.subject);  

        //  The ID of the organization-wide email address associated with the outgoing email.  
        if ( owea != null && owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);   
        }

        WEBC_CommunityWrapper.RegistrationData data = new WEBC_CommunityWrapper.RegistrationData();
        data.id = rep.Id;
        data.email= rep.Invited_Email__c;
        data.name = rep.Invited_Name__c;

        /* data is set up as a JSON string, encrypted and encoded into the email */
        String sJson = JSON.serialize(data);
        system.debug('JSON DATA : ' + sJson);

        String sVerifyLinkUrl = 'TestLink';
        if ( !Test.isRunningTest() ) {           
            String sKey = (String)Community_Settings__c.getInstance('DF_Secret_Key').value__c;
            String sStubUrl = (String)Community_Settings__c.getInstance('DF_Stub_Url').value__c;
            String encryptedData = WEBC_CryptoUtils.encryptValue(sJson, sKey);
            String encodedData = EncodingUtil.urlEncode(encryptedData, 'UTF-8');
            sVerifyLinkUrl = sStubUrl + 'register-community-admin?invite=' + encodedData;
        }

        String sBody = emailTemplate.Body;
        sBody=sBody.replace('{{inviter_name}}', rep.Inviter_Name__c);
        sBody=sBody.replace('{{contact_name}}', rep.Invited_Name__c);
        sBody=sBody.replace('{{verifyLink}}',sVerifyLinkUrl);
        mail.setPlainTextBody(sBody);

        return mail;

    }


}