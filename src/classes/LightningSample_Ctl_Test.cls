@isTest
private class LightningSample_Ctl_Test
{
	@isTest
	static void itShould()
	{
		
		Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        User u = (User)mapTestData.get('User');

        System.runAs(u) {        
			User u2 = LightningSample_Controller.getCurrentUser();
		}

	}
}