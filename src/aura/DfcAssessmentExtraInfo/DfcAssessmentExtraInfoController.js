({
	init: function(component, event, helper) 
    {

                    // See if we are running in IE9 xo we can show field labels as placeholders are unsupported
        var ua = window.navigator.userAgent;
        var msie = ua.indexOf ( "MSIE " );
        var version = msie > 0 ? parseInt (ua.substring (msie+5, ua.indexOf (".", msie ))) : 0;
        component.set('v.IE9', version==9 ? true : false);
        
		helper.determineIfRequired(component);
	},

    onAnswerChange: function(component, event, helper) 
    {
		helper.determineIfRequired(component);
	}

})