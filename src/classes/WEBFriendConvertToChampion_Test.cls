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
private class WEBFriendConvertToChampion_Test {
	

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();   
        User u = (User)mapTestData.get('User');
        
        test.starttest();
        System.runAs(u) {
         PageReference pageRef = Page.WEBFriendConvertToChampion;        
         WEBFriendConvertToChampion controller = new WEBFriendConvertToChampion();
         system.assertEquals(null,controller.convertToChampion());
         controller.birthDateString ='18/04/1975';
         controller.whychampion ='test';
         system.assertNotEquals(null,controller.convertToChampion());
        }
    }
}