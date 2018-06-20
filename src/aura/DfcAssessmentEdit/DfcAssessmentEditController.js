({
	// Save Draft Assessment
	onSave : function(component, event, helper) 
    {
        /*
         * Fire the save event.
         */
        var questionGroups = component.get('v.questionGroups');
   		var e = component.get('e.CsqDispatch');
        e.setParam('action', 'DfcUpdateAssessment');
        e.setParam('data', questionGroups);
        e.fire();	
	},
    
	onSubmit : function(component, event, helper) 
    {
       /*
        * Show all errors. 
        */
        component.set('v.pristine', false);
       
        /*
         * Check the validation tracker for errors. 
         */
        var ret = {};
        component.find('validationTracker').validate(ret);
        if (!ret.valid) {
            var e = $A.get('e.c:CsqShowAlert');
        	e.setParam('message', 'Please review the form and ensure you have answered all questions');
        	e.fire();	
            setTimeout(function(){window.scrollTo(0,document.body.scrollHeight);}, 50);
           return;
        }
        
        /*
         * Fire the submit event.
         */
        var questionGroups = component.get('v.questionGroups');
   		var e = component.get('e.CsqDispatch');
        e.setParam('action', 'DfcSubmitAssessment');
        e.setParam('data', questionGroups);
        e.fire();	
	},
    
})