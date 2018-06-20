/*
* 2014-03-25 : SM : Test methods for the DF_EventAttendeeTriggerMethods class
*/
@IsTest 
private class TestDF_EventAttendeeTriggerMethods {

  
    private static String FRIEND_RT_NAME = 'Dementia_Friend';
    private static String CHAMPION_RT_NAME = 'Dementia_Friend_Champion';
    private static String SESSION_RT_NAME = 'Dementia_Friend_Awareness_Session';
    private static String TRAINING_RT_NAME = 'Champion_Training_Course';
   

    
    
    
    
    static testmethod void testSessionTrigger() {
       Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();       
       DF_Event__c  testSession = (DF_Event__c)mapTestData.get('FriendSession');
       DF_Contact__c dfContactRecord = (DF_Contact__c)mapTestData.get('DFc');
        test.startTest();
      
        DF_EventAttendee__c dfe1 = new DF_EventAttendee__c();
        dfe1.DF_Contact__c = dfContactRecord.Id;
        dfe1.DF_Event__c = testSession.Id;
    
   
        
        
        insert dfe1;
        
        delete dfe1;
                
    }
    
    
    static testmethod void testTrainingTrigger() {        
        
       Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();   
       
       DF_Event__c  testTraining = (DF_Event__c)mapTestData.get('ChampCourse'); 
       DF_Contact__c dfContactRecord = (DF_Contact__c)mapTestData.get('DFc');
         
       test.startTest();
       
       DF_EventAttendee__c dfe1 = new DF_EventAttendee__c();
       dfe1.DF_Contact__c = dfContactRecord.Id;
       dfe1.DF_Event__c = testTraining.Id;
       system.debug('*** -- Test Code Debug 2 - ' + dfe1.DF_Contact__r.Portal_Contact__c + ' -- ***');
        //This should fire the first trigger
        
        
        insert dfe1;
        
        delete dfe1;
        
                
    }
}