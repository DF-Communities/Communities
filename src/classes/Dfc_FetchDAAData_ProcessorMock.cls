@isTest
global class Dfc_FetchDAAData_ProcessorMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
  
  String url = 'http://www.dementiaaction.org.uk/daa/list';
    Http h = new Http();
    HttpResponse res = new HttpResponse();
    req.setEndpoint(url);
    req.setMethod('GET');
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"last_change_date":"2016-01-22T15:59:39+00:00","url":"http://www.dementiaaction.org.uk/local_alliances/15807_haywards_heath_dementia_action_alliance","region":"South East","contact":"Dawn Fairbrother","logo":"http://www.dementiaaction.org.uk/assets/0002/1985/haywards_heath_DAA_logo.jpg","name":"Haywards Heath Dementia Action Alliance","id":15807,"email":"dawn.fairbrother@alzheimers.org.uk","abstract":"The Haywards Heath Dementia Action Group was set up in December 2014 with the intention of helping the community become more dementia-friendly. "}');
    res.setStatusCode(200);


    return res;
    
   

}
}