@isTest
private class Dfc_Util_Test
{

    @testSetup
    public static void setupData() {

        Dfc_DataFactory_Test.TestDataCreation(); 

        // Set some of the focus areas to be selected
        List<DFC_Community_Action_Area__c> actions = [select id, Community__c, Selected__c from DFC_Community_Action_Area__c order by Community__c];
        String id = actions[0].Community__c;
        Integer i = 0;
        for ( DFC_Community_Action_Area__c action : actions ) { 

            String cid = action.Community__c;
            if ( cid != id ) { i = 0; }

            if ( i< 4 ) { action.Selected__c= true;}

        }

        update actions;

    }

    // test get communities, related activities and get invites
    // and a new unregistered representative
    @isTest
    static void itShould()
    {

        // Get the user linked to the Active Community with Assessment
        User u = [select Id from User where Email = 'test2.testcontact@myemail.com'];    
        DFC_Community__c comm = [select Id from DFC_Community__c limit 1];
        comm.Status__c = 'Active';
        update comm;

        test.startTest();

        // Run as a specific user
        System.runAs(u) {

         // Get the current Communities   
         List<DFC_Community__c> communities = Dfc_Util.getCommunitiesForCurrentUser();
         DFC_Community__c community = communities[0];
         System.assertEquals('Here Somewhere', community.Location__c);

         // Get an assessment
         DFC_Assessment__c assessment = Dfc_Util.getAssessmentForCommunityAndYear(community.Id, 1);
         System.assertEquals(1, assessment.Year_Number__c);
         
         DFC_Assessment__c assess = Dfc_Util.readAssessment(assessment.Id);
         DFC_Activity__c[] activities = Dfc_Util.readCommunityActivities(community.Id);

         // Get the community activities
         Object o = Dfc_Util.readCommunityActivitiesWithSigning(community.Id);

         o = Dfc_Util.getDraftContext(community);

         String contactId = Dfc_Util.getDfContactIdForCurrentUser();       
         DFC_Community_Representative__c invited = Dfc_Util.inviteRepresentative(community.Id, 'someonelese@myemail.com', 'Test Another');


       }


        test.stopTest();
    }

     // test create assessment
    @isTest
    static void itShould2()
    {

        // Get the user linked to the Active Community with Assessment
        User u = [select Id from User where Email = 'test1.testcontact@myemail.com'];    
        DFC_Community__c comm = [select Id, Name__c, Status__c from DFC_Community__c where Status__c = 'Draft'];
        comm.Status__c = 'Active';
        comm.Date_Submitted__c = system.today().addYears(-1).adddays(-1);
        comm.Date_Approved__c  = system.today().addYears(-1).adddays(-1);

        update comm;

        test.startTest();

        // Run as a specific user
        System.runAs(u) {

         DFC_Assessment__c assessment = Dfc_Util.getAssessmentForCommunityAndYear(comm.Id, 1);
         System.assertEquals(1, assessment.Year_Number__c);         

       }


        test.stopTest();
    }


    // test getting communities for DAA
    @isTest
    static void itShould3()
    {

        DFC_Alliance__c alliance = [select Id from DFC_Alliance__c where Name= 'DFC Test Alliance' limit 1];
        // In the Test Scenario, there are two communities linked to this Alliance
        List<DFC_Community__c> lis = Dfc_Util.getCommunitiesForDaa(alliance.Id);
        System.assertEquals(2, lis.size());

    }


    // Test getting find id for email
    @isTest
    static void itShould4()
    {

        List<DF_Contact__c> lis = [select Email__c from DF_Contact__c where Email__c = 'test1.testcontact@myemail.com'];
        String s = Dfc_Util.findIdForEmail('test1.testcontact@myemail.com', lis);

        System.assertEquals(lis[0].id, s);

    }

    // Update assessment
    @isTest
    static void itShould5()
    { 


        // Get the user linked to the Active Community with Assessment
        User u = [select Id from User where Email = 'test2.testcontact@myemail.com'];    

        test.startTest();

        // Run as a specific user
        System.runAs(u) {

         // Get the current Communities   
         List<DFC_Community__c> communities = Dfc_Util.getCommunitiesForCurrentUser();
         DFC_Community__c comm = communities[0];
         
         // Get an assessment
         DFC_Assessment__c assessment = Dfc_Util.getAssessmentForCommunityAndYear(comm.Id, 1);

         List<DFC_Assessment_Answer__c> answers = [select id from DFC_Assessment_Answer__c where Assessment__c =: assessment.id];
         Dfc_Util.updateAssessment(assessment.id, 'Submitted', answers);         
         
        }


    }

    // Activity and update Community methods
    @isTest
    static void itShould6()
    { 
          
          User u = [select Id from User where Email = 'test2.testcontact@myemail.com'];    

          test.startTest();

          DFC_Activity__c activity = [select id from DFC_Activity__c limit 1];
          DFC_Activity__c activity1 = Dfc_Util.readActivity(activity.id);

        // Run as a specific user
        System.runAs(u) {

          DFC_Community__c comm = Dfc_Util.getCommunitiesForCurrentUser()[0];
          List<DFC_Community_Action_Area__c> areas = [select id from DFC_Community_Action_Area__c where Community__c =: comm.id];
          String[] ids = new String[]{};
          for ( DFC_Community_Action_Area__c area : areas ) { ids.add(area.id); }

          activity = new DFC_Activity__c(
                Title__c = 'Activity 1',
                Description__c = 'Activity Description',
                Community__c = comm.Id,
                Start__c =  system.today() + 90);
    
           Map<String, Object> result = Dfc_Util.addActivity(comm.id, activity, ids);
            
           activity.Title__c = 'Updated'; 
           result = Dfc_Util.updateActivity(activity, ids);

           // Update the Community
           comm.Name__c = 'Updated';
           DFC_Community__c comm2 = Dfc_Util.updateCommunity(comm, areas);

           // Update the action areas
           List<DFC_Community_Action_Area__c> areas2 = Dfc_Util.updateActionAreas(comm.id, areas);

           //Validate the Community
           Dfc_Util.validateCommunity(comm);

        }

        // Add an attachment 
        Attachment attach=new Attachment();

        attach.Name='Unit Test Attachment ';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.Body=bodyBlob;
        attach.ParentId=activity.id;
        attach.ContentType = 'application/msword';
        attach.IsPrivate = false;
        attach.Description = 'Test';

        insert attach;

        System.runAs(u) {

          Object o = Dfc_Util.removeActivityAttachment(activity.id, attach.id);
          List<DFC_Community_Action_Area__c> actions = Dfc_Util.removeActivity(activity.Id);


        }


  }


    // Create Community
    @isTest
    static void itShould7()
    { 

        // Get the user linked to the Active Community with Assessment
        User u = [select Id from User where Email = 'test2.testcontact@myemail.com'];    

        test.startTest();

        // Run as a specific user
        System.runAs(u) {

            DFC_Community__c comm = Dfc_Util.createNewCommunity();
         
        }


    }

    // Active Context
    @isTest
    static void itShould8()
    { 

        // Get the user linked to the Active Community with Assessment
        User u = [select Id from User where Email = 'test2.testcontact@myemail.com'];    

        test.startTest();

        // Run as a specific user
        System.runAs(u) {

         // Get the current Communities   
         List<DFC_Community__c> communities = Dfc_Util.getCommunitiesForCurrentUser();
         DFC_Community__c comm = communities[0];

         Dfc_CommunityContext context = Dfc_Util.getActiveContext(comm);        
         
        }


    }

   // Activity Methods
    @isTest
    static void itShould9()
    { 

        // Get the user linked to the Active Community with Assessment
        User u = [select Id from User where Email = 'test2.testcontact@myemail.com'];    

        test.startTest();

        // Run as a specific user
        System.runAs(u) {

         // Get the current Communities   
         List<DFC_Community__c> communities = Dfc_Util.getCommunitiesForCurrentUser();
         DFC_Community__c comm = communities[0];

         Dfc_CommunityContext context = Dfc_Util.getActiveContext(comm);        
         
        }


    }


    // Add a new representative methods
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

         DFC_Community_Representative__c  rep = Dfc_Util.addRepresentative(comm.Id, 'someonenew@myemail.com');

         rep = Dfc_Util.addRepresentative(comm.id, 'test4.testcontact@myemail.com');         

         Dfc_Util.deleteRepresentative(comm.id, rep.id);

        }


    }

    // Signed payload
    @isTest
    static void itShould11()
    { 

        String s = 'payload';
        String payload = Dfc_Util.createSignedPayload(s);
        String result = Dfc_Util.extractSignedPayload(payload);

    }
    
  

    // Snippetts
    @isTest
    static void itShould12()
    { 


        Page_Snippet__c snip = new Page_Snippet__c();
        snip.Name__c = 'x';
        snip.Unique_Name__c = 'x';
        snip.Body_Text__c = 'x';
        insert snip;

        String s = Dfc_Util.readSnippet('x');
        snip.Body_Text__c = 'y';

        Dfc_Util.updateSnippet(snip);



    }

    // Resources
    @isTest
    static void itShould13()
    { 


        DFC_Resource__c res = new DFC_Resource__c();
        res.Title__c = 'x';
        res.Description__c = 'x';
        res.Applies_To_Status__c = 'Draft';
        insert res;

        Map<String, Object> result = Dfc_Util.getResourcesForState('Draft');

    }



}