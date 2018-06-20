@isTest
private class DF_WEBC_Login_Ctl_Test
{
	@IsTest 
    public static void doTest () {
    
    	Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    	User u = (User)mapTestData.get('User');

        // Instantiate a new controller with all parameters in the page
        DF_WEBC_Login_Controller controller = new DF_WEBC_Login_Controller ();
        
        controller.emailAddress = u.UserName;
        controller.password = 'passw0000rd';         
        
        PageReference pr = controller.login();

    }   

    // No data
    @IsTest
    public static void doTest2 () {
    
        // Instantiate a new controller with all parameters in the page
        DF_WEBC_Login_Controller controller = new DF_WEBC_Login_Controller ();
        
        controller.emailAddress = '';
        controller.password = ''; 

        PageReference pr = controller.login();        
        
    }       

    // Corp User Login
    @IsTest 
    public static void doTest3 () {
    
        // Instantiate a new controller with all parameters in the page
        DF_WEBC_Login_Controller controller = new DF_WEBC_Login_Controller ();
        
        controller.emailAddress = 'AdminUser';
        controller.password = 'passw000rd'; 
        
        PageReference pr = controller.login();
        
    }       
}