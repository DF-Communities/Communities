@isTest
private class DF_WEBC_RegisterFriend_Form_Ctl_Test
{
	@isTest
	static void doTest()
	{
		
		DF_WEBC_RegisterFriend_Form_Controller ctl = new DF_WEBC_RegisterFriend_Form_Controller();
		ctl.gender='Male';
		ctl.ethnicGroup='British';

		List<SelectOption> lis = ctl.genderOptionList;
		lis = ctl.ethnicGroupOptionList;

		ctl.gender = 'Male';
		ctl.ethnicGroup = 'White';
		
	}
}