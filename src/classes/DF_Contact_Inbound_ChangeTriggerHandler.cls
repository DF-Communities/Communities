public without sharing class DF_Contact_Inbound_ChangeTriggerHandler {
  private boolean m_isExecuting = false;
  private integer BatchSize = 0;    
 
  public DF_Contact_Inbound_ChangeTriggerHandler(boolean isExecuting, integer size){

     m_isExecuting = isExecuting;
     BatchSize = size;

  }  
  
  public void OnBeforeInsert(List<DF_Contact_Inbound_Change__c> newDFCChangelis, Map<ID, DF_Contact_Inbound_Change__c> dfcChangenewMap){

     limitNoOfChangeRec(newDFCChangelis,null);
  }
  
  public void OnBeforeUpdate(List<DF_Contact_Inbound_Change__c> updatedDFCChangelis, Map<ID, DF_Contact_Inbound_Change__c> dfcChangeOldMap){
     
        
  }
  
   public void OnAfterInsert(List<DF_Contact_Inbound_Change__c> newDFCChangelis, Map<ID, DF_Contact_Inbound_Change__c> dfcChangenewMap){

    sendChangeAlertToDFUser(newDFCChangelis);
  }
  
  
  public void limitNoOfChangeRec( List<DF_Contact_Inbound_Change__c> newDFCChangelis, Map<ID, DF_Contact_Inbound_Change__c> dfcChangenewMap ){
  
   set<Id> dfcontactIds = new set<Id>();
   Map<String,Id> dfcontactowMap = new Map<String,Id>();
   Map<String,DF_Contact_Inbound_Change__c> dfcontactMap= new Map<String,DF_Contact_Inbound_Change__c>();
    
   for ( DF_Contact_Inbound_Change__c dcc: newDFCChangelis){    
     dfcontactIds.add(dcc.Related_DF_contact__c);
         
   }
   for (DF_Contact__c dc : [select id,ownerid from DF_Contact__c where id in :dfcontactIds] ){
    
   
    dfcontactowMap.put(dc.id , dc.ownerid);
   }
   
   for(DF_Contact_Inbound_Change__c dcc: [select Related_DF_contact__c from DF_Contact_Inbound_Change__c  where Related_DF_contact__c in :dfcontactIds] ){
    
     dfcontactMap.put(dcc.Related_DF_contact__c,dcc);  
   }
   
   for ( DF_Contact_Inbound_Change__c dcc2: newDFCChangelis){
    
  
    
    if( dfcontactMap.get(dcc2.Related_DF_contact__c)==null){
     
       
     dcc2.ownerid = dfcontactowMap.get(dcc2.Related_DF_contact__c);
     dcc2.External_Id__c =dcc2.Related_DF_contact__c;
     
   }
   if( dfcontactMap.get(dcc2.Related_DF_contact__c)!=null){
     
     dcc2.addError('Cannot add more than one change record');   
    
   }
   
    
  }

  
}

    /*
        2016-04-8   AR  Received new Email template with fewer merge fields. Commented out (but did NOT remove) code relating to previous email template, in case of future need.
    */
    public void sendChangeAlertToDFUser(List<DF_Contact_Inbound_Change__c> newDFCChangelis){
    
    
        //string CHANGE_NOTIFICATION_HTML ='DF_Contact_Change_Notification_HTML';
        string CHANGE_NOTIFICATION_HTML ='DF_Contact_Change_Notification_HTML_v2';
        String ORG_WIDE_EMAIL_ADDRESS_ID = WEBC_CommunityWrapper.getOrgWideEmailId('DF'); 
        list<Messaging.SingleEmailMessage> lisEmailsToSend= new List<Messaging.SingleEmailMessage>();
        list<User> recipientlis = new List<User>();
        Map<String,String> mapValuesforUser = new Map<String,String>();
        //Map<String,String> mapValuesforAllUsers = new Map<String,String>();
        //Map<String,String> mapValuesDFRec = new Map<String,String>();
        //List<DF_Contact__c>  lisDFContacts  = new List<DF_Contact__c>();
        //List<String> lisFieldsforemail = new List<String>{'cTitle__c','cFirst_Name__c','cLast_Name__c','cBirthDate__c','cStreet__c','cCity__c','cCounty__c','cPostcode__c','cContact_Number__c','dTitle__c','dFirst_Name__c','dLast_Name__c','dBirthDate__c','dStreet__c','dCity__c','dCounty__c','dPostcode__c','dContact_Number__c'};
        //list<String> sstring = new List<String>();
        
        Set <Id> ownerIds = new Set <Id> ();
        //set<Id> dfContactIds = new Set<Id>();
        set<Id> DFChangeIds = new Set <Id> ();
        
        for( DF_Contact_Inbound_Change__c dcc :newDFCChangelis){
            
            DFChangeIds.add(dcc.id);
            
            
        }
        
        for( DF_Contact_Inbound_Change__c dcc2 :[Select ownerid,Related_DF_Contact__r.Portal_User__c From DF_Contact_Inbound_Change__c Where Id in:DFChangeIds]){
            
            if(dcc2.Related_DF_Contact__r.Portal_User__c !=null && dcc2.Related_DF_Contact__r.Portal_User__c == dcc2.Ownerid ){
            ownerIds.add(dcc2.Ownerid);
            }
            
        }
    
    
        //lisDFContacts =[select Title__c,First_Name__c,Last_Name__c,BirthDate__c,Street__c,City__c,County__c,Postcode__c,Contact_Number__c,ownerid from DF_Contact__c where id in:dfContactIds ];
        //mapValuesDFRec = emailMapValuesForUser(newDFCChangelis,lisDFContacts); //emailMapValuesforUser(newDFCChangelis,lisDFContacts);
        
        recipientlis = [select id,name,firstname,lastname from user where id in :ownerIds];
    
        for(User u : recipientlis){
            /*
            for (string s:lisFieldsforemail){
            
                mapValuesforUser.put(s,mapValuesDFRec.get(s+'$'+u.id));
            }*/
   
            mapValuesforUser.put('FirstName',u.FirstName);
            mapValuesforUser.put('LastName',u.LastName);
   
            Messaging.SingleEmailMessage sm =  Mail_Utils.getEmailWithData(
                                                CHANGE_NOTIFICATION_HTML, 
                                                u.Id,
                                                null, 
                                                ORG_WIDE_EMAIL_ADDRESS_ID, 
                                                False,
                                                null,
                                                mapValuesforUser) ;
                                        
            lisEmailsToSend.add(sm);
        
        }
    
        if ( lisEmailsToSend.size() > 0 ) { Messaging.sendEmail(lisEmailsToSend); }
    }



 
    

/*      DEPRECATED BY ANDY ROUSE - NEW EMAIL TEMPLATE REQUIRES FEWER MERGE FIELDS
    public map <string,string> emailMapValuesForUser( List <DF_Contact_Inbound_Change__c > newDFCChangelis ,List <DF_Contact__c > newDFlis){
  
        map <String,String> dfcontactdataMap = new map <String,String>();
        map <String,String> dfemailuserdataMap = new map <String,String>();
        list<String> lisFields = new list<String>{'Title__c','First_Name__c','Last_Name__c','BirthDate__c','Street__c','City__c','County__c','Postcode__c','Contact_Number__c'};
        
        //Get the full list of fields on the DF_Contact_Inbound_Change__c object
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> cFields = schemaMap.get('DF_Contact_Inbound_Change__c').getDescribe().fields.getMap();
        
        Map <String,String> fieldswithdataMap = new Map <String,String>();
  
        //df changed data///
        
        list<string> dccIds = new list<string>();
        //cycle through the newly created changes
        for(DF_Contact_Inbound_Change__c dcc : newDFCChangelis ){
            dccIds.add(dcc.id);
        }
        
        //Why not just loop through the trigger records? They should have all the fields necessary in an after trigger
        for(DF_Contact_Inbound_Change__c ob : ( list<DF_Contact_Inbound_Change__c> )DF_Utils.objectListWithAllFields('id',dccIds, Schema.sObjectType.DF_Contact_Inbound_Change__c )){
            
            //gets all the fields on that change (is this necessary? The trigger context should have all the fields)
            //DF_Contact_Inbound_Change__c ob = ( DF_Contact_Inbound_Change__c )DF_Utils.objectWithAllFields('id',dcc.id, Schema.sObjectType.DF_Contact_Inbound_Change__c );

            //system.debug('Here is the dcc - '+dcc);
            //system.debug('Here is the ob - '+ob);

            // loop through all of the inbound_change_fields
            for (Schema.SObjectField f : cFields.values()) {
                
                Schema.DescribeFieldResult fd = f.getDescribe(); 
      
                //If the field in question is null, skip
                system.debug('FIELD - '+fd.getName());
                system.debug('VALUE - '+ob.get(fd.getName()));
                
                if ( ob.get(fd.getName())==null ){ continue; }
         
                //loop through fields we're interested in
                for (string fname :lisFields){
        
                    
                    //if the field we're interested in is the same as the field from the outer loop (should be able to avoid this loop by using maps to call fields as needed)
                    if ( fname == fd.getName() ) {             
         
                        //key - recordId$FieldName, value - FieldName (not value)
                        //fieldswithdataMap.put(dcc.related_DF_Contact__c +'$'+fname,fname);
                        fieldswithdataMap.put(ob.related_DF_Contact__c +'$'+fname,fname);
         
                        //Formatted values to string and put into map
                        // Key - c<<FieldName>>$InboundChangeOwner, Value - Field Label: Value of Field
                        if(fd.getName()== 'Birthdate__c'){
        
                            //dfcontactdataMap.put('c'+fd.getName()+'$'+dcc.ownerid,fd.getLabel()+':'+ date.valueof(ob.get('Birthdate__c')).format());
                            dfcontactdataMap.put('c'+fd.getName()+'$'+ob.ownerid,fd.getLabel()+':'+ date.valueof(ob.get('Birthdate__c')).format());
                        } else {
                            
                            //dfcontactdataMap.put('c'+fd.getName()+'$'+dcc.ownerid,fd.getLabel()+':'+ string.valueof(ob.get(fd.getName())));
                            dfcontactdataMap.put('c'+fd.getName()+'$'+ob.ownerid,fd.getLabel()+':'+ string.valueof(ob.get(fd.getName())));
                        }
        
                    }
                }
            }
        }
      
        dfemailuserdataMap = emailMapValuesForDFCon(newDFlis,fieldswithdataMap,dfcontactdataMap);
     
        return dfemailuserdataMap;

    }
*/      
    /***********************************************/  
    
      ////df contact current data///
      
/*   
    public map <string,string> emailMapValuesForDFCon( list<DF_Contact__c > newDFlis, map<string,string> fieldswithdataMap,  map <String,String> dfIndataMap){
    
        map <String,String> dfcontactdataMap = new map <String,String>();
        dfcontactdataMap = dfIndataMap ;  
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> dfFields = schemaMap.get('DF_Contact__c').getDescribe().fields.getMap();
        Map <String,String> fWithdataMap = new Map <String,String>();
        fWithdataMap =  fieldswithdataMap;
    
        list<string> dcIds = new list<Id>();
        
        for(DF_Contact__c dc : newDFlis ){
            dcIds.add(dc.id);
        }
  
        for(DF_Contact__c ob2 : ( list<DF_Contact__c> )DF_Utils.objectListWithAllFields('id',dcIds, Schema.sObjectType.DF_Contact__c )){
            //DF_Contact__c ob2 = ( DF_Contact__c )DF_Utils.objectWithAllFields('id',dc.id, Schema.sObjectType.DF_Contact__c );
    
            for (Schema.SObjectField f : dfFields.values()) {
       
                Schema.DescribeFieldResult fd = f.getDescribe(); 
        
                for (string fname : fWithdataMap.keyset()){
        
                    //if ( fname == dc.id+'$'+fd.getName() ) {
                    if ( fname == ob2.id+'$'+fd.getName() ) {
                        
                        if(ob2.get(fd.getName())== null){
       
                            //dfcontactdataMap.put('d'+fd.getName()+'$'+dc.ownerid,fd.getLabel()+':');
                            dfcontactdataMap.put('d'+fd.getName()+'$'+ob2.ownerid,fd.getLabel()+':');
                        
                        } else if(fd.getName()== 'Birthdate__c') {
                            
                            //dfcontactdataMap.put('d'+fd.getName()+'$'+dc.ownerid,fd.getLabel()+':'+ date.valueof(ob2.get('Birthdate__c')).format());
                            dfcontactdataMap.put('d'+fd.getName()+'$'+ob2.ownerid,fd.getLabel()+':'+ date.valueof(ob2.get('Birthdate__c')).format());
        
                        } else {
        
                            //dfcontactdataMap.put('d'+fd.getName()+'$'+dc.ownerid,fd.getLabel()+':'+ string.valueof(ob2.get(fd.getName())));
                            dfcontactdataMap.put('d'+fd.getName()+'$'+ob2.ownerid,fd.getLabel()+':'+ string.valueof(ob2.get(fd.getName())));
                        }
                    }
       
                }
            }
     
        }
            //**************************************************

        system.debug('MAP VALUES:'+dfcontactdataMap);
        return dfcontactdataMap;   
    }
  
    
*/

}