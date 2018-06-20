/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_ForgotPassword_Controller
 *  Author  : Lakshmi Rajendram
 *  Date    : 12-03-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
public with sharing class DF_WEBC_ForgotPassword_Controller_Test {
    
    
    static testMethod void doTest() {
      
       DF_WEBC_ForgotPassword_Controller ctl = new DF_WEBC_ForgotPassword_Controller();
       Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();  
       DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
       test.starttest();
       ctl.emailAddress = dfc.Email__c;

       ctl.forgotPassword();

       Page_Snippet__c snip = ctl.forgotPasswordSnippet;

     }

    /* Test a bad email address */
    static testMethod void doTest2() {
      
       DF_WEBC_ForgotPassword_Controller ctl = new DF_WEBC_ForgotPassword_Controller();
       ctl.emailAddress = 'Somewhere@test.com';
       ctl.forgotPassword();

     }

    /* Test support methods */
    static testMethod void doTest3() {
      
       DF_WEBC_ForgotPassword_Controller ctl = new DF_WEBC_ForgotPassword_Controller();
       ctl.getLisForOrgAdmin('someone@test.com');

       Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData(); 
       DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
       test.starttest();
       List<User> lis = new List<User>();
       lis.add((User)mapTestData.get('User'));
       ctl.handleLis(lis);
        test.stoptest();

     }     


}