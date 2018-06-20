@isTest
public class WebChampionActionList_Test {
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Test APEX Class for WebChampionActionList Apex Class.
 *  Author  : Lakshmi Rajendram
 *  Date    : 05-10-2015
 *  Version : 0.1 Unit Test
 *
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ??
 *                             
*******************************************************************************************/
static testMethod void mainTest(){


       WEBChampionActionList controller = new WEBChampionActionList();
       Page_Snippet__c  pagesnipp=new Page_Snippet__c(Name__c='Test',Body_Text__c='SampleText',Unique_Name__c='DementiaFriendsTotalSnippet');
       test.starttest();
       insert pagesnipp;      
       controller.totalfriendsSnippet=pagesnipp;
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
       User u = (User )mapTestData.get('User'); 
        DF_Contact__c df = (DF_Contact__c )mapTestData.get('Champion'); 
        DF_Event__c DFe = (DF_Event__c )mapTestData.get('FriendSession');
        Action__c  a = new Action__c (DF_Contact__c=df.id,Action__c='test', Public__c=true);
        insert a;
        
        List<Action__c> lis = new List<Action__c>();
        lis.add(a);
       controller.actions=lis;
       controller.thisUser =u ;
       
}

}