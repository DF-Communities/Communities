@isTest
private class DF_WEBC_ChangePassword_Ctl_Test
{
	@isTest
	static void doTest()
	{

		DF_WEBC_ChangePassword_Controller ctl = new DF_WEBC_ChangePassword_Controller();
		PageReference pr = ctl.doCancel();

		ctl.password = 'passw000rd';
		ctl.password2 = 'passw000rd';
		ctl.currentPassword = 'pass';

		pr = ctl.changePassword();

	}

	@isTest
	static void doTest2()
	{

		DF_WEBC_ChangePassword_Controller ctl = new DF_WEBC_ChangePassword_Controller();
		PageReference pr = ctl.doCancel();

		ctl.password = '';
		ctl.password2 = '';
		ctl.currentPassword = '';

		pr = ctl.ChangePassword();

	}

}