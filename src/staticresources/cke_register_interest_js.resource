
app.config(function($locationProvider) {$locationProvider.html5Mode({
      enabled: true,
      requireBase: false
    });
});
    
app.controller('RootController', function($scope, $timeout, actionService, Modernizr) 
{

    /* Logging  */

    $scope.logging = true;
    if ( $scope.logging ) { console.log('Logging is on');}
    $scope.log = function (msg) {               
        if ( $scope.logging ) { console.log(msg); }
    }

    $scope.ie9 = window.CKIE9;
    $scope.textPattern = '^[a-zA-Z \'?-]{2,40}$';
    $scope.textPattern2 = '^[a-zA-Z \'?-]{1,40}$';
    $scope.emailPattern= /^[-a-zA-Z0-9~\"!$%^&*_=+}{\'?]+(\.[-a-zA-Z0-9~"!$%^&*_=+}{\'?]+)*@([a-zA-Z0-9_][-a-zA-Z0-9_]*(\.[-a-zA-Z0-9_]+)*\.([a-zA-Z]*)|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?[^.]$/;

    $scope.cleanData = function() 
    {

        var data = angular.copy($scope.data);
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


    /*Set the data object up */
    $scope.err = { };

    $scope.submitNotificationRequest = function() 
    {    

        $scope.log('Submitting Form');
        $scope.showErrors = true;

         /* validate the captcha */
        $scope.err.badCaptcha = false;             
        $scope.data.captchaResponse = grecaptcha.getResponse();
        if ( $scope.data.captchaResponse.length == 0 ) {

             $scope.log('Captcha is empty');
             $scope.err.badCaptcha = true;            

        }

        /* Check for errors */
        if ($scope.haveErrors()) {

            $timeout(scrollFirstError);
            $scope.log('Errors have been found');
            $scope.alert = 'Please review the form and correct the highlighted errors';
            $scope.waiting = false;
            return;

        }

        $scope.log('No errors found. Continuing to the post');

        $scope.alert = null;
        $scope.waiting = true;
        var data = $scope.cleanData();

        actionService.invokeAction(CkeHomeHoldingController.processSubmit, data)
        .then(function(data){
            console.log(data)
            $scope.confirmation = data;
            $scope.completed = true;

         })
        .catch(function(e){
            console.error(e);
            $scope.alert = 'Submit could not be processed, please check details and retry';
            $scope.waiting = false;
            $scope.completed = false;
        });

    }
    
    $scope.haveErrors = function()
    {
        if ($scope.form.$invalid) return true;
        var keys =  Object.keys($scope.err);
        $scope.log('Errors: ' + keys);

        for (var n=0; n<keys.length; n++) {

           $scope.log('Error: ' + keys[n]);
           if ($scope.err[keys[n]]) return true;
        }
        return false;
    }
    
    $scope.$watch('haveErrors()', function(newval, oldval){
        if (oldval&&!newval) $scope.alert = null;
    });

});