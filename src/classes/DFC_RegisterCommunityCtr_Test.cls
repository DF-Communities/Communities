@isTest
private class DFC_RegisterCommunityCtr_Test {
	
	@testSetup
    public static void setupData() {

        Dfc_DataFactory_Test.TestDataCreation(); 

        // Set some of the focus areas to be selected
        List<DFC_Community_Action_Area__c> actions = [select id, Community__c, Selected__c from DFC_Community_Action_Area__c order by Community__c];
        String id = actions[0].Community__c;
        DFC_Community__c comm = [select Id from DFC_Community__c where id=:id];
        Integer i = 0;
        for ( DFC_Community_Action_Area__c action : actions ) { 

            String cid = action.Community__c;
            if ( cid != id ) { i = 0; }

            if ( i< 4 ) { action.Selected__c= true;}

        }

        update actions;
        DFC_RegisterCommunityController.Community community = new DFC_RegisterCommunityController.Community();
        
        Object o= DFC_RegisterCommunityController.saveCommunity(community,id);
        DFC_RegisterCommunityController controller=new DFC_RegisterCommunityController();
        Object o2= controller.getdata();
    }

	
	@isTest static void test_method_one() {
		// Implement test code
      // Get the user linked to the Active Community with Assessment
        User u = [select Id from User where Email = 'test2.testcontact@myemail.com'];    
        DFC_Community__c comm = [select Id from DFC_Community__c limit 1];
        comm.Status__c = 'Active';
        update comm;
      System.runAs(u) {
		DFC_Community__c o= DFC_RegisterCommunityController.readCommunity(comm.id);
		
         Object ob = Dfc_Util.readCommunity(comm.id);
		 ob=DFC_RegisterCommunityController.context;

         ob = DFC_RegisterCommunityController.dfcDraftContext(comm.id);
         List<Object> rep =DFC_RegisterCommunityController.existingReps(comm.id);
         DFC_RegisterCommunityController controller= new DFC_RegisterCommunityController();
         
        } 
	
	}
      @isTest
	static void itShould10()
    { 

        // Get the user linked to the Active Community with Assessment
        User u = [select Id from User where Email = 'test2.testcontact@myemail.com'];    

        test.startTest();

        // Run as a specific user
        System.runAs(u) {

         // Get the current Communities   
         List<DFC_Community__c> communities = Dfc_Util.getCommunitiesForCurrentUser();
         DFC_Community__c comm = communities[0];

         DFC_Community_Representative__c  rep = DFC_RegisterCommunityController.addRepresentative(comm.Id, 'someonenew@myemail.com');

         rep = DFC_RegisterCommunityController.addRepresentative(comm.id, 'test4.testcontact@myemail.com');         
         rep = DFC_RegisterCommunityController.inviteRepresentative(comm.id, 'test5.testcontact@myemail.com','test invite');
         DFC_RegisterCommunityController.deleteRepresentative(comm.id, rep.id);
         object ob= DFC_RegisterCommunityController.handleinvites('test4.testcontact',comm.id) ;

         object ob2 = DFC_RegisterCommunityController.handleReps(comm.id,'test4@mail.com');
         
        }


    }

	 // test getting communities for DAA
    @isTest
    static void test_method_two()
    {
        DFC_Community__c comm = [select Id,name__c from DFC_Community__c limit 1];
        comm.name__c = 'test comm';
        
        DFC_Alliance__c alliance = [select Id from DFC_Alliance__c where Name= 'DFC Test Alliance' limit 1];
        // In the Test Scenario, there are two communities linked to this Alliance
        List<DFC_Community__c> lis = DFC_RegisterCommunityController.getCommunitiesForDaa(alliance.Id);
        System.assertEquals(1, lis.size());
        DFC_RegisterCommunityController.Community community = new DFC_RegisterCommunityController.Community();
        Object o= DFC_RegisterCommunityController.saveCommunity(community,comm.id);
        //DFC_RegisterCommunityController.validateCommunity(comm.id);
    }
	
}