({
    jsLoaded: function(component, event, helper) {
        
        var longitude = 0.1278; //component.get("v.longitude"); //37.784173, 
        var latitude = 51.5074; //component.get("v.latitude");
        var latLng = [latitude, longitude];
        
        var map = L.map('map', {zoomControl: false, tap: false})
        .setView(latLng, 14);
        L.tileLayer(
            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
            {
                attribution: 'Tiles © Esri'
            }).addTo(map);
        
       
        L.marker(latLng, {title: 'Event location'}).addTo(map);
        //L.panTo(latLng);

        
        component.set("v.map", map);
    }
})