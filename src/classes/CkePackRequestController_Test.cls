@isTest
public class CkePackRequestController_Test {

    Public static CkePackRequestController.Command getData() {
        
        Community_Settings__c progressIdSetting = new Community_Settings__c(Name = 'CKE_Pack_Progress_Id', Value__c = 'testProgressId');
        insert progressIdSetting;

        CkePackRequestController.Command cmd = new CkePackRequestController.Command();
        cmd.title = 'Mr';
        cmd.firstName = 'Test';
        cmd.lastName = 'Test';
        cmd.email = 'Test@test.com';

        cmd.city = 'test';
        cmd.county = 'test';
        cmd.addressLine1 = 'test';
        cmd.postcode = 'SW3 1PE';
        cmd.optinEmail = true;
        cmd.optinPhone = true;
        cmd.optinSMS = true;
        cmd.optinTC = true;
        cmd.optoutPost = true;
        cmd.optinSocial = true;
        cmd.phone = '07777777777';
        cmd.dob = '2000-04-23T18:25:43.511Z';
        cmd.captchaResponse = 'xxxx';
        cmd.submitted = true;

        return cmd;

    }

    // Successful save and Submit
    @isTest
    static void itShould()
    {        
        Edt_Item__c ei1 = new Edt_Item__c(Group__c='gdpr', Key__c='contact-preferences',Text1__c='test');
        insert ei1;
        Edt_Item__c ei2 = new Edt_Item__c(Group__c='gdpr', Key__c='connection-to-dementia',Text1__c='test');
        insert ei2;
        Edt_Item__c ei3 = new Edt_Item__c(Group__c='gdpr', Key__c='company',Text1__c='test');
        insert ei3;
        
        Community_Settings__c cs1 = new Community_Settings__c(Name='CKE_Pack_Progress_Id', Value__c='asdfasdf');
        insert cs1;
        Community_Settings__c cs2 = new Community_Settings__c(Name='Cke_Captcha_Site', Value__c='asdfasdf');
        insert cs2;
        Community_Settings__c cs3 = new Community_Settings__c(Name='Cke_Captcha_Secret', Value__c='asdfasdf');
        insert cs3;
        CkePackRequestController prc = new CkePackRequestController();
        
        /*CkePackRequestController prc = new CkePackRequestController();
        prc.companyTooltip = '1';
        prc.proximityTooltip = '1';
        prc.preferencesTooltip = '1';*/

        Test.setMock(HttpCalloutMock.class, new CkeMailClientMockHttp_Test());
        CkePackRequestController.Command cmd = getData();
        CkePackRequestController.processSubmit(cmd);

    }

}