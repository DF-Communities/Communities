({
    handlerMap: {},
    
	messageHandler: function(component, event)
    {
        if (!component.isValid()) return;

        var iframe = component.find('iframe').getElement();
	    if (event.source.location.toString() !== iframe.src) return;

        if (event.data=="CANCEL") {
          component.get('e.cancel').fire();
          return;
        }
        
        var data = JSON.parse(event.data);
        if (data.error) {
 		  console.error(data.error);             
 		  console.error(data.diagnostic);             
          component.set('v.message', data.error);        
        }
        else {
         component.set('v.message', '');        
         var id = component.get('v.recordId');        
         var e = component.get('e.CsqDispatch');
		 e.setParam('action', 'DfcUpdateAttachments');
         e.setParam('data', { recordId: id, attachments: data.attachments });            
         e.fire();
        }
      
    }
})