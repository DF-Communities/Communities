@isTest 
public class WEBSessionDetails_Test {
    
    static testmethod  void pageLoadWithValidParameter_positive()
    {
        Map<String, Object> mapTestData = DF_DataFactory_Test.getTestData();
        User u  = (User)mapTestData.get('User');
        DF_Contact__c dfc = (DF_Contact__c)mapTestData.get('DFc');
        DF_Event__c devent = (DF_Event__c)mapTestData.get('FriendSession');
        DF_EventAttendee__c  DevAtten = (DF_EventAttendee__c)mapTestData.get('FriendAtten');
        
        PageReference vfPage = Page.WEBSessionDetails;
		Test.setCurrentPage(vfPage);
        
        ApexPages.currentPage().getParameters().put('id',devent.Id);
        WEBSessionDetails wsd = new WEBSessionDetails();
        
    } 
    

}