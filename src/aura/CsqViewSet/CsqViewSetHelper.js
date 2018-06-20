({
    contentMap: {},
    
    handleInit : function(component) 
    {
        var helper = this;
        var store = component.get('v.store')[0].get('v.instance');
        var defs = store.viewDefs;
        var body = component.get('v.body');
        
        // body.length is the number of immediate children of the viewset
        if (body.length != defs.length) throw new Error('Number of view defs not matched by number of view components');

        for (var i=0; i<body.length; i++) {
          var c = body[i];
          var def = defs[i];
          var vc;
          if (c.isInstanceOf('c:CsqViewComponent')) {
            vc = c;
          }
          else {
            var vcs = c.find({instancesOf:'c:CsqViewComponent'});
            if (vcs.length==0) continue;
            if (vcs.length>1) throw new Error('Multiple elements of type CsqViewComponent for '+def.name);
            vc = vcs[0];
          }
          if (vc) {
		  	vc.set('v.viewId', def.id);
		  	vc.set('v.viewStore', store);
          }
        }
        
        ////////////////////
        helper.buildContentMap(component);
        
	},
    
    handleValidationEvent: function(component, event)
    {
        var helper = this;
        
        var group = event.getParam('group');/////
       	var source = event.getParam('source');
        if (!source||!source.isValid()) return;
        
        var viewNo = helper.contentMap[source.getGlobalId()];
        if (viewNo===undefined && event.getParam('initial')) {
            helper.buildContentMap(component);
            viewNo = helper.contentMap[source.getGlobalId()];
        }
        if (viewNo===undefined) {
            return;
        }
        
   		var e = component.get('e.CsqDispatch');
        e.setParam('action', 'CsqUpdateViewErrorStatus');
        e.setParam('data', { ordinal:viewNo, key:event.getParam('key'), valid:event.getParam('valid') });
        e.fire();
    },
    
    getComponentBody: function(component)
    {
        component = component.getConcreteComponent();
        var body = component.get('v.body');
        if ((!body||!body.length)&&component.getSuper()) body = component.getSuper().get('v.body');
        return body || [];
    },
    
    buildContentMap: function(component)
    {
        var helper = this;
        helper.contentMap = {};
        var body = component.get('v.body');
        for (var i=0; i<body.length; i++) {
          helper.gatherContent(body[i], helper.contentMap, i);
        }
        // console.log('View set content map built')
    },
    
    gatherContent: function(component, map, marker)
    {
        var helper = this;
        if (component.getName().indexOf('ui$')===0) return;
        if (component.isInstanceOf('aura:text')) return;
        if (component.isInstanceOf('aura:expression')) return;
        map[component.getGlobalId()] = marker;
    	var body = this.getComponentBody(component);
        for (var n=0; n<body.length; n++){
            helper.gatherContent(body[n], map, marker);
        }
    },
    
    isContainedBy: function(component, container)
    {
        var helper = this;
        var component = component.getConcreteComponent();
    	var body = this.getComponentBody(container);
        for (var n=0; n<body.length; n++){
        var cmp = body[n];
            if (cmp===component) return true;
            if (helper.isContainedBy(component, cmp)) return true;
        }
        return false;
    }
    
    
})