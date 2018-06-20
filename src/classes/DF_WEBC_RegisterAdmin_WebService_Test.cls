/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_RegisterAdmin_WebService
 *  Author  : Lakshmi Rajendram
 *  Date    : 12-03-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
public with sharing class DF_WEBC_RegisterAdmin_WebService_Test {
    
 static testMethod void doTest() {
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();

    req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;

    DF_WEBC_RegisterAdmin_WebService.DataHolder data = new DF_WEBC_RegisterAdmin_WebService.DataHolder();
    data.orgName = 'Test Org';
    data.firstName = 'test';
    data.lastName = 'Test';
    data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '00';
    data.postCode = 'BR2 2PR';
    data.street = 'Some Street';
    data.city = 'London';
    data.county = '';
    data.country = 'England';
    data.password = 'passw0rd22';
    data.password2 = 'passw0rd22';

    data.userName = 'testOrg';
    data.emailDomain = 'testxxx';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    DF_WEBC_RegisterAdmin_WebService.doPost(data);

    }

static testMethod void doTest2() {
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();

    req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;

    DF_WEBC_RegisterAdmin_WebService.DataHolder data = new DF_WEBC_RegisterAdmin_WebService.DataHolder();
    data.orgName = '';
    data.firstName = '';
    data.lastName = '';
    data.emailAddress = '';
    data.emailAddress2 = '';
    data.telephone = '';
    data.postCode = '';
    data.street = '';
    data.city = '';
    data.county = '';
    data.country = '';
    data.password = '';
    data.password2 = '';

    data.userName = '';
    data.emailDomain = '';

    data.recaptcha_challenge = '';
    data.recaptcha_response = '';

    DF_WEBC_RegisterAdmin_WebService.doPost(data);

    }

   static testMethod void doTest3() {
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();

    req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
    req.httpMethod = 'POST';
    RestContext.request = req;
    RestContext.response = res;

    DF_WEBC_RegisterAdmin_WebService.DataHolder data = new DF_WEBC_RegisterAdmin_WebService.DataHolder();
    data.orgName = '';
    data.firstName = '';
    data.lastName = '';
    data.emailAddress = 'g';
    data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
    data.telephone = '';
    data.postCode = '';
    data.street = '';
    data.city = '';
    data.county = '';
    data.country = '';
    data.password = 'p';
    data.password2 = 'passw0rd22';

    data.userName = '';
    data.emailDomain = '';

    data.recaptcha_challenge = 'challenge';
    data.recaptcha_response = 'response';

    DF_WEBC_RegisterAdmin_WebService.doPost(data);

    }

    static testMethod void doTest4() {
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        DF_WEBC_RegisterAdmin_WebService.DataHolder data = new DF_WEBC_RegisterAdmin_WebService.DataHolder();
        data.orgName = '';
        data.firstName = '';
        data.lastName = '';
        data.emailAddress = 'gg-tt-nws-c001a@mailinator.com';
        data.emailAddress2 = 'gg-tt-nws-c001a@mailinator.com';
        data.telephone = '';
        data.postCode = '';
        data.street = '';
        data.city = '';
        data.county = '';
        data.country = '';
        data.password = 'p';
        data.password2 = 'passw0rd22';

        data.userName = 'aaa aaa';
        data.emailDomain = '';

        data.recaptcha_challenge = 'challenge';
        data.recaptcha_response = 'response';

        DF_WEBC_RegisterAdmin_WebService.doPost(data);

    }




}