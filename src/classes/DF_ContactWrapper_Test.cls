@isTest
private class DF_ContactWrapper_Test
{

  
    @isTest
    static void doTest1()
    {
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');  
                
        Test.startTest();
        DF_Contact_Wrapper dfcW = new DF_Contact_Wrapper(dfc);
        
        boolean b = dfcW.isSubscriber;
        b = dfcW.isChampion;
        b = dfcW.isChampionConverted;
        
        b = dfcW.isFriend;
        b = dfcW.isFriendConverted;

    }


    /* Confirm Friend */
    @isTest
    static void doTest2()
    {
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');  
        test.starttest();
        DF_Contact_Wrapper dfcW = new DF_Contact_Wrapper(dfc);

        String s = dfcW.confirmFriend('DEMENTIAFRIEND123'); 
        system.assertEquals(true, dfcW.isFriendConverted);

    }

    /* Confirm Friend Bad Code */
    @isTest
    static void doTest3()
    {
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');  

        test.starttest();
        DF_Contact_Wrapper dfcW = new DF_Contact_Wrapper(dfc);
              
        String s = dfcW.confirmFriend('XXX');   
        system.assertEquals(false, dfcW.isFriendConverted);

        s = dfcW.confirmFriend('');             
        system.assertEquals(false, dfcW.isFriendConverted);

    }

    /* Convert to Champion */
    @isTest
    static void doTest4()
    {
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');  

        DF_Contact_Wrapper dfcW = new DF_Contact_Wrapper(dfc);
        test.starttest();
        Boolean b = dfcW.convertToChampion();               
        system.assertEquals(true, dfcW.isChampion);

        b = dfcW.convertToFriend();
        system.assertEquals(true, dfcW.isFriend);       

    }


    /* Convert to Champion and Convert */
    @isTest
    static void doTest5()
    {
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');  
        Partner_Organisation__c part = (Partner_Organisation__c)mapTestData.get('partnerOrg');
                
        Test.startTest();
        DF_Contact_Wrapper dfcW = new DF_Contact_Wrapper(dfc);
        
        Boolean b = dfcW.convertToChampion();               
       // String s = dfcW.confirmChampion(part.DFC_Code__c);
        
        Boolean d = dfcw.isFriendProspective;
        dfc.Status__c =  DF_Utils.STATUS_CONVERTED ;
        Contact df=dfcw.Contact;
        User u = dfcw.User;
        boolean c = dfcw.isChampionActive;
        String e = dfcw.ChampionStatus;
        dfc.Code_verefied__c = true;
        update dfc;
        
       // system.assertEquals(true, dfcW.isChampionActive);

        dfcW.convertToFriend();
       // system.assertEquals(true, dfcW.isFriendConverted);

    }


    /* Convert to Champion and Convert bad code*/
    @isTest
    static void doTest6()
    {
        
        Map<String, Object> mapTestData= DF_DataFactory_Test.getTestData();     
        DF_Contact__c dfc2 = (DF_Contact__c)mapTestData.get('DFc2');  
        Lead lead=new Lead(
                      Company='Test',
                      df_contact__c = DFc2.id,  
                      LastName = 'test',  
                      FirstName= 'test',                              
                      Number_of_employees__c = '8',
                      Sector__c = 'Other',
                      Sector_other__c = 'Test',
                      RecordTypeId = DF_Utils.getsObjectRecordTypeId('Lead','Dementia_Friends_Website'),
                      LeadSource='Web',
                      status='Open' ,
                      partner_code__c = 'test55'
                      );
                      insert lead;
        
        Partner_Organisation__c part = (Partner_Organisation__c)mapTestData.get('partnerOrg');
        DF_Contact_Wrapper dfcW = new DF_Contact_Wrapper(dfc2);
        system.assertNotEquals(null,dfcw.orgLeads);
        test.starttest();
        Boolean b = dfcW.convertToChampion();
        
      
                
        //String s = dfcW.confirmChampion('dfc123');
        system.assertEquals(false, dfcW.isChampionConverted);

       // s = dfcW.confirmChampion('');
        system.assertEquals(false, dfcW.isChampionConverted);


    }
    
    

}