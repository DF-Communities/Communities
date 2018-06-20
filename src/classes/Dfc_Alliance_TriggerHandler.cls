/*
 *  The Dementia Action Alliances records are populated from the DAA website
 *  We need to link each Alliance to it's region in England
 *
 */


public without sharing class Dfc_Alliance_TriggerHandler {
    
    public Dfc_Alliance_TriggerHandler() {
    
    }
    
    public void OnBeforeInsert(DFC_Alliance__c[] lis) {

         applyRegionId(lis, null);

    }

    public void OnBeforeUpdate(DFC_Alliance__c[] lisOld, DFC_Alliance__c[] lisNew, Map<ID, DFC_Alliance__c> mapOld) {

            applyRegionId(lisNew, mapOld);          

    }

    private void applyRegionId(Dfc_Alliance__c[] lis, Map<ID, DFC_Alliance__c> mapOld ) {


        // Get all the English regions and put them in a map
        List<DFC_DAA_Region__c> lisRegions = [select Id, Name from DFC_DAA_Region__c where Country__c='England'];

        Map<String, DFC_DAA_Region__c> mapRegions = new Map<String, DFC_DAA_Region__c>();
        for ( DFC_DAA_Region__c region : lisRegions ) {
            mapRegions.put( region.Name, region );
        }

        // Loop thru the Alliances and update the Region id based on the Name of the region in England
        for ( DFC_Alliance__c alliance : lis ) {

            DFC_DAA_Region__c region = mapRegions.get(alliance.Region__c);
            if ( region != null ) {
                alliance.DAA_Region__c = region.Id;
                
            }

        }

   }


}