@isTest
public class DF_Utils_Test {
    

    static testMethod void doTest1() {
        
        Test.startTest();           // Reset CPU Time, DML and other governor limits
        // --------------------------------------------------------------------------
        Map<String, RecordType> mapRT = DF_Utils.getDfcRecordTypesMap();
        
        mapRT = DF_Utils.getContactRecordTypesMap();
        mapRT = DF_Utils.getDfcRecordTypeIdMap();
        mapRT = DF_Utils.getDfEventRecordTypeIdMap();
        mapRT = DF_Utils.getDfEventRecordTypesMap();
        // --------------------------------------------------------------------------
        Test.stopTest();             // Forces asynchronous code to complete
    }

    static testMethod void doTest2() {
        Test.startTest();
        // --------------------------------------------------------------------------
        String s = DF_Utils.getContactRecordTypeId('Champion');       
        s = DF_Utils.getDfcRecordTypeId('Champion');
        s = DF_Utils.getDfEventRecordTypeId('Champion_Training_Course');
        // --------------------------------------------------------------------------
        Test.stopTest();

    }   

    static testMethod void doTest3() {


        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
        
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');  

        Test.startTest();
        // --------------------------------------------------------------------------
        Contact contact = DF_Utils.getContactRecord(dfc);

        User u = (User)mapTestData.get('User');
        DF_Contact__c dfc2 =  DF_Utils.getDFContactForUser(u.id);
        Contact con = DF_Utils.getContactRecordForDfcId(dfc.id);
        
        User u2 =DF_Utils.getUserRecord(dfc);
       
        boolean b = DF_Utils.hasUserRecord(dfc);

        b=DF_Utils.isChampion(dfc);
        b = DF_Utils.isFriend(dfc);
        b = DF_Utils.isFriendConverted(dfc);
        b = DF_Utils.isSubscriber(dfc);

        dfc = (DF_Contact__c)mapTestData.get('Champion');  
        b = DF_Utils.isChampionRetired(dfc);
        b = DF_Utils.isChampionConverted(dfc); 
        b = DF_Utils.isChampionProspective(dfc);
        b = DF_Utils.isChampionVerified(dfc);
        b = DF_Utils.isChampionDeclined(dfc);
        b = DF_Utils.isChampionSuspended(dfc);
        b = DF_Utils.isChampionHiatus(dfc);

        List<Action__c> actions = DF_Utils.dfActions(dfc);

        // --------------------------------------------------------------------------
        Test.stopTest();
    }

    static testMethod void doTest4() {

        List<SelectOption> lis = DF_Utils.ethnicGroupOptions;
        lis = DF_Utils.genderOptions;

    }

    static testMethod void doTest5() {

        Integer i = DF_Utils.totalFriendCount;

    }

    static testMethod void doTest6() {

    Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
    Test.startTest();
    // --------------------------------------------------------------------------
    Map<String, Partner_Organisation__c> mapPO = DF_Utils.getPartnerOrgMap();
    String s = DF_Utils.getOrgIdForChampionCode('testpo123');

    }
    
   
    static testMethod void doTest7() {


        Champion_Codes__c c = new Champion_Codes__c();
        c.Name = 'xxxx';
        c.Code__c = 'xxx';
        insert c;
        List<String> lis = DF_Utils.listchampionCodes; 

    }

    static testMethod void doTest8() {


        Champion_Codes__c c = new Champion_Codes__c();
        c.Name = 'xxxx';
        c.Code__c = 'xxx';
        insert c;
    
        sObject o = DF_Utils.objectWithAllFields('id', c.id, Schema.sObjectType.Champion_Codes__c);

    }    

    static testMethod void doTest9() {

        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();
        Contact contact = (Contact)mapTestData.get('contact');
        String s = DF_Utils.getCustomSetting('DF_Friend_Count_Baseline_Date');
        s = DF_Utils.getActionRecordTypeId('Partner_Action');
        s = DF_Utils.getContactRecordTypeName(contact.RecordTypeId);

        DF_Contact__c dfc = DF_Utils.getDFContactForEmail(contact.Email);


    }

     static testMethod void doTest10() {

        Schema.DescribeFieldResult field = DF_Contact__c.Type_Of_Champion__c.getDescribe();
        List<SelectOption> options = new List<SelectOption>();
        options = DF_Utils.getOptions(field);
        String s='';
        s=DF_Utils.getNetworkId('Champion Exchange');
        String perm;
        perm = DF_Utils.getPermissionSetId('Exchange_User');


    }
   

}