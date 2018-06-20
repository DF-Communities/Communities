({
	init : function(component, event, helper) 
    {
        helper.setSelection(component);
	},
    
	onSelectionChange : function(component, event, helper) 
    {
		var text = event.source.get('v.text');
        helper.storeSelection(component, text);
	},
    
   	onOtherTextChange : function(component, event, helper) 
    {
        helper.storeSelection(component, '-@other@-');
	}

})