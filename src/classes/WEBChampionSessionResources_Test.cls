@istest
public class WEBChampionSessionResources_Test{
  static testmethod void testWEBChampionSessionResources()
    {
     Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
     User u  = (User)mapTestData.get('User2');  
      Session_Category__c scat = new Session_Category__c(name='testname',Description__c='testDescription',Type__c='Post');
       insert scat;
       
      Session_Resource__c sRes = new Session_Resource__c(Name__c ='testresorce',Type__c='Post',Session_Resource_Category__c = scat.id); 
       insert sRes;
      
      Blob b = Blob.valueOf('Test Data');  
      
    Attachment attachment = new Attachment();  
    attachment.ParentId = sRes.id;  
    attachment.Name = 'Test Attachment for Parent';  
    attachment.Body = b;  
      
    insert(attachment);   
     system.runAs(u){     
     test.starttest(); 
       WEBChampionSessionResources webResource = new WEBChampionSessionResources(); 
       system.assertnotequals(null,webResource.sessionResources);
       system.assertnotequals(null,webResource.att);
       system.assertnotequals(null,webResource.sessionCategories);
       WEBChampionSessionResources.sessionResourceCategory inCl = new WEBChampionSessionResources.sessionResourceCategory();
       
     
     }
      
    }
    
    }