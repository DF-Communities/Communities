/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DF_WEBC_NewsletterArchivesCtl_Test {

    static testMethod void myUnitTest() {
    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
     User u  = (User)mapTestData.get('User'); 
    Newsletter_Archive_Category__c ncat = new Newsletter_Archive_Category__c(name='testname',Description__c='testDescription');
    insert ncat;
       
    Newsletter_Archive__c nArc = new Newsletter_Archive__c(Name__c ='testresorce',Newsletter_Archive_Category__c = ncat.id); 
    insert nArc;
      
    Blob b = Blob.valueOf('Test Data');  
      
    Attachment att = new Attachment();  
    att.ParentId = nArc.id;  
    att.Name = 'Test Attachment for Parent';  
    att.Body = b;  
      
    insert(att);   
    test.starttest(); 
    system.runAs(u){ 
    DF_WEBC_NewsletterArchivesController newsArchive = new DF_WEBC_NewsletterArchivesController(); 
    
    }  
    }
}