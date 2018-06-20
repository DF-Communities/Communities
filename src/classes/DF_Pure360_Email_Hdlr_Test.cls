@isTest
private class DF_Pure360_Email_Hdlr_Test
{
	@isTest
	static void doTest()
	{
		
		DF_Pure360_Email_Handler handler = new DF_Pure360_Email_Handler();
		handler.sendVerificationRequest('alz_test@mailinator.com', 'http://www.alzheimers.org.uk', 'TestUser', DF_Pure360_Email_Handler.MESSAGE_VERIFY_STANDARD);
		
	}
}