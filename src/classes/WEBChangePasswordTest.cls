/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBChangePassword.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex test class.
 *               
 *  Modification History
 *  Date            Who         Description 
 *                    
*******************************************************************************************/
@IsTest 
public with sharing class WEBChangePasswordTest {
   	@IsTest(SeeAllData=true) 
   	public static void testChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        WEBChangePassword controller = new WEBChangePassword();
        controller.currentPassword = '123456';
        controller.password = 'Qwerty12'; 
        controller.password2 = 'Qwerty12';                
        
        System.assertEquals(controller.changePassword(),null);   
        
        WEBChangePassword controller2 = new WEBChangePassword();
        controller2.currentPassword = '';
        controller2.password = ''; 
        controller2.password2 = '';                
        
        System.assertEquals(controller2.changePassword(),null);
        
        System.assertNotEquals(null, controller2.doCancel());                           
    }    
}