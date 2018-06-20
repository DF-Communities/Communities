/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_Asdf_UrlRewriter
 *  Author  : Gary Grant
 *  Date    : 12-03-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
public with sharing class DF_Asdf_UrlRewriter_Test {
    
    @isTest
    static void testMapUrl() {

     
        system.debug('Entering re-writer test');
     
        DF_Asdf_UrlRewriter rewriter = new DF_Asdf_UrlRewriter();
        PageReference pr = new PageReference('/WebArticle?page=what-is-a-friend');         
        PageReference redirect = rewriter.mapRequestUrl(pr); 
        List<PageReference> lis = rewriter.generateUrlFor(new List<PageReference>());
        
        system.debug('completed re-writer test');

    }



}