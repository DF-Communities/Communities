trigger Dfc_Community_Representative_Trigger on DFC_Community_Representative__c (after insert) {

    Dfc_CommunityRep_TriggerHandler handler = new Dfc_CommunityRep_TriggerHandler();

    if( Trigger.isInsert && Trigger.isAfter) {

        handler.onAfterInsert(Trigger.new, Trigger.newMap);

    }


}