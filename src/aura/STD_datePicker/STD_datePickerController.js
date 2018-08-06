({
    doInit : function(component, event, helper) {
		var daysAhead = component.get("v.daysOffsetFromToday");
        var jsDate = new Date();
        if($A.util.isUndefined(daysAhead)) {
            daysAhead = 0;
        } else {
            if (!component.get("v.dateSelectionFromToday")) {
				jsDate.setDate(jsDate.getDate() + daysAhead);
            }
        }
        // Set the default date
        var dateStrFormat = jsDate.getFullYear() + "-" + 
                                  ('0' + (jsDate.getMonth() + 1)).slice(-2) + "-" + 
                                  ('0' + jsDate.getDate()).slice(-2);
        component.set("v.value", dateStrFormat);
        
        helper.fireDateValueEvt(component);
    },
    
    setScriptLoaded : function(component, event, helper) {

        // Determine the min start date
        var daysAhead = component.get("v.daysOffsetFromToday");
        var targetDate = new Date();
        if($A.util.isUndefined(daysAhead)) {
            daysAhead = 0;
        } else {
            if (!component.get("v.dateSelectionFromToday")) {
                targetDate.setDate(targetDate.getDate() + daysAhead);
            }
        }
        
		
        var maxDate = new Date();
        maxDate.setDate(targetDate.getDate() + component.get("v.maxDaysFromNowSelectionRestriction")); // Sessions cannot be more than 180 days in advance
        
        var j$ = jQuery.noConflict();
        var datepickerId = '#datepicker-' + component.get("v.name");

        j$( datepickerId ).datepicker({
            format:'dd/mm/yyyy',
   			autoclose: true,
            startDate  : targetDate, 
            endDate: maxDate,
            container: 'body',
            todayHighlight: true,
            pickerPosition: 'bottom-left',
            zIndexOffset: 100000
        })
        .on('changeDate', function(ev){
            var jsDate = ev.date;
            var dateStrFormat = jsDate.getFullYear() + "-" + 
                                  ('0' + (jsDate.getMonth() + 1)).slice(-2) + "-" + 
                                  ('0' + jsDate.getDate()).slice(-2);

            component.set("v.value", dateStrFormat); 
            helper.verifyDateInRangeHelper(component, event, helper);
        });
        j$( datepickerId ).datepicker('setDate', targetDate);
        helper.setDefaultDate(component);   

    },
    
    resetComponent : function(component, event, helper) {
       helper.setDefaultDate(component);
    },
    
    handleStylingFramework: function(component, event, helper) {
        //var isSlds = event.getparam("useSlds");
        //component.set("v.useSlds", isSlds);
    },
    
    setDate : function(component, event, handler) {
      //$A.get('e.force:refreshView').fire();
    },
    
    validateComponent : function(component, event, helper) {
        var auraId = "dateField";
        return helper.assessComponent(component, false, auraId);  
    },
        
    setDateValueOnSelection : function(component, event, helper) {
        component.set("v.value", event.getParam("date"));	    
    },
    
    verifyDateInRange : function(component, event, helper) {
    	helper.verifyDateInRangeHelper(component, event, helper);	
	}

})