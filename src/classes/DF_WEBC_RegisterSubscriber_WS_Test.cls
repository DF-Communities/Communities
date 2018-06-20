@isTest
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for WEBC_RegisterSubscriber_WebService
 *  Author  : Lakshmi Rajendram
 *  Date    : 23-02-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
public class DF_WEBC_RegisterSubscriber_WS_Test {
    
    // Existing DFC
    static testMethod void doTest() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        test.starttest();
        DF_WEBC_RegisterSubscriber_WebService.DataHolder data = new DF_WEBC_RegisterSubscriber_WebService.DataHolder();        
        data.firstName = dfc.First_Name__c;
        data.lastName = dfc.Last_Name__c;
        data.emailAddress = dfc.Email__c;
        data.emailAddress2 = dfc.Email__c;
        data.newsletter = true;

        DF_WEBC_RegisterSubscriber_WebService.doPost(data);        
        
    }

    // Existing DFC as a SimpleUpdate
    static testMethod void doTest1a() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        test.starttest();
        DF_WEBC_RegisterSubscriber_WebService.DataHolder data = new DF_WEBC_RegisterSubscriber_WebService.DataHolder();        
        data.firstName = dfc.First_Name__c;
        data.lastName = dfc.Last_Name__c;
        data.emailAddress = dfc.Email__c;
        data.emailAddress2 = dfc.Email__c;
        data.isSimpleUpdate = true;
        data.newsletter = true;

        DF_WEBC_RegisterSubscriber_WebService.doPost(data);        
        
    }


    // New Registration
    static testMethod void doTest2() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        DF_WEBC_RegisterSubscriber_WebService.DataHolder data = new DF_WEBC_RegisterSubscriber_WebService.DataHolder();        
        data.firstName = 'test';
        data.lastName = 'Test';
        data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
        data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
        data.newsletter = true;

        DF_WEBC_RegisterSubscriber_WebService.doPost(data);        
        
    }

    /* blank data */
    static testMethod void doTest3() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        DF_WEBC_RegisterSubscriber_WebService.DataHolder data = new DF_WEBC_RegisterSubscriber_WebService.DataHolder();        
        data.firstName = '';
        data.lastName = '';
        data.emailAddress = '';
        data.emailAddress2 = '';
        data.newsletter = true;

        DF_WEBC_RegisterSubscriber_WebService.doPost(data);        
        
    }

    /* Bad email address */
    static testMethod void doTest3a() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        DF_WEBC_RegisterSubscriber_WebService.DataHolder data = new DF_WEBC_RegisterSubscriber_WebService.DataHolder();        
        data.firstName = 'test';
        data.lastName = 'Test';
        data.emailAddress = 'p';
        data.emailAddress2 = 'p2';
        data.newsletter = true;

        DF_WEBC_RegisterSubscriber_WebService.doPost(data);        
        
    }


    // 
    static testMethod void doTest4() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        DF_WEBC_RegisterSubscriber_WebService.DataHolder data = new DF_WEBC_RegisterSubscriber_WebService.DataHolder();        
        data.firstName = 'test';
        data.lastName = 'Test';
        data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
        data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
        data.isSimpleUpdate = true;
        data.newsletter = true;

        DF_WEBC_RegisterSubscriber_WebService.doPost(data);        
        
    }

    /* Do Recaptcha */
    static testMethod void doTest5() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        DF_WEBC_RegisterSubscriber_WebService.DataHolder data = new DF_WEBC_RegisterSubscriber_WebService.DataHolder();        
        data.firstName = 'test';
        data.lastName = 'Test';
        data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
        data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
        data.newsletter = true;
        
        data.doRecaptcha = true;
        data.recaptcha_challenge = 'challenge';
        data.recaptcha_response = 'response';

        DF_WEBC_RegisterSubscriber_WebService.doPost(data);        
        
    }

    
}