@isTest
public with sharing class Dfc_AssessmentReminder_Batcher_Test {
    

    @testSetup
    public static void setupData() {

        Dfc_DataFactory_Test.TestDataCreation(); 

    }
    
    static testmethod void covermethod(){
        
        User u = [select id from User where Email = 'test1.testcontact@myemail.com'];    
        DFC_Community__c comm = [select Id from DFC_Community__c where status__c = 'Active' limit 1];
        comm.Date_Approved__c  = system.today().addmonths(-9);
        update comm;
        test.starttest();
        Dfc_AssessmentReminder_Schedulable f = new Dfc_AssessmentReminder_Schedulable(); 
        f.execute(null);
           
           System.assert(Limits.getEmailInvocations()==1);
        
    
    
}

}