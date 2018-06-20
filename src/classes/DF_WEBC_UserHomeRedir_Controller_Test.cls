/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_User_Home_Redirect_Controller
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
public with sharing class DF_WEBC_UserHomeRedir_Controller_Test {
    
    
    static testMethod void testdoAction() {
  
  	   Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
       DF_Contact__c DFc = (DF_Contact__c)mapTestData.get('DFc');
  	   PageReference testPage = Page.DF_WEBC_UserHome;
       testPage.getParameters().put('oid', '12345');
        
       Test.setCurrentPage(testPage);
       
       Test.StartTest();
        
	    DF_WEBC_User_Home_Redirect_Controller dhr=new DF_WEBC_User_Home_Redirect_Controller();
	    WEBC_Login controller = new WEBC_Login ();

        controller.emailAddress = DFc.email__c;
        controller.password = '123456'; 
        dhr.doAction();

    }
}