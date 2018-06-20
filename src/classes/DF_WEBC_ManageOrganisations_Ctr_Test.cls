/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : test class for DF_WEBC_ManageOrganisations_Controller class
 *  Author  : Lakshmi Vasudevan
 *  Date    : Jun 2016
 *  Version : 0.1 Unit Test
 *
 *  Description : 
 *               
 *  Modification History
 *  Date            Who         Description 

*******************************************************************************************/ 

@isTest
private class DF_WEBC_ManageOrganisations_Ctr_Test {

    static testMethod void myUnitTest() {
    	test.starttest();
        DF_WEBC_ManageOrganisations_Controller ctr = new DF_WEBC_ManageOrganisations_Controller();
        ctr.isChampion=true;
        
    }
}