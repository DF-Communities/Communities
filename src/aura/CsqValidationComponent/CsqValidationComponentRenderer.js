({
    afterRender : function(component, helper) 
    {
       this.superAfterRender();
       component.set('v.rendered', true);
       helper.validate(component, true)
   }
})