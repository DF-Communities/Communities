({
	init : function(component, event, helper) 
    {
        var handler = function(event) { console.log('PM');console.log(component);return helper.messageHandler(component, event); };
        helper.handlerMap[component.getGlobalId()] = handler;
        window.addEventListener("message", handler);
	},

    doneRendering: function(component, event, helper) 
    {
        console.log('======>done rendering')
    }

})