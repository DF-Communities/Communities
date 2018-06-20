@isTest
public class DF_Mail_Utils_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for DF_Mail_Utils
***********************************************************************************************/

    static testMethod void testSearchTaskHistory() {

    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 

    Task task = new Task();     
    task.whatId = DFChamp.id; 
    task.subject = 'xxx';
    task.Description ='xxx';   

    insert task;

    Map<String, task> mapTasks = new Map<String, task>();
    mapTasks.put(DFChamp.id + '~' + DF_Mail_Utils.DF_WELCOME_EMAIL, task);
    mapTasks.put(DFChamp.id + '~' + DF_Mail_Utils.DF_SUPERCHAMP_EMAIL, task);
    mapTasks.put(DFChamp.id + '~' + DF_Mail_Utils.DF_PROSNOTATTENDED_EMAIL, task);
    mapTasks.put(DFChamp.id + '~' + DF_Mail_Utils.DFC_ACTIVATE_CHAMP_ACCOUNT, task);
    mapTasks.put(DFChamp.id + '~' + DF_Mail_Utils.DFC_ENTERED_CODE_NO_SESSION, task);

    DF_Mail_Utils.searchTaskHistory(mapTasks, DFChamp.id, DF_Mail_Utils.DF_WELCOME_EMAIL);
    DF_Mail_Utils.searchTaskHistory(mapTasks, DFChamp.id, DF_Mail_Utils.DF_SUPERCHAMP_EMAIL);
    DF_Mail_Utils.searchTaskHistory(mapTasks, DFChamp.id, DF_Mail_Utils.DF_PROSNOTATTENDED_EMAIL);
    DF_Mail_Utils.searchTaskHistory(mapTasks, DFChamp.id, DF_Mail_Utils.DFC_ACTIVATE_CHAMP_ACCOUNT);
    DF_Mail_Utils.searchTaskHistory(mapTasks, DFChamp.id, DF_Mail_Utils.DFC_ENTERED_CODE_NO_SESSION);

    }

    static testMethod void coverMethod () {

    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 
    DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
    
    DFchamp.Status__c = 'Converted';
    DFeatt.EventAttendeeStatus__c = 'Attended';
    
    test.starttest();
    update DFchamp;
    update DFeatt;
    List<Task> lisTask =[select whatid,id,DFC_email_tracker__c from Task where DFC_email_tracker__c !=null and whatid =:DFchamp.Id];
    DF_Mail_Utils.isDuplicateEmail(DFchamp, 'TEREF01',lisTask );
       
    DF_Mail_Utils.isDuplicateEmail(DFchamp,'TEREF04',lisTask );
        
    
     
    }
    
    static testMethod void coverMethod1 () {

    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 
    DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
    
    
    DFchamp.Status__c = 'Prospective';
    DFeatt.EventAttendeeStatus__c = 'No show';
    
    
    test.starttest();
    update DFchamp;
    update DFeatt;
    List<Task> lisTask2 =[select whatid,id,DFC_email_tracker__c from Task where DFC_email_tracker__c !=null and whatid =:DFchamp.Id];
    DF_Mail_Utils.isDuplicateEmail(DFchamp, 'TEREF03',listask2 );
    
    }
    
    static testMethod void coverMethod2 () {

    Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
    DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 
    DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
    
    DFchamp.Status__c = 'Converted';
    DFchamp.Type_of_Champion__c = 'Super Champion';
    
    
    test.starttest();
    update DFchamp;
    List<Task> lisTask =[select whatid,id,DFC_email_tracker__c from Task where DFC_email_tracker__c !=null and whatid =:DFchamp.Id];
    List<DF_Contact__c> conlis = [select id from DF_Contact__c where id =:DFchamp.id];
    Map<String,Task> sMap= DF_Mail_Utils.getNextEmailCounterRequired(conlis, Df_Mail_Utils.DFC_CONGRATS_REACHING_X_DF);
    
    }
    
    
}