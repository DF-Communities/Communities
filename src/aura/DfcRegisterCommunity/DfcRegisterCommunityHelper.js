({
    
    
	getService : function(component, name) 
    {
       return component.find(name).get('v.instance');
	},

    setStep : function(component, stepno) 
    {
        var context = component.get('v.context');
        var selected = component.get('v.selectedStep');

        if (selected==stepno) return;
        
        if (selected && selected<context.steps.length-1) context.steps[selected-1].pristine = false;
        for (var i=Math.max(stepno,selected)-3; i>=0 ;i--) context.steps[i].pristine = false;

		//Nov 2016. DfcValidationChange is returning Null during init
        var ev = $A.get('e.c:DfcValidationChange');
        if ( !$A.util.isUndefinedOrNull(ev) ) {
            ev.fire();
        } else { console.log('Null DfcValidationChange event in helper'); }
        
        // This code replaced above
        //$A.get('e.c:DfcValidationChange').fire();
        
        context.currentStep = context.steps[stepno-1];
     	context.currentStep.viewCount += 1;
        component.set('v.selectedStep', stepno);
    }    

})