@istest
public class WEBChampionPreTrainingMat_test{

 static testmethod void testWEBChampionSessionResources()
    {
     // List<Session_Category__c> sessCats = [SELECT Id, Name, Description__c FROM Session_Category__c]; 
      Session_Category__c scat = new Session_Category__c(name='testname',Description__c='testDescription');
       insert scat;
       
      Session_Resource__c sRes = new Session_Resource__c(Name__c ='testresorce',Type__c='Pre',Session_Resource_Category__c = scat.id); 
       insert sRes;
      
      Blob b = Blob.valueOf('Test Data');  
      
    Attachment attachment = new Attachment();  
    attachment.ParentId = sRes.id;  
    attachment.Name = 'Test Attachment for Parent';  
    attachment.Body = b;  
      
    insert(attachment);   
         
      WEBChampionPreTrainingMaterials webResource = new WEBChampionPreTrainingMaterials(); 
      
    }
  }