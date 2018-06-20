/******************************************************************************************
*  Alzheimer's Society
*  
*  Purpose : APEX Test Class for DF_WEBC_ToggleSubscription_WebService
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
public with sharing class DF_WEBC_ToggleSubscriptio_WS_Test {
    
    
  static testMethod void doTest() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u = (User)mapTestData.get('User');

        system.runAs(u) {
        test.starttest();
        
            DF_WEBC_ToggleSubscription_WebService.DataHolder data = new DF_WEBC_ToggleSubscription_WebService.DataHolder();        
            data.action = 'on';
            DF_WEBC_ToggleSubscription_WebService.ResponseHolder responseHoler = DF_WEBC_ToggleSubscription_WebService.doPost(data);
        
            data.action = 'off';
            responseHoler = DF_WEBC_ToggleSubscription_WebService.doPost(data);    

        }        
        
    }

static testMethod void doTest2() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.starttest();
        DF_WEBC_ToggleSubscription_WebService.DataHolder data = new DF_WEBC_ToggleSubscription_WebService.DataHolder();        
        data.action = 'on';
        DF_WEBC_ToggleSubscription_WebService.ResponseHolder responseHoler = DF_WEBC_ToggleSubscription_WebService.doPost(data);
        
    }

}