@isTest
public class LightningUtils_Test {
    
    @testSetup static void setup() {
        // Create the test data once and then run all methods on the dataset
        DF_DataFactory_Test.getTestData();  
        
    }
    
    static testmethod void getLightningHostUrl_positive() {
        LightningUtils.getLightningHostUrl();
    }

}