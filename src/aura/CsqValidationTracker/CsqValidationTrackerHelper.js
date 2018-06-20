({
    getComponentBody: function(component)
    {
        component = component.getConcreteComponent();
        var body = component.get('v.body');
        if ((!body||!body.length)&&component.getSuper()) body = component.getSuper().get('v.body');
        return body || [];
    },
    
    containsValidationError: function(component)
    {
        var helper = this;
        if (component.isInstanceOf('aura:text')) return;
        if (component.isInstanceOf('aura:expression')) return;
    	var body = this.getComponentBody(component);
        for (var n=0; n<body.length; n++){
        var cmp = body[n];
            if (cmp.isInstanceOf('c:CsqValidationComponent')&&cmp.get('v.isValid')==false) return true;
            if (helper.containsValidationError(cmp)) return true;
        }
        return false;
    },
    
    buildContentMap: function(component)
    {
        var helper = this;
        var body = component.get('v.body');
        for (var i=0; i<body.length; i++) {
          helper.gatherContent(body[i], helper.contentMap, i);
        }
        console.log(helper.contentMap)
    },
    
    gatherContent: function(component, map, marker)
    {
        var helper = this;
        //component = component.getConcreteComponent();
        map[component.getGlobalId()] = marker;
    	var body = this.getComponentBody(component);
        for (var n=0; n<body.length; n++){
            helper.gatherContent(body[n], map, marker);
        }
    }

})