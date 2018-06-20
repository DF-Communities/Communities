global class BatchSendVerificationEmail implements Database.Batchable<SObject>, Database.Stateful, Schedulable

 // Batch class to update df contacts with portal user
    {
    public String query;
 
        global void execute( SchedulableContext SC )
        {
          // batch run 
          BatchSendVerificationEmail batch = new BatchSendVerificationEmail();
          Database.executeBatch( batch, 4 );
        }

        global Database.QueryLocator start(Database.BatchableContext BC)
        {
      
           
          query = 
                'Select Id, ' +
                'Last_Name__c, '+
                'First_name__c, '+
                'Email__c '+
                ' From ' +
                'DF_Contact__c ' +
                ' Where ' +
                'isVerifyEmailNotSent__c = true';
                
    
            system.debug('+++Query+++'+ query);
            if(Test.isRunningTest())
                {
                    query += ' Limit 1';
                }

            return Database.getQueryLocator(query);
        }

        global void execute(Database.BatchableContext BC, List<SObject> scope)
        {
        
         List<DF_Contact__c> lisdfc = new List<DF_Contact__c> ();
         string var = '?cp=true';
         string password = 'dfReg1234';
         string startUrl='/change-password'+var;
         string templateName ='Custom_Verification_Request';
         WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');
        for ( sObject s : scope ) {
              
              DF_Contact__c  dfc = (DF_Contact__c)s;
             
              lisdfc.add(dfc);
            }
            
         for(DF_Contact__c dfc : lisdfc){
       
         Contact contact=  DF_Utils.getContactRecordForDfcId(dfc.id);  
         community.sendVerificationRequest(contact, password, startUrl, templateName);
         system.debug('BatchSendVerificationEmail: send verification request');

            
          
          }

         
         
        }
        
        global void finish(Database.BatchableContext BC)
        {
          // do something interesting
        }


}