/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DCE_UrlReWriter_Test {
	
	@testSetup private static void setupData(){
    	DCE_TestDataFactory.setUpDataWithAmends();
    }
    
    static testMethod void testGenerateUrlFor() {
        
        DCE_ServiceAmend__c amend = [select id, portalServiceNumber__c from DCE_ServiceAmend__c limit 1];
        
        list<PageReference> pageRefsForTest = new list<PageReference>();
    		
		pageRefsForTest.add(new PageReference('/DCE_Dashboard'));
		pageRefsForTest.add(new PageReference('/DCE_OrgDetails'));
		pageRefsForTest.add(new PageReference('/DCE_UserDetails'));
		pageRefsForTest.add(new PageReference('/DCE_unhandledUrl'));
		
		pageRefsForTest.add(new PageReference('/DCE_ServiceEdit?aid='+amend.id));
		pageRefsForTest.add(new PageReference('/DCE_ServiceView?aid='+amend.id));
		
		//NOt ids at all
		pageRefsForTest.add(new PageReference('/DCE_ServiceEdit?aid=madeUpId'));
		pageRefsForTest.add(new PageReference('/DCE_ServiceView?aid=madeUpId'));
		
		//Ids that don't exist
		pageRefsForTest.add(new PageReference('/DCE_ServiceEdit?aid=a0s12000004G558AAB'));
		pageRefsForTest.add(new PageReference('/DCE_ServiceView?aid=a0s15000003X398FDS'));
		
		//Pages that shouldn't have parameters
		pageRefsForTest.add(new PageReference('/DCE_Dashboard?dfe=a0s12000004G558AAB'));
		pageRefsForTest.add(new PageReference('/DCE_UserDetails?egr=a0s15000003X398FDS'));
        
        test.startTest();
        
        DCE_UrlReWriter rewriter = new DCE_UrlReWriter();
        
        list<PageReference> returnedReferences = rewriter.generateUrlFor(pageRefsForTest);
        
        test.stopTest();
        
        system.assertEquals('/home', returnedReferences[0].getUrl());
        system.assertEquals('/our-details', returnedReferences[1].getUrl());
        system.assertEquals('/my-details', returnedReferences[2].getUrl());
        system.assertEquals('/DCE_unhandledUrl', returnedReferences[3].getUrl());
        system.assertEquals('/serviceedit/'+amend.portalServiceNumber__c, returnedReferences[4].getUrl());
        system.assertEquals('/serviceview/'+amend.portalServiceNumber__c, returnedReferences[5].getUrl());
        system.assertEquals('/home', returnedReferences[6].getUrl());
        system.assertEquals('/home', returnedReferences[7].getUrl());
        system.assertEquals('/home', returnedReferences[8].getUrl());
        system.assertEquals('/home', returnedReferences[9].getUrl());
        system.assertEquals('/home?dfe=a0s12000004G558AAB', returnedReferences[10].getUrl());
        system.assertEquals('/my-details?egr=a0s15000003X398FDS', returnedReferences[11].getUrl());
    }
    
    static testMethod void testMapRequestUrl() {
    	
    	DCE_ServiceAmend__c amend = [select id, portalServiceNumber__c from DCE_ServiceAmend__c limit 1];
    	
    	test.startTest();
    	
    	DCE_UrlReWriter rewriter = new DCE_UrlReWriter();
    	
    	// all simple tests of the mappings
    	system.assertEquals('/DCE_Dashboard', rewriter.mapRequestUrl(new PageReference('/home')).getUrl());
    	system.assertEquals('/DCE_LoginPage', rewriter.mapRequestUrl(new PageReference('/login')).getUrl());
    	system.assertEquals('/DCE_newOrgRequest', rewriter.mapRequestUrl(new PageReference('/Request')).getUrl());
    	system.assertEquals('/DCE_NewOrgRequestConfirm', rewriter.mapRequestUrl(new PageReference('/Thank-you')).getUrl());
    	system.assertEquals('/DCE_OrgDetails', rewriter.mapRequestUrl(new PageReference('/our-details')).getUrl());
    	system.assertEquals('/DCE_UserDetails', rewriter.mapRequestUrl(new PageReference('/my-details')).getUrl());
    	system.assertEquals('/DCE_ServiceEdit?aid='+amend.id, rewriter.mapRequestUrl(new PageReference('/ServiceEdit/'+amend.portalServiceNumber__c)).getUrl());
    	system.assertEquals('/DCE_ServiceView?aid='+amend.id, rewriter.mapRequestUrl(new PageReference('/ServiceView/'+amend.portalServiceNumber__c)).getUrl());
    	
    	
    	//handling odd, incorrect urls
    	system.assertEquals('/DCE_Dashboard', rewriter.mapRequestUrl(new PageReference('/home/random')).getUrl());
    	system.assertEquals('/DCE_Dashboard', rewriter.mapRequestUrl(new PageReference('/home/random/Other')).getUrl());
    	system.assertEquals(null, rewriter.mapRequestUrl(new PageReference('/madeUpUrl')));
    	system.assertEquals('/DCE_Dashboard', rewriter.mapRequestUrl(new PageReference('/ServiceView/123456')).getUrl());
    	system.assertEquals('/DCE_Dashboard', rewriter.mapRequestUrl(new PageReference('/ServiceEdit/123456')).getUrl());
    	
    	
    	test.StopTest();
    	
    }
    
    
}