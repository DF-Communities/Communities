@isTest
global class servicesPostcodeanywhereCoUkMock implements WebServiceMock{
  
   public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType){
                   
              response.put('response_x', new servicesPostcodeanywhereCoUk.Response_element());
              
              system.debug( response);
            return;
        
        }
}