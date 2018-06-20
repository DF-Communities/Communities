/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : test class for DFP_Utils 
 *  Author  : Lakshmi Vasudevan
 *  Date    : 04/05/2016
 *  Version : 0.1 Unit Test
 *    
 *  Description: 
 *               
 *  Modification History
 *  Date            Who         Description 
  
 
                            
*******************************************************************************************/

@isTest
private class DFP_Utils_Test {

    @testsetup  static void mytestdata(){   
     DFP_DataFactory_Test.TestDataCreation();   
    }

    static testMethod void myUnitTest() {
    
    List<Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
    List<DF_Contact__c> dfc = [select id,Email__c from DF_Contact__c limit 1];
    List<User> u  = [select id,name,contactId from User where email = 'test.testcontact@myemail.com' limit 1]; 
    List<Lead> lead = [select Id,Status from lead limit 1]; 
    test.starttest();
    Partner_Organisation__c p = DFP_Utils.currentOrg(partner[0].Id);
    Boolean shasActions =   DFP_Utils.hasActions(partner[0].Id);
    DFP_Utils.updatePartnerAdministrators(dfc);
    String s= DFP_Utils.findIdForEmail('test.testcontact@myemail.com',dfc);
    system.assertEquals(false,DFP_Utils.validEmail('asd@gagg'));
    system.assertEquals(true,DFP_Utils.validEmail('la@test.com'));
    system.assertEquals(true,DFP_Utils.isExistingAdmin('test.testcontact@myemail.com',partner[0].Id));
    system.assertNotEquals(null,DFP_Utils.getOrgsForDFC(dfc[0].Id));
    system.assertEquals(true,DFP_Utils.isExistingAdminbyOrgName('test.testcontact@myemail.com','Test Partner Name'));
    
    }
    
    static testMethod void myUnitTest2() {
    	
    List <Partner_Organisation__c> partner = [select id,name from Partner_Organisation__c where name='Test Partner Name' limit 1 ];
    List <Contact> c =[select id from contact where email='test.testcontact3@myemail.com' limit 1];
    List<DF_Contact__c> dfc2 = [select id,Email__c from DF_Contact__c  where email__c ='test.testcontact@myemail.com' limit 1];
    DF_Contact__c DFc = new DF_Contact__c();
    DFc.RecordTypeId = DF_Utils.getsObjectRecordTypeId('DF_Contact__c','Dementia_Friend');//mapRecordTypes.get('Dementia_Friend$DF_Contact__c').Id;
    DFc.First_Name__c ='test';
    DFc.Last_Name__c = 'test';
    DFc.Email__c = 'test.testcontact3@myemail.com';
    DFc.portal_contact__c = c[0].Id;
    insert DFc;
    test.starttest();
    Id partnerId=partner[0].Id;
   
    List<DFP_Utils.Leadwrapper> lw = DFP_Utils.getLeadsForDFC(dfc2[0].Id);	
    //system.assertNotEquals(null,DFP_Utils.Leadwrapper);
    system.assertNotEquals(null,DFP_Utils.inviteAdministrator(partnerId,'testadmin@mailinator.com','test admin'));	
    system.assertNotEquals(null, DFP_Utils.addAdministrator(partnerId,DFc.Id));
    system.assertEquals(true,DFP_Utils.isInvite('la@testorg.com'));
    }
}