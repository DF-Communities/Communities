@isTest
global class servicesPostcodeanywhereWrapper_Test{

   global  static testMethod void coverTypes()
    {
        new servicesPostcodeanywhereCoUk.ArrayOfResults();
        new servicesPostcodeanywhereCoUk.Results();
        new servicesPostcodeanywhereCoUk.Response_element();
        new servicesPostcodeanywhereCoUk.SoapRequest_element();
        new servicesPostcodeanywhereCoUk.WebServiceSoap();


    }
     static testmethod void doTest(){
     	test.starttest();
         Test.setMock(WebServiceMock.class, new servicesPostcodeanywhereCoUkMock());    
        servicesPostcodeanywhereCoUk.WebServiceSoap ws = new servicesPostcodeanywhereCoUk.WebServiceSoap();
        servicesPostcodeanywhereCoUk.ArrayOfResults ws_response = ws.RetrieveByPostcode('key', 'pPostcode', 'userName');
		servicesPostcodeanywhereWrapper sw= new servicesPostcodeanywhereWrapper('IG1 3LQ');

   }

    

}