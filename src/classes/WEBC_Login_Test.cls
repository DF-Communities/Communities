/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for WEBC_Login
 *  Author  : Lakshmi Rajendram
 *  Date    : 23-02-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@IsTest global with sharing class WEBC_Login_Test {
    @IsTest global static void loginTest () {
        // Instantiate a new controller with all parameters in the page
        WEBC_Login controller = new WEBC_Login ();
        controller.emailAddress = 'test@salesforce.com';
        controller.password = '123456'; 
        
        System.assertEquals( controller.login(),null ); 
        
        WEBC_Login controller2 = new WEBC_Login ();
        controller2.emailAddress = '';
        controller2.password = ''; 
        
        System.assertEquals( controller2.login(),null );         
        
        
    }        
}