({
    render: function(component, helper)
    {
        console.log('=====>R')
        return this.superRender();
    },
    
    afterRender: function(component, helper)
    {

        console.log('=====>AR')

        console.log(component.getElement().innerHTML)
        
        this.superAfterRender();
    },
    
    unrender: function(component, helper)
    {
        console.log('=====>UR')
        console.log(component.getGlobalId())
        var handler = helper.handlerMap[component.getGlobalId()];
        console.log(handler)
        window.removeEventListener("message", handler, false);
        return this.superUnrender();
    },
    

})