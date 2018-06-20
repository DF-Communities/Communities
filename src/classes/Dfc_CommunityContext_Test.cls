@isTest
class Dfc_CommunityContext_Test
{

  @testSetup
  static void setupData() {

            Dfc_DataFactory_Test.TestDataCreation();
  }

  @isTest
  static void itShould()
  {
              Dfc_CommunityContext context = new Dfc_CommunityContext();

              DFC_DAA_Region__c[] regions = context.regions;

              DFC_Alliance__c[] alliances = context.alliances;

              DFC_Action_Area__c[] actionAreas = context.actionAreas;

              DFC_Activity__c[] activities = context.activities;

              DFC_County__c[]  counties = context.counties;
    
              UserRecordAccess[]  access = context.access;

              User u = [SELECT Id FROM User WHERE Email = 'test1.testcontact@myemail.com'];    
            
              String userId = UserInfo.getUserId();
              context.currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId];

              User u2                          = context.currentUser; 

              DF_Contact__c currentContact = context.currentContact;
              
  }
  

  }