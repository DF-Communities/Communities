({
	init : function(component, event, helper) 
    {
        // See if we are running in IE9 so we can show field labels as placeholders are unsupported
        var ua = window.navigator.userAgent;
        var msie = ua.indexOf ( "MSIE " );
        var version = msie > 0 ? parseInt (ua.substring (msie+5, ua.indexOf (".", msie ))) : 0;
        component.set('v.IE9', version==9 ? true : false);
        
        var data = {};
        var act = component.get('v.activity');
        
        var create = component.get('v.new');
        var _ = component.find('lodashService').get('v.instance');

        if (!act && !create) console.error('No activity data supplied to DfcEditActivity');
	
        if (act) {        
            data.start = $A.localizationService.formatDate(act.Start__c, 'D MMM YYYY');
            data.end = act.End__c && $A.localizationService.formatDate(act.End__c, 'D MMM YYYY');
            data.title = act.Title__c;
            data.description = act.Description__c;
        }
        else {
			component.set('v.activity', {sobjectType:'DFC_Activity__c'});
        }
        component.set('v.data', data);
    
        var actionAreas = component.get('v.actionAreas');
      
        var areas = _.map(_.filter(actionAreas, {Selected__c:true}), function(a){
            return { Id:a.Id, 
                     Name: a.Action_Area__r.Name, 
                     selected: act && !!_.find(act.Action_Areas__r, {Action_Area__c:a.Id})};
        });
        component.set('v.areas', areas);

        var selected = _.find(areas, {selected:true });
        component.set('v.selectedAreaId', selected?selected.Id:null);
	},
    
	onSave : function(component, event, helper) 
    {
        /*
         * Show all errors.
         */
		component.set('v.pristine', false)	
		
        /*
         * Exit if errors. 
         */
        var ret = {};
        component.find('validationTracker').validate(ret);
		if (!ret.valid) return;
        
        /*
         * Transfer data into event payload.
         */
        var _ = component.find('lodashService').get('v.instance');
        var data = component.get('v.data');
        var act = component.get('v.activity');
        act = _.cloneDeep(act);
		act.Start__c = $A.localizationService.parseDateTime(data.start, 'D MMM YYYY');
        act.Start__c.setHours(12);
        act.End__c = data.end && data.end.trim() ? $A.localizationService.parseDateTime(data.end, 'D MMM YYYY') : null;
        if (act.End__c) act.End__c.setHours(12);
        act.Title__c = data.title;
        act.Description__c = data.description;
    	
        var selectedAreaId = component.get("v.selectedAreaId");
        
        /*
         * Fire the save event.
         */
   		var e = component.get('e.save');
        e.setParam('data', {activity: act, actionAreaIds: [selectedAreaId] });
        e.fire();	
	},
    
    
    onAreaSelect: function(component, event, helper) 
    {
//		component.get('e.cancel').fire();	
	},
	
	onCancel : function(component, event, helper) 
    {
		component.get('e.cancel').fire();	
	}
})