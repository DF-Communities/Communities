/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBChampionEditMyDetails.
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
@IsTest public without sharing class WEBChampionEditMyDetailsTest {
    
    @IsTest
    public static void championEditMyDetailsTest() {

        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();   
        User u = (User)mapTestData.get('User');
		
        System.debug('???: ' + u.Contact.DF_Contact__c);
        
         test.starttest();
         System.runAs(u) {
         PageReference pageRef = Page.WEBChampionEditMyDetails;        
         WEBChampionEditMyDetails controller = new WEBChampionEditMyDetails();
         List<SelectOption> ProxmityOptions = controller.getProxmityOptions();
         controller.getDate('2012-01-12');
             controller.emailOptIn = false;
             controller.telephoneOptIn = false;
             controller.textMessageOptIn = false;
             controller.socialMediaOptIn = false;
             controller.postOptOut = false;
             controller.infoSessionRadius = 25;
          Demographic_Information__c dg = controller.clientdgdata;
         controller.clientdgdata.ethnic_group__c='please specify';
         controller.clientdgdata.ethnic_group_other__c='test';
         List<SelectOption> titleList = controller.titleList;
         Page_Snippet__c pn= new Page_Snippet__c (
         Body_Text__c='test',
         Unique_Name__c='DementiaFriendsTotalSnippet',
         Name__c='test'
        );
         
         insert pn;
         
         pn= controller.totalFriendsSnippet;
         list<string> proximitylis = new list<string>(); 
         proximitylis .add('Carer');
         //System.assertEquals(null,controller.saveUserDetails());

        controller.thisUser.firstName = '';
        controller.thisUser.lastName = '';
        
         
        controller.dfContactRecord.First_Name__c = '';
        controller.dfContactRecord.Last_Name__c = '';
        controller.dfContactRecord.Postcode__c = '';
        controller.dfContactRecord.Title__c ='';
        controller.dfContactRecord.Contact_Number__c ='012345';
        controller.dfContactRecord.Champion_exchange_access__c=true;
        controller.dfContactRecord.Newsletters__c=true;
        controller.dfContactRecord.Street__c=''; 
        controller.dfContactRecord.County__c='';
        controller.dfContactRecord.City__c='';
        controller.dfContactRecord.User_opted_out__c =false;
        controller.dfContactRecord.Birthdate__c =date.today().addyears(-15).adddays(-10);
        controller.isChampion = true;
        controller.isChampionConverted = true;
        controller.proximity = proximitylis;

        List<SelectOption> genderOptionList = controller.genderOptionList;
        List<DF_Contact_Inbound_Change__c> contactDetailsChanged = controller.contactDetailsChanged;
        
        /*System.assertEquals(null,controller.saveUserDetails());
        System.assertNotEquals(null,controller.birthDateError);
        System.assertNotEquals(null,controller.phoneError);
         System.assertEquals(null,controller.convertToChampion());
        //System.assertEquals(null,controller.saveBirthdate());
         //System.assertEquals(true,controller.isError);
        //System.assertNotEquals(null,controller.clientDgData);*/
   
        WEBChampionEditMyDetails.updateUserRecord(u.Id, u.Email, u.FirstName, u.LastName);
        test.stopTest();
        controller.saveBirthdate();
        controller.convertToChampion();
        controller.saveUserDetails();
                     
         }
        
        
    }
   
    
    
}