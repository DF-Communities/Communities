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
private class DCE_LoginPage_Controller_Test {

    @testSetup static void testSetup(){
    	DCE_testDataFactory.createPartnerUsers();
    }
    
    static testMethod void passwordTooShort() {
        DCE_LoginPage_Controller controller = new DCE_LoginPage_Controller ();
        
        controller.emailAddress = 'andy.rouse@dementiafriends.org.uk';
        controller.password = '';         
        
        PageReference pr = controller.login();
        
    }
    
    static testMethod void usernameTooShort() {
        DCE_LoginPage_Controller controller = new DCE_LoginPage_Controller ();
        
        controller.emailAddress = '';
        controller.password = 'Pa55w0rd';         
        
        PageReference pr = controller.login();
        
    }
    
    static testMethod void userExists() {
        
        User u = [select id, username from User where isActive = true and id IN (select assigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 1];
                
        DCE_LoginPage_Controller controller = new DCE_LoginPage_Controller ();
        
        controller.emailAddress = u.username;
        controller.password = 'Pa55w0rd';         
        
        PageReference pr = controller.login();
        
    }
    
    static testMethod void testPasswordReset() {
        
        User u = [select id, username from User where isActive = true and id IN (select assigneeId from PermissionSetAssignment where PermissionSet.Name = :DCE_ControllerUtils.DCE_PERMISSION_SET_NAME) limit 1];
                
        DCE_LoginPage_Controller controller = new DCE_LoginPage_Controller ();
        
        controller.userNameForReset = u.userName;

		PageReference pr = controller.resetPassword();
    }
    
}