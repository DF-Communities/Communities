/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : test class for ExchangeCommunityGroupAccess 
 *  Author  : Lakshmi Vasudevan
 *  Date    : 20/01/2017
 *  Version : 0.1 Unit Test
 *    
 *  Description: 
 *               
 *  Modification History
 *  Date            Who         Description 
  
 
                            
*******************************************************************************************/
@isTest
private class ExchangeCommunityGroupAccess_Test {
	
	@isTest static void test_method_one() {
		
		 Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
		 Set <Id> userIds = new Set<Id>();
		 Id gpId ;
		 User u = (User)mapTestData.get('User2');  
         userIds.add(u.Id);
         
         System.runAs ( new User(Id = UserInfo.getUserId()) ) {

         

         CollaborationGroup gp = new CollaborationGroup(
          Name = 'General',  //Group name must be unique
          CollaborationType = 'Private',
          CanHaveGuests = false,
          IsArchived = false,
          IsAutoArchiveDisabled = true
           );
          insert gp;
          gpId=gp.Id;

       }
       Test.startTest();
         ExchangeCommunityGroupAccess ecg = new ExchangeCommunityGroupAccess(userIds,gpId);
         ID jobID = System.enqueueJob(ecg);
       Test.stopTest();
	}
	
}