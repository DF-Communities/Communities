({
  	setSelection: function(component) 
    {
		var question = component.get('v.question');
		var answer = question.Entered_Answer__c;
        answer = answer ? answer.split(new RegExp('[\n\r]+')) : [];

        var items = component.getSuper().find({instancesOf:'ui:inputCheckbox'});
        items.forEach(function(item){
          var text = item.get('v.text');
          item.set('v.value', answer.indexOf(text)>=0);
        });
        
	},
    
  	getSelection : function(component) 
    {
     	var sel = [];
        var items = component.getSuper().find({instancesOf:'ui:inputCheckbox'});
        items.forEach(function(item){
           if (item.get('v.value')) sel.push(item.get('v.text'));
        });
        return sel.length ? sel.join('\n') : null;
	}
    
})