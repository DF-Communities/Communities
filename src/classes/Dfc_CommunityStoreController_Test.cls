@isTest
public without sharing class Dfc_CommunityStoreController_Test {

    @testSetup
    public static void setupData() {

        Dfc_DataFactory_Test.TestDataCreation(); 

    }

    @isTest
    public static void CoverMethod() {

	   	User u = [SELECT Id FROM User WHERE Email = 'test1.testcontact@myemail.com'];
	   	DFC_Community__c comm = [select Id from DFC_Community__c limit 1];

		DFC_Activity__c activity = new DFC_Activity__c();
		activity.Title__c = 'xxx';
		activity.Description__c = 'xxx';
		activity.End__c = System.now();
		activity.Start__c = System.now();
		activity.Community__c = comm.id;
		insert activity;


	   	DFC_Action_Area__c area = [select Id from DFC_Action_Area__c limit 1];
	   	System.runAs(u) { 

	   		DFC_CommunityStoreController ctl = new DFC_CommunityStoreController();
	   		comm = (DFC_Community__c) DFC_CommunityStoreController.getCommunity(comm.Id);	   		
			Object o = DFC_CommunityStoreController.removeActivity(activity.Id);
		
	   	}

	}   	

    @isTest
    public static void CoverMethod2() {

	   	User u = [select Id from User where Email = 'test1.testcontact@myemail.com'];
	   	DFC_Community__c comm;

	   	test.startTest();

	   	DFC_Action_Area__c area = [select Id from DFC_Action_Area__c limit 1];
	   	System.runAs(u) { 

	   		DFC_CommunityStoreController ctl = new DFC_CommunityStoreController();

	   		String currentUserId = DFC_CommunityStoreController.getCurrentUserId();

	   		List<DFC_Community__c> communities = Dfc_Util.getCommunitiesForCurrentUser();

	   		comm = (DFC_Community__c) DFC_CommunityStoreController.getCommunity(communities[0].Id);

	   		DFC_Community_Action_Area__c[] actions1 = (DFC_Community_Action_Area__c[])DFC_CommunityStoreController.getCommunityActionAreas(comm.Id);	   		
			comm = (DFC_Community__c)DFC_CommunityStoreController.updateCommunity(comm, actions1);

			DFC_Community_Action_Area__c[] actions2 = (DFC_Community_Action_Area__c[])DFC_CommunityStoreController.updateActionAreas(comm.id, actions1);

			List<String> actionIds = new List<String>();
			for (DFC_Community_Action_Area__c action : actions1) {
				actionIds.add(action.id);
			}

			String sJson = JSON.serialize(actionIds);

			DFC_Activity__c activity = new DFC_Activity__c();
			activity.Title__c = 'xxx';
			activity.Description__c = 'xxx';
			activity.End__c = System.now();
			activity.Start__c = System.now();

			Map<String, Object> mapReturn = (Map<String, Object>)DFC_CommunityStoreController.addActivity(comm.id, activity, sJson);

			Map<String, Object> actMap = (Map<String, Object>)DFC_CommunityStoreController.getCommunityActivities(comm.Id);
			
			List<String> keys = new List<String>(actMap.keyset());
			List<DFC_Activity__c> activities = (List<DFC_Activity__c>)actMap.get(keys[0]);
			
			DFC_Activity__c activity2 = activities[0];
			activity2.Description__c = 'Updated';
			DFC_CommunityStoreController.updateActivity(activity2,sJson);

		
	   	}

	   	test.stopTest();

	}   	


	@isTest
    public static void CoverMethod3() {

	   	User u = [select Id from User where Email = 'test1.testcontact@myemail.com'];
	   	DFC_Community__c comm = [select Id from DFC_Community__c limit 1];
	   	DFC_Community__c comm3 = (DFC_Community__c)DFC_CommunityStoreController.getCommunity(comm.id);

	   	DFC_Action_Area__c area = [select Id from DFC_Action_Area__c limit 1];
			
		comm.Status__c = 'Active';
		update comm;
	   	
		DFC_Community__c comm2;
		DFC_CommunityContext context;

	  // 	System.runAs(u) { 
	//		context = (DFC_CommunityContext)DFC_CommunityStoreController.getActiveForUserWithContext();
	//	}	

		comm.Status__c = 'Draft';
		update comm;
		
	//	System.runAs(u) { 
	//		context = (DFC_CommunityContext)Dfc_CommunityStoreController.getDraftForUserWithContext();			
	//		List<DFC_Community__c> lis = (List<DFC_Community__c>)DFC_CommunityStoreController.getCommunitiesForDaa(comm.DA_Alliance__c);
	//   	}

   		DFC_CommunityStoreController ctl2 = new DFC_CommunityStoreController();
  		DFC_Community__c comm4 = (DFC_Community__c) DFC_CommunityStoreController.getCommunity(comm.id);

	}   	

	@isTest
    public static void CoverMethod4() {

	   	User u = [select id from User where Email = 'test1.testcontact@myemail.com'];
	   	DFC_Community__c comm = [select id from DFC_Community__c limit 1];
		DFC_Community_Representative__c rep = [select Id from DFC_Community_Representative__c where Community__c =: comm.id];

	   	DFC_Action_Area__c area = [select Id from DFC_Action_Area__c limit 1];
	   	System.runAs(u) { 

			Object o = DFC_CommunityStoreController.addRepresentative(comm.id, 'random.guy@random.place.xxx');
			o = DFC_CommunityStoreController.inviteRepresentative(comm.id, 'other.guy@random.place.xxx', 'Random Guy');
			
		//	o = DFC_CommunityStoreController.representativeConflict('test.testcontact@myemail.com');
			o = DFC_CommunityStoreController.removeRepresentative(comm.id, rep.id);

		
	   	}

	}

    @isTest
    public static void CoverMethod5() {

   		List<DFC_Activity__c> lisAct = [select Id from DFC_Activity__c];
   		List<Attachment> lis = [select id, parentid from Attachment where parentid in :lisAct];
   		Attachment att = lis[0];
   		Object o = DFC_CommunityStoreController.removeActivityAttachment(att.parentId, att.id);

	}   	


    @isTest
    public static void CoverMethod6() {

	   	User u = [select Id from User where Email = 'test3.testcontact@myemail.com'];
	   	System.runAs(u) { 

	   		String s = (String)DFC_CommunityStoreController.getCurrentContactId();	   			   		

	   	}

	}   	


	// Throw Errors in each method. Feed in bad parameters
	@isTest
	public static void CoverMethod7() { 

		 List<DFC_Community_Action_Area__c> lis = new List<DFC_Community_Action_Area__c>();	   		


		DFC_CommunityStoreController ctl = new DFC_CommunityStoreController();
	   	Dfc_ErrorResponse e = (Dfc_ErrorResponse)DFC_CommunityStoreController.getCommunity('xxx');
		e = (Dfc_ErrorResponse)DFC_CommunityStoreController.getCommunityActionAreas('xxx');	   
		e = (Dfc_ErrorResponse)DFC_CommunityStoreController.getCommunityActivities('xxx');		

    	e = (Dfc_ErrorResponse)DFC_CommunityStoreController.getCommunity('Garbage');    

		e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.getCommunityActionAreas('xxx'); 
    	e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.getCommunityActivities('xxx');
    	e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.updateCommunity(null, lis) ;
		e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.updateActionAreas('xxx', null); 
    	e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.addActivity('xxx', null, null); 
		e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.updateActivity(null, null); 
		e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.removeActivity('xxx'); 
		e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.removeActivityAttachment('xxx', 'xxx'); 
    	e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.addRepresentative('xxx', 'xxx'); 
		e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.inviteRepresentative('xxx', 'xxx', 'xxx'); 
		e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.removeRepresentative('xxx', 'xxxx'); 
	//	e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.getDraftForUserWithContext(); 
	//	e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.getActiveForUserWithContext();
		//e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.getCommunitiesForDaa(''); 
		e = (Dfc_ErrorResponse)Dfc_CommunityStoreController.getCurrentContactId(); 
    

    }


 }