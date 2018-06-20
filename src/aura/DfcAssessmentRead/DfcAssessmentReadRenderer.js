({
    afterRender: function(component)
    {
        this.superAfterRender();
        if (component.get('v.showSubmitMessage')) window.scrollTo(0,0);
    }
     
})