({
    sendToVF : function(component, helper) {
        //Prepare message in the format required in VF page
        var message = {
            "loadGoogleMap" : true,
            "mapOptionsCenter": component.get('v.mapOptionsCenter'), 
            "mapData": component.get('v.mapData'), 
            "mapOptions": component.get('v.mapOptions'),  
        };
        //console.log(JSON.stringify(message));
        
        console.log(message.mapOptions);
        console.log(message.mapOptions.zoom);
        console.log(message.mapOptions["zoom"]);
        console.log(message["mapOptions"]["zoom"]);
        
        message.mapOptions =JSON.parse(message.mapOptions);
        message.mapOptionsCenter = JSON.stringify(message.mapOptionsCenter);
        message.mapData = JSON.stringify(message.mapData);;
        
        //message.mapOptions = {"zoom":16};
        //message.mapOptionsCenter = {"lat":51.507351,"lng":-0.11};
        //message.mapData = [{"lat":51.507351,"lng":-0.11,"markerText":"Test"}];
        
        //Send message to VF
        helper.sendMessage(component, helper, message);
    },
    
    sendMessage: function(component, helper, message){
        //Send message to VF
        message.origin = window.location.hostname;
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        console.log('LTNG posting out msg to VF as: ' + JSON.stringify(message) + ' and vfHost: ' + component.get("v.vfHost"));
        vfWindow.postMessage(message, component.get("v.vfHost"));
    }
})