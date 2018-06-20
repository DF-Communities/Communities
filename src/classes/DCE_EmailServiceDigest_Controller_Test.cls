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
private class DCE_EmailServiceDigest_Controller_Test {

    @testSetup private static void dataSetup(){
    	DCE_TestDataFactory.setUpDataWithAmends();
    }
    
    static testMethod void myUnitTest() {
        
		Account acc = [select id from Account where Name ='PartnerAccount1'];
		
		User recipient = [select id from User where Accountid = :acc.id limit 1];
		
		DCE_EmailServiceDigest_Controller cont = new DCE_EmailServiceDigest_Controller();
		
		cont.recipientId = recipient.id;
        
        map<Date, list<DCE_EmailServiceDigest_Controller.amendWrapper>> amendMap = cont.AmendMap;
        
        system.assertEquals(2, amendMap.size());
        
        integer months = 4;
        
        for(Date d : cont.OrderedDates){
       		system.assertEquals(system.today().addMonths(-1-(months*3)).toStartOfMonth(),d);
        	months -= 1;
        	system.assertEquals(5, amendMap.get(d).size());
        }
        
        system.assertEquals(true, cont.getShowTable());
        
    }
}