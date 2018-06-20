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
private class DCE_UserDetailsController_Test {

    @testSetup private static void setupData(){
    	DCE_testDataFactory.createPartnerUsers();
    }
    
    static testMethod void myUnitTest() {
        
		User u = [select id from User where IsActive = true and ContactId IN (select Id from Contact where Account.Name = 'PartnerAccount1') limit 1];
		
		system.runas(u){
			
			test.startTest();
			
			DCE_UserDetailsController cont = new DCE_UserDetailsController();
			
			User us = cont.user;
			us.FirstName = 'Jim';
			 
			cont.save(); 
			
			test.stopTest();
			
		}
        
    }
}