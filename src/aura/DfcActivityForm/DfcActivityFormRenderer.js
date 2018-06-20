({
    render: function(component, helper)
    {
        console.log('=====>R')
        return this.superRender();
    },
    
    afterRender: function(component, helper)
    {

        console.log('=====>AR')

        return this.superAfterRender();
    },
    
    unrender: function(component, helper)
    {
        console.log('=====>UR')
        return this.superUnrender();
    },
    

})