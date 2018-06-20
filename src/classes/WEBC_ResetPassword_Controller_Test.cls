@isTest
private class WEBC_ResetPassword_Controller_Test
{
        @isTest
	static void doTest()
	{

        Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('contact');
        contact.Password_Reset_Key__c = 'RandomString';
        update contact;

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');    
        String key = community.secretKey;

        DateTime dt = system.now();
        String sContactKey = contact.id + ':::RandomString:::' + dt.getTime();
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');

        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);

        WEBC_ResetPassword_Controller ctl = new WEBC_ResetPassword_Controller();

        ctl.password='passw000rd';
        ctl.password2='passw000rd';

        PageReference pr = ctl.resetPassword();

	}

    // Bad Password
	@isTest
	static void doTest2()
	{

	    Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('contact');
        contact.Password_Reset_Key__c = 'RandomString';
        update contact;        

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');    
        String key = community.secretKey;

        DateTime dt = system.now();
	    String sContactKey = contact.id + ':::RandomString:::' + dt.getTime();
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');

        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);

        WEBC_ResetPassword_Controller ctl = new WEBC_ResetPassword_Controller();

        ctl.password='p';
        ctl.password2='passw000rd';

        PageReference pr = ctl.resetPassword();

	}


    // Bad Contact
	@isTest
	static void doTest3()
	{

	    Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');    
        String key = community.secretKey;

	    /* Random contact id will not be found */
        DateTime dt = system.now();
	    String sContactKey = '00B20000006RoYI' + ':::RandomString:::' + dt.getTime();
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');

        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);

        WEBC_ResetPassword_Controller ctl = new WEBC_ResetPassword_Controller();

        ctl.password='passw000rd';
        ctl.password2='passw000rd';

        PageReference pr = ctl.resetPassword();

	}

    // Expired Request Date
	@isTest
	static void doTest4()
	{

	    Map<String,Object> mapTestData = DF_DataFactory_Test.getTestData();
	    Contact contact = (Contact)mapTestData.get('contact');
        contact.Password_Reset_Key__c = 'RandomString';
        update contact;        

        WEBC_CommunityWrapper community = new WEBC_CommunityWrapper('DF');    
        String key = community.secretKey;

	    /* Date on the request expired */
        DateTime dt = system.now();
        dt.addDays(-50);
	    String sContactKey = contact.id + ':::RandomString:::' + dt.getTime();
        String encryptedValue = WEBC_CryptoUtils.encryptValue(sContactKey, key);
        String encryptedContactKey = EncodingUtil.urlEncode(encryptedValue, 'UTF-8');

        String decodedParam = EncodingUtil.urlDecode(encryptedContactKey, 'UTF-8');

        ApexPages.currentPage().getParameters().put('c', 'DF');
        ApexPages.currentPage().getParameters().put('data', decodedParam);

        WEBC_ResetPassword_Controller ctl = new WEBC_ResetPassword_Controller();

        ctl.password='passw000rd';
        ctl.password2='passw000rd';

        PageReference pr = ctl.resetPassword();

	}


}