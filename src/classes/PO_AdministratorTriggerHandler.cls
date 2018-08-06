public without sharing class PO_AdministratorTriggerHandler {
  

    public PO_AdministratorTriggerHandler() {
        
    }

    public void OnAfterInsert(PO_Administrator__c[] itemsNew, Map<ID, PO_Administrator__c> itemsNewMap){

        sendInvites(itemsNew,itemsNewMap);

    }

    /* Send email to Invited Dementia Friendly Community Representative */
    private void sendInvites(PO_Administrator__c[] itemsNew ,Map<ID, PO_Administrator__c> itemsNewMap) {
     
        // Reserves email capacity to send single email to the specified number of email addresses, after the current transaction commits.
        Messaging.reserveSingleEmailCapacity(itemsNew.size());
        String sTemplateName = 'DF_Partner_Admin_Invite';
        Set<Id> poIds = new Set<Id>();
        List<EmailTemplate> lisTemplates = 
                [  SELECT Id, Subject, HtmlValue, Body 
                   FROM EmailTemplate 
                   WHERE DeveloperName = :sTemplateName];   
                   

        if ( lisTemplates.size() ==0 ) { return ; }
        EmailTemplate emailTemplate=lisTemplates[0];
        String sReplyTo = 'TestValue';
        OrgWideEmailAddress[] owea = null;
        
        if ( !Test.isRunningTest() ) {           
           sReplyTo = (String)Community_Settings__c.getInstance('DF_Default_Reply_To_Address').value__c;
           owea = [select Id from OrgWideEmailAddress where Address =:sReplyTo];
           
        }

        List<Messaging.SingleEmailMessage> lisMails = new List<Messaging.SingleEmailMessage>();


        for(PO_Administrator__c item: [select IsAddedThroughLoadProcess__c,DF_Contact__r.First_Name__c,DF_Contact__r.Last_Name__c,Status__c,Invited_Name__c,Invited_Email__c,DF_Contact__c,Inviter_Name__c,DF_Contact__r.Name__c,DF_Contact__r.Portal_Contact__c,Partner_Organisation__r.Name, Partner_Organisation__r.DFC_Code__c from PO_Administrator__c where Id in:itemsNewMap.keyset()]){
           
           system.debug('item  '+ item);
            if ( item.Status__c == 'Invited' && item.Invited_Email__c != null ) {

                Messaging.SingleEmailMessage mail = getInviteEmail(item,emailTemplate, owea);
                lisMails.add(mail);
             
            }
            
            if ( item.Status__c == 'Registered' && item.IsAddedThroughLoadProcess__c == false  ) {
            
                Messaging.SingleEmailMessage mail = getRegisteredEmail(item);
                lisMails.add(mail);
            }

        }

        if ( lisMails.size() > 0 ) {
          // Messaging.SendEmailResult[] results = 
           Messaging.sendEmail(lisMails);
           
        }



    }
    
    private Messaging.SingleEmailMessage getRegisteredEmail(PO_Administrator__c admin){
                                                            
       String sTemplateName = 'DF_Partner_Admin_Registerd';
       String ORG_WIDE_EMAIL_ADDRESS_ID = WEBC_CommunityWrapper.getOrgWideEmailId('DF');
                                                            
                                                        
         
             Map<String, String> mapValues = new Map<String, String>();
             mapValues.put('contact_firstname', admin.DF_Contact__r.First_Name__c);
             mapValues.put('contact_lastname', admin.DF_Contact__r.Last_Name__c);
             mapValues.put('contact_name', admin.DF_Contact__r.First_Name__c + ' ' + admin.DF_Contact__r.Last_Name__c);
             mapValues.put('inviter_name', admin.Inviter_Name__c);
             mapValues.put('partner_code', admin.Partner_Organisation__r.DFC_Code__c); 
             mapValues.put('partner_name', admin.Partner_Organisation__r.Name); 
            
           
             Messaging.SingleEmailMessage mail = Mail_Utils.getEmailWithData(sTemplateName, 
                                                   admin.DF_Contact__r.Portal_Contact__c, 
                                                   admin.Id, 
                                                   ORG_WIDE_EMAIL_ADDRESS_ID, 
                                                   false, 
                                                   null, 
                                                   mapValues);
             return mail;
            
                                                            
        
    }

    private Messaging.SingleEmailMessage getInviteEmail(PO_Administrator__c admin, 
                                                        EmailTemplate emailTemplate, 
                                                        OrgWideEmailAddress[] owea)
    {

        
        // Create a new SingleEmailMessag object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Email recipient address
        List<String> emailAddresses = new List<String>();
        emailAddresses.add(admin.Invited_Email__c);
        mail.setToAddresses(emailAddresses);

        mail.setSubject(emailTemplate.subject);  

        //  The ID of the organization-wide email address associated with the outgoing email.  
        if ( owea != null && owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);   
        }

        WEBC_CommunityWrapper.RegistrationData data = new WEBC_CommunityWrapper.RegistrationData();
        data.id = admin.Id;
        data.email= admin.Invited_Email__c;
        data.name = admin.Invited_Name__c;

        /* data is set up as a JSON string, encrypted and encoded into the email */
        String sJson = JSON.serialize(data);
        system.debug('JSON DATA : ' + sJson);

        String sVerifyLinkUrl = 'TestLink';
        if ( !Test.isRunningTest() ) {           
            String sKey = (String)Community_Settings__c.getInstance('DF_Secret_Key').value__c;
            String sStubUrl = (String)Community_Settings__c.getInstance('DF_Stub_Url').value__c;
            String encryptedData = WEBC_CryptoUtils.encryptValue(sJson, sKey);
            String encodedData = EncodingUtil.urlEncode(encryptedData, 'UTF-8');
            sVerifyLinkUrl = sStubUrl + 'register-partner-admin?invite=' + encodedData;
        }

        String sBody = emailTemplate.Body;
        sBody=sBody.replace('{{inviter_name}}', admin.Inviter_Name__c);
        sBody=sBody.replace('{{contact_name}}', admin.Invited_Name__c.split(' ',0)[0]);
        sBody=sBody.replace('{{partner_name}}', admin.Partner_Organisation__r.Name);
        sBody=sBody.replace('{{verifyLink}}',sVerifyLinkUrl);
        mail.setPlainTextBody(sBody);

        return mail;

    }


 
}