@IsTest 

public without sharing class WEBFriendEditMyDetailsTest {
   
      @IsTest
     public static void covermethodTest() {
     
    
      
         Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();   
         User u = (User)mapTestData.get('User');
        //Contact c = (Contact)mapTestData.get('Contact');
        //Demographic_Information__c dg =( Demographic_Information__c)mapTestData.get('Demographic');
        
        test.starttest();
        System.runAs(u) {
         PageReference pageRef = Page.WEBFriendEditMyDetails;        
         WEBFriendEditMyDetails controller = new WEBFriendEditMyDetails();
                   
         controller.clientdgdata.ethnic_group__c='please specify';
         controller.clientdgdata.ethnic_group_other__c='test';
            controller.emailOptIn = false;
             controller.telephoneOptIn = false;
             controller.textMessageOptIn = false;
             controller.socialMediaOptIn = false;
             controller.postOptOut = false;
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
        System.assertEquals(null,controller.saveUserDetails());

        controller.thisUser.firstName = '';
        controller.thisUser.lastName = '';
        
         
        controller.dfContactRecord.First_Name__c = '';
        controller.dfContactRecord.Last_Name__c = '';
        controller.dfContactRecord.Postcode__c = '';
        controller.dfContactRecord.Title__c ='Other';
        controller.dfContactRecord.Birthdate__c =date.today().addyears(-19);
        controller.proximitystring='carer;professional';
        controller.proximity = proximitylis;
        System.assertEquals(null,controller.saveUserDetails());
        WEBFriendEditMyDetails.updateUserRecord(u.Id, u.Email, u.FirstName, u.LastName);
        controller.getProxmityOptions();
        controller.saveUserDetails();
        
        
        }
        
    }
}