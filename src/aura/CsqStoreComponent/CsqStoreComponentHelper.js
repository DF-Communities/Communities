({
    instanceMap : {}, //map storeId -> store 
    
    componentMap: {}, //map storeId -> list of the (valid) components of that type
    
    fireChangeEventMap: {}, //map storeId -> debounced fire change function for that type

    promiseService: null, //Set by init handler
    
    lodashService: null, //Set by init handler
    
    getStoreId: function(component)
    {
		'use strict'
        var cmp = component.getConcreteComponent();
		return cmp.getDef().toString();/////????
    },
    
    getInstance: function(component)
    {
		'use strict'
        var cmp = component.getConcreteComponent();
		var storeId = this.getStoreId(component);
        if (!this.instanceMap[storeId]) {
          this.componentMap[storeId] = [cmp];
          this.fireChangeEventMap[storeId] = this.newFireChangeFunction(storeId);
          this.instanceMap[storeId] = this.newInstance(component, this.newActionService(storeId));
        }
        else {
	      this.componentMap[storeId].push(cmp);
        }
        return this.instanceMap[storeId];
	},
    
    newInstance: function(component, actionService)
    {
		'use strict'
        
        var helper = this;
        var _ = helper.lodashService;
        var Promise = helper.promiseService;

        var storeId = helper.getStoreId(component);
        
        var cmp = component.getConcreteComponent();
        var componentDef = cmp.getDef();
        if (!componentDef.getHelper().createInstance) 
            throw new Error('Component '+this.getComponentName(componentDef)+' extending CsqStoreComponent does not implement createInstance() helper method');
        
        var instanceData = componentDef.getHelper().createInstance(cmp, Promise, _, actionService);
        //MUST VALIDATE: all items present; diptab.. not null.. functions all not null (??) //////////////////////////////////////

	    var store = {
            dispatchHandler: function(payload)
            {
                var name = payload.action;
                var data = payload.data;
                var handler = instanceData.dispatchTable[name];
                if (!handler) return false;
                var priorState = _.cloneDeep(instanceData.state);
                var ret = handler(data);
                if (!_.isEqual(instanceData.state, priorState)) helper.fireChangeEvent(storeId); 
                return ret || true;
			},
            copyProperty: function(targetComponent, propertyName, attributeName, transform)
            {
                attributeName = attributeName || propertyName;
                if (attributeName.substr(0,2)!='v.') attributeName = 'v.'+attributeName ;
                var av = targetComponent.get(attributeName);
                var pv = this[propertyName];
                if (transform) pv = transform(pv);
                if (_.isEqual(av, pv)) return false;
                targetComponent.set(attributeName, pv);
                return true;
            }
        };        

        Object.defineProperty(store, 'storeId', {value:storeId, enumerable: true});

        var initPromise = instanceData.init();
        if (!initPromise || !initPromise.then) throw new Error('Store component did not return a promise from instanceData.init()');
        Object.defineProperty(store, 'waitForInitialization', {value:initPromise, enumerable: true});

        _.forOwn(instanceData.properties, function(fn, key){
			//check value is a fn.....            
            Object.defineProperty(store, key, {get: function(){return _.cloneDeep(fn())}, enumerable: true});
        });
        
        return store;
	},
    
    fireChangeEvent: function(storeId)
    {
        if (storeId) {
          this.fireChangeEventMap[storeId]();
        }
        else {
		  $A.get('e.c:CsqStoreChanged').fire();
        }
    },
    
    newFireChangeFunction: function(storeId)
    {
       var fire = $A.getCallback(function() {
         var e = $A.get('e.c:CsqStoreChanged');
         e.setParam('storeId', storeId);
         e.fire();
       });
       return this.lodashService.debounce(fire, 100, {leading:false, maxWait:150, trailing:true});//////????????
    },
    
    fireAlertEvent: function(message)
    {
	  var e = $A.get('e.c:CsqShowAlert');
      e.setParam('message', message);
      e.fire();
    },
    
    getComponentName: function(componentDef)
    {
		'use strict'
		var s = componentDef.toString();
        s = s.replace('markup://', '');
        return s;
    },
    
    getComponent: function(storeId)
    {
      'use strict'
      var list = this.componentMap[storeId];
      list = this.lodashService.filter(list, function(c){return c.isValid()});
      return list[0];
    },

    getComponentBody: function(component)
    {
        component = component.getConcreteComponent();
        return component.getSuper() ? component.getSuper().get('v.body') : component.get('v.body');
    },
    
    isContainedBy: function(component, container)
    {
        var component = component.getConcreteComponent();
    	var body = this.getComponentBody(container);
        for (var n=0; n<body.length; n++){
        var cmp = body[n];
            if (cmp===component) return true;
            if (cmp.isInstanceOf('aura:html')) return this.isContainedBy(component, cmp);
        }
        return false;
    },
    
    newActionService: function(storeId)
    {
		'use strict'
        var helper = this;
        var _ = helper.lodashService;
        var Promise = helper.promiseService;
        
        function CsqActionService()
        {
            var self = this;
            
			self.get = function(name)
            {
             	return helper.getComponent(storeId).get('c.'+name);
            };
                
            self.run = function(action, callback)
            {
                var settled = false;
                
                return new Promise( $A.getCallback(function(resolve, reject){

                    action.setCallback(this, function(response) {
                        var ret = response.getReturnValue();
                        if (ret && ret.isErrorResponse) {
                            if (!settled) { reject(ret); settled = true; }
                            console.error(JSON.stringify(ret));
                            helper.fireAlertEvent(ret.message);
                        }
                        else {
                            callback(ret);
                            if (!settled) {
                                resolve(ret);
                                settled = true;
                            }
                            helper.fireChangeEvent(storeId);
                        }
                    }, 'SUCCESS');
                    
                    action.setCallback(this, function(response) {
                        var error = action.getError();
                        console.error(JSON.stringify(error));
                        if (!settled) { reject(error); settled = true; }
                        helper.fireAlertEvent(error);
                    }, 'ERROR');
                    
                    action.setCallback(this, function(response) {
                        console.log('INCOMPLETE>>>>>>>>>>>');
                        if (!settled) { reject('Failed to complete'); settled = true; }
                        helper.fireAlertEvent(error);
                    }, 'INCOMPLETE');
                    
                    action.setCallback(this, function(response) {
                        if (!settled) { reject('Aborted'); settled = true; }
                        helper.fireAlertEvent(error);
                    }, 'ABORTED');
                    
                    $A.enqueueAction(action);
                    
                }));
       
    		};
            
       }
        
       return new CsqActionService();
    }
    
  
})