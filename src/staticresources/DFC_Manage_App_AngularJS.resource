var app = angular.module('manageApp', ['ngSanitize']);

app.directive('myDatepicker', function($parse, Modernizr) {

    /* set the date ranges */
    var dt = new Date();
    dt.setFullYear(dt.getFullYear(), dt.getMonth(), dt.getDate());

    /* The business don't like the Chrome date picker */
    if (Modernizr.inputtypes.date && navigator.userAgent.toLowerCase().indexOf('chrome') == -1) {

        return function(scope, element, attrs, controller) {
            jQuery(element).attr('type', 'date');
            jQuery(element).attr('min', '1900-01-01');
        }

    }

    return function(scope, element, attrs, controller) {

        var ngModel = $parse(attrs.ngModel);

        jQuery(function() {

            element.datepicker({
                dateFormat: 'dd/mm/yy',
                changeMonth: true,
                changeYear: true,
                yearRange: "2016:2025",
                //maxDate: dt,
                defaultDate: dt,
                onChangeMonthYear: function(year, month, inst) {
                    if (inst.currentYear != inst.drawYear || inst.currentMonth != inst.drawMonth) {
                        jQuery(this).datepicker("setDate", new Date(year, month - 1, inst.selectedDay));
                    }
                }
            }).on('changeDate', function(e) {
                ngModel.assign(scope, e.date);
            });

        });
    }

});

/*

app.directive('demoFileModel', function($parse) {
    return {
        restrict: 'A', //the directive can be used as an attribute only

        link: function(scope, element, attrs) {
            var model = $parse(attrs.demoFileModel),
                modelSetter = model.assign; //define a setter for demoFileModel

            //Bind change event on the element
            element.bind('change', function() {
                //Call apply on scope, it checks for value changes and reflect them on UI
                scope.$apply(function() {
                    //set the model value
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
});

app.directive('ngConfirmClick', [
    function() {
        return {
            priority: -1,
            restrict: 'A',
            link: function(scope, element, attrs) {
                element.bind('click', function(e) {
                    var message = attrs.ngConfirmClick;
                    // confirm() requires jQuery
                    if (message && !confirm(message)) {
                        e.stopImmediatePropagation();
                        e.preventDefault();
                    }
                });
            }
        }
    }
]);*/

app.controller('manageController', function($scope, $filter, filterFilter, actionService, $window, Modernizr) {
    $scope.isAppInitialised = false;
    $scope.isDatePickerOn = (!Modernizr.inputtypes.date || navigator.userAgent.toLowerCase().indexOf('chrome') > -1);

    $scope.showPart1 = true;
    $scope.showPart2 = false;
    $scope.showPart3 = false;
    $scope.showPart4 = false;
    $scope.showPart5 = false;
    $scope.showPart6 = false;

    $scope.focusAreaInput = {};
    $scope.focusAreaInput.readOnlyMode = true;
    $scope.focusAreaInput.title = '';
    $scope.focusAreaInput.startDateUiFormat = '';
    $scope.focusAreaInput.endDateUiFormat = '';
    $scope.focusAreaInput.description = '';
    $scope.focusAreaInput.hasMinNoFocusAreas = true;
    $scope.focusAreaInput.selectedFocusAreaNoContent = {};

    $scope.repInput = {}
    $scope.repInput.email = '';
    $scope.repInput.name = '';
    $scope.repInput.showInvitation = false;
    $scope.repInput.addRepErrMessage = '';
    $scope.repInput.inviteRepErrMessage = '';

    $scope.activities = {};
    $scope.activities.id = null;
    $scope.activities.readOnlyMode = true;
    $scope.activities.focusAreaSelect = null;
    $scope.activities.focusAreaSelectId = null;
    $scope.activities.title = '';
    $scope.activities.startDateUiFormat = '';
    $scope.activities.endDateUiFormat = '';
    $scope.activities.selectedStartDate = '';
    $scope.activities.selectedEndDate = '';
    $scope.activities.description = '';
    $scope.activities.editModes = {};
    $scope.activities.attachments = [];

    $scope.activityInput = {};
    $scope.activityInput.focusAreaSelectIdOld = null;
    $scope.activityInput.attachmentError = false;

    $scope.activityInput.endDateError = false;
    $scope.activityInput.descriptioneError = false;
    $scope.activityInput.titleError = false;
    $scope.activityInput.focusAreaError = false;

    $scope.assessmentdata = '';
    $scope.year = 0;

    $scope.fileUpload = {};
    $scope.commId = $window.dfcid;

    $scope.assessmentdata = '';
    $scope.yearNumber = 1;
    $scope.yearEnding = null;
    $scope.firstAssessmentDate = null;
    $scope.dueDate = null;
    $scope.submittedDate = null;
    $scope.lastModifiedDate = null;
    $scope.lastModifiedName = null;
    $scope.status = null;
    $scope.questionGroups = null;
    $scope.isSubmit = false;


    var getCoreData = function(commId) {

        console.log('Community ID detected as: ' + $scope.commId);

        // Get community info
        actionService.invokeAction(DFC_CommunityInfoController.getCommunity, $scope.commId)
            .then(function(data) {
                $scope.part1data = data;
                if ($scope.part1data.Date_Approved__c) {
                    $scope.firstAssessmentDate = getFirstAssessmentDate();
                    init();
                }
                getPart4Info(data);
            })
            .catch(function(e) {
                console.log('Error on part1 info retrieval');
                console.error(e);
            });

    };

    var DFC_Community_Action_Area__c = function() {
        this.Id = null;
        this.Name = null;
        this.Selected__c = null;
        this.Description__c = null;
    }

    /*
    	Extract the necessary Action Area data to prepopulate the form as well as 
    	any drop down picklists. Preserve the SFDC Action Area object for future
    	DML operations on submitting changes to action areas
    */

    var getPart2Info = function() {

        actionService.invokeAction(DFC_CommunityInfoController.getCommunityActionAreas, $scope.commId)
            .then(function(data) {

                // Structure the data
                $scope.part2data = {}; // TODO not actually used aywhere now
                $scope.actionAreaValues = [];
                $scope.commActionAreas = {};

                for (var i = 0; i < data.length; i++) {

                    var actionAreaInst = new DFC_Community_Action_Area__c();
                    actionAreaInst.Id = data[i].Id;
                    actionAreaInst.Name = data[i].Action_Area__r.Name;
                    actionAreaInst.Action_Area__c = data[i].Action_Area__c;
                    actionAreaInst.Selected__c = data[i].Selected__c;
                    actionAreaInst.Description__c = data[i].Description__c;
                    $scope.focusAreaInput.selectedFocusAreaNoContent[data[i].Id] = (data[i].Selected__c && data[i].Description__c == null);
                    $scope.commActionAreas[data[i].Id] = actionAreaInst;

                    // Formulate the action area drop down list				
                    if (data[i].Selected__c) {
                        $scope.actionAreaValues.push({
                            id: data[i].Action_Area__r.Id,
                            name: data[i].Action_Area__r.Name
                        });
                    }
                }
                //performFocusAreaValidations();
                console.log('=======================')
                $scope.actionAreaObjSfdc = ''; 
            })
            .catch(function(e) {
                console.log('Error on part2 info retrieval');
                console.error(e);
            });

    };

    var formatDateSalesforceToUi = function(dateLong) {

        var dateObj = new Date(dateLong);
        var day = (dateObj.getDate() < 10) ? '0' + parseInt(dateObj.getDate()) : dateObj.getDate();
        var month = dateObj.getMonth();
        var year = dateObj.getFullYear();

        return day + '/' + month + '/' + year;
    }

    var getPart3Info = function() {

        $scope.activities = {};

        actionService.invokeAction(DFC_CommunityInfoController.getCommunityActivities, $scope.commId)
            .then(function(data) {
                $scope.attachmentData = data.sdata;
                var activityData = data.activities;

                for (var i = 0; i < activityData.length; i++) {

                    var objInst = new activityInputObj();
                    objInst.activityId = activityData[i].Id;
                    if (activityData[i].Action_Areas__r != undefined && activityData[i].Action_Areas__r.length > 0) {
                        objInst.focusArea = activityData[i].Action_Areas__r[0].Action_Area__r.Action_Area__r.Name;
                        objInst.focusAreaId = activityData[i].Action_Areas__r[0].Action_Area__r.Action_Area__r.Id;
                    }
                    objInst.title = activityData[i].Title__c;
                    objInst.description = activityData[i].Description__c;
                    objInst.startDateUiTitle = formatDate(new Date(activityData[i].Start__c));
                    objInst.startDateUiFormat = formatDateSalesforceToUi(activityData[i].Start__c);
                    objInst.endDateUiFormat = formatDateSalesforceToUi(activityData[i].End__c);
                    objInst.editMode = false;
                    objInst.attachments = [];

                    if (activityData[i].hasOwnProperty('Attachments')) {
                        for (var j = 0; j < activityData[i].Attachments.length; j++) {
                            var attSfdcId = activityData[i].Attachments[j].Id;
                            var attObj = {}
                            attObj["Id"] = attSfdcId;
                            attObj["SignedId"] = data.sdata[attSfdcId];
                            attObj["Name"] = activityData[i].Attachments[j].Name;

                            objInst.attachments.push(attObj);
                        }
                    }

                    $scope.activities[objInst.activityId] = objInst;
                }
            })
            .catch(function(e) {
                console.error(e);
            });

    };



    function formatDate(date) {
        var monthNames = [
            "January", "February", "March",
            "April", "May", "June", "July",
            "August", "September", "October",
            "November", "December"
        ];

        var day = date.getDate();
        var monthIndex = date.getMonth();
        var year = date.getFullYear();

        return day + ' ' + monthNames[monthIndex] + ' ' + year;
    }



    $scope.onClickToggleActivityView = function(activityId) {

        if (activityId == undefined) {
            // New activity is being defined
            ($scope.activityInput.editMode) ? $scope.activityInput.editMode = false: $scope.activityInput.editMode = true;
        } else {
            // Toggle the existing activty edit view
            ($scope.activities[activityId].editMode) ? $scope.activities[activityId].editMode = false: $scope.activities[activityId].editMode = true;

            // Prepopulate the object that will be send to Salesforce 
            $scope.activityInput.activityId = $scope.activities[activityId].activityId;
            $scope.activityInput.focusArea = $scope.activities[activityId].focusArea;
            $scope.activityInput.focusAreaId = $scope.activities[activityId].focusAreaId;
            $scope.activityInput.focusAreaSelectIdPrev = $scope.activities[activityId].focusAreaId; // Initialise previous value for dropdown selection changes
            $scope.activityInput.title = $scope.activities[activityId].title;
            $scope.activityInput.description = $scope.activities[activityId].description;
            $scope.activityInput.startDateUiTitle = $scope.activities[activityId].startDateUiTitle;
            $scope.activityInput.startDateUiFormat = $scope.activities[activityId].startDateUiFormat;
            $scope.activityInput.endDateUiFormat = $scope.activities[activityId].endDateUiFormat;
            $scope.isDatePickerOn = true;

            for (var i = 0; i < $scope.actionAreaValues.length; i++) {
                if ($scope.actionAreaValues[i]['id'] == $scope.activities[activityId].focusAreaId) {
                    $scope.activityInput.focusAreaSelect = $scope.actionAreaValues[i];
                    break;
                }
            }
        }
    }

    var getPart4Info = function(communityCoreData) { // TODO handle multiple representatives

        var part4data = {};
        $scope.reps = [];
        var fullname = null;
        var email = null;
        var status = null;
        var id = null;

        for (var i = 0; i < communityCoreData["Representatives__r"].length; i++) {

            if (i == 0) {
                part4data["fullName"] = communityCoreData.Representatives__r[i].DF_Contact__r.Name;
                part4data["email"] = communityCoreData.Representatives__r[i].DF_Contact__r.Email__c;
                part4data["status"] = communityCoreData.Representatives__r[i].Role__c;
            }

            // Handle the invited vs registered field 
            id = communityCoreData.Representatives__r[i].Id;
            status = communityCoreData.Representatives__r[i].Role__c;
            if (status == 'Registered') {
                fullname = communityCoreData.Representatives__r[i].DF_Contact__r.Name;
                email = communityCoreData.Representatives__r[i].DF_Contact__r.Email__c;
            } else {
                fullname = communityCoreData.Representatives__r[i].Invited_Name__c;
                email = communityCoreData.Representatives__r[i].Invited_Email__c;
            }
            addRepToPage(fullname, email, status, id);
        }

        // Load the reps into the variable for HTML rendering
        $scope.allReps = $scope.reps;
        $scope.part4data = part4data;
        console.log('=======================')
    };

    var Rep = function() {
        this.id = null;
        this.fullname = null;
        this.email = null;
        this.status = null;
    }

    var addRepToPage = function(fullname, email, status, id) {
        var rep = new Rep();
        rep.id = id;
        rep.fullname = fullname;
        rep.email = email;
        rep.status = status;
        $scope.reps.push(rep);
    }

    var getRepList = function() {
        $scope.allReps = [];
        if ($scope.reps != undefined) {
            for (var i = 0; i < $scope.reps.length; i++) {
                $scope.allReps.push($scope.reps[i]);
            }
        }
    }

    $scope.onClickCancelInviteRep = function() {
        $scope.repInput.showInvitation = false;
        $scope.repInput.email ='';
    }

    /* 
    	Control actions as moving forward through the form
    */
    $scope.onClickAddRepEmail = function() {
        // Save new reps
         var emailPattern = /^[-a-zA-Z0-9~\"!$%^&*_=+}{\'?]+(\.[-a-zA-Z0-9~"!$%^&*_=+}{\'?]+)*@([a-zA-Z0-9_][-a-zA-Z0-9_]*(\.[-a-zA-Z0-9_]+)*\.([a-zA-Z]*)|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?[^.]$/;

         if(emailPattern.test($scope.repInput.email)) {
            actionService.invokeAction(DFC_CommunityInfoController.addRepresentative, $scope.commId, $scope.repInput.email)
                .then(function(data) {
                    console.log('Saved representative details successfully or did ir: ' + JSON.stringify(data));
                    if (data.typeName == "Dfc_Exception") {
                        $scope.repInput.addRepErrMessage = data.message;
                        $scope.repInput.showInvitation = false;
                    } else {
                        if(!data) {
                            $scope.repInput.addRepErrMessage = '';
                            $scope.repInput.showInvitation = true;
                        } else {
                            console.log('Returned data is: ' + data);
                            addRepToPage(data.DF_Contact__r.Name, data.DF_Contact__r.Email__c, data.Role__c, data.Id);
                        }
                    }
                })
                .catch(function(e) {
                    console.log('Error saving new rep details');
                });
        } else {
            $scope.repInput.addRepErrMessage = 'Please enter a valid email';  
        }
    }

    $scope.isCurentUsersRepCard = function(repId) {
        // Allow the removal of any rep except for the rep of the current user
        for (var i = 0; i < $scope.allReps.length; i++) {
            if ((repId == $scope.allReps[i].id) && ($scope.allReps[i].email == $window.commUserEmail)) {
                return false;
            }
        }
        return true;
    }

    $scope.onClickSendRepInvitation = function() {

        if (($scope.repInput.name == null || $scope.repInput.name == '')) {
            $scope.repInput.inviteRepErrMessage = 'Please enter the invitee\'s name';
            return;
        }
        // Save new reps
        actionService.invokeAction(DFC_CommunityInfoController.inviteRepresentative, $scope.commId, $scope.repInput.email, $scope.repInput.name)
            .then(function(data) {
                console.log('Saved representative details successfully with ' + JSON.stringify(data));
                addRepToPage(data.Invited_Name__c, data.Invited_Email__c, data.Role__c, data.Id);
                // Clear the working variables
                $scope.repInput.email = '';
                $scope.repInput.name = '';
                $scope.repInput.showInvitation = false;
                $scope.repInput.addRepErrMessage = '';
                $scope.repInput.inviteRepErrMessage = '';
            })
            .catch(function(e) {
                console.log('Error saving new rep details');
            });
    }

    $scope.removeRepresentative = function(id) {
        actionService.invokeAction(DFC_CommunityInfoController.removeRepresentative, $scope.commId, id)
            .then(function(data) {
                console.log('Deletion data object is: ' + JSON.stringify(data));
                removeRepFromPage(id);
                console.log('Successfully removed rep');
            })
            .catch(function(e) {
                console.log('Error remoing rep');
            })
    }

    var removeRepFromPage = function(id) {
        for (var i = 0; i < $scope.reps.length; i++) {

            if ($scope.reps[i].id == id) {
                $scope.reps.splice(i, 1);
                break;
            }
        }
    }

    /* 
    	Control actions when moving backwards through the form
    */
    $scope.onNavClick = function(pageToShow) {
        showPart(pageToShow);
    }

    var showPart = function(pageToShow) {

        switch (pageToShow) {

            case "showPart1":

                $scope.showPart1 = true;
                $scope.showPart2 = false;
                $scope.showPart3 = false;
                $scope.showPart4 = false;
                $scope.showPart5 = false;
                $scope.showPart6 = false;
                break;

            case "showPart2":

                $scope.showPart1 = false;
                $scope.showPart2 = true;
                $scope.showPart3 = false;
                $scope.showPart4 = false;
                $scope.showPart5 = false;
                $scope.showPart6 = false;
                break;

            case "showPart3":

                $scope.showPart1 = false;
                $scope.showPart2 = false;
                $scope.showPart3 = true;
                $scope.showPart4 = false;
                $scope.showPart5 = false;
                $scope.showPart6 = false;
                break;

            case "showPart4":

                $scope.showPart1 = false;
                $scope.showPart2 = false;
                $scope.showPart3 = false;
                $scope.showPart4 = true;
                $scope.showPart5 = false;
                $scope.showPart6 = false;

                // Save new reps TODO does this matter if run when clicking on the back button?
                actionService.invokeAction(DFC_CommunityInfoController.addRepresentative, $scope.commId, $scope.repInput.email)
                    .then(function(data) {
                        console.log('Saved representative details successfully');
                    })
                    .catch(function(e) {
                        console.log('Error saving new rep details');
                    });
                break;

            case "showPart5":

                $scope.showPart1 = false;
                $scope.showPart2 = false;
                $scope.showPart3 = false;
                $scope.showPart4 = false;
                $scope.showPart5 = true;
                $scope.showPart6 = false;
                break;

            case "showPart6":

                $scope.showPart1 = false;
                $scope.showPart2 = false;
                $scope.showPart3 = false;
                $scope.showPart4 = false;
                $scope.showPart5 = false;
                $scope.showPart6 = true;
                break;

        }

    }

    var focusAreaContentOnRevert = {};
    $scope.focusAreaEdit = function() {

        $scope.focusAreaInput.readOnlyMode = !$scope.focusAreaInput.readOnlyMode;
        // Create a revert copy in case changes are cancelled
        for (key in $scope.commActionAreas) {
            focusAreaContentOnRevert[key] = {};
            focusAreaContentOnRevert[key].Description__c = $scope.commActionAreas[key].Description__c;
            focusAreaContentOnRevert[key].Selected__c = $scope.commActionAreas[key].Selected__c;
            focusAreaContentOnRevert[key].selectedFocusAreaNoContent = ($scope.commActionAreas[key].Selected__c && $scope.commActionAreas[key].Description__c == null);
        }
    }

    /*
    	Activity page controls
    */
    $scope.reloadFocusAreaData = function() {

        $scope.focusAreaInput.readOnlyMode = true;
        for (key in focusAreaContentOnRevert) {
            $scope.commActionAreas[key].Description__c = focusAreaContentOnRevert[key].Description__c;
            $scope.commActionAreas[key].Selected__c = focusAreaContentOnRevert[key].Selected__c;
            $scope.focusAreaInput.selectedFocusAreaNoContent[key] = focusAreaContentOnRevert[key].selectedFocusAreaNoContent;
        }
    }


    $scope.saveFocusAreaData = function() {

        // Get all focus area edits
        var focusAreaInputs = [];
        var focusArea = null;

        // Get the values from $scope.commActionAreas
        var focusAreaArr = [];
        $scope.focusAreaInput.hasMinNoFocusAreas = false;
        $scope.focusAreaInput.isMissingContent = false;
        for (key in $scope.commActionAreas) {
            focusAreaArr.push($scope.commActionAreas[key]);
            performFocusAreaValidations(key);
        }

        if ($scope.focusAreaInput.hasMinNoFocusAreas && !$scope.focusAreaInput.isMissingContent) {

            actionService.invokeAction(DFC_CommunityInfoController.updateActionAreas, $scope.commId, focusAreaArr) //focusAreaInputs) //focusAreaInputs => List<DFC_Community_Action_Area__c> in the Apex class parameter
                .then(function(data) {
                    $scope.focusAreaInput.readOnlyMode = true;

                    $scope.actionAreaValues = []; // Refresh all focus area sselection lists for the activities page
                    for (key in $scope.commActionAreas) {
                        //Update the dropdown list for activities
                        if ($scope.commActionAreas[key].Selected__c) {
                            $scope.actionAreaValues.push({
                                id: key,
                                name: $scope.commActionAreas[key].Name
                            });
                        }
                        performFocusAreaValidations(key);
                    }

                })
                .catch(function(e) {
                    console.log('Failed on action area update: ');
                    console.error(e);
                })
        }
    }

    $scope.isMissingContent = function(focusAreaId) {

        var logicalCondition = $scope.commActionAreas[focusAreaId].Selected__c &&
            ($scope.commActionAreas[focusAreaId].Description__c == null ||
                $scope.commActionAreas[focusAreaId].Description__c == '');
        return logicalCondition;
    }

    var cleanDataStructureForSfdc = function(sfdcObject, fieldToRemove) {
        delete sfdcObject[fieldToRemove];
    }

    var performFocusAreaValidations = function(key) {
        // Ensure at least one action area is selected
        if ($scope.commActionAreas[key].Selected__c) {
            $scope.focusAreaInput.hasMinNoFocusAreas = true;
            // Ensure that all selected focus areas have content
            if ($scope.commActionAreas[key].Description__c == null || $scope.commActionAreas[key].Description__c == '') {
                $scope.focusAreaInput.isMissingContent = true;
            } else {
            }
        }

    }

    /*
    	Revert cancelled area focus modifications
    */
    $scope.facilitateRollback = function(focusAreaEdited) {

        switch (focusAreaEdited) {

            case "fa1":
                console.log('New entry is : ' + $scope.focusAreaInput.editFocusArea1);
                console.log('Old entry is : ' + $scope.focusAreaInput.descriptionRollback1); //$scope.part2data['Arts, culture, leisure and recreation']);
                break;

            case "fa2":
                console.log('New entry is : ' + $scope.focusAreaInput.editFocusArea2); //editFocusArea2);
                console.log('Old entry is : ' + $scope.focusAreaInput.descriptionRollback2); //$scope.part2data['Businesses and shops']);
                break;

            case "fa3":
                console.log('New entry is : ' + $scope.focusAreaInput.editFocusArea3);
                console.log('Old entry is : ' + $scope.focusAreaInput.descriptionRollback3); //$scope.part2data['Children, young people and students']);
                break;

            case "fa4":
                console.log('New entry is : ' + $scope.focusAreaInput.editFocusArea4);
                console.log('Old entry is : ' + $scope.focusAreaInput.descriptionRollback4); //$scope.part2data['Community, voluntary, faith groups and organizations']);
                break;

            case "fa5":
                console.log('New entry is : ' + $scope.focusAreaInput.editFocusArea5);
                console.log('Old entry is : ' + $scope.focusAreaInput.descriptionRollback5); //$scope.part2data['Fire and police']);
                break;

            case "fa6":
                console.log('New entry is : ' + $scope.focusAreaInput.editFocusArea6);
                console.log('Old entry is : ' + $scope.focusAreaInput.descriptionRollback6); //$scope.part2data['Health and social care']);
                break;

            case "fa7":
                console.log('New entry is : ' + $scope.focusAreaInput.editFocusArea7);
                console.log('Old entry is : ' + $scope.focusAreaInput.descriptionRollback7); //$scope.part2data['Housing']);
                break;

            case "fa8":
                console.log('New entry is : ' + $scope.focusAreaInput.editFocusArea8);
                console.log('Old entry is : ' + $scope.focusAreaInput.descriptionRollback8); //$scope.part2data['Transport']);
                break;

        }

    }

    $scope.onNewActivityClick = function() {
        $scope.activityInput = new activityInputObj();
        $scope.activityInput.editMode = true;
    }

    $scope.onCancelActivityClick = function() {
        $scope.activities.readOnlyMode = true;
    }

    $scope.handleDateInput = function(dateType) {
        var inputText;
        var isStartDate;

        /* Is there date at all */
        if (dateType == 'endDate') {
            inputText = $scope.activityInput.endDateUiFormat;
            isStartDate = false;
        } else if (dateType == 'startDate') {
            inputText = $scope.activityInput.startDateUiFormat;
            isStartDate = true;
        }

        if (!inputText) {
            return;
        };

        var userDate;
        if ($scope.isDatePickerOn) {
            var v = inputText.split('/');
            userDate = new Date(v[2], v[1] - 1, v[0]);

        } else {

            /* this will be yy-mm-dd */
            userDate = new Date(inputText);
        }

        if (dateType == 'endDate') {
            $scope.activityInput.endDateSfdcFormat = userDate;
        } else if (dateType == 'startDate') {
            $scope.activityInput.startDateSfdcFormat = userDate;
        }

        var today = new Date();
        if (userDate.getFullYear() - today.getFullYear() > 1) {
            $scope.dateAlert = "Please enter a valid date within the past year"; // TODO add error catching element
            return;
        }

        (isStartDate) ? $scope.activityInput.startDateUiFormat = inputText: $scope.activityInput.endDateUiFormat = inputText;

        return;
    }

    var DFC_Activity__c = function() {}

    $scope.onSaveActivityClick = function(optionalActivitySfdcId) {

        var focusAreaJson = '["' + $scope.activityInput.focusAreaSelectId + '"]';
        var activityParams = {};
        activityParams["Title__c"] = $scope.activityInput.title;
        activityParams["Description__c"] = $scope.activityInput.description;
        $scope.handleDateInput('startDate') // This converts the value set in $scope.activityInput.startDateUiFormat;
        activityParams["Start__c"] = $scope.activityInput.startDateSfdcFormat;
        $scope.handleDateInput('endDate') // This converts the value set in $scope.activityInput.endDateUiFormat;
        activityParams["End__c"] = $scope.activityInput.endDateSfdcFormat;

        if (performActivityValidations(activityParams)) {
            return;
        }

        if (optionalActivitySfdcId != undefined) {
            activityParams["Id"] = $scope.activityInput.activityId;
            activityParams["focusAreaId"] = $scope.activityInput.focusAreaSelectId; //$scope.activityInput.focusAreaSelect["id"];

            if ($scope.activityInput.focusAreaSelectIdPrev == undefined) {
                $scope.activityInput.focusAreaSelectIdPrev = '';
            }

            actionService.invokeAction(DFC_CommunityInfoController.updateActivity, activityParams, $scope.activityInput.focusAreaSelectIdPrev, $scope.commId)
                .then(function(data) {
                    $scope.activityInput.focusAreaSelectIdOld = null; // Clear any previous focus area selection 
                    $scope.activityInput.editMode = false;
                    updateActivityList(activityParams);
                })
                .catch(function(e) {
                    console.error(e);
                })

        } else {
            actionService.invokeAction(DFC_CommunityInfoController.addActivity, $scope.commId, activityParams, focusAreaJson)
                .then(function(data) {
                    // Return to the view mode
                    $scope.activityInput.editMode = false;
                    updateActivityList(data.activity);
                })
                .catch(function(e) {
                    console.error(e);
                })
        }
    }

    var performActivityValidations = function(activityParams) {
        // Check end date occurs after the start date 

        $scope.activityInput.endDateError = false;
        $scope.activityInput.titleError = false;
        $scope.activityInput.descriptionError = false;
        $scope.activityInput.focusAreaError = false;
        $scope.activityInput.startDateError = false;
        var isError = false;

        if (activityParams["Start__c"] == null || activityParams["Start__c"] == '') {
            $scope.activityInput.startDateError = true;
            isError = true;
        }
        if (activityParams["End__c"] != null && (activityParams["Start__c"] > activityParams["End__c"])) {
            $scope.activityInput.endDateError = true;
            isError = true;
        }
        if (activityParams["Title__c"] == null || activityParams["Title__c"] == '') {
            $scope.activityInput.titleError = true;
            isError = true;
        }
        if (activityParams["Description__c"] == null || activityParams["Description__c"] == '') {
            $scope.activityInput.descriptionError = true;
            isError = true;
        }
        if ($scope.activityInput.focusAreaSelect == null) {
            $scope.activityInput.focusAreaError = true;
            isError = true;
        }
        return isError;
    }

    var activityInputObj = function() {
        this.title = null;
        this.description = null;
        this.start = null;
        this.end = null;
        this.focusArea = null;
        this.startDateUiTitle = null;
        this.startDateUiFormat = null;
        this.endDateUiFormat = null;
        this.editMode = null;
        this.showFileUploadSection = null;
    }

    var updateActivityList = function(activityParams) {

        var activityId = activityParams["Id"];

        if ($scope.activities[activityId] == undefined) { // When adding new activities
            $scope.activities[activityId] = new activityInputObj();
        }
        $scope.activities[activityId].activityId = activityId;
        $scope.activities[activityId].focusArea = $scope.activityInput.focusAreaSelect.name;
        $scope.activities[activityId].title = $scope.activityInput.title;
        $scope.activities[activityId].description = $scope.activityInput.description;
        $scope.activities[activityId].startDateUiTitle = formatDate(new Date(activityParams["Start__c"]));
        $scope.activities[activityId].startDateUiFormat = $scope.activityInput.startDateUiFormat;
        $scope.activities[activityId].endDateUiFormat = $scope.activityInput.endDateUiFormat;
        $scope.activities[activityId].editMode = false;
        $scope.activities[activityId].showFileUploadSection = false;

    }

    $scope.onClickRemoveActivity = function(activityId) {
        actionService.invokeAction(DFC_CommunityInfoController.removeActivity, activityId)
            .then(function(data) {
                if ($scope.activities.length == 1) {
                    $scope.activities = null;
                } else {
                    delete $scope.activities[activityId];
                }
                console.log('Activity successfully deleted');
            })
            .catch(function(e) {
                console.error(e);
            })
    }


    $scope.onClickCancelAttachment = function(activityId) {
        $scope.activities[activityId].showFileUploadSection = false;
    }

    $scope.onFocusAreaSelectChange = function() {
        $scope.activityInput.focusAreaSelectId = $scope.activityInput.focusAreaSelect.id;
    }

    $scope.onClickViewAttachment = function(attachId) {
        $scope.urlAttachmentBody = null;
        // Get the time limited info for all activities
        actionService.invokeAction(DFC_CommunityInfoController.readCommunityActivitiesWithSigning, $scope.commId)
            .then(function(data) {
                // Get the link to the clicked attachment
                $scope.urlAttachmentBody = data[attachId];
            })
            .catch(function(e) {
                console.log('Error in retrieving content');
            })

    }

    $scope.onClickRemoveAttachment = function(activityId, attId) {

        var deleteConfirm = $window.confirm('Are you sure you want to delete the attachment?');

        if (deleteConfirm) {
            actionService.invokeAction(DFC_CommunityInfoController.removeActivityAttachment, activityId, attId)
                .then(function(data) {
                    // Now find the attachment and remove from the list of shown attachments
                    var tempArr = $scope.activities[activityId].attachments;
                    for (var i = 0; i < $scope.activities[activityId].attachments.length; i++) {
                        if ($scope.activities[activityId].attachments[i].Id == attId) {
                            if ($scope.activities[activityId].attachments.length == 1) {
                                $scope.activities[activityId].attachments = [];
                            } else {
                                $scope.activities[activityId].attachments.splice(i, 1);
                            }
                        }

                    }

                })
                .catch(function(e) {
                    console.log("Failed to remove attachment");
                })
        }
    }

    var maxStringSize = 6000000; //Maximum String size is 6,000,000 characters
    var maxFileSize = 4350000; //After Base64 Encoding, this is the max file size
    var chunkSize = 950000; //Maximum Javascript Remoting message size is 1,000,000 characters
    var attachment;
    var attachmentName;
    var fileSize;
    var positionIndex;
    var doneUploading;

    $scope.onClickAttachFile = function(activityId) {
        console.log('In click attach file with ID: ' + activityId);
        $scope.activities[activityId].showFileUploadSection = true;
    }

    //Method to prepare a file to be attached to the Account bound to the page by the standardController
    $scope.onClickUploadFile = function(activityId) {
        $scope.activityInput.attachmentError = false;
        
        // List the accecpted mimetypes
        var mimeTypeMap = {};
        mimeTypeMap['txt'] = 'text/plain';
        mimeTypeMap['pdf'] = 'application/pdf';
        mimeTypeMap['ics'] = 'text/calendar';
        mimeTypeMap['eml'] = 'message/rfc822';
        mimeTypeMap['ico'] = 'image/x-icon';
        mimeTypeMap['jpg'] = 'image/jpeg';
        mimeTypeMap['jpeg'] = 'image/jpeg';
        mimeTypeMap['png'] = 'image/png';
        mimeTypeMap['xls'] = 'application/vnd.ms-excel';
        mimeTypeMap['xlsb'] = 'application/vnd.ms-excel.sheet.binary.macroenabled.12';
        mimeTypeMap['pptx'] = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
        mimeTypeMap['xlsx'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        mimeTypeMap['docx'] = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        mimeTypeMap['ppt'] = 'application/vnd.ms-powerpoint';
        mimeTypeMap['mpp'] = 'application/vnd.ms-project';
        mimeTypeMap['doc'] = 'application/msword';
        mimeTypeMap['wri'] = 'application/x-mswrite';
        mimeTypeMap['wps'] = 'application/vnd.ms-works';
        mimeTypeMap['oxt'] = 'application/vnd.openofficeorg.extension';
        mimeTypeMap['odi'] = 'application/vnd.oasis.opendocument.image';
        mimeTypeMap['ods'] = 'application/vnd.oasis.opendocument.spreadsheet';
        mimeTypeMap['odt'] = 'application/vnd.oasis.opendocument.text';
        mimeTypeMap['rtf'] = 'application/rtf';
        mimeTypeMap['trx'] = 'text/richtext';
        mimeTypeMap['zip'] = 'application/zip';

        var uid = 'myFileField-' + activityId;
        var file = document.getElementById(uid).files[0];
        var result = null;

        if (file != undefined) {
            if (file.size <= maxFileSize) {
                attachmentName = file.name;

                // Set MIME type
                var fileExtStartIndex = attachmentName.lastIndexOf('.') + 1;
                var fileExtEndIndex = attachmentName.length;
                var mimeTypeKey = attachmentName.substring(fileExtStartIndex, fileExtEndIndex).toLowerCase();
                var contentType = mimeTypeMap[mimeTypeKey];
                if (contentType == undefined || contentType == null) {
                    $scope.activityInput.attachmentError = true;
                    return;
                }

                var fileReader = new FileReader();
                fileReader.onloadend = function(e) {
                    attachment = window.btoa(this.result); //Base 64 encode the file before sending it
                    positionIndex = 0;
                    fileSize = attachment.length;
                    doneUploading = false;
                    if (fileSize < maxStringSize) {
                        result = uploadAttachment(null, activityId, contentType);
                    } else {
                        alert("Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".");
                    }
                    //console.log('e: ' + JSON.stringify(e));
                }
                fileReader.onerror = function(e) {
                    alert("There was an error reading the file.  Please try again.");
                }
                fileReader.onabort = function(e) {
                    alert("There was an error reading the file.  Please try again.");
                }

                fileReader.readAsBinaryString(file); //Read the body of the file

            } else {
                alert("File must be under 4.3 MB in size.  Your file is too large.  Please try again.");
            }
        } else {
            alert("You must choose a file before trying to upload it");
        }
    }

    //Method to send a file to be attached to the Account bound to the page by the standardController
    //Sends parameters: Account Id, Attachment (body), Attachment Name, and the Id of the Attachment if it exists to the controller   
    var uploadAttachment = function(fileId, activityId, contentType) {
        var attachmentBody = "";
        if (fileSize <= positionIndex + chunkSize) {
            attachmentBody = attachment.substring(positionIndex);
            doneUploading = true;
        } else {
            attachmentBody = attachment.substring(positionIndex, positionIndex + chunkSize);
        }
        console.log("Uploading " + attachmentBody.length + " chars of " + fileSize + ' to activity: ' + activityId);

        actionService.invokeAction(DFC_CommunityInfoController.doUploadAttachment,
                activityId, attachmentBody, attachmentName, fileId, contentType)
            .then(function(result) {
                $scope.activities[activityId].showFileUploadSection = false;
                if ($scope.activities[activityId].attachments == undefined) {
                    $scope.activities[activityId].attachments = [];
                }
                $scope.activities[activityId].attachments.push({
                    "Id": result['id'],
                    "SignedId": result['sid'],
                    "Name": attachmentName
                });
            })
            .catch(function(e) {
                console.log('Errored');
            });
    }



    $scope.onClickCancelAttachFile = function() {
        $scope.showFileUploadSection = false;
    }

    var getPart6Info = function() {
        actionService.invokeAction(DFC_CommunityInfoController.getResources, 'Active')
            .then(function(data) {
                $scope.commResources = data.resources;
            })
            .catch(function(e) {});
    };

    //lakshmi's methods

    var getpart5Data = function(commId) {


        actionService.invokeAction(DFC_CommunityInfoController.getAssessmentForCommunityAndYear, $scope.commId, $scope.yearNumber)
            .then(function(data) {
                $scope.assessmentdata = data;
            })
            .catch(function(e) {
                console.log('Error on part1 info retrieval');
                console.error(e);
            });

    };

    var getEndDateForYearNumber = function(dateApproved, yearNumber) {
        var ad = typeof(dateApproved == 'string') ? new Date(dateApproved) : dateApproved;
        var month = ad.getMonth();
        var day = ad.getDate();
        if (month == 2 && day == 29) day = 28;
        console.log('returned date@@' + new Date(ad.getFullYear() + yearNumber, month, day, 12));
        return new Date(ad.getFullYear() + yearNumber, month, day, 12);
    };


    var getYearNumber = function() {
        return $scope.yearNumber;
    };

    var getYearEnding = function() {
        return $scope.yearEnding;
    };

    var getDueDate = function() {
        return $scope.dueDate;
    };

    var getLastModifiedDate = function() {
        return $scope.lastModifiedDate;
    };

    var getLastModifiedName = function() {
        return $scope.lastModifiedName;
    };

    var getSubmittedDate = function() {
        return $scope.submittedDate;
    };

    var getStatus = function() {
        return $scope.status;
    };

    var getQuestionGroups = function() {
        return $scope.questionGroups;
    };

    var init = function() {
        return loadAssessment(0);
    };

    $scope.onUpdateAssessment = function(data) {
        var questionGroups = data;
        $scope.isSubmit = false;
        return storeAssessment('Draft', $scope.questionGroups)
    };

    $scope.onSubmitAssessment = function(data) {
        var questionGroups = data;
        $scope.isSubmit = true;

        return storeAssessment('Submitted', $scope.questionGroups)

    };

    var storeAssessment = function(status, questionGroups) {

        var assessmentId = $scope.questionGroups[0].questions[0].Assessment__c;
        var isValid = true;
        var answers = [];
        $scope.questionGroups.forEach(function(group) {
            group.questions.forEach(function(q) {
                if (status == 'Submitted' && (q.Entered_Answer__c == null ||
                        q.Extra_Information__c == null && q.Capture_Extra__c && (q.Capture_Extra_On_Option__c != null && q.Capture_Extra_On_Option__c.indexOf(q.Entered_Answer__c) >= 0))) {
                    isValid = false;
                    return;
                }
                var answer = {};
                answer.Id = q.Id;
                answer.sobjectType = q.sobjectType;
                answer.Entered_Answer__c = q.Entered_Answer__c;
                answer.Other_Selected__c = q.Other_Selected__c;
                answer.Extra_Information__c = q.Extra_Information__c;
                answers.push(answer);
            });
        });
        if (isValid) {
            actionService.invokeAction(DFC_CommunityInfoController.updateAssessment,
                    assessmentId, status, answers)
                .then(function(data) {

                    formatAssessment(data);
                });
        }
    };

    var loadAssessment = function(year) {

        var communityId = getPassedCommunityId(); // community Id
        actionService.invokeAction(DFC_CommunityInfoController.getAssessmentForCommunityAndYear, $scope.commId, year)
            .then(function(data) {
                $scope.assessmentdata = data;
                formatAssessment(data);

            })
    };

    var getPassedCommunityId = function() {
        var a = /[?&]dfcid=([^&#]*)/g.exec(location.search);
        return a ? decodeURIComponent(a[1].replace(/\+/g, " ")) : null;
    };

    var formatAssessment = function(data) {
        if (data == null) {
            $scope.yearNumber = null;
            $scope.yearEnding = null;
            $scope.dueDate = null;
            $scope.submittedDate = null;
            $scope.lastModifiedDate = null;
            $scope.lastModifiedName = null;
            $scope.status = null;
            $scope.questionGroups = null;
            return;
        };

        $scope.yearNumber = data.Year_Number__c;
        $scope.status = data.Status__c;
        $scope.lastModifiedDate = data.LastModifiedDate;
        $scope.lastModifiedName = data.LastModifiedBy.Name;

        $scope.yearEnding = getEndDateForYearNumber(data.Community__r.Date_Approved__c, $scope.yearNumber);

        // Assessment Due Date - 1 month after year ending date
        var month = $scope.yearEnding.getMonth() + 1;
        var day = $scope.yearEnding.getDate();
        if (month == 2 && day == 29) day = 28;
        $scope.dueDate = new Date($scope.yearEnding.getFullYear(), month, day, 12);

        var ds = data.Date_Submitted__c == undefined ? null : data.Date_Submitted__c;
        $scope.submittedDate = typeof(ds == 'string') ? new Date(ds) : ds;

        formatAnswers(data.Answers__r);
    };

    var formatAnswers = function(data) {
        var field = 'Sequence__c';
        var answers = data.sort(function(a, b) {
            return (a[field] > b[field] ? 1 : -1);
        });


        angular.forEach(answers, function(item, key) {

            var rx = new RegExp('[\n\r]+');
            item.Options__c = item.Options__c && item.Options__c.split(rx);

            item["enteredAnswer"] = {};
            item.enteredAnswer = item.Entered_Answer__c && item.Entered_Answer__c.split(rx);
            item.Capture_Extra_On_Option__c = item.Capture_Extra_On_Option__c && item.Capture_Extra_On_Option__c.split(rx);
            item["otherText"] = item.Other_Selected__c == true ? item.Entered_Answer__c : '';
            item["selectedMultiValues"] = [];
            var array = [];
            angular.forEach(item.Options__c, function(item1) {
                if (item.enteredAnswer != null) {
                    if (item.enteredAnswer.indexOf(item1) != -1) {
                        item.selectedMultiValues.push({
                            name: item1,
                            selected: true
                        });
                    } else {
                        item.selectedMultiValues.push({
                            name: item1,
                            selected: false
                        });
                    }
                } else {

                    item.selectedMultiValues.push({
                        name: item1,
                        selected: false
                    });
                }
            });
        });


        var n = 0;
        var groups = [];

        while (n < answers.length) {


            var a = answers[n];

            var grp = {
                Title__c: a.Title__c,
                Guidance__c: a.Guidance__c,
                Capture_Extra__c: a.Capture_Extra__c,
                questions: [a]
            }
            while (++n < answers.length && answers[n].Continuation__c)
                grp.questions.push(answers[n]);

            groups.push(grp);


        }

        $scope.questionGroups = groups;
    };

    var getEndDateForYearNumber = function(dateApproved, yearNumber) {
        var ad = typeof(dateApproved == 'string') ? new Date(dateApproved) : dateApproved;
        var month = ad.getMonth();
        var day = ad.getDate();
        if (month == 2 && day == 29) day = 28;
        return new Date(ad.getFullYear() + yearNumber, month, day, 12);
    };

    var getFirstAssessmentDate = function() {
        var ad = new Date($scope.part1data.Date_Approved__c);
        if (!ad) return null;
        var year = ad.getFullYear();
        var month = ad.getMonth();
        var day = ad.getDate();
        if (month == 1 && day == 29) day = 28;
        return new Date(year + 1, month, day, 12);
    };

    //Lakshmi's methods end


    // Fire all initial definitions
    getCoreData($scope.commId);
    getPart2Info($scope.commId);
    getPart3Info();
   // getpart5Data($scope.commId);
    getPart6Info();

    $scope.$watch(["reps", "activityInput.editModes", "activities", "$scope.activityInput.focusAreaSelectId", "commActionAreas", "actionAreaValues"], function(newVal, oldVal, scope) {
        console.log("------------------------- OLDVAL: " + oldVal);
    }, true);

    $scope.$watch(["$scope.commActionAreas", "$scope.focusAreaInput.selectedFocusAreaNoContent", "focusAreaInput.selectedFocusAreaNoContent"], function(newVal, oldVal, scope) {
        console.log("------------------------- OLDVAL: " + oldVal);
    }, true);

    $scope.$watch("reps", function(newVal, oldVal) {
        console.log("------------------------- OLDVAL: " + oldVal);
        getRepList();
    }, true);


    $scope.$watch('activityInput.focusAreaSelectId', function(newval, oldval) {
        if (oldval != undefined) {
            $scope.activityInput.focusAreaSelectIdPrev = oldval;
        }
    });

});