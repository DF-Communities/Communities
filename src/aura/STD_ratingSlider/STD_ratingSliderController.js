({
    initiateRatingSlider : function(component, event, helper) {
        console.log("In afterscriptsloaded");
        var isRun = component.get("v.afterScriptsIsRun");
        var initialValue = component.get("v.value");
        console.log("isRun: " + isRun);
        if(!isRun) {
            var champSlider = new Slider("#rating-slider-champ", {});
            champSlider.setValue(initialValue);
            champSlider.on('slideStop', function(ev){
                helper.handleSelectedRating(component, helper, event, champSlider.getValue());
            });
            var friendSlider = new Slider("#rating-slider-friend", {});
		    friendSlider.setValue(initialValue);
            friendSlider.on('slideStop', function(ev){
                helper.handleSelectedRating(component, helper, event, champSlider.getValue());
            });
            
            component.set("v.afterScriptsIsRun", true);
        }
        console.log("afterScriptsIsRun?: " + component.get("v.afterScriptsIsRun"));
    }
})