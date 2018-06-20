@isTest
private class Test_LocationCallouts{
     @isTest static void testCallout() {
        try{
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());        
            
            Saved_Search__c ssavedsearch= new Saved_Search__c();
            ssavedsearch.Post_Code__c = '638183';
            insert ssavedsearch;
                 
            LocationCallouts.getLocation(ssavedsearch.Id);   
        }
        catch(Exception e){}     
      
    }
}