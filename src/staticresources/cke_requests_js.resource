
app.config(function($locationProvider) {$locationProvider.html5Mode({
      enabled: true,
      requireBase: false
    });
});


  
/*https://bootstrap-datepicker.readthedocs.org/en/latest/*/  
/*app.directive('myDatepicker', function ($parse, Modernizr) {


    var dt = new Date();
    dt.setFullYear(dt.getFullYear()-16, dt.getMonth(), dt.getDate());
    var maxDate = dt.toJSON().split('T')[0];

    if ( Modernizr.inputtypes.date && navigator.userAgent.toLowerCase().indexOf('chrome') == -1 ) { 

        return function (scope, element, attrs, controller) {
            jQuery(element).attr('type', 'date');
            jQuery(element).attr('min', '1900-01-01');
            jQuery(element).attr('max', maxDate);
        }
        
    }

    return function (scope, element, attrs, controller) {

        var ngModel = $parse(attrs.ngModel);            
        
        jQuery(function(){
            
            jQuery(element).attr("readonly", "true");
            element.datepicker({
              dateFormat: 'dd/mm/yy',
              changeMonth:true,
              changeYear:true,
              yearRange:"1900:-15",
              maxDate: dt,
              defaultDate: dt,
              onChangeMonthYear: function(year, month, inst) {
            if(inst.currentYear != inst.drawYear || inst.currentMonth != inst.drawMonth) {
                jQuery(this).datepicker("setDate", new Date(year, month - 1, inst.selectedDay));
              }
            }
            }).on('changeDate', function(e) {
                  ngModel.assign(scope, e.date);
            });
            
        });
    }
     
});*/

 app.directive('ckUpperCase', function() 
 {
    return {
      require: 'ngModel',
      scope: {ckUpperCase:'='},
      link: function(scope, element, attrs, modelCtl) {
       modelCtl.$parsers.push(function(inputValue) {
          if (!scope.ckUpperCase) return inputValue;
          if (inputValue==null) inputValue = '';
          var cap = inputValue.toUpperCase();
          if (cap !== inputValue) {
            modelCtl.$setViewValue(cap);
            modelCtl.$render();
          }
          return cap;
       });
     }
  };
 });
    
app.controller('RootController', function($scope, $timeout, actionService, $window) 
{

    /* Logging  */

    $scope.logging = true;
    if ( $scope.logging ) { console.log('Logging is on');}
    $scope.log = function (msg) {               
        if ( $scope.logging ) { console.log(msg); }
    }

    $scope.ie9 = window.CKIE9;
    $scope.textPattern = '^[a-zA-Z \'?-]{2,40}$';
    $scope.textPattern2 = '^[a-zA-Z \'?-]{2,40}$';
    //$scope.postcodePattern =  /^((GIR[ ]?0AA)|((([A-PR-UWYZ][0-9][0-9]?)|(([A-PR-UWYZ][A-HK-Y][0-9][0-9]?)|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))[ ]?[0-9][ABD-HJLNP-UWXYZ]{2}))$/;
    $scope.postcodePattern = '^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {0,5}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$';
    $scope.emailPattern= /^[-a-zA-Z0-9~\"!$%^&*_=+}{\'?]+(\.[-a-zA-Z0-9~"!$%^&*_=+}{\'?]+)*@([a-zA-Z0-9_][-a-zA-Z0-9_]*(\.[-a-zA-Z0-9_]+)*\.([a-zA-Z]*)|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?[^.]$/;
    $scope.showOtherTitle = false;
    //$scope.isDatePickerOn = (!Modernizr.inputtypes.date || navigator.userAgent.toLowerCase().indexOf('chrome') > -1 );

    $scope.selectedBirthDay = null;
    $scope.selectedBirthMonth = null;
    $scope.selectedBirthYear = null;

    $scope.cleanData = function() 
    {

        var data = angular.copy($scope.data);
        delete data.email2;
        delete data.titleSelect;
        delete data.locationSelect;
        delete data.countrySelect;
        delete data.dobText;
        /*delete data.prox.a;
        delete data.prox.b;
        delete data.prox.c;
        delete data.prox.d;
        delete data.prox.e;
        delete data.prox.f;
        delete data.prox.g;*/
        delete data.prox;
        return data;

    }

    function scrollFirstError()
    {
        var $ = angular.element;
        var e = $('.ng-invalid, .invalid').not('form');
        if (e.length==0) return;
        
        e = e.first();
        $('html, body').animate({
            scrollTop: e.offset().top - 205
        }, 2000);

        if(e.is('input[type=text],input[type=email]')) e.focus();
    }
        
    /*--------- Init --------------*/

    $scope.titleValues = [

        {id: 'void', name : 'Please select'},
        {id: 'Mr', name : 'Mr'},
        {id: 'Ms', name : 'Ms'},
        {id: 'Mrs', name : 'Mrs'},
        {id: 'Miss', name : 'Miss'},
        {id: 'Dr', name : 'Dr'},
        {id: 'Prof', name : 'Prof'},
        {id: 'Other', name : 'Other'}     

    ];
    //$scope.data = {titleSelect : $scope.titleValues[0].name};

    /*
        {id: 'England', name : 'England'},
        {id: 'Northern Ireland', name : 'Northern Ireland'},
        {id: 'Scotland', name : 'Scotland'},
        {id: 'Wales', name : 'Wales'}
    */
    $scope.countryValues = [ 

        {id: 'GB', name : 'United Kingdom'}

    ];

    $scope.locationValues = [

        {id: '', name : 'Please select'},
        {id: 'Work', name : 'Work'},
        {id: 'Home', name : 'Home'},
        {id: 'School', name : 'School'},
        {id: 'Other', name : 'Other'}

    ];  

    $scope.proximityValues = {

        a : 'Person with Dementia',
        b : 'Current Family or Friend',
        c : 'Past Family or Friend',
        d : 'Carer',
        e : 'Past Carer',
        f : 'Professional',
        g : 'Interested Party'

    }

    birthDayValues = function() {
        
        var dayOptions = [];
        var i=1;

        dayOptions.push({id: null, name: 'Day'});
        while(i<=31) {
            var curObj = {id: i, name: (i).toString()};
            dayOptions.push(curObj);
            i++; 
        }
        return dayOptions;
    }
    $scope.birthDayValues = birthDayValues();

    $scope.birthMonthValues = [
        {id: null, name: 'Month'},
        {id: 1, name: 'January'},
        {id: 2, name: 'February'},
        {id: 3, name: 'March'},
        {id: 4, name: 'April'},
        {id: 5, name: 'May'},
        {id: 6, name: 'June'},
        {id: 7, name: 'July'},
        {id: 8, name: 'August'},
        {id: 9, name: 'September'},
        {id: 10, name: 'October'},
        {id: 11, name: 'November'},
        {id: 12, name: 'December'}
    ];

    
    birthYearValues = function() {
        var date = new Date();
        var startYear = date.getFullYear();
        var noYearOptions = startYear - 1900;
        
        var yearOptions = [];
        var i=16;

        yearOptions.push({id: null, name: 'Year'});
        while(i<noYearOptions) {
            var curObj = {id: startYear - i, name: (startYear - i).toString()};
            yearOptions.push(curObj);
            i++; 
        }
        return yearOptions;
    }
    $scope.birthYearValues = birthYearValues();

    /*Set the data object up */
    $scope.err = { };
    $scope.data = { country:'GB' };
    $scope.data.id = id;
    $scope.data.countrySelect = $scope.countryValues[0];
    $scope.data.dob = '';
    $scope.data.companyName = '';
    $scope.data.optinPhone = false;
    $scope.data.optinSms = false;
    $scope.phoneErrMsg = null;
    $scope.locationIsWork = false;


    
    $scope.data.requestCode = $window.requestCode;

    $scope.submitPackRequest = function() 
    {    
        $scope.showErrors = true;

        /* validate the captcha */
        $scope.err.badCaptcha = false;            
        /*$scope.data.captchaResponse = grecaptcha.getResponse();
        if ( $scope.data.captchaResponse.length == 0 ) {

             $scope.log('Captcha is empty');
             $scope.err.badCaptcha = true;            

        }*/

        $scope.validateName();
        $scope.validateAddress();
        $scope.validatePhone(true, true);
        $scope.validateOtherTitle();
        $scope.validateDoB();

        /* Check for errors */
        if ($scope.haveErrors()) {

            $timeout(scrollFirstError);
            $scope.alert = 'Please review the form and correct the highlighted errors';
            $scope.waiting = false;
            return;

        }

        //$scope.data.requestCode = $window.requestCode;

        $scope.alert = null;
        $scope.data.submitted = true;
        $scope.waiting = true;
        var data = $scope.cleanData();


        actionService.invokeAction(CkePackRequestController.processSubmit, data)
        .then(function(data){
            $scope.confirmation = data;
            $scope.completed = true;
            window.location = baseUrl + '/request-a-pack-thank-you';
         })
        .catch(function(e){
            console.error(e);
            $scope.alert = 'Submit could not be processed, please check details and retry';
            $scope.waiting = false;
            $scope.data.submitted = false;
        });

    }


 
    $scope.quickSave = function()
    {    
      //console.log('referrerUrl: ' + referrerUrl);
      //$scope.log(data.referrerUrl);

        if ($scope.form.email.$invalid || $scope.err.emailMismatch) {
            return;
        }

        var data = $scope.cleanData();
        $scope.log(data);

        actionService.invokeAction(CkePackRequestController.processPartialSubmit, data)
        .then(function(data){
            $scope.data.id = data.id;
         })
        .catch(function(e){
            console.error(e);
            $scope.alert = 'Error Saving Form';
        });

    }

    $scope.onProximitySelection = function() 
    {

      var selections = '';

      $scope.data.prox.a ? selections += $scope.proximityValues['a'] +'; ':null;
      $scope.data.prox.b ? selections += $scope.proximityValues['b'] +'; ':null;
      $scope.data.prox.c ? selections += $scope.proximityValues['c'] +'; ':null;
      $scope.data.prox.d ? selections += $scope.proximityValues['d'] +'; ':null;
      $scope.data.prox.e ? selections += $scope.proximityValues['e'] +'; ':null;
      $scope.data.prox.f ? selections += $scope.proximityValues['f'] +'; ':null;
      $scope.data.prox.g ? selections += $scope.proximityValues['g'] +'; ':null;

      if(selections.length > 0 ) {
        selections = selections.substr(0,selections.length-2);
        $scope.log(selections);
      }

      $scope.data.proximity = selections;
    }

    $scope.onEmailChange = function()
    {

        $scope.err.emailMismatch = false;
        var email = $scope.data.email;
        if (!email||email.trim().length==0) return; 

        //$scope.err.emailMismatch = email != $scope.data.email2;
        $scope.err.emailMismatch = false;

    }

    $scope.onDobBlur = function()
    {

      if($scope.validateDoB()) {
        $scope.quickSave();
      }

    }

    $scope.validateDoB = function() 
    {
      var isValid = true;

      // Reset all errros at start of validation
      $scope.err.badBirthDay = false;
      $scope.err.badBirthMonth = false;
      $scope.err.badBirthYear = false;
      $scope.dobAlert = null;
      $scope.data.dobText = null;
      $scope.err.badDob = false;
      
      //console.log("Selected birthdate is: " + $scope.selectedBirthDay + "/" + $scope.selectedBirthMonth + "/" + $scope.selectedBirthYear);

      // Check that all fields are entered
      if($scope.selectedBirthDay == undefined || $scope.selectedBirthDay == null || $scope.selectedBirthDay == "null") {
        $scope.err.badBirthDay = true;
        $scope.err.badDob = true;
        $scope.dobAlert = "Please enter your complete date of birth"
        $scope.data.dobText = "Please enter your complete date of birth";
        isValid = false;
      }
      if($scope.selectedBirthMonth == undefined || $scope.selectedBirthMonth == null || $scope.selectedBirthMonth == "null") {
        $scope.err.badBirthMonth = true;
        $scope.err.badDob = true;
        $scope.dobAlert = "Please enter your complete date of birth"
        $scope.data.dobText = "Please enter your complete date of birth";
        isValid = false;
      }
      if($scope.selectedBirthYear == undefined || $scope.selectedBirthYear == null  || $scope.selectedBirthDay == "null") {
        $scope.err.badBirthYear = true;
        $scope.err.badDob = true;
        $scope.dobAlert = "Please enter your complete date of birth"
        $scope.data.dobText = "Please enter your complete date of birth";
        isValid = false;
      }

      // Check that the day selection is correct
      var validMonthDays = {};
      validMonthDays["1"] = 31;
      validMonthDays["2"] = 29;
      validMonthDays["3"] = 31;
      validMonthDays["4"] = 30;
      validMonthDays["5"] = 31;
      validMonthDays["6"] = 30;
      validMonthDays["7"] = 31;
      validMonthDays["8"] = 31;
      validMonthDays["9"] = 30;
      validMonthDays["10"] = 31;
      validMonthDays["11"] = 30;
      validMonthDays["12"] = 31;

      var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

      var maxDaysForSelectedMonth = validMonthDays[$scope.selectedBirthMonth]; // Offset applied for the initial "Month" picklist option
      if(!angular.isUndefined(maxDaysForSelectedMonth) && ($scope.selectedBirthDay > maxDaysForSelectedMonth)) {
        $scope.err.badBirthDay = true;
        $scope.err.badDob = true;
        $scope.dobAlert = "There are not " + $scope.selectedBirthDay + " days in " + monthNames[$scope.selectedBirthMonth];
        $scope.data.dobText = "There are not " + $scope.selectedBirthDay + " days in " + monthNames[$scope.selectedBirthMonth-1];
        isValid = false;
      }

      // Check that the entered age is 16 on the day of submission
      var minDate16 = new Date().getTime() - (1000*60*60*24*365*16);
      var userDate = new Date($scope.selectedBirthYear, $scope.selectedBirthMonth-1, $scope.selectedBirthDay, 12, 0, 0, 0).getTime(); 
      
      if(userDate > minDate16) {
        $scope.err.badBirthDay = true;
        $scope.err.badDob = true;
        $scope.dobAlert = "Sorry, you must be 16 to register for Cupcake Day";
        $scope.data.dobText = "Sorry, you must be 16 to register for Cupcake Day";
        isValid = false;
      }

      if(isValid) {
        $scope.data.dob = userDate;
      }

      return isValid;

    }

    $scope.validateAddress = function()
    {
      pattern1 = new RegExp($scope.textPattern);
      pattern2 = new RegExp($scope.postcodePattern);
      //console.log('$scope.data.addressLine1 is: ' + $scope.data.addressLine1);
      //console.log('pattern1.test($scope.data.addressLine1: ' + pattern1.test($scope.data.addressLine1));

      if(typeof $scope.data.addressLine1 === "undefined") {
        $scope.err.addrInvalid = true;
      } else {
        $scope.err.addrInvalid = false; 
      }
      if(typeof $scope.data.city === "undefined") {
        $scope.err.cityInvalid = true;      
      } else {
        $scope.err.cityInvalid = false; 
      }
      if(typeof $scope.data.postcode === "undefined") {
        $scope.err.postcodeInvalid = true;
      } else {
        $scope.err.postcodeInvalid = false; 
      }
    }

    $scope.validatePhone = function(bNoSave, isFormSubmission)
    {
        if ( !bNoSave ) { $scope.quickSave(); }
        $scope.err.badPhone = false;
        $scope.phoneErrMsg = '';

        var phone = $scope.data.phone;

        /*if(isFormSubmission) { // Run regardless if page is being submitted
          phone = false;
        }*/

        if ( $scope.form.telephone.$invalid ) { 
             $scope.err.badPhone = true;
             $scope.phoneErrMsg = "Please enter a valid UK phone number";
             return;
        } else if (!phone && ($scope.data.optinSms || $scope.data.optinPhone)) { 
              $scope.err.badPhone = true;
              $scope.phoneErrMsg = "As you have opted into Text Message or Phone in the contact preferences section we require your phone number";
              return;   
        }

        if(!$scope.err.badPhone) {
          $scope.phoneErrMsg  = '';
        }

        return; 
        
    }

    $scope.isGreaterUk = function()
    {
      // Forms can only be submitted from UK addresses
      return true;
    }
    
    /*$scope.handleDob = function()
    {

        //$scope.log('BirthDate: ' + $scope.data.dobText + ' ' + $scope.isDatePickerOn);
        $scope.err.badDob = false;
        $scope.dobAlert = "Please tell us your date of birth, so we can be sure you are old enough.";
        $scope.log($scope.data.dobText);
        if ( !$scope.data.dobText ) { return; }

        var dobText = $scope.data.dobText;
        $scope.log(dobText);
        if (!dobText) { 
            $scope.err.badDob = true;             
            return;
        };
        

        var dob;
        if ( $scope.isDatePickerOn ) {

            //Force the european date format 
            var v = dobText.split('/');
            //$scope.log(v);
        
            dob = new Date(v[2],v[1]-1,v[0]);
            //$scope.log(dob);

        } else { 

            // this will be yy-mm-dd 
            dob = new Date(dobText);
        }

        var today = new Date();
        var age = today.getFullYear() - dob.getFullYear();

        if ( dob.getFullYear() < 1900 ) {

            $scope.err.badDob = true; 
            $scope.dobAlert = "Please enter a valid date after 1900";
            return;
        }

        var m = today.getMonth() - dob.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) {
             age--;        
        }

        if ( isNaN(age) ) { 
          $scope.err.badDob = true;
        }    
        
        if ( age < 16 )  { 

            $scope.err.badDob = true; 
            $scope.dobAlert = "You must be at least 16 years old";
        
        }

        $scope.data.dob = dob;
        return;
        
    }*/
    
    $scope.onTitleSelectChange = function()
    {
        if ($scope.data.titleSelect.id == 'Other') {
            $scope.data.title = '';
            $scope.showOtherTitle = true;
            $scope.err.badOtherTitle = false;
            setTimeout(function(){document.querySelector('[name=title]').focus();}, 50);
        }
        else {
          $scope.data.title = $scope.data.titleSelect.id;
          $scope.showOtherTitle = false;
          $scope.err.badOtherTitle = false;
        }
        $scope.log($scope.data.titleSelect.id);
    }

    $scope.validateOtherTitle = function() {

        if($scope.showOtherTitle == true && $scope.data.title == '') {
            $scope.err.badOtherTitle = true;
        } else {
            $scope.err.badOtherTitle = false;
        }
    }

    $scope.validateName = function() {

        $scope.err.badName = false;
        if($scope.data.lastName == '' || (typeof $scope.data.lastName === "undefined")) {
            $scope.err.badName = true;
        } else if($scope.data.firstName == '' || (typeof $scope.data.firstName === "undefined")) {
            $scope.err.badName = true;
        }
    }

    $scope.onLocationSelectChange = function()
    {
        try {
          $scope.data.location = $scope.data.locationSelect.id;

          // Show the extra company name field if user selected "Work"
          if($scope.data.locationSelect.id === "Work") {
            $scope.isLocationWork = true;
          } else {
            $scope.isLocationWork = false;
          }

        } catch(err) {$scope.data.location='';}
    }
     
    $scope.onCountrySelectChange = function()
    {
       try {
           $scope.data.country = $scope.data.countrySelect.id;
       } catch (err) {$scope.data.country='';}
    }

    $scope.onCitySelectChange = function()
    {
       try {
           $scope.data.city = $scope.data.city.id;
       } catch (err) {$scope.data.city='';}
    }

    $scope.onAddressBlur = function()
    {
      $scope.validateAddress();
      $scope.quickSave();
      $scope.data.postcode = $scope.data.postcode.replace(/\s/g,'').replace(/^(.{2,4})[ ]*([0-9][ABD-HJLN-UW-Z]{2})$/,'$1 $2');

    }

    $scope.onGeneralTextBlur = function()
    {
      $scope.validateName();
      $scope.quickSave();

    }

    $scope.onPostcodeBlur = function()
    {

      $scope.quickSave();
      if ($scope.form.postcode.$invalid) { return; }
      $scope.data.postcode = $scope.data.postcode.replace(/\s/g,'').replace(/^(.{2,4})[ ]*([0-9][ABD-HJLN-UW-Z]{2})$/,'$1 $2');

    }

    $scope.haveErrors = function()
    {   
        var keys =  Object.keys($scope.err);

        for (var n=0; n<keys.length; n++) {
            //console.log('Checking errors on ' + keys[n] + ' with result: ' + $scope.err[keys[n]]);
           if ($scope.err[keys[n]]) {
            //$scope.log('Posting error boolean as Error DETECTED on keys[n]: ' + $scope.err[keys[n]]);
            return true;
           }
        }
        return false;
    }
    
    $scope.$watch('haveErrors()', function(newval, oldval){
        $scope.log('Ran watch with newval: ' + newval + ' oldval: ' + oldval);
        if (oldval&&!newval) $scope.alert = null;
    });

    pcacontrol.listen("populate", function(address, variations) {
       $scope.$apply(function(){
           
           $scope.log(address);

           // Select the english version of the address if there are variations
           if (address.Language!="ENG"&&variations&&variations.length) {
               
               variations.forEach(function(v){
                 
                 if (v.Language=="ENG") address = v;
                 
               });
           }

       if (address.Company){
         $scope.data.addressLine1 = address.Company;
             $scope.data.addressLine2 = address.Line1;
             $scope.data.addressLine3 = address.Line2;
       if (address.Line3){
         $scope.data.addressLine3 = $scope.data.addressLine3 + ', ' + address.Line3;
       }
       }    
       else { 
             $scope.data.addressLine1 = address.Line1;
             $scope.data.addressLine2 = address.Line2;
             $scope.data.addressLine3 = address.Line3;
       }            
           $scope.data.city = address.City;
           $scope.data.county = address.Province;
           $scope.data.postcode = address.PostalCode;
           for ( var i = 0 ; i < $scope.countryValues.length; i++ ) {
                if ( $scope.countryValues[i].id == address.country ) {
                     $scope.data.countrySelect = $scope.countryValues[i];   
                     $scope.data.country = $scope.countryValues[i].id;  
                }
           }
       
       });
    });


});