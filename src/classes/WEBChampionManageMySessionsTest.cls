/******************************************************************************************
 *  Cloud Symphony
 *  
 *  Purpose : APEX test class for WEBChampionManageMySessions.
 *  Author  : CSL
 *  Date    : 27-02-2014
 *  Version : 1.0
 *
 *  Description:    Apex test class.
 *               
 *  Modification History
 *  Date            Who         Description 
 *                    
*******************************************************************************************/
@isTest(seeAllData=false)
public with sharing class WEBChampionManageMySessionsTest {
    static testMethod void manageMySessionsTest() {
        WEBChampionManageMySessions controller;
        
        Test.startTest();
        
        controller = new WEBChampionManageMySessions();

        System.assertNotEquals(null, controller.pastEvents);
        System.assertNotEquals(null, controller.upcomingEvents);
        
        Test.stoptest();
    }
}