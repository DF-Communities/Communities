({
    init : function(component, event, helper) 
    {
      // var cc = component.getConcreteComponent();
      // cc.addHandler("validate", component, "c.validate");//////??????????????????????
	},
    
    validate : function(component, event, helper) 
    {
        if (!component.get('v.rendered')) return;
        helper.validate(component, false);
	}
})