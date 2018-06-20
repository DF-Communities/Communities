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
private class DF_WEBC_InboundChToDFCController_Test {

    static testMethod void acceptChanges() {
     Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
     User u  = (User)mapTestData.get('User');
     DF_Contact__c dc = (DF_Contact__c)mapTestData.get('DFc');
     DF_Contact_Inbound_Change__c dcc = (DF_Contact_Inbound_Change__c)mapTestData.get('DFChange');
     
     test.starttest();
     System.runAs(u) {
     PageReference pr = Page.DF_WEBC_InboundChangesToDFC;
     test.setCurrentPage(pr);
     DF_WEBC_InboundChangesToDFCController controller = new DF_WEBC_InboundChangesToDFCController();
     
     System.assertNotEquals(controller, null);
     PageReference prview=controller.autoRunCopyChanges();
     }
    }
     static testMethod void rejectChanges() {
     Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
     User u  = (User)mapTestData.get('User');
     DF_Contact__c dc = (DF_Contact__c)mapTestData.get('DFc');
     DF_Contact_Inbound_Change__c dcc = (DF_Contact_Inbound_Change__c)mapTestData.get('DFChange');
     
     test.starttest();
     System.runAs(u) {
     PageReference pr = Page.DF_WEBC_InboundChangesToDFC;
     test.setCurrentPage(pr);
     DF_WEBC_InboundChangesToDFCController controller = new DF_WEBC_InboundChangesToDFCController();
     controller.child = dcc ; 
     System.assertNotEquals(controller, null);
     controller.reject();
     }
    }
}