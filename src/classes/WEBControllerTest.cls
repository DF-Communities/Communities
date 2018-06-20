/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBController.
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
@isTest 
public class WEBControllerTest {
	
	private static String RANDOM_STRING = String.valueOf(system.now().format('yyyyMMddHHmmssSSS')) + String.valueOf(Crypto.getRandomInteger()).substring(1,4);
	private static String EMAIL_ADDRESS = RANDOM_STRING + '_dummy@test.com';
	private static String PASSWORD = 'Qwerty12345';
	private static User adminUser;
	private static User guestUser;
	private static Map<String, Object> mapTestData; 
	
	private static void setUpSystemData(){

	    mapTestData = DF_DataFactory_Test.getTestData();   

		adminUser = (User)mapTestData.get('adminUser');
		//guestUser = [Select Id From User Where UserType='Guest' limit 1];
    	Global_Setting__c setting = Global_Setting__c.getInstance('webAccountOwnerId');
    	if (setting == null){
    		setting = new Global_Setting__c(Name='webAccountOwnerId',Value__c=adminUser.Id);
        	insert setting;
    	}
	}
	@IsTest
    private static void webcontrollertest(){

        setUpSystemData();
        
        /*
        PageReference pageRef = Page.WEBRegisterFriend;
        pageRef.getParameters().put('recaptcha_challenge_field','test values');
       	pageRef.getParameters().put('recaptcha_response_field','test values');
       	pageRef.getParameters().put(WEBController.pageId_PARAM,'dummyId');
	   	pageRef.getParameters().put(WEBController.showPreview_PARAM,'true');
       	test.setCurrentPage(pageRef);

        system.runAs(guestUser){
        	system.assertEquals(WEBController.isLoggedIn, false,'running in the context of Guest user');
        	pageRef = WEBController.registerUser('Mr', 'dummy_First', 'dummy_Last', '1234567890', EMAIL_ADDRESS, 'AB1 2BC', PASSWORD, PASSWORD, 'Friend',true);
        	system.assertEquals(pageRef, null,'This would always be null in test context');
        	
        	list<Type> handlers = WEBControllerTest.getHandlers();
	   		WEBController handler = (WEBController)handlers[0].newInstance();
	   		String homepageUrl = handler.homepageUrl;
	   		String loginUrl    = handler.loginUrl;
	   		PageReference loginReference = handler.loginReference;
	   		PageReference loginRedirect = handler.loginRedirect();
	   		Boolean showCookiePolicy = handler.showCookiePolicy;
	   		
	   		pageRef = WEBController.registerUser('Mr', 'dummy_First', 'dummy_Last', '1234567890', EMAIL_ADDRESS, 'AB1 2CD', PASSWORD, '123', 'Friend',true);
        }
        */
        
        Test.startTest();

        system.runAs(adminUser){
       		system.assertEquals(WEBController.checkUserExists(EMAIL_ADDRESS),false,'User is created and exists in the database.');
        }
        
        User newRegisteredUser = (User)mapTestData.get('User');
        //User newRegisteredUser = [Select Id,ContactId From User Where Profile.Name='DF HVCP' And IsActive=true limit 1];
        
        system.runAs(newRegisteredUser){
	   		system.assertEquals(newRegisteredUser.Id, WEBController.thisUser.Id,'new Registered User is the running user.');
	   		String pageId = WEBController.pageId;
	   		Boolean priview = WEBController.showPreview;
	   		system.assert(WEBController.isLoggedIn);
	   		Boolean isChampion = WEBController.isChampion;
	   		Id userAccId = WEBController.userAccountId;
	   		
	   		list<Type> handlers = WEBControllerTest.getHandlers();
	   		WEBController handler = (WEBController)handlers[0].newInstance();
	   		String homepageUrl = handler.homepageUrl;
	   		String loginUrl    = handler.loginUrl;
	   		PageReference loginReference = handler.loginReference;
	   		PageReference loginRedirect = handler.loginRedirect();
	   		Boolean showCookiePolicy = handler.showCookiePolicy;
        }
    }
    
    private static List<Type> getHandlers() {
        list<Type> handlers = new list<Type> {WEBTraining.class};
        return handlers;
    }
}