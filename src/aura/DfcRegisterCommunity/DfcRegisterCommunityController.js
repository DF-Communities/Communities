({
	initHandler : function(component, event, helper) 
    {
      
        var _ = helper.getService(component, 'lodashService');
        var communityService = helper.getService(component, 'communityService');
        
        // If we have come from the Verify Process there will be a 'country' parameter
        var country = component.get('v.country');

        var context = {};
        context.formFactor = $A.get('$Browser.formFactor');
        context.steps = [
             {title: 'STEP 1', label:'Community Location', pristine:true, errors:[]}, 
             {title: 'STEP 2', label:'Community Details', pristine:true, errors:[]},
             {title: 'STEP 3', label:'Community Representatives', pristine:true, errors:[]}, 
             {title: 'STEP 4', label:'Areas For Action', pristine:true, errors:[]}, 
             {title: 'STEP 5', label:'Submit your application', pristine:true, errors:[]},
             {title: 'HELP', label:'Resources', pristine:true, errors:[]}
        ];

        Object.defineProperty(context, 'hasErrors', {
            enumerable: false,
            get: function(){
                if (this.updateError) return true;
                for (var n=0; n<this.steps.length; n++) {
                    if (this.steps[n].errors.length) return true;
                }
                return false;  
            }
        });
        
        context.currentStep = context.steps[0];


        
        communityService.getCurrentDraftWithContext().
        then(function(ctx){

            _.extend(context,ctx);
            
            if (context.community.Status__c=='New') {
                context.community.Status__c='Draft'
            }
            else {
                for (var n=0; n<context.steps.length-2; n++) {
                  context.steps[n].pristine = false;
               }
            }
            
            // If this is a new application and we have no value in the Country field and there is a qs param country value...
            if (!context.community.Country__c) {
            	if (country=='w') {
                  context.community.Country__c = 'Wales'; 
            	}
            	if (country=='e') {
                  context.community.Country__c = 'England'; 
            	}
            }   
            
            component.set('v.context', context);
            
            //Nov 2016 This is suddenly failing with an Undefined during init. See afterRender 
            //$A.get('e.c:DfcValidate').fire();            
            helper.setStep(component, 1);
            
            console.log(context)
        })
        .catch(function(error){console.error(error)});
	},
    
    onSetStep: function(component, event, helper) 
    {
       var currentStep = component.get('v.selectedStep');
       
       helper.setStep(component, event.getParam('step'));
       window.scrollTo(0, 120);

       var context = component.get('v.context');
       var communityService = helper.getService(component, 'communityService');
        
        //TODO clone the community, fix up non-numeric population and anything else that might prevent save
        
        
       communityService.updateCommunity(context.community)
       .then(function(){
           if (!context.updateError) return;
           component.set('v.alert', '');
           context.updateError = null;
           $A.get('e.c:DfcValidationChange').fire();
       })
       .catch(function(error){
           var msg = error.message||'Save failed ';
           component.set('v.alert', msg);
           context.updateError = msg;
           $A.get('e.c:DfcValidationChange').fire();   
       }); 
    },
    
    nextStep: function(component, event, helper) 
    {
        var stepno = component.get('v.selectedStep');
        var e = $A.get('e.c:DfcSetStep');
        e.setParam('step',stepno+1);
        e.fire();
    },
    
    prevStep: function(component, event, helper) 
    {
        var stepno = component.get('v.selectedStep');
        var e = $A.get('e.c:DfcSetStep');
        e.setParam('step',stepno-1);
        e.fire();
    },
   
    onValidationEvent: function(component, event, helper) 
    {
      var step = event.getParam('group');
      if (!step) return;

      var key = event.getParam('key');
      var valid = event.getParam('valid');
      var context = component.get('v.context');
      
      var i = step.errors.indexOf(key);
      if ((i>=0 && !valid) || (i<0 && valid)) return;
      
      if (i>=0) step.errors.splice(i, 1);
      else step.errors.push(key);       
        
      //Nov 2016 DfcValidateChange is not found during init. See afterRender 
      if (!helper.fireValidationChange) {          
          var _ = helper.getService(component, 'lodashService');
          var ev = $A.get('e.c:DfcValidationChange');
          if (!$A.util.isUndefinedOrNull(ev)) {
        	helper.fireValidationChange = _.debounce(function(){ev.fire();}, 400, {leading:false});
          } else { console.log('Null DfcValidationChange event in controller'); }         
      }
      helper.fireValidationChange();  
      
      /* Nov 2016 This code replaced above
      if (!helper.fireValidationChange) {
        var _ = helper.getService(component, 'lodashService');
        helper.fireValidationChange = _.debounce(function(){$A.get('e.c:DfcValidationChange').fire();}, 400, {leading:false});
      }
      helper.fireValidationChange();
      */
    },

 
    
})