({
    createRowOnLoad : function(component, helper) {
                var totalNoRows = 0;
        helper.createRowItemCmp(component, totalNoRows, true);
    },
    
    createOrDeleteRow : function(component, helper, isCreateRowEvt, totalNoRows, evtCmp) {

        if(isCreateRowEvt) {
            helper.createRowItemCmp(component, totalNoRows, false);
        } else {
            helper.destroyRowItemCmp(component, totalNoRows, evtCmp);
        }
    },
    
    destroyRowItemCmp : function(component, curTotalNoRows, cmpToDestroy) {
        
        cmpToDestroy.destroy();
        var newTotalNoRows = curTotalNoRows - 1;
        // Update the max rows on each of the components
        var rowCountUpdateEvt = $A.get("e.c:STD_dynRowCountEvt");        
        rowCountUpdateEvt.setParams({"newTotalNoRows" : newTotalNoRows,
                                     "isInit" : false});
        rowCountUpdateEvt.fire();
        component.set("v.totalNoRows", newTotalNoRows);
        
    },
    
    createRowItemCmp : function(component, curTotalNoRows, isInitRun) {
        
        var newTotalNoRows = curTotalNoRows + 1;
        var isInit = isInitRun;
        
        var dateFieldApiName = "Preference_" + String(newTotalNoRows) + "_Date__c";
        var periodFieldApiName = "Preference_" + String(newTotalNoRows) + "_Period__c";
        var timeFieldApiName = "Preference_" + String(newTotalNoRows) + "_Time__c";
        
    	$A.createComponent(
        "c:DF_infoSessionTimePreference",
        {
            "aura:id" : "sessionTimePreferenceCmpId",
            "name" : "sessionTimePreference-" + newTotalNoRows,
            "dateFieldApiName" : String(dateFieldApiName),
            "periodFieldApiName" : String(periodFieldApiName),
            "timeFieldApiName" : String(timeFieldApiName),
            "rowNum" : newTotalNoRows,
            "totalNoRows" : newTotalNoRows,
            "useSlds" : component.get("v.useSlds")
        }, function(newCmp, status, errorMessage){
             if(status === "SUCCESS") {
                 var body = component.get("v.body");
                 body.push(newCmp);
                 component.set("v.body", body);

                 if(!isInit) {
                     component.set("v.totalNoRows", newTotalNoRows);
                     // Update the max rows on each of the components
                     var rowCountUpdateEvt = $A.get("e.c:STD_dynRowCountEvt");
                     rowCountUpdateEvt.setParams({"newTotalNoRows": newTotalNoRows,
                                                  "isInit" : false});
                     rowCountUpdateEvt.fire();
                 }
                 component.set("v.isLoading", false);
             } else if(status === "INCOMPLETE") {
                 console.log("No response from server or browser is offline");
             } else if(status === "ERROR") {
                 console.log("Error: " + errorMessage);
             }
         });
    },
    
    updateRowCount : function(component, helper, totalNoRows) {
        var rowCmps = component.find("sessionTimePreferenceCmpId");
        for(var rowInd in rowCmps) {
            
            var dateFieldApiName = "Preference_" + String(totalNoRows) + "_Date__c";
            var periodFieldApiName = "Preference_" + String(totalNoRows) + "_Period__c";
            var timeFieldApiName = "Preference_" + String(totalNoRows) + "_Time__c";
            
            var rowCmp = rowCmps[rowInd];
            rowCmp.set("v.dateFieldApiName", dateFieldApiName);
            rowCmp.set("v.periodFieldApiName", periodFieldApiName);
            rowCmp.set("v.timeFieldApiName", timeFieldApiName);
            rowCmp.set("v.rowNum", rowInd);
            rowCmp.set("v.totalNoRows", totalNoRows);
            
        }
    }
})