@isTest
without sharing class Dfc_AssessmentStoreController_Test {

    @testSetup
    static void setupData() {  Dfc_DataFactory_Test.TestDataCreation(); }

    @isTest
  	static void itShould()
  	{

  		// Get the test user linked to the Active Community
  		User testUser = [SELECT Id FROM User WHERE Email = 'test2.testcontact@myemail.com'];	


  		
  		System.runAs(testUser) {

  				Test.startTest();

          List<DFC_Community__c> communities = Dfc_Util.getCommunitiesForCurrentUser();

  				// Get the Assessment for Year 1

          DFC_Community__c community = communities[0];
          		
      		Integer assessmentYear = 1;
      		Object obj= Dfc_AssessmentStoreController.getAssessmentForCommunityAndYear(community.Id, assessmentYear) ;

      		DFC_Assessment__c assessment = (DFC_Assessment__c)obj;


  				// Get the Answers for that assessment
  				List<DFC_Assessment_Answer__c> answers =  
  				[SELECT Id,  Entered_Answer__c FROM DFC_Assessment_Answer__c 
  				 WHERE Assessment__c = :assessment.Id];

				  Dfc_AssessmentStoreController.updateAssessment(assessment.Id, 'Draft', answers);

				  Dfc_AssessmentStoreController.updateAssessment(assessment.Id, 'Draft', null);



                 // Now test getting an Assessment for year 99
			    assessmentYear = 99;
          obj= Dfc_AssessmentStoreController.getAssessmentForCommunityAndYear(community.Id, assessmentYear) ;
  			
  			}

  			Test.stopTest();

  			

    }

}