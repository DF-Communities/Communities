@isTest
public class ExchangeGroupAccess_Batcher_Test {
    
    @isTest static void test_method_one() {
     Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
        
           
         string communityName = Community_Settings__c.getInstance('Exchange_Site').value__c;
         Id communityId = DF_Utils.getCommunityId(communityName);
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

         User u2 = new User(Alias = 'newUser', Email='newuser@testexchange.com',

         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',

         LocaleSidKey='en_US', ProfileId = p.Id,

         TimeZoneSidKey='America/Los_Angeles', UserName='user123exchange@testexchange.test');

         
         system.runAs(u2){
         CollaborationGroup gp = new CollaborationGroup(
          Name = 'ExchangeGroupAccess',  //Group name must be unique
          CollaborationType = 'Private',
          NetworkId = communityId,
          CanHaveGuests = false,
          IsArchived = false,
          IsAutoArchiveDisabled = true
           );
          insert gp;
          }
          List<CollaborationGroup> lisgp = new List<CollaborationGroup>();
          lisgp = [select id from CollaborationGroup where name ='ExchangeGroupAccess'];
          CollaborationGroupMemberRequest cgmr = new CollaborationGroupMemberRequest();
          
          
          cgmr.CollaborationGroupId = lisgp[0].Id;
          cgmr.requesterid= UserInfo.getUserId();
         
          Test.startTest();
          insert cgmr;
         

       
       ExchangeGroupAccess_Batcher batch = new ExchangeGroupAccess_Batcher();
       database.executebatch(batch,4);
    }
    
    
}