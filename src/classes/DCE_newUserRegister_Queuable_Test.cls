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
private class DCE_newUserRegister_Queuable_Test {

	static void setupData(){
		
	}

    static testMethod void myUnitTest() {
        
        Id userId = [select id, FirstName, Name,IsActive, Email from User where isActive = true and email != null and Id NOT IN (select assigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) and profile.Name = 'System Administrator' limit 1].id;
        
        test.startTest();
        
        DCE_newUserRegister_Queuable testCont = new DCE_newUserRegister_Queuable(userId);
        
        system.enqueueJob(testCont);
        
        test.stopTest();
        
    }
}