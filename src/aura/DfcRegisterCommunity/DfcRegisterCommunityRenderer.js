({
    afterRender : function(component, event, helper) {
        
        /* Nov 2016. These calls previously in the init
           moved here to prevent failure of the initi process
        */   
      	$A.get('e.c:DfcValidate').fire();
        $A.get('e.c:DfcValidationChange').fire();  
        
    }
})