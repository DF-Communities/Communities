({
	openModel : function(component, event, helper) {
		// for Display Model,set the "isOpen" attribute to "true"
		component.set("v.isOpen", true);
	},

	signupCancel : function(component, event, helper) {
		// $A.util.addClass(component, "hide");
		event.preventDefault();
		console.log("In modal evt");
		var action = component.getEvent("DF_signUpCancelEvt");
		action.fire();
		console.log("Sent out cancel evt");
	},
    
    signupMessage : function(component, event) {
       var args = event.getParam("arguments");
       component.set("v.modeConfirmSignup", false);
       component.set("v.modeConfirmSuccess", args.isSuccess);
    },

	signupConfirm : function(component, event, helper) {
		event.preventDefault();
		var action = component.getEvent("DF_signUpConfirmEvt");
		action.fire();
		//component.set("v.isOpen", false);
		// hideModal(component);
	},

	hideModal : function(component) {
		console.log("closing modal");
		var modalCmp = component.find("modal-popup");
		$A.util.addClass(modalCmp, "hide");
		var errorCmp = component.find("enforce-time-selection");
		$A.util.addClass(errorCmp, "hide");
		component.set("v.isOpen", false);
	}
})