({
    onClick : function(component, event, helper) {
        var id = event.target.dataset.menuItemId;
        console.log('menuitemid '+id);
        if (id) {
            component.getSuper().navigate(id);
         }
   }
})