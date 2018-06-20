@isTest
private class DF_Push_Notifications_Ctr_Test {
	
	@isTest static void test_method_one() {
		// Implement test code
		 /* Run a search for Push notifications */
               
        DF_Push_Notifications_Controller pushCtrl = new DF_Push_Notifications_Controller();
                      
        pushCtrl.clicked();

        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();        
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('Champion');  

        Test.startTest();
                       
        List<SelectOption> lis = pushCtrl.getTypeOptions(); 
        List<String> lisSelection = new List<String>();    
        String regionSelection ='';
      
        lisSelection.add(lis[0].getValue());
        pushCtrl.type_selection = lisSelection;
      
        lis = pushCtrl.getInterestsOptions(); 
        lisSelection = new List<String>();    
        lisSelection.add(lis[0].getValue());
        pushCtrl.interests_selection = lisSelection;

        lis = pushCtrl.getRegionOptions(); 
        regionSelection='London';
        pushCtrl.region_selection = regionSelection;

        pushCtrl.totalfriendsmin ='';
        pushCtrl.totalfriendsmax = '';

        Date sessionDate = date.newInstance(1990, 11, 21);
        Date sessionDate2 = date.newInstance(1990, 12, 21);
        Date champtraining = date.newInstance(1985, 11, 21);
        Date champtraining2 = date.newInstance(1986, 11, 21);

        pushCtrl.latestsession = sessionDate;
        pushCtrl.latestsession2 = sessionDate2 ;
        pushCtrl.champtraining = champtraining;
        pushCtrl.champtraining2 = champtraining2;
        pushCtrl.newsletter ='True';
        pushCtrl.nextPage();
        pushCtrl.previousPage();
        pushCtrl.changeRecordsPerPage();
        pushCtrl.init();
        pushCtrl.runSearch();
        
        pushCtrl.toggleSort();
              
    }
  

  	@isTest static void test_method_two() {

        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();        
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('Champion');  
        dfc.Status__c =DF_Utils.STATUS_CONVERTED;
        update dfc;
        Test.startTest();
        PageReference pageRef = Page.DF_Push_Notifications;

        Test.setCurrentPage(pageRef);

        DF_Push_Notifications_Controller pushCtrl = new DF_Push_Notifications_Controller();
        pushCtrl.totalfriendsmin ='';
        pushCtrl.totalfriendsmax = '';
        pushCtrl.init() ;
        pushCtrl.runSearch();
        system.assertNotEquals(null,pushCtrl.DFCWrappersList.size());
        pushCtrl.processSelected();
        pushCtrl.selectedDFCs.put(dfc.id,dfc);
     
        pushCtrl.pushMessage ='test';
        pushCtrl.title='test';
        pushCtrl.btnTitle='test';
        pushCtrl.btnLink ='test';
        pushCtrl.addMessages();


     }
}