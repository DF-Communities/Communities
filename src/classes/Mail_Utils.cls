public with sharing class Mail_Utils {


    public static Map<String, EmailTemplate> mapTemplates;
    
    public static void sendTemplatedEmail(String templateApiName, ID targetObjId, Id whatId, String orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList ) {
   
      //  templateId   must be ID of an Email template
      //  targetObjId must be a DF Contact also used in merge fields of template recipient.xxxx
      //  whatId    must be an SObject that is used in the merge fields of the template relatedTo.xxxx
      //  fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
      //  bcc      not permitted when using templates

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        Id templateId; 

        try { 
            
            templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;
        
         } catch (Exception e) {

               throw new DF_Mail_Exception ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName +
                 ' refer to Setup | Communications Templates ' + templateApiName);

        }
        
        email.setTargetObjectId(targetObjId);
        email.setWhatId(whatId);
        
        if ( orgWideEmailId != null && orgWideEmailId !='') { 
                email.setorgWideEmailAddressId(orgWideEmailId);
        }
        
        email.setTemplateId(templateId);
        email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users

        System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, templateId:' + templateId + ' tagetObjId:' + targetObjId +
               ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
       
        try {

           Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});             
           return;

        }

        catch (EmailException e) {throw new DF_Mail_Exception('[U-02] sendTemplatedEmail error. ' + e.getMessage());}

    }
    

    public static Messaging.SingleEmailMessage getTemplatedEmail(String templateApiName, ID targetObjId, Id whatId, Id orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList ) {
   
        /*  templateId   must be ID of an Email template
            targetObjId must be a DF Contact also used in merge fields of template recipient.xxxx
            whatId    must be an SObject that is used in the merge fields of the template relatedTo.xxxx
            fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
            bcc      not permitted when using templates
        */    

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String templateId;         
        templateId = getEmailTemplateMap().get(templateApiName).id;
        
        if ( templateId == null ) { throw new DF_Mail_Exception ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName +
                                     ' refer to Setup | Communications Templates ' + templateApiName);
        }
      
        email.setTargetObjectId(targetObjId);
        email.setWhatId(whatId);
        email.setorgWideEmailAddressId(orgWideEmailId);
        email.setTemplateId(templateId);
        email.setSaveAsActivity(saveAsActivity); // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users

        System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, templateId:' + templateId + ' tagetObjId:' + targetObjId +
                        ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
       
        try {
           return email;           
        }

        catch (EmailException e) {throw new DF_Mail_Exception('[U-02] sendTemplatedEmail error. ' + e.getMessage());}
   
   }

   public static Messaging.SingleEmailMessage getEmailWithData(String templateApiName, ID targetObjId, Id whatId, String orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList, Map<String,String> mapValues)
   {

        // Attachments currently not handled. TODO !!!

        try {
              
              Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
              EmailTemplate template = getEmailTemplateMap().get(templateApiName);

              system.debug('Mail_Utils Template Type : ' + template.TemplateType);  
            
              if ( template == null ) { throw new DF_Mail_Exception ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName +
                                          ' refer to Setup | Communications Templates ' + templateApiName);
              }
          
              email.setTargetObjectId(targetObjId);
              if ( whatId != null ) { email.setWhatId(whatId); }
              if ( orgWideEmailId != null && orgWideEmailId != '' ) { email.setorgWideEmailAddressId(orgWideEmailId); }
              email.setSaveAsActivity(saveAsActivity); 
       
              String sBody = template.Body;              
              String sHtml = template.HTMLValue;
              String sSubject = template.Subject;

              for (String key : mapValues.keySet()) {
    
                  String sSource = '{{' + key +'}}'; 
                  String sReplace = mapValues.get(key);

                  sReplace = sReplace == null ? '' : sReplace;
                  sBody=sBody.replace(sSource, sReplace);
                  if ( sHtml != null ) { 
                    sHtml=sHtml.replace(sSource, sReplace);
                  }
                  sSubject=sSubject.replace(sSource, sReplace);

              }

              email.setSubject(sSubject);
              if ( sHtml != null ) {
                email.setHTMLBody(sHtml);
              }
              email.setPlainTextBody(sBody);

             return email;                   

        }

        catch (EmailException e) {
              throw new DF_Mail_Exception('[U-02] sendTemplatedEmail error. ' + e.getMessage());
        }

   }
    
   public static Map<String, EmailTemplate> getEmailTemplateMap (){   
    
    
    if ( mapTemplates !=null ) { return mapTemplates; }

    mapTemplates = new Map<String, EmailTemplate>();
    List <EmailTemplate> lisTemp = [select Id, DeveloperName, Body, HTMLValue, TemplateType, Subject from EmailTemplate  where IsActive = true];
     
    for (EmailTemplate e : lisTemp){
         mapTemplates.put(e.DeveloperName, e);
    }   

    return mapTemplates;
    
   }

   public static Id getOrgWideEmail(){
    
    ID ORG_WIDE_EMAIL_ADDRESS_ID ;
    Global_Setting__c globalSetting = Global_Setting__c.getInstance('orgWideEmailAddress');
    if (globalSetting != null && globalSetting.Value__c != null) {
          ORG_WIDE_EMAIL_ADDRESS_ID = globalSetting.Value__c;
        }

    return ORG_WIDE_EMAIL_ADDRESS_ID;

    }

}