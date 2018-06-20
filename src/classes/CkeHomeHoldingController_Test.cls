@isTest
private class CkeHomeHoldingController_Test
{
	Public static CkeHomeHoldingController.Command getData() {

		CkeHomeHoldingController.Command cmd = new CkeHomeHoldingController.Command();
		cmd.FirstName = 'Test';
		cmd.LastName = 'Test';
		cmd.Email = 'Test@test.com';
		cmd.CaptchaResponse = 'xxxx';

		return cmd;

	}

	// Successful save and Submit
	@isTest
	static void itShould()
	{

		Test.setMock(HttpCalloutMock.class, new CkeMailClientMockHttp_Test());
		CkeHomeHoldingController.Command cmd = getData();
		CkeHomeHoldingController.processSubmit(cmd);

		// Test for same data twice
		CkeHomeHoldingController.processSubmit(cmd);

		String s = CkeHomeHoldingController.captchaSite;

	}
}