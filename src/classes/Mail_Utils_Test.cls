@isTest
public class Mail_Utils_Test {
/*  
***********************************************************************************************
     * @author          Lakshmi Rajendram 
     * @date            10-08-2015
     * @description     Test class for Mail_Utils
***********************************************************************************************/

static testMethod void coverMethod () {

 Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
 Id OW = Mail_Utils.getOrgWideEmail();
    DF_Contact__c DFchamp = (DF_Contact__c )mapTestData.get('Champion'); 
    DF_Eventattendee__c DFeatt = (DF_Eventattendee__c )mapTestData.get('ChampAtten');
    test.starttest();
    DFchamp.Status__c = 'Converted';
    DFeatt.EventAttendeeStatus__c = 'Attended';
    
    update DFchamp;
    update DFeatt;
    Map<String, EmailTemplate> mapTemp= Mail_Utils.getemailTemplateMap();
    String templateName= (mapTemp.get(DF_Mail_Utils.VF_SUPER_CHAMPION).DeveloperName);

    Mail_Utils.getTemplatedEmail(templateName,DFchamp.Portal_Contact__c, DFchamp.Id, OW, true, null); 
    
    
}
}