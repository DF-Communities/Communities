@isTest
class Dfc_Resource_Store_Controller_Test
{

  @testSetup
  static void setupData() {

    Dfc_DataFactory_Test.TestDataCreation();

  }

  @isTest
  static void itShould() {

  		
  		Object o = Dfc_Resource_Store_Controller.getResourcesForState('Draft');
  		o = Dfc_Resource_Store_Controller.getResourcesForState(null);
     }
 }