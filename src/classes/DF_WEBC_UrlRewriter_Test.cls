/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for DF_WEBC_UrlRewriter
 *  Author  : Lakshmi Rajendram
 *  Date    : 12-03-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
@isTest
public class DF_WEBC_UrlRewriter_Test {
    
    @isTest
    static void testMapUrl() {

     
        system.debug('Entering re-writer test');
     
        DF_WEBC_UrlRewriter rewriter = new DF_WEBC_UrlRewriter();
        PageReference pr = new PageReference('/subscribe');         
        PageReference redirect = rewriter.mapRequestUrl(pr); 

        //system.debug(redirect.getUrl());
        //String expectedResult = '/DF_WEBC_RegisterNewsletter' ;
        //System.assert(redirect.url == expectedResult);
        
        //https://dfdev-dfdev.cs18.force.com/verify?data=4ABk%2FyfPU81rDeCBJmuKKWfigueYUfiRkVm1QHdYhMET4Ntq6%2BmO%2B7XAvqrwK7IDV6Zdro3%2FMuReEwwydprMcQ%3D%3D&c=DF
        
        //mapUrls.put('/verify', '/WEBC_VerifyRegistration');
        pr = new PageReference('/verify?data=4ABk%2FyfPU81rDeCBJmuKKWfigueYUfiRkVm1QHdYhMET4Ntq6%2BmO%2B7XAvqrwK7IDV6Zdro3%2FMuReEwwydprMcQ%3D%3D&c=DF');
        redirect = rewriter.mapRequestUrl(pr);
        
        List<PageReference> lis = rewriter.generateUrlFor(new List<PageReference>());
        
        system.debug('completed re-writer test');

    }



}