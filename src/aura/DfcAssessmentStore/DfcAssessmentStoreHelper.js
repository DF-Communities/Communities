({
	 // Use actionService to retrieve data in Apex
	createInstance : function(cmp, Promise, _, actionService) 
    {
       'use strict'

        /* These are the read only properties this store exposes */
        var properties = {
            "yearNumber": getYearNumber,
            "yearEnding": getYearEnding,
            "dueDate" : getDueDate,
            "submittedDate" : getSubmittedDate,
            "lastModifiedDate" : getLastModifiedDate,
            "lastModifiedName" : getLastModifiedName,
            "status": getStatus,
            "questionGroups": getQuestionGroups,
        };

        // Action dispatch table
        var dispatchTable = {
  		   "DfcUpdateAssessment": onUpdateAssessment,   
  		   "DfcSubmitAssessment": onSubmitAssessment,   
        };

       /* This var holds the current state of the data and can change as actions happen 
          When the data chnges, onStoreChanged gets fired
       */
       var state = {
           yearNumber:null,
           yearEnding:null,
           dueDate:null,
           submittedDate:null,
           lastModifiedDate:null,
           lastModifiedName:null,
           status:null,
           questionGroups:null
       };
           
       function getYearNumber()
       {
       	 return state.yearNumber;    
       }

       function getYearEnding()
       {
       	 return state.yearEnding;    
       }

       function getDueDate()
       {
         return state.dueDate;    
       }

       function getLastModifiedDate()
       {
         return state.lastModifiedDate;    
       }

       function getLastModifiedName()
       {
         return state.lastModifiedName;    
       }

       function getSubmittedDate()
       {
         return state.submittedDate;    
       }

       function getStatus()
       {
       	 return state.status;    
       }

       function getQuestionGroups()
       {
       	 return state.questionGroups;    
       }

       function init()
       {
          return loadAssessment(0);
       }
        
       // Save Draft Assessment 
       function onUpdateAssessment(data)
       {
           var questionGroups = data;
     	   return storeAssessment('Draft', questionGroups)
       }
        
       function onSubmitAssessment(data)
       {
           var questionGroups = data;
     	   return storeAssessment('Submitted', questionGroups)
       }
        
       function storeAssessment(status, questionGroups)
       {
           var assessmentId = questionGroups[0].questions[0].Assessment__c;

           var answers = [];
           questionGroups.forEach(function(group){
               group.questions.forEach(function(q){
                 var answer = {};
                 answer.Id = q.Id;
                 answer.sobjectType = q.sobjectType;
                 answer.Entered_Answer__c = q.Entered_Answer__c;
                 answer.Other_Selected__c = q.Other_Selected__c;
                 answer.Extra_Information__c = q.Extra_Information__c;
                 answers.push(answer);
               });
           });

	      var action = actionService.get('updateAssessment');
          action.setParam('assessmentId', assessmentId);
          action.setParam('status', status);
          action.setParam('answers', answers);
          return actionService.run(action, function(data){
            formatAssessment(data);
          });
       }
        
       function loadAssessment(year)
       {
 
          var communityId = getPassedCommunityId();  // community Id

	        var action = actionService.get('getAssessmentForCommunityAndYear');
          if (communityId) {
        
            action.setParam('Id', communityId);
          }
          action.setParam('yearEnding', year);
          return actionService.run(action, function(data){
            formatAssessment(data);
          });
       }

       function getPassedCommunityId()
       {
          var a = /[?&]dfcid=([^&#]*)/g.exec(location.search);
          return a ? decodeURIComponent(a[1].replace(/\+/g, " ")) : null;
       }

        function formatAssessment(data)
        {
            if (data==null) {
           	 state.yearNumber = null;
           	 state.yearEnding = null;
             state.dueDate = null;
             state.submittedDate = null;
             state.lastModifiedDate = null;
             state.lastModifiedName = null;
           	 state.status = null;
             state.questionGroups = null;
             return;
       	   };
            
           state.yearNumber = data.Year_Number__c;
           state.status = data.Status__c;
           state.lastModifiedDate = data.LastModifiedDate;
           state.lastModifiedName= data.LastModifiedBy.Name;

           state.yearEnding = getEndDateForYearNumber(data.Community__r.Date_Approved__c, state.yearNumber);
          
           // Assessment Due Date - 1 month after year ending date
           var month = state.yearEnding.getMonth()+1;
           var day = state.yearEnding.getDate();
           if (month==2 && day==29) day = 28;
           state.dueDate =  new Date(state.yearEnding.getFullYear(), month, day, 12);

           var ds = data.Date_Submitted__c == undefined ? null : data.Date_Submitted__c;
           state.submittedDate = typeof(ds=='string') ? new Date(ds) : ds;

           formatAnswers(data.Answers__r);
        }
        
        function formatAnswers(data)
        {
            var answers = _.sortBy(data, 'Sequence__c');
           _.each(answers, formatAnswer);
           
           var n = 0;
           var groups = [];
           while(n<answers.length) {
             var a = answers[n];
             var grp = { Title__c:a.Title__c, Guidance__c:a.Guidance__c, questions: [a] }
			 while (++n<answers.length && answers[n].Continuation__c) grp.questions.push(answers[n]);	             
			 groups.push(grp);
           } 
            
           state.questionGroups = groups;
        }
        
        function formatAnswer(answer)
        {
            var rx = new RegExp('[\n\r]+');
            answer.Options__c = answer.Options__c && answer.Options__c.split(rx);
            answer.Capture_Extra_On_Option__c = answer.Capture_Extra_On_Option__c && answer.Capture_Extra_On_Option__c.split(rx);
        }

		function getEndDateForYearNumber(dateApproved, yearNumber)
        {
           var ad = typeof(dateApproved=='string') ? new Date(dateApproved) : dateApproved;
           var month = ad.getMonth();
           var day = ad.getDate();
           if (month==2 && day==29) day = 28;
   		   return new Date(ad.getFullYear()+yearNumber, month, day, 12);
        }
        
        return { dispatchTable:dispatchTable, properties:properties, init:init, state:state };
	}
})