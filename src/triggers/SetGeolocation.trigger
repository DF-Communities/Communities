trigger SetGeolocation on Saved_Search__c(after insert) {
    for (Saved_Search__c a : trigger.new)
        if (a.Geolocation__Latitude__s == null || a.Geolocation__Latitude__s == 0.0 )
            LocationCallouts.getLocation(a.id);
}