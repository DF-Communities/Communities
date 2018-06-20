app.controller('RootController', function($scope, $timeout, codeService, cardService, actionService, deviceService, PAYTYPE) 
{
  'use strict';
  
  $scope.ie9 = window.CKIE9;
  $scope.waiting = false;
  $scope.countryCodes = codeService.getCountryCodes();
  $scope.emailPattern = /^[-a-zA-Z0-9~\"!$%^&*_=+}{\'?]+(\.[-a-zA-Z0-9~"!$%^&*_=+}{\'?]+)*@([a-zA-Z0-9_][-a-zA-Z0-9_]*(\.[-a-zA-Z0-9_]+)*\.([a-zA-Z]*)|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?[^.]$/;
  $scope.phonePatternUk = '^0(\\d ?){10}$';
  $scope.phonePattern = '^\\+?[0123456789 ]{6,20}$';
  $scope.postcodePattern = '^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {0,5}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$';
  $scope.textPattern = '^[a-zA-Z \'?-]{2,40}$';
  $scope.textPattern2 = '^[a-zA-Z \'?-]{1,40}$';
  $scope.numbersOnlyPattern = '^[0-9]*$';

  /* Logging  */

  $scope.logging = true;
  if ( $scope.logging ) { console.log('Logging is on for payments');}
  $scope.log = function (msg) {               
      if ( $scope.logging ) { console.log(msg); }
  }

  $scope.err = { };
  $scope.data = initFormData();
  $scope.showOtherTitle = false;
  
  function scrollFirstError()
{
      var $ = angular.element;
      var e = $('.ng-invalid, .invalid').not('form');
      if (e.length==0) return;
      
      e = e.first();
      $('html, body').animate({
          scrollTop: e.offset().top - 205
      }, 1000);

      if(e.is('input[type=text],input[type=email]')) e.focus();
}
  
  function getProximity()
{
      var prx = '';
      angular.element('#proximityOptions input:checked').each(function(){
          if (prx.length) prx += ';';
          prx += this.value;
      });
      return prx;
}
  
  function initFormData()
  {
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

      /*
          {id: 'England', name : 'England'},
          {id: 'Northern Ireland', name : 'Northern Ireland'},
          {id: 'Scotland', name : 'Scotland'},
          {id: 'Wales', name : 'Wales'}
      */
      $scope.countryValues = [ 

          {id: 'United Kingdom', name : 'United Kingdom'}

      ];

      $scope.locationValues = [

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


      var token = getPassedToken();
      return loadFormData(token) || { type:PAYTYPE, countryCode:'GB', prox:{} };
  }

  
  
  function loadFormData(token)
  {
  	if (!token||!haveLocalStorage()) return null;    
      var json = localStorage.getItem('cke.'+PAYTYPE+'.data'); 
      if (!json) return null;
      var o = JSON.parse(json);
      return o.token==token ? o.data : null;
  }
  
  function storeFormData(token, data)
  {
  	if (!token||!haveLocalStorage()) return;    
      data = angular.copy(data);
      delete data.cardNumber;
      delete data.cvv;
      var o = {token:token, data:data}
      localStorage.setItem('cke.'+PAYTYPE+'.data', JSON.stringify(o)); 
  }
  
  function getPassedToken()
  {
      var a = /[?&]token=([^&#]*)/g.exec(location.search);
      return a ? decodeURIComponent(a[1].replace(/\+/g, " ")) : null;
  }
  
  function haveLocalStorage() 
  {
      try {
          localStorage.setItem('xtest', 'xtest');
          localStorage.removeItem('xtest');
          return true;
      } catch (e) {
          return false;
      }
}
  
 	function runCardPayment(data)
  {    
      $scope.waiting = true;
      actionService.invokeAction(CkePayinController.createPayment, data)
      .then(function(data){
          window.location.replace(window.CKBASE+(PAYTYPE=='Donation'?'/donate-thank-you':'/pay-in-thank-you'));  
       })
      .catch(function(e){
          console.error(e);
          $scope.alert = e.result.message; //'Payment could not be processed, please check card details and billing address and retry';
          $scope.waiting = false;
      });
  }
  
function runPaypalPayment(data)
  {    
      $scope.waiting = true;
      actionService.invokeAction(CkePayinController.setExpressCheckout, data)
      .then(function(data){
        storeFormData(data.TOKEN, $scope.data);
          window.location.href = data.XCOURL;
       })
      .catch(function(e){
          console.error(e);
          $scope.alert = 'PayPal payment could not be processed';
          $scope.waiting = false;
      });
 }

  $scope.runPayment = function()
  {    
      $scope.validatePhone();
      $scope.onExpiryChange();

  		$scope.showErrors = true;
      if ($scope.haveErrors()) {
    	  //$timeout(scrollFirstError);
    	  $timeout(function(){$scope.alert = 'Please check the form for problems highlighted in red';}, 1200);
        return;
      }
      $scope.err.cardError = null;
      $scope.alert = null;

      var data = angular.copy($scope.data);
  		delete data.prox;
  		delete data.email2;
  		delete data.titleSelect;
  		delete data.amountOption;
  		delete data.otherAmount;

      data.proximity = getProximity();

      return $scope.isCardPayment() ? runCardPayment(data) : runPaypalPayment(data);
  }
      
  $scope.onButtonKeyup = function(event)
  {
      if (event.keyCode==32||event.keyCode==13) $scope.runPayment();
  }
  
  $scope.onCardNumberChange = function()
  {
      $scope.err.cardError = null;

      var cn = $scope.data.cardNumber;
      if (!cn||cn.trim().length==0) return; 

      var ct = $scope.data.cardType;
      if (!ct||ct.trim().length==0) return; 

      if (cardService.checkCreditCard(cn, ct)) return;
      
      $scope.err.cardError = "Please check the card number and type";
  }

  $scope.onEmailChange = function()
  {
      $scope.err.emailMismatch = false;
      var email = $scope.data.email;
      if (!email||email.trim().length==0) return; 
      //$scope.err.emailMismatch = email != $scope.data.email2;
      $scope.err.emailMismatch = false;
  }

  $scope.onExpiryChange = function()
  {
      /*
        $scope.formatExpiryMonth();
        $scope.formatExpiryYear();
      */
	  console.log("In expiry change");
	  console.log($scope.data.paymentMethod);
	  console.log(!$scope.isCardPayment());
	  console.log($scope.data.paymentMethod == undefined);
	  if($scope.data.paymentMethod == undefined) {
		console.log("Setting dabexpiry to true on undefined payment method");
		$scope.err.badExpiry = true;
	  }
	  
      if ( !$scope.isCardPayment() ) { return; }
	  $scope.err.badExpiry = true;
	  
	  console.log("EXPIRY MONTH" + $scope.data.expiryMonth);
      if($scope.data.expiryMonth == "MM") {
        $scope.data.expiryMonth = false;
      }
      if($scope.data.expiryYear == "YYYY") {
        $scope.data.expiryYear = false;
      }
	  
      var em = $scope.data.expiryMonth;
      if (!em) return; 
      
      var ey = $scope.data.expiryYear;
      if (!ey) return; 
      
	    $scope.err.badExpiry = false;

      em = parseInt(em, 10);
      ey = parseInt(ey, 10);

      if ( isNaN(em) || isNaN(ey) ) { 
        $scope.err.badExpiry = true;          
        return;
      }

      if (ey<100) ey += 2000;

      var now = new Date();
      var thisYear = now.getFullYear();
      var thisMonth = now.getMonth();
      
  		if (em<1||em>12) $scope.err.badExpiry = true;
  		if (ey<thisYear) $scope.err.badExpiry = true;
  		if (ey==thisYear&&em-1<thisMonth) $scope.err.badExpiry = true;
  
  }
  
  $scope.formatExpiryYear = function()
  {
      var ey = $scope.data.expiryYear;
      if (!ey) return; 
      if (angular.element('#cardExpirationYear').is(':focus')) return;
      ey = parseInt(ey, 10);
      if(ey<2000||ey>2099) return;
      $scope.data.expiryYear = ey-2000;
  }
  
  $scope.formatExpiryMonth = function()
  {
      var em = $scope.data.expiryMonth;
      if (!em) return; 
      if (angular.element('#cardExpirationMonth').is(':focus')) return;
      em = parseInt(em, 10);
      if(em>0&&em<10) $scope.data.expiryMonth = '0'+em;
  }
  
  $scope.onTitleSelectChange = function()
  {
      if ($scope.data.titleSelect.id =='Other') {
        $scope.data.title = '';
        setTimeout(function(){document.querySelector('[name=title]').focus();}, 50);
      }
      else {
        $scope.data.title = $scope.data.titleSelect.id;
      }
  }
 
  $scope.onPaymentMethodChange = function()
  {
      var method = $scope.data.paymentMethod;
      if (method=='paypal') {
        $scope.data.cardType = null;
        $scope.data.cardNumber = null;
        $scope.data.cardholderName = null;
        $scope.data.expiryMonth = 'MM';
        $scope.data.expiryYear = 'YYYY';
        $scope.data.cvv = null;
        $scope.err.badExpiry = false;
        $scope.err.cardError = null;
      }
      else {
        $scope.data.cardType = method;
      }
      $scope.onCardNumberChange();
  }
  
  $scope.onAmountOptionChange = function()
  {
      var amt = $scope.data.amountOption;
	if (amt=='0') { 
          $scope.data.amount = '';
      }
      else {
          $scope.data.amount = amt;
          $scope.data.otherAmount = '';
      }
  }
  
$scope.onOtherAmountFocus = function()
  {
      $scope.data.amountOption = '0';
	$scope.data.amount = $scope.data.otherAmount
  }
  
  $scope.onOtherAmountChange = function()
  {
    if ($scope.otherAmountSelected()) $scope.data.amount = $scope.data.otherAmount;
  }
  
  $scope.otherAmountSelected = function()
  {
      return $scope.data.amountOption == '0';
  }
  
  $scope.isGreaterUk = function()
  {
  	var cc = $scope.data.countryCode;
      return cc=='GB'||cc=='IM'||cc=='GG'||cc=='JE';
  }

  $scope.onTitleSelectChange = function()
    {
        console.log("In onTitleSelectChange");
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
        console.log("In validate other title");
        /*console.log("$scope.showOtherTitle: " + $scope.showOtherTitle);
        console.log("$scope.data.title: " + $scope.data.title);*/
        if($scope.showOtherTitle == true && $scope.data.title == '') {
            $scope.err.badOtherTitle = true;
        } else {
            $scope.err.badOtherTitle = false;
        }
    }
  
  $scope.onCardNumberBlur = function()
  {
      var value = $scope.data.cardNumber;
	if (!value) return;
  	value = value.replace(/\s/g,'');
  	$scope.data.cardNumber = value.replace(/\b(\d{4})(\d{4})(\d{4})(\d{4})\b/, '$1 $2 $3 $4');
  }

  $scope.onPostcodeBlur = function()
  {
	if ($scope.form.postcode.$invalid) return;
      $scope.data.postcode = $scope.data.postcode.replace(/^(.{2,4})[ ]*([0-9][ABD-HJLN-UW-Z]{2})$/,'$1 $2');;
  }
  
  $scope.isCardPayment = function()
  {
      return $scope.data.paymentMethod && $scope.data.paymentMethod != 'paypal';
  }

  $scope.validatePhone = function()
  {
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
        console.log("$scope.err.badPhone: " + $scope.err.badPhone);

      return; 
      
  }
  
  $scope.haveErrors = function()
  {
      if ($scope.form.$invalid) return true;
      var keys =  Object.keys($scope.err);
      for (var n=0; n<keys.length; n++) {
         if ($scope.err[keys[n]]) return true;
      }
      return false;
  }
  
  $scope.$watch('haveErrors()', function(newval, oldval){
      if (oldval&&!newval) $scope.alert = null;
  });

 if (typeof Sarissa!='undefined'&&Sarissa.originalXMLHttpRequest) pca.XMLHttpRequest = Sarissa.originalXMLHttpRequest;
    
 var pcafields = [{ element: "addressfinder", field: "" }];
 var pcaoptions = { key:"JC46-CM31-FG25-ZB91", countries: { codesList: "GBR" }, culture:"en_GB" }
 var pcacontrol = new pca.Address(pcafields, pcaoptions);
 pcacontrol.listen("load", function(){pcacontrol.setCountry("GBR");});

 pcacontrol.listen("populate", function(address, variations) {
     $scope.$apply(function(){
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
	   else{
           $scope.data.addressLine1 = address.Line1;
           $scope.data.addressLine2 = address.Line2;
           $scope.data.addressLine3 = address.Line3;
	   }            
         $scope.data.city = address.City;
         $scope.data.county = address.Province;
         $scope.data.postcode = address.PostalCode;
         $scope.data.countryCode = address.CountryIso2;
   });
});

 /* Remove device-specific CSS changes
 var $ = angular.element;    
 $('input[type=text],input[type=email]')
   .on('focus', function() {
       if (deviceService.getDevicePlatform()!=="Android") return;
       if (!window.matchMedia||window.matchMedia('(min-height:680px)').matches) return;
       $('.navigation--main').css('position', 'absolute')
   })
   .on('blur', function() {
       $('.navigation--main').css('position', 'fixed')
   });*/

});

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
