/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Javascript code for Dementia Friends web site 
 *  Author  : Gary Grant
 *  Date    : 15-12-2015
 
 * Update   : 22-01-2016 New Registration Model, security update
 * Update   : 20-06-2016 Guernsey removed from Community Admin Registration
 * Update   : 17-08-2016 added football registration
 * Update	: March 2018 Support for Google Captcha 2	
 
    
*******************************************************************************************/


function _webc_globals(){};

/*==================== Global iPhone Setup =======================*/

_webc_globals.prototype.iphoneSetup = function() {

    /* Switch off autocorrect etc on all forms for iPhone */ 
    $('input').not('.autocorrect').attr('autocorrect', 'off');
    $('input').not('.autocomplete').attr('autocomplete', 'off');
    $(':input[id^=email]').attr('autocapitalize', 'off');
    $(':input[id^=password]').attr('autocapitalize', 'off');
    $(':input[id^=email2]').attr('autocapitalize', 'off');
    $(':input[id^=password2]').attr('autocapitalize', 'off');
    $(':input[id^=emailAddress]').attr('autocapitalize', 'off');
    $(':input[id^=emailAddress2]').attr('autocapitalize', 'off');

};


/*==================== WEBC Globals ================================*/

_webc_globals.prototype.isValidPassword = function(sFieldId, sUserNameFieldId) {         

    if ( _webc.isNull(sFieldId) ) { return false; }     
    if ( _webc.isNull(sUserNameFieldId) ) { return false; }     

    var sValue = _webc.getFieldValue(sFieldId);
    var sUserNameValue = _webc.getFieldValue(sUserNameFieldId);

    if ( sValue < 8 ) return false;    
    if ( sValue.toLowerCase().indexOf('password') > -1 ) return false;
    
    var sUserName = sUserNameValue.split('@')[0];
    if ( sValue.toLowerCase().indexOf(sUserName) > -1 ) return false;

    //return /^([a-zA-Z+]+[0-9+]+|[0-9+]+[a-zA-Z+]+)$/.test(sValue);
    return /^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$/.test(sValue); //Requires only alphanumeric characters and at least one of each.          

};    

_webc_globals.prototype.isValidEmail = function(sFieldId) {             


    if ( _webc.isNull(sFieldId) ) { return false; }     

    var sValue = _webc.getFieldValue(sFieldId);
    
    return /^\S+@\S+\.\S+$/.test(sValue);       
    /* return /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.test(sValue); */                   
    
};

_webc_globals.prototype.isValidPhone = function(sFieldId) {
 
 if ( _webc.isNull(sFieldId) ){ return false; }
 
 var sValue = _webc.getFieldValue( sFieldId );      
 return /^0(\d ?){10}$/.test(sValue);            
               
};

_webc_globals.prototype.getFieldValue = function(sFieldId) {

    return $.trim($('[id$=' + sFieldId +']').val());
};


_webc_globals.prototype.getCheckboxListValues = function(sField) {

        // get all the values and concatinate into a string array
       var values = [];
      
        $('#' + sField + ' input:checked').each(function() {
            values.push(this.name);            
        });
        
        return values.join(";");
         
 };
   
   
 _webc_globals.prototype.implode = function (vValues) {

        var s = '';
        vValues.each(function() {
            if ( s != '' ) { s = s + ';'; }
            s = s + this;
        });

};


_webc_globals.prototype.isChecked = function(sFieldId) {

    if ( !($('[id$=' + sFieldId +']').is(':checkbox')) ) return false;
    return $('[id$=' + sFieldId +']').prop('checked');
};

_webc_globals.prototype.clearErrors = function(fieldIds) {

   if ( fieldIds==null || fieldIds == undefined || fieldIds== '' ) {

     $('[id$=Error]').val('');
     $('[id$=Error]').hide();
     $('.has-error').removeClass('has-error');        

   } else {

     var v = fieldIds.toString().split(',');
     $.each(v, function(i, s) { _webc.clearError(s.trim()); });        

   }

};

 _webc_globals.prototype.clearError = function(sFieldId) {

    var e = $('[id$=' + sFieldId +'Error]');
    e.text('');
    e.hide();
    e.parent('div').removeClass('has-error');

}; 

_webc_globals.prototype.setErrorMessage = function(sFieldId, message) {              
       
    if (message != 'null') {

      var e = $('[id$=' + sFieldId +'Error]');
      e.text(message);
      e.show();
      e.parent('div').addClass('has-error');

    }
};

_webc_globals.prototype.isNull = function(sFieldId) {
            
    var v = _webc.getFieldValue(sFieldId);
    if ( v==null || v == undefined || v== '' ) return true;         
    return v.trim().length==0;        

};

_webc_globals.prototype.enableForm = function(sFormId) {

    //$('#' + sFormId).find("input(:disabled), select(:disabled), textarea(:disabled)").prop("disabled",false);
    $('#save-' + sFormId).show();      
    this.submitCount = 0;

};

_webc_globals.prototype.disableForm = function(sFormId) {

    //$('#' + sFormId).find("input:not(:disabled), select:not(:disabled), textarea:not(:disabled)").prop("disabled",true);
    $('#save-' + sFormId).hide();                   
    this.submitCount = 1;

};

/* Date in Format DD/MM/YYYY*/
_webc_globals.prototype.isValidDateString = function (dateString) {

 var parts = dateString.split('\/');
 if ( parts.length != 3 ) { return false; }
 if ( parts[2].length != 4 ) { return false; }
 if ( parseInt(parts[1]) > 12 ) { return false; }
 if ( parseInt(parts[0]) > 31 ) { return false; }
 
 return true;
 
 }

  /* Date in Format DD/MM/YYYY*/
    _webc_globals.prototype.isValidDateStringWithOutNull = function (dateString) {
     if(dateString!=null || dateString!='' ){ return true;}
     var parts = dateString.split('\/');
     
     if ( parts.length != 3 ) { return false; }
     if ( parts[2].length != 4 ) { return false; }
     if ( parseInt(parts[1]) > 12 ) { return false; }
     if ( parseInt(parts[0]) > 31 ) { return false; }
     
     return true;
     
     }


/* Date in Format DD/MM/YYYY*/
_webc_globals.prototype.getAge = function (dateString) {

 var today = new Date();
 var parts = dateString.split('\/');
     
 var birthDate = new Date(parts[2],parts[1]-1,parts[0]);  
 
 var age = today.getFullYear() - birthDate.getFullYear();
 
 var m = today.getMonth() - birthDate.getMonth();
 if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
     age--;        
 }
 
 return age;
};

_webc_globals.prototype.log = function (string) {

    if ( _webc.showLog ) { console.log(string); } //alert (string);

};

/*===== Set up the Global. This variable will have methods and properties attached to it by each page.====*/
var _webc = new _webc_globals();
_webc.showLog = false;
_webc.submitCount = 0;

/*==================== DF Specific Functions used by more than one page =========================*/

_webc.setActivePanel = function (step) { 

   $('.step-active').removeClass('step-active').addClass('step');
   $('#panel-step-' + step).removeClass('step').addClass('step-active');

}

_webc.setActivePanel = function (step) { 

       $('.step-active').removeClass('step-active').addClass('step');
       $('#panel-step-' + step).removeClass('step').addClass('step-active');

    }


_webc_globals.prototype.googleTracking = function(page,title){
       
       window.dataLayer = window.dataLayer || [];  
       window.dataLayer.push({ 
         "event" :  "ga_vpv",  
         "ga_vpv" : {  
           "page" : page,  
           "title" : title  
         }  

       });

    }

 _webc_globals.prototype.googleTrackingVideo = function(){

    window.dataLayer = window.dataLayer || [];  
                window.dataLayer.push({  
               "event" : "video_ready"  
                }); 
    }

/*==================== End WEBC Globals ================================*/

/*============ Registration Specific Base methods for base data ========*/
/*============WEBC_LongFormBase_js=======================================*/


_webc.setupLongFormEvents = function() {

    /* Hook the titleOther field up to the value of title */ 
    $('[id$=title-select]').change(
       
        function() {
            
            if ( $(this).val()=='Other' ){ 
                $('#title-other-container').show();
            } else {
                $('#title-other-container').hide();
            }
    
    });


     $('[id$=ethnicGroup]').change(
        function () {

            
            
            if ( $('[id$=ethnicGroup]').val().indexOf("please specify")>-1)  { 

                $('#ethnicGroup-other-container').show();
                document.getElementById('ethnicOtherLabel').innerHTML = $('[id$=ethnicGroup]').val();

            } else {

                $('#ethnicGroup-other-container').hide();
                $('#ethnicGroup-other-container input').val("");
            }

        

     });

     $('[id$=sector]').change(
          function () {

            
            
            if ( $('[id$=sector]').val().indexOf("please specify")>-1)  { 

                $('#sector-other-container').show();
                document.getElementById('sectorOtherLabel').innerHTML = 'please specify';

            } else {

                $('#sector-other-container').hide();
                $('#sector-other-container input').val("");
            }

        

        });

            
     $('#whychampion').keyup(    
        function ()
       {
            var field= $('[id$=whychampion]').val();
            var maxlimit = 255;
            if ( field.length > 255 ) {
            field = field.substring( 0,5 );
            return false;
         } else {
          
          $('[id$=counter]').val(maxlimit - field.length);
          
         
        }
      });
        
    /* Hook the submit up to the action button */ 
    $('#save-long-form').off('click').on('click', function(event) {
           console.log('yet another save form');  
        // This prevents a mysterious double click event
        if ( _webc.submitCount > 0 ) { return false; }
        _webc.clearErrors();
        
        if (!_webc.validateLongForm()) {
            _webc.setErrorMessage('longServer', "Please correct the errors displayed above");            
            return false;
        }
        console.log('Going for subimt form');
        _webc.submitLongForm();        
        return false;
        
    });

    $('#password').focusout(function() { 

    _webc.validatePasswordOK();

    });

    $('#emailAddress2').focusout(function() {

      _webc.validateEmailOK(true);        

    });

    $('#password2').focusout(function() { 

      _webc.validatePasswordOK(true);

    });

}; 

_webc.putRegistrationBaseData = function(formData, bExcludeCaptcha) {

    formData.data['userid'] = _webc.getFieldValue('userid');
            
    var title = ( 
        _webc.getFieldValue('title-select')=='Other' ? _webc.getFieldValue('titleOther') : _webc.getFieldValue('title-select') );            

    formData.data['title'] = title;            
    formData.data['firstName'] = _webc.getFieldValue('firstName');
    formData.data['lastName'] = _webc.getFieldValue('lastName');
    formData.data['emailAddress'] = _webc.getFieldValue('emailAddress');
    formData.data['emailAddress2'] = _webc.getFieldValue('emailAddress2');
    formData.data['postCode'] = _webc.getFieldValue('df_pca_postcode');
    formData.data['street'] = _webc.getFieldValue('df_pca_street');
    formData.data['city'] = _webc.getFieldValue('df_pca_city');
    formData.data['county'] = _webc.getFieldValue('df_pca_county');
    formData.data['country'] = _webc.getFieldValue('df_pca_country');
    formData.data['telephone'] = _webc.getFieldValue('telephone');
    formData.data['password'] = _webc.getFieldValue('password');
    formData.data['password2'] = _webc.getFieldValue('password2');    

    if ( !bExcludeCaptcha ) { 
        
        /* March 2018 
        formData.data['recaptcha_challenge'] = _webc.getFieldValue('recaptcha_challenge_field');
        formData.data['recaptcha_response'] = _webc.getFieldValue('recaptcha_response_field');
    	*/
        formData.data['recaptcha_challenge'] = '';
        formData.data['recaptcha_response'] = grecaptcha.getResponse();
        
    }

};

_webc.handleEmailCheck = function(response, event) {

    if ( response ) {

        _webc.setErrorMessage('emailAddress', 'Email is already registered. Please sign in to continue.');
        $('#save-long-form').hide();
        return; 

    };
        
    if ( _webc.validateEmailOK() ) {                  
        $('#save-long-form').show();                    
    };

};

_webc.isExistingOrg = function(response, event) {
    	
    	 _webc.log('enter is existing org'+response);
        if ( response==true ) {

            _webc.setErrorMessage('orgName', 'Organisation is already registered. Please contact your administrator or programmepartnership@alzheimers.org.uk for more information.');
            $('#save-long-form').hide();
            return; 

        }
            
        else {
            _webc.clearErrors('orgName');                   
            $('#save-long-form').show();                    
        }

    };
 

_webc.validateEmailOK = function(bWithConfirm) {

    var rtn = true;
    
    if ( !_webc.isValidEmail('emailAddress') ) {

        _webc.setErrorMessage('emailAddress', "Email Address is a not a valid format");
        rtn = false;                

    } else {

        _webc.clearErrors('emailAddress'); 

    }

    if ( bWithConfirm ) { 
        
        if ( _webc.getFieldValue('emailAddress') !== _webc.getFieldValue("emailAddress2") ) {

            _webc.setErrorMessage('emailAddress2', "Email Addresses do not match");
            rtn = false;                    

        } else {

            _webc.clearErrors('emailAddress2');

        }

    }
    
    return rtn;

};

_webc.validatePasswordOK = function(bWithConfirm) {

    var rtn = true;    
        
    if ( !_webc.isValidPassword('password', 'emailAddress') ) {        
                
        _webc.setErrorMessage('password', "Passwords must be numbers and letters and at least 8 characters. Your password may not contain the word 'password' or your email address name");
        rtn=false;
            
    } else {

        _webc.clearErrors('password'); 

    }

    if ( bWithConfirm ) { 

         if ( _webc.getFieldValue('password') !== _webc.getFieldValue("password2") ) {

            _webc.setErrorMessage('password2', "Passwords do not match");
            rtn=false;                

         } else {

            _webc.clearErrors('password2');
        
        }
    
    }

    return rtn;

};

_webc.validateLongFormBaseData = function(bExcludeRecaptcha) {


    var isError = false;
    
    /*March 2018 - introduction of captcha v2*/
    if ( !bExcludeRecaptcha ) {
        
        var capResponse = grecaptcha.getResponse();
        if ( capResponse.length == 0 ) {
            _webc.setErrorMessage('reCAPTCHA', "Please confirm you are not a robot");
            isError=true;   
        }
    
    }   

    if (_webc.getFieldValue('title-select')=='NULL') {
        _webc.setErrorMessage('title', "Please select your title");
        isError= true;
    }

    if (_webc.getFieldValue('title-select')=='Other' && _webc.isNull('titleOther')) {
        _webc.setErrorMessage('titleOther', "Please enter your title");
        isError= true;
    }

    if (_webc.isNull('firstName')) {
        _webc.setErrorMessage('firstName', "Please enter First Name");
        isError= true;
    }
    
    if (_webc.isNull('lastName')) {
        _webc.setErrorMessage('lastName', "Please enter Last Name");
        isError= true;
    }
    

    if (_webc.isNull('df_pca_postcode')) {
        _webc.setErrorMessage('postcode', "Please enter your postcode");
        isError= true;
    }
     
    if (_webc.isNull('df_pca_street')) {
        _webc.setErrorMessage('street', "Please enter your street");
        isError= true;
    } 
    
    if (_webc.isNull('df_pca_city') && _webc.isNull('df_pca_county')) {
        _webc.setErrorMessage('city', "Please enter your city or county");
        isError= true;
    }
     
    if (_webc.isNull('df_pca_country')) {
        _webc.setErrorMessage('country', "Please enter your county");
        isError= true;
    } 
     if(!_webc.isValidPhone('telephone')){
      _webc.setErrorMessage('telephone', "Phone number must be 11 digits starting with 0");
        isError= true;
    
    }

    if (! _webc.validateEmailOK() ) {
        isError=true;
    }

    if (! _webc.validatePasswordOK() ) {
        isError= true;    
    }
                   
    return isError;            
            
};
    
    /*==================== Register Friend Error Management ======================================*/

_webc.populateLongFormBaseErrors = function(response) {

    _webc.setErrorMessage('longServer',response.standardErrorMsg);
    _webc.setErrorMessage('title',response.titleError);
    _webc.setErrorMessage('firstName',response.firstNameError);
    _webc.setErrorMessage('lastName',response.lastNameError);
    _webc.setErrorMessage('emailAddress',response.emailAddressError);
    _webc.setErrorMessage('postCode',response.postCodeError);
    _webc.setErrorMessage('street',response.streetError);
    _webc.setErrorMessage('city',response.cityError);
    _webc.setErrorMessage('county',response.countyError);
    _webc.setErrorMessage('country',response.countryError);
    _webc.setErrorMessage('telephone',response.telephoneError);
    _webc.setErrorMessage('password',response.passwordError);
    _webc.setErrorMessage('reCAPTCHA',response.reCAPTCHAError);                                             

};

 /*======================== DG Data Methods =======================================================*/
    // These methods are relevant where the DF_WEBC_RegisterDemoInfo component is used

    _webc.putDemoInfoData = function(formData) {
    
        formData.data['ethnicGroup']= _webc.getFieldValue('ethnicGroup');  
        formData.data['ethnicOther']= _webc.getFieldValue('ethnicOther'); 
        formData.data['proximity']= _webc.getCheckboxListValues('proxcheckboxes');
    };

    _webc.putGdprSettings = function(formData) {
        console.log('a: ' + document.getElementById('email-short-form'));
        console.log(_webc.isChecked('email-short-form'));
        console.log(document.getElementById('email-short-form') == null);
        console.log(_webc.isChecked('emailPref'));
        formData.data['gdprEmailOptIn'] = (document.getElementById('email-short-form') == null) ? _webc.isChecked('emailPref')  : _webc.isChecked('email-short-form');  
        formData.data['gdprPhoneOptIn'] = _webc.isChecked('phonePref');
        formData.data['gdprSmsOptIn'] = _webc.isChecked('smsPref');  
        formData.data['gdprSocialOptIn'] = _webc.isChecked('socialPref'); 
        formData.data['gdprPostOptOut'] = _webc.isChecked('postPref'); 
        return formData;
    };

/*======================== DG Data Methods =======================================================*/



        /*==================== Register Dementia Friendly Community Administrator SETUP =====================================*/

        _webc.RegisterCommunityAdmin_init = function() {
                
            _webc.iphoneSetup();
                
            $('[id$=title-other-container]').hide();
            $('#success-message').hide();
            $('#long-register-form').hide();

            /* On intial Page Load the options are presented based on location */
            $('[id^=friend-options-text]').hide();

            // This is from the generic sub form that displays the form
            $('#newsletter').val('');
            $('#newsletter').prop('checked', false);

            _webc.clearErrors();
            _webc.setupLongFormEvents();

            /* Hook the Country select in to the change action */ 
            $('#community-country-select').val('0');


            /* Standard case - there is no invitation to register */
            if ( _webc.inviteId == '' ) {

                    $('#standard-registration').show();
                    $('#panel-step-3').show();
                    $('#panel-step-4').show();
                    $('#country-select-container').show();
                    $('#standard-header').show(); 

                    $('#community-country-select').change(
                       
                        function() {

                            var country = $(this).val();                                        
                            
                            // 1 = England, 3 = Wales
                            if ( country=='1'|| country == '3' ){ 

                                $('[id^=friend-options-text]').hide();
                                $('#intro-text-container').show();                        
                                $('#intro-text-step-1').fadeIn();
                                $('#long-register-form').fadeIn();
                                _webc.setActivePanel('2');
                            }

                            // People from Northern Ireland, Scotland or outside the UK cannot register Communities
                            //2 = Guernsey,
                            if (   country=='4'|| country == '2' || country == '5' || country == '99' ){ 
                                
                                $('#intro-text-container').hide();                        
                                $('#intro-text-step-1').hide();
                                $('#long-register-form').hide();
                                $('#friend-options-texts').show();
                                $('[id^=friend-options-text-]').hide();
                                $('#friend-options-text-'+country).fadeIn();
                                _webc.setActivePanel('1');
                            }        

                    });            

            /* Invitation case - there is an invitation to register */
            } else {


                $('#invite-registration').show();

                $('#community-country-select').hide(); 
                $('[id^=friend-options-text]').hide();                
                $('#intro-text-container').show();                        
                $('#intro-text-step-invite').show();
                $('#long-register-form').show();
                
                $('[id$=firstName]').val(_webc.inviteName.split(' ')[0]); 
                $('[id$=lastName]').val(_webc.inviteName.split(' ')[1]);
                                           
                $('[id$=emailAddress]').val(_webc.inviteEmail);
                $('[id$=emailAddress]').prop('readonly', true);
                        
                $('[id$=emailAddress2]').val(_webc.inviteEmail);
                $('[id$=emailAddress2]').prop('readonly', true);
                $('[id$=emailAddress2]').hide();
                $('[id$=emailAddress2_container]').hide();

                _webc.setActivePanel('2');               

            }
           

            /*==================== Register Community Admin LONG FORM SUBMIT =====================================*/

            _webc.submitLongForm = function () {
				console.log('In submit long form');
                var message = "";
                _webc.clearErrors();

                /* Fix the country options now the user has entered their data */
                $('[id^=friend-options]').hide();
                
                _webc.disableForm('long-form');
                
                var formData = {};            
                formData['data'] = {};
                _webc.putRegistrationBaseData(formData, false);    
				formData = _webc.putGdprSettings(formData);
                var b = _webc.isChecked('newsletter');
                formData.data['newsletter'] = b; 
                formData.data['inviteId'] = _webc.inviteId;
                formData.data['communityCountry'] = $('#community-country-select').val();
                                
                var sJson = JSON.stringify(formData.data);
                console.log('invokeSubmitAction with: ' + JSON.stringify(formData));
                _webc.invokeSubmitAction(sJson);    
            
            };
            
            _webc.handleResult = function(response, event) {
                                            
                if ( !event.status ) {

                    _webc.setErrorMessage('longServer', event.message);  
                    console.log(event.where);                 
                    _webc.enableForm('long-form');

                } else {


                    if (response.returnCode == 0) {

                        _webc.populateLongFormErrors(response);
                        grecaptcha.reset();
                        //Recaptcha.reload_internal('t');
                        _webc.enableForm('long-form');               

                    }

                    else if ( response.returnCode == -2 ) {                                                

                         _webc.populateLongFormErrors(response);   
                        grecaptcha.reset();
                        //Recaptcha.reload_internal('t');
                         _webc.enableForm('long-form');

                    }

                    else if ( response.returnCode == 3 ) {

                         var e = document.createElement('textarea');
                         e.innerHTML = response.redirectUrl;
                         var decodedUrl = e.value;
                         
                         window.location.replace(decodedUrl);                                           

                    }

                    else {

                        _webc.hideLongForm(true);    
                        $('#success-message').fadeIn();   
                        _webc.setActivePanel('3');                    
                        
                    }

                }

            };
            

            _webc.validateLongForm = function() {


                var isError = false;
           
                isError = _webc.validateLongFormBaseData();

                var addrOk = false;
                addrOk = _webc.getFieldValue('df_pca_country') == 'England' ? true : addrOk; 
                addrOk = _webc.getFieldValue('df_pca_country') == 'Wales' ? true : addrOk; 
                addrOk = _webc.getFieldValue('df_pca_country') == 'Guernsey' ? true : addrOk;
                addrOk = _webc.getFieldValue('df_pca_country') == 'Isle of Man' ? true : addrOk;

                if ( !addrOk ) {
               
                  _webc.setErrorMessage('country', "Sorry. We can only register Friends in England, Wales, Guernsey and Isle of Man.");
                   isError=true;
                   
               }
                
                            
               /* Return false if the form fails validation, hence the negative */            
               return !isError;            
                        
            };
            
            /*==================== Register Friend Error Management ======================================*/

            _webc.populateLongFormErrors = function(response) {
            
                _webc.populateLongFormBaseErrors(response);
            
            };

            _webc.showLongForm = function() {
            
                $('#intro-text-step-1').hide();
                $('#intro-text-step-2').hide();

                $('#intro-text-step-3').fadeIn();        
                $('#long-register-form').fadeIn();                       
            };

            _webc.hideLongForm = function(isComplete) {
            
               _webc.isLongFormCompleted = isComplete;
               $('#long-register-form').hide();
               $('#intro-text-container').hide();

            };
    
        }; /* End Init Function */

    /*==================== Register Dementia Friendly Community Administrator SETUP =====================================*/


/*==================== Register Admin Init =====================================*/

_webc.RegisterAdmin_init = function() { 
  
 _webc.iphoneSetup();

    $('#success-message').hide();
    $('#long-register-form').hide();

    /* On intial Page Load the optoins are presented based on location */
    $('[id^=friend-options-text]').hide();

    _webc.clearErrors();

    /* Hook the Country where you live select */ 
    $('#friend-options-select').val('0');
    $('#friend-options-select').change(
       
        function() {
            
            if ( $(this).val()=='1' ){ 
                $('[id^=friend-options-text]').hide();
                $('#friend-options-text-1').fadeIn();
                $('#long-register-form').fadeIn();
                $('[id$=newsletter]').prop('checked', false);

            }
            
            if ( $(this).val()=='2' ){
                $('[id^=friend-options-text]').hide();
                $('#friend-options-text-2').fadeIn();
                $('#long-register-form').fadeIn();
                $('[id$=newsletter]').prop('checked', false);                        
            }            

            if ( $(this).val()=='3' ){ 
                $('[id^=friend-options-text]').hide();
                $('#friend-options-text-3').fadeIn();
                $('#long-register-form').fadeIn();
                $('[id$=newsletter]').prop('checked', false);                        
            }            
            
            if ( $(this).val()=='4' ){ 
                
                $('[id^=intro-text-]').hide();                                      
                $('#long-register-form').hide();
                $('[id^=friend-options-text-]').hide();                  
                $('#friend-options-texts').show();                                                
                $('#friend-options-text-4').fadeIn();
            }            

            if ( $(this).val()=='5' ){ 

                $('[id^=intro-text-]').hide();                                     
                $('#long-register-form').hide();
                $('[id^=friend-options-text-]').hide();                  
                $('#friend-options-texts').show();                                                
                $('#friend-options-text-5').fadeIn();
            }            
            
            if ( $(this).val()=='99' ){ 
                $('[id^=intro-text-]').hide();                                      
                $('#long-register-form').hide();
                $('[id^=friend-options-text-]').hide();                  
                $('#friend-options-texts').show();                                                
                $('#friend-options-text-99').fadeIn();
            }            
            

    });            
        
    /* Hook the submit up to the action button */ 
    $('#save-long-form').off('click').on('click', function() {

        // This is to prevent a mysterious double click event
        if ( _webc.submitCount > 0 ) { return false; }
        _webc.clearErrors();
        if (!_webc.validateLongForm()) {
            return false;
        }
        _webc.submitLongForm();                  
        return false;
        
    });  

    /*
    $('[id$=emailDomain]').focusout(function(){

         if ( !_webc.isNull('emailDomain')) {
          $('#display-domain').text(_webc.getFieldValue('emailDomain'));
         } 

    });            
*/
                              

 /*==================== Register Admin Long Form =====================================*/

 _webc.submitLongForm = function () {
	console('submitLongForm lin976');
     var message = "";
     _webc.clearErrors();

     /* Fix the country options now the user has entered their data */
     $('[id^=friend-options]').hide();
     
     _webc.disableForm('long-form');
     
     var formData = {};            
     formData['data'] = {};
                  
     formData.data['orgName'] = _webc.getFieldValue('orgName');
     formData.data['employees'] = _webc.getFieldValue('employees');            
     formData.data['firstName'] = _webc.getFieldValue('firstName');
     formData.data['lastName'] = _webc.getFieldValue('lastName');
     formData.data['emailAddress'] = _webc.getFieldValue('emailAddress');
     formData.data['emailAddress2'] = _webc.getFieldValue('emailAddress2');

    formData.data['userName'] = _webc.getFieldValue('userName');
     //formData.data['emailDomain'] = _webc.getFieldValue('emailDomain');            

     formData.data['telephone'] = _webc.getFieldValue('telephone');
     formData.data['password'] = _webc.getFieldValue('password');
     formData.data['password2'] = _webc.getFieldValue('password2');

     var b = _webc.isChecked('newsletter');
     formData.data['newsletter'] = b; 
    
     formData.data['postCode'] = _webc.getFieldValue('df_pca_postcode');
     formData.data['street'] = _webc.getFieldValue('df_pca_street');
     formData.data['city'] = _webc.getFieldValue('df_pca_city');
     formData.data['county'] = _webc.getFieldValue('df_pca_county');
     formData.data['country'] = _webc.getFieldValue('df_pca_country');


     formData.data['recaptcha_challenge'] = '';
     formData.data['recaptcha_response'] = grecaptcha.getResponse();
     
    
     var sJson = JSON.stringify(formData);
     
     $.ajax({
         url: "services/apexrest/friend/register-admin",
         type: "POST",
         contentType: "application/json",
         data: sJson,
         processData:false,
         dataType: "json",
         success: function (response, textStatus, jqXHR) {
     
             if (response.returnCode == 0) {

                 _webc.populateLongFormErrors(response);
                 grecaptcha.reset();
                 //Recaptcha.reload_internal('t');                         
                 _webc.enableForm('long-form');               

             }
             
             else if ( response.returnCode == -2 ) {                                                

                  _webc.populateLongFormErrors(response);   
                 grecaptcha.reset(); 
                 //Recaptcha.reload_internal('t');                          
                  _webc.enableForm('long-form');

             }
             
             else {

                 _webc.hideLongForm(true);    
                 $('#success-message').fadeIn();  
                 _webc.setActivePanel('3');                         
                 
             }
             
             
         },
         error: function (jqXHR, textStatus, errorThrown) {
             
             alert(jqXHR.responseText);                    
             _webc.setErrorMessage('longServer', errorThrown);                   
             _webc.enableForm('long-form');
             
         },
         
         // callback handler that will be called on completion
         // which means, either on success or error
         complete: function () {
         
         }

     })
     
 
 };

 /*==================== Register Admin Form Management =====================================*/
 
 _webc.validateLongForm = function() {
 
 
     var isError = false;

     if (_webc.isNull('orgName')) {
         _webc.setErrorMessage('orgName', "** Please enter Organisation Name");
         isError= true;
     }

     if (_webc.isNull('employees') || _webc.getFieldValue('employees')=='NULL' ) {
         _webc.setErrorMessage('employees', "** Please enter number of employees");
         isError= true;
     }

     /* 
     if (_webc.isNull('emailDomain') || _webc.getFieldValue('emailDomain')=='NULL' ) {
         _webc.setErrorMessage('emailDomain', "** Please enter an Email Domain");
         isError= true;
     }
  */

     if ( _webc.isNull('userName') || _webc.getFieldValue('userName')=='NULL' ) {
         _webc.setErrorMessage('userName', "** Please enter a user name");
         isError= true;
     }

     if ( !_webc.isNull('userName') ) {

        var sValue = _webc.getFieldValue('userName');  
       if ( !(/^[a-zA-Z0-9]*$/.test(sValue)) ) {            
       _webc.setErrorMessage('userName', "** Please use numbers and letters without '@' or spaces");
          isError= true;
         }
     }              



     if (_webc.isNull('firstName')) {
         _webc.setErrorMessage('firstName', "** Please enter First Name");
         isError= true;
     }
     
     if (_webc.isNull('lastName')) {
         _webc.setErrorMessage('lastName', "** Please enter Last Name");
         isError= true;
     }
     
     if ( _webc.getFieldValue('emailAddress') !== _webc.getFieldValue("emailAddress2") ) {
         _webc.setErrorMessage('emailAddress', "** Email Addresses do not match");
         isError= true;
     }
     
     if ( !_webc.isValidEmail('emailAddress') ) {
         _webc.setErrorMessage('emailAddress', "** Email Address is a not a valid format");
         isError= true;
     }


     if (_webc.isNull('df_pca_postcode')) {
         _webc.setErrorMessage('postcode', "Please enter a postcode");
         isError= true;
     }
      
     if (_webc.isNull('df_pca_street')) {
         _webc.setErrorMessage('street', "Please enter the building/street address");
         isError= true;
     } 
     
     if (_webc.isNull('df_pca_city') && _webc.isNull('df_pca_county')) {
         _webc.setErrorMessage('city', "Please enter the city or county");
         isError= true;
     }
      
     if (_webc.isNull('df_pca_country')) {
         _webc.setErrorMessage('country', "Please enter the county");
         isError= true;
     } 

     var addrOk = false;
     addrOk = _webc.getFieldValue('df_pca_country') == 'England' ? true : addrOk; 
     addrOk = _webc.getFieldValue('df_pca_country') == 'Guernsey' ? true : addrOk;
     addrOk = _webc.getFieldValue('df_pca_country') == 'Isle of Man' ? true : addrOk;
     addrOk = _webc.getFieldValue('df_pca_country') == 'Wales' ? true : addrOk;

        if ( !addrOk ) {
       
          _webc.setErrorMessage('country', "Sorry. We can only register Organisations in England, Wales, Guernsey and Isle of Man.");
           isError=true;
           
        }

     
     if (_webc.isNull('telephone')) {
         _webc.setErrorMessage('telephone', "Please enter a phone number");
         isError= true;
     } 
     
     if (!_webc.isValidPhone('telephone')) {
        
            _webc.setErrorMessage('telephone', "Please enter your contact number in correct format");
            isError= true;
        } 
        

                 
    if ( _webc.getFieldValue('password') !== _webc.getFieldValue("password2") ) {
     
         _webc.setErrorMessage('password', "Passwords do not match");
         isError= true;
     
    }
                 
     if ( !_webc.isValidPassword('password', 'userName') ) {        
         
         _webc.setErrorMessage('password', "Passwords must be numbers and letters and at least 8 characters. Your password may not contain the word 'password' or your email address name");
         isError= true;
     
     }
     
     if ( isError ) {
     
      _webc.setErrorMessage('longServer', "Please correct the errors displayed above");
     }
                 
     return !isError;            
             
 };
 
 /*==================== Register Admin Error Management ======================================*/

 _webc.populateLongFormErrors = function(response) {
 
     _webc.setErrorMessage('longServer',response.standardErrorMsg);
     _webc.setErrorMessage('orgName',response.orgNameError);
     _webc.setErrorMessage('employees',response.employeesError);
     _webc.setErrorMessage('firstName',response.firstNameError);
     _webc.setErrorMessage('lastName',response.lastNameError);
     _webc.setErrorMessage('emailAddress',response.emailAddressError);
     

     _webc.setErrorMessage('userName',response.userNameError);
     _webc.setErrorMessage('emailDomain',response.emailDomain);             

     _webc.setErrorMessage('telephone',response.telephoneError);
     _webc.setErrorMessage('password',response.passwordError);
     _webc.setErrorMessage('reCAPTCHA',response.reCAPTCHAError);                                             

 };

 _webc.showLongForm = function() {
 
     $('#intro-text-step-1').hide();
     $('#intro-text-step-2').hide();

     $('#intro-text-step-3').fadeIn();        
     $('#long-register-form').fadeIn();                       
 };

 _webc.hideLongForm = function(isComplete) {
 
    _webc.isLongFormCompleted = isComplete;
    $('#long-register-form').hide();
 };

}; /* End Register Admin Init Function */

/*=========================================== End Register Admin ==============================================================*/

  /*==================== Register Dementia Champion SETUP =====================================*/

        _webc.RegisterChampion_init = function() {
                
            _webc.iphoneSetup();
                
            $('[id$=title-other-container]').hide();
            $('#success-message').hide();
            $('#long-register-form').hide();
            $('#demoInfo-register-form').hide();

            /* On intial Page Load the optoins are presented based on location */
            $('[id^=friend-options-text]').hide();

            // This is from the generic sub form that displays the form
            // Pack Request is not relevant in this case
            $('#little-book').hide();
            $('#packRequest').hide();
            $('#packRequest_container').hide();
            $('#packRequest').val('');
            $('#packRequest').prop('checked', false);

            $('#newsletter').val('');
            $('#newsletter').prop('checked', false);
            
            $('#champnewsletter-container').show();
            $('#champnewsletter').prop('checked',true);
        
        $('#whychampion-container').show();

            $('#birthDate-container').show();
            $("input[name='proximity']").val('') ;           
            $('[id$=ethnicGroup-other-container]').hide();
            
            _webc.clearErrors();
            _webc.setupLongFormEvents();

            /* Hook the Country select in to the change action */ 
            $('#friend-options-select').val('0');
            $('#friend-options-select').change(
               
                function() {

                    var country = $(this).val();                                        
                    
                    // England, Guernsey, Wales
                    if ( country=='1'|| country == '2' || country == '3' ){ 

                        $('[id^=friend-options-text]').hide();
                        $('#intro-text-container').show();                        
                        $('#intro-text-step-1').fadeIn();
                        $('#long-register-form').fadeIn();
                        $('#demoInfo-register-form').fadeIn();
                        _webc.setActivePanel('2');
                        //google tracking vpv-7
                        _webc.googleTracking("/vpv/register_champion/step_2", "VPV - Register Dementia Friend Champion - Step 2" );
  
                    }

                    // People from Northern Ireland, Scotland or outside the UK cannot register as Friends
                    if (  country=='4'|| country == '5' || country == '99' ){ 
                        
                        $('#intro-text-container').hide();                        
                        $('#intro-text-step-1').hide();
                        $('#long-register-form').hide();
                        $('#demoInfo-register-form').hide();
                        $('#friend-options-texts').show();
                        $('[id^=friend-options-text-]').hide();
                        $('#friend-options-text-'+country).fadeIn();
                        _webc.setActivePanel('1');
                    }        

            });            
           

            /*==================== Register Dementia Champion LONG FORM SUBMIT =====================================*/

            _webc.submitLongForm = function () {
				console.log('Champ submitLongFrm');
                var message = "";
                _webc.clearErrors();

                /* Fix the country options now the user has entered their data */
                $('[id^=friend-options]').hide();
                
                _webc.disableForm('long-form');
                
                var formData = {};            
                formData['data'] = {};
                
                // Call the various methods to add the data required
                _webc.putRegistrationBaseData(formData, false);    
                _webc.putDemoInfoData(formData);  
                formData = _webc.putGdprSettings(formData);
                formData.data['birthDate'] = _webc.getFieldValue('birthDate');

                var b = _webc.isChecked('newsletter');
                formData.data['newsletter'] = b; 
                
                var c =_webc.isChecked('champnewsletter'); 
                console.log(formData.data['champnewsletter']);
                formData.data['champnewsletter'] =  c;

        		formData.data['whychampion'] = _webc.getFieldValue('whychampion'); 
                
                var sJson = JSON.stringify(formData.data);                
                _webc.invokeSubmitAction(sJson);    
            
            };

            _webc.handleResult = function(response, event) {
                                
                if ( !event.status ) {

                    _webc.setErrorMessage('longServer', event.message);  
                    console.log(event.where);                 
                    _webc.enableForm('long-form');

                } else {


                    if (response.returnCode == 0) {

                        _webc.populateLongFormErrors(response);
                        grecaptcha.reset();
                        //Recaptcha.reload_internal('t');
                        _webc.enableForm('long-form');               

                    }

                    else if ( response.returnCode == -2 ) {                                                

                         _webc.populateLongFormErrors(response);   
                        grecaptcha.reset();
                        //Recaptcha.reload_internal('t');
                         _webc.enableForm('long-form');

                    }

                    else {

                        _webc.hideLongForm(true);    
                        $('#success-message').fadeIn();   
                        _webc.setActivePanel('3');   
                        //google tracking vpv-8
                        _webc.googleTracking("/vpv/register_champion/step_3", "VPV - Register Dementia Friend Champion - Step 3" );               
                        
                    }

                }

            };
            

            _webc.validateLongForm = function() {


                var isError = false;
           
                isError = _webc.validateLongFormBaseData();

                var addrOk = false;
                addrOk = _webc.getFieldValue('df_pca_country') == 'England' ? true : addrOk; 
                addrOk = _webc.getFieldValue('df_pca_country') == 'Guernsey' ? true : addrOk;
                addrOk = _webc.getFieldValue('df_pca_country') == 'Isle of Man' ? true : addrOk;
                addrOk = _webc.getFieldValue('df_pca_country') == 'Wales' ? true : addrOk;

                if ( !addrOk ) {
               
                  _webc.setErrorMessage('country', "Sorry. We can only register Friends Champions in England, Guernsey, Isle of Man and Wales.");
                   isError=true;
                   
               }

               if ( !_webc.isValidDateString(_webc.getFieldValue('birthDate')) ) {
             
                    _webc.setErrorMessage('birthDate', "Please enter a valid date in the format DD/MM/YYYY");
                    isError = true;
             
                } else {
             
                     if ( _webc.getAge(_webc.getFieldValue('birthDate')) < 16 ) {
                     
                        _webc.setErrorMessage('birthDate', "Sorry, you need to be over 16 to be a Dementia Friends Champion.");
                         isError= true;
                     
                     }              
                }

        if( _webc.getFieldValue('whychampion')==null || _webc.getFieldValue('whychampion')=='' ){
                
                _webc.setErrorMessage('whychampion', "Field cannot be empty");
                    isError = true;
                
                }
                
                            
               /* Return false if the form fails validation, hence the negative */            
               return !isError;            
                        
            };
            
            /*==================== Register Champion Error Management ======================================*/

            _webc.populateLongFormErrors = function(response) {
            
                _webc.populateLongFormBaseErrors(response);

                _webc.setErrorMessage('birthDate',response.birthDateError);
                 console.log(response);
            };

            _webc.showLongForm = function() {
            
                $('#intro-text-step-1').hide();
                $('#intro-text-step-2').hide();

                $('#intro-text-step-3').fadeIn();        
                $('#long-register-form').fadeIn();                       
            };

            _webc.hideLongForm = function(isComplete) {
            
               _webc.isLongFormCompleted = isComplete;
               $('#long-register-form').hide();
               $('#intro-text-container').hide();

            };
    
        }; /* End Init Function */

    
    /*==================== Register Dementia Champion SETUP =====================================*/
       /*================ End of Register Dementia Champion =====================================*/

   

/*==================== Register Dementia Champion SETUP =====================================*/

/*
$(document).ready( function() {

_webc.invokeShortSubmitAction = function (sJson) { 
  Visualforce.remoting.Manager.invokeAction (
        'DF_WEBC_Register_Remoter.handleDigitalFriendJson', 
        sJson, 
        _webc.handleShortResult
   );
};

var count=1;
_webc.invokeSubmitAction = function (sJson, caller) {   	
  	
    _webc.log('Count : ' + count + ' - ' + caller);
    count++;
    Visualforce.remoting.Manager.invokeAction (
        'DF_WEBC_Register_Remoter.handleFriendJson', 
        sJson, 
        _webc.handleResult
   );
};

_webc.invokeMakeDDFAction = function (sJson) { 
  Visualforce.remoting.Manager.invokeAction (
        'DF_WEBC_Register_Remoter.handleMakeDDFJson', 
        sJson, 
        _webc.handleMakeDDFResult
   );
};


});
*/


/*==================== Register Digital Friend PAGE SETUP =====================================*/

_webc.RegisterDigitalFriend_init = function() {
        
    _webc.iphoneSetup();

    $('[id$=title-other-container]').hide();
    $('#success-message').hide();

    /* On intial Page Load the optoins are presented based on location */
    $('[id^=friend-options-text]').hide();
    $('[id^=intro-text-]').hide();
    $('#short-form-container').hide();
    $('#long-register-form').hide();
    $('#demoInfo-register-form').hide();
    $('#little-book').hide();
    $('#packRequest').hide(); 
    $('#packRequest_container').hide();
    $('#packRequest').val('');
    $('#packRequest').prop('checked', false);
    $('#birthDate-container').show();
    $('#birthDate-container').removeClass('required');
    $('#helptext').hide();
    $('#birthDateError').show();
    $('[id$=ethnicGroup-other-container]').hide();
    
    _webc.log ('one');

    _webc.clearErrors();
    _webc.setupLongFormEvents();
    
    _webc.log ('two');

    /*
     <option value='0'>Where do you live?</option>
     <option value='1'>England</option>
     <option value='2'>Jersey,Guernsey,Isle of Man</option>
     <option value='3'>Wales</option>
     <option value='4'>Northern Ireland</option>
     <option value='5'>Scotland</option>
     <option value='99'>Outside the UK</option>
    */    

    /* Hook the Country where you live select */ 
    $('#friend-options-select').val('0');
    $('#friend-options-select').change(
       
        function() {
            
            var country = $(this).val();                                        
            
            // England, Guernsey, Wales
            if ( country=='1'|| country == '2' || country == '3' ){ 

                $('[id^=friend-options-text]').hide();
                $('#intro-text-container').show();                        
                $('#intro-text-step-1').fadeIn();
                $('#short-form-container').fadeIn();
                _webc.setActivePanel('2');
                //google tracking vpv-1
              _webc.googleTracking("/vpv/register_digital_friend/step_2", "VPV - Register Digital Dementia Friend - Step 2" );
            }

            // People from Northern Ireland, Scotland or outside the UK cannot register as Friends
            if (  country=='4'|| country == '5' || country == '99' ){ 
                
                $('#intro-text-container').hide();                        
                $('#intro-text-step-1').hide();
                $('#short-form-container').hide();
                $('#friend-options-texts').show();
                $('[id^=friend-options-text-]').hide();
                $('#friend-options-text-'+country).fadeIn();
                _webc.setActivePanel('1');
            }        

    });        
    
    _webc.log ('three');
                    
                    
    var saveShortFormHasRun = false;               
    /* Hook the submit up to the action button */ 
    $('#save-short-form').off("click").on("click",
        
        function() {
            if(!saveShortFormHasRun) {
                saveShortFormHasRun = true;

                _webc.clearErrors();
                                    
                if (!_webc.validateShortForm()) { 
                    saveShortFormHasRun = false;
                    return false;
                }
                
                _webc.log('Validation OK - Short Form');

                _webc.submitShortForm();        

            }          
            return false;
        
    });
    
    
    _webc.log ('six');     
                              
   /*==================== Register Digital Friend FORM SUBMIT =====================================*/
    
    
    _webc.submitShortForm = function() {

        var message = "";
        _webc.clearErrors();

        _webc.log('Submitting short form');

        /* Fix the country options now the user has entered their data */
        $('[id^=friend-options]').hide();               
        
        _webc.disableForm('short-form');
        
        var formData = {};
        formData['data'] = {};

        formData.data['firstName'] = _webc.getFieldValue('firstName_short');
        formData.data['lastName'] = _webc.getFieldValue('lastName_short');
        formData.data['emailAddress'] = _webc.getFieldValue('emailAddress_short');
        formData.data['emailAddress2'] = _webc.getFieldValue('emailAddress2_short');
        
        var b = _webc.isChecked('newsletter_short');
        formData.data['newsletter'] = b;            

        if(document.getElementById('emailPref_short') != null) {
            formData.data['gdprEmailOptIn'] = _webc.isChecked('emailPref_short');
        }
        formData.data['gdprPhoneOptIn'] = false;
        formData.data['gdprSmsOptIn'] = false;  
        formData.data['gdprSocialOptIn'] = false; 
        formData.data['gdprPostOptOut'] = false; 
        
        var sJson = JSON.stringify(formData.data);

        _webc.invokeShortSubmitAction(sJson);    
        
        _webc.log(sJson);

    
    };
    
    _webc.log ('seven');


    _webc.handleShortResult = function(response, event) {
        

        if ( !event.status ) {

            _webc.setErrorMessage('shortServer', event.message);  
            _webc.enableForm('short-form');

        } else {


            if (response.returnCode == 0) {

               _webc.setErrorMessage('shortServer', 'Error: ' + response.standardErrorMsg);

            }

            else if ( response.returnCode == -2 ) {                                                

                message = "This email address is already registered.";
                if ( response.standardErrorMsg != '' ) { message = response.standardErrorMsg; }
                _webc.setErrorMessage('shortServer', 'Error: ' + response.message);  

            }

            else {


                $('[id$=userid]').val(response.userid);                            
                $('[id$=firstName]').val(response.firstName); 
                $('[id$=lastName]').val(response.lastName);
            
                $('[id$=firstName]').prop('readonly', true); 
                $('[id$=lastName]').prop('readonly', true);
                
                $('[id$=emailAddress]').val(response.emailAddress);
                $('[id$=emailAddress]').prop('readonly', true);
                
                $('[id$=emailAddress2]').val(response.emailAddress);
                $('[id$=emailAddress2]').prop('readonly', true);
                $('[id$=emailAddress2]').hide();
                $('[id$=emailAddress2_container]').hide();
                
                /* If the short form is submitted, this is a pack request, so set the field value */
                $('#packRequest').val('on');
                $('#packRequest').prop('checked', true);                        
                $('[id^=packRequest]').show();
                                            
                $('[id$=newsletter]').val(_webc.getFieldValue('newsletter_short'));
                
                var isNewsletterChecked = $('[id$=newsletter_short]').prop('checked');
                $('[id$=newsletter]').prop('checked', isNewsletterChecked);
                
                if(document.getElementById('emailPref_short')!=null) {
                    var isShortFormEmailChecked = $('[id$=emailPref_short]').prop('checked');
                    $('[id$=emailPref]').prop('checked', isShortFormEmailChecked);
                }                 
                _webc.insertVideo();                   
                
            }

        }

    };


    /*==================== Register Digital Friend LONG FORM SUBMIT =====================================*/


    _webc.submitLongForm = function () {

        var message = "";
        _webc.clearErrors();

        /* Fix the country options now the user has entered their data */
        $('[id^=friend-options]').hide();
        
        _webc.disableForm('long-form');
        
        var formData = {};            
        formData['data'] = {};
        _webc.putRegistrationBaseData(formData, false);
        _webc.putDemoInfoData(formData); 
        formData = _webc.putGdprSettings(formData);
        formData.data['birthDate'] = _webc.getFieldValue('birthDate');
        var b = _webc.isChecked('newsletter');
        formData.data['newsletter'] = b; 

        b = _webc.isChecked('packRequest');
        formData.data['packRequest'] = b; 

        // temporary football promotion
        formData.data['footballTeam'] = _webc.getFieldValue('footballTeam');
        formData.data['videoType'] = videoType;                
        var sJson = JSON.stringify(formData.data);
        _webc.invokeSubmitAction(sJson);  

    
    };

    _webc.handleResult = function(response, event) {
        console.log('In another handleResult method');       
        if ( !event.status ) {

            _webc.setErrorMessage('longServer', event.message);  
            console.log(event.where);                 
            _webc.enableForm('long-form');

        } else {


            if (response.returnCode == 0) {

                _webc.populateLongFormErrors(response);
                grecaptcha.reset();
                //Recaptcha.reload_internal('t');
                _webc.enableForm('long-form');               

            }

            else if ( response.returnCode == -2 ) {                                                

                 _webc.populateLongFormErrors(response);   
                grecaptcha.reset();
                //Recaptcha.reload_internal('t');
                 _webc.enableForm('long-form');

            }

            else {

                _webc.hideLongForm(true);    
                $('#success-message').fadeIn();   
                _webc.setActivePanel('5'); 
                //google tracking vpv-4
                _webc.googleTracking("/vpv/register_digital_friend/step_5", "VPV - Register Digital Dementia Friend - Step 5");                   
                
            }

        }

    };
    

    _webc.validateLongForm = function() {


        var isError = false;
   
        isError = _webc.validateLongFormBaseData();

        var addrOk = false;
        addrOk = _webc.getFieldValue('df_pca_country') == 'England' ? true : addrOk; 
        addrOk = _webc.getFieldValue('df_pca_country') == 'Guernsey' ? true : addrOk;
        addrOk = _webc.getFieldValue('df_pca_country') == 'Isle of Man' ? true : addrOk;
        addrOk = _webc.getFieldValue('df_pca_country') == 'Wales' ? true : addrOk;

        if ( !addrOk ) {
       
          _webc.setErrorMessage('country', "Sorry. We can only register Friends in England, Guernsey, Isle of Man and Wales.");
           isError=true;
           
       }
 
    if ( !_webc.isValidDateString(_webc.getFieldValue('birthDate')) && !_webc.isNull('birthDate') ) {
             
                    _webc.setErrorMessage('birthDate', "Please enter a valid date in the format DD/MM/YYYY");
                    isError = true;
             
         } else {
             
                     if ( _webc.getAge(_webc.getFieldValue('birthDate')) < 0 ) {
                     
                        _webc.setErrorMessage('birthDate', "Sorry, birthdate can not be a date in future.");
                         isError= true;
                     
                     }              
          } 
        
                    
       /* Return false if the form fails validation, hence the negative */            
       return !isError;            
                
    };
    
    /*==================== Register Friend Error Management ======================================*/

    _webc.populateLongFormErrors = function(response) {
    
        _webc.populateLongFormBaseErrors(response);
        _webc.setErrorMessage('birthDate',response.birthDateError);
    };

    _webc.showLongForm = function() {
    
        $('#intro-text-step-1').hide();
        $('#intro-text-step-2').hide();
        $('#bsl-video').hide();
        $('#intro-text-step-5').fadeIn();        
        $('#long-register-form').fadeIn();  
        $('#demoInfo-register-form').fadeIn();

        // Temporary Football Promotion
        $('[id$=football-team-container]').fadeIn();    

                     
    };

    _webc.hideLongForm = function(isComplete) {
    
       _webc.isLongFormCompleted = isComplete;
       $('#long-register-form').hide();
       $('#demoInfo-register-form').hide();
       $('#intro-text-container').hide();

    };

    _webc.log ('eight');

    /*==================== Register Digital Friend VIDEO MANAGEMENT =====================================*/

    /* Not using onYouTubeIframeAPIReady because the video is not required 
       on initial page load
    */

    /*    The API calls this function when the player's state changes.
          The function indicates that when playing a video (state=1),
          the player should play for six seconds and then stop.  
          States: 1=playing, 2=paused, 3=buffering, 5=cued, -1=unstarted
          State 0 = ended 
    */

     var videoType;
    _webc.onPlayerStateChange = function (event) {

        var state = event.target.getPlayerState();
        if (state === 0) {
              
            var sVid = event.target.getVideoUrl();
            var s1 = sVid.split('v=');
            var vid = s1[1].split('&')[0];
            videoType = (vid==='fync5IKMgnk'?'Standard Video':'BSL'); 
            //_gaq.push(['_trackEvent', 'video', 'complete', vid]); 
            //google tracking
            _webc.googleTrackingVideo();

            $('#player').hide();

            / * Reset the video so it doesn't keep showing the form */                
            event.target.clearVideo();     
            $('#final-player-image').fadeIn();

        }
    
    };

   /* The API will call this function when the video player is ready.
       df_isVideoShownForm is set the first time the function runs 
    */
    _webc.isVideoShownForm = false;

    _webc.onPlayerReady = function() {

            function updateTime() {
    
                if (_webc.player && _webc.player.getCurrentTime) {
        
                    if (_webc.player.getCurrentTime() >= 290) { // 4 minutes 10 seconds

                    /* When the video gets to 250 then show the form and make the subscriber a Friend */
                    if (_webc.isVideoShownForm) { return; }
                        _webc.isVideoShownForm = true;                        
                        
                        _webc.showLongForm();
                        _webc.submitCount=0;
                        _webc.convertToDDF();  
                        _webc.setActivePanel('4');
                        //google tracking vpv-3
                      _webc.googleTracking("/vpv/register_digital_friend/step_4", "VPV - Register Digital Dementia Friend - Step 4" );
                
                    };
        
                }
            }

        _webc.timeupdater = setInterval(updateTime, 1000);
    };

    _webc.setActivePanel = function (step) { 

        $('.step-active').removeClass('step-active').addClass('step');
        $('#panel-step-' + step).removeClass('step').addClass('step-active');

    }


    _webc.insertVideo = function() {

        _webc.log('Showing Video');

       $('#intro-text-step-3').hide();          
       $('#intro-text-step-1').hide();
       $('#short-form-container').hide();

       $('#video-container').fadeIn();
       $('#bsl-video').fadeIn();
       //var vid = '9KBlXb3j2Q8';
       var vid = 'fync5IKMgnk';

       $("#bslLink").on('click', function() {
              
               _webc.player.loadVideoById("qut1FiQfcrI", 0, "default");
               
                 return false;
        });
               
       $("#standardLink").on('click', function() {
              
               _webc.player.loadVideoById("fync5IKMgnk", 0, "default");
               
                 return false;
        });
       
       _webc.player = new YT.Player('player', {
           height: '390',
           width: '701',
           videoId: vid,
           playerVars: { 'autoplay': 0, 'autohide': 1, rel: 0 },
           events: {
               'onReady': _webc.onPlayerReady,
               'onStateChange': _webc.onPlayerStateChange
           }
       });
       
       _webc.log('Google Push on the Video');
      // _gaq.push(['_trackEvent', 'video', 'show', vid]);
       //google tracking
      // _webc.googleTrackingVideo();
       
        _webc.log('Showing Intro Step 2');
       $('#intro-text-step-2').fadeIn();               
       
       $('#player').fadeIn();
       _webc.setActivePanel('3');
       //google tracking vpv-2
       _webc.googleTracking("/vpv/register_digital_friend/step_3", "VPV - Register Digital Dementia Friend - Step 3" );
               
       
    };
    
    
    /* If the user watches the video but does not submit the form
       they still qualify as a Digital Dementia Friend
    */                
    _webc.convertToDDF = function() {            

        var formData = {};            
        formData['data'] = {};
        formData.data['userid'] = _webc.getFieldValue('userid');
        formData.data['action'] = 'makeDDf';
        var sJson = JSON.stringify(formData.data);

        _webc.invokeMakeDDFAction(sJson);    

    
    };


    _webc.handleMakeDDFResult = function(response, event) {
        

        if ( !event.status ) {

            console.log(event.where);                 
            
        } else {


            if (response.returnCode == 1) {

                 // Sept 2016. Change the code model
                 //window._fbq.push(['track', '6026361393936', {'value':'0.00','currency':'GBP'}]);                            
                 
                 fbq('init', '116006675405800');
                 fbq('track', 'PageView');
                 twq('init','nvgr8');
                 twq('track','PageView');

            }

        }

    };
    
    
    _webc.log ('nine');

    /*==================== Register Digital Friend FORM MANAGEMENT =====================================*/


    _webc.validateShortForm = function() {
    
        _webc.log('Validating Short Form');

        var isError = false;
        if (_webc.isNull('firstName_short')) {
            _webc.setErrorMessage('firstName_short', "Please enter your first name");
            isError= true;
        }
        
        if (_webc.isNull('lastName_short')) {
            _webc.setErrorMessage('lastName_short', "Please enter your last name");
            isError= true;
        }
        
        if ( _webc.getFieldValue('emailAddress_short') !== _webc.getFieldValue("emailAddress2_short") ) {
            _webc.setErrorMessage('emailAddress_short', "Email addresses do not match");
            isError= true;
        }
        
        if ( !_webc.isValidEmail('emailAddress_short') ) {
            _webc.setErrorMessage('emailAddress_short', "Email address is a not a valid format");
            isError= true;
        }
        
        _webc.log('Validated Short Form : ' + isError);

        return !isError;            
                
    };
    
    
    _webc.log ('ten');
    
    /*==================== Register Digital Friend Error Management ======================================*/


}; /* End Init Function */

_webc.log ('eleven');


/*====================================== Register Digital Friend End =================================*/

/*==================== Register Newsletter PAGE SETUP =====================================*/

_webc.RegisterNewsletter_init = function() {

    _webc.iphoneSetup();

    $('#success-container').hide();
    $('#shortServerError').hide();
                    
    /* Hook the submit up to the action button */ 
    var saveShortFormHasRun = false;
    $('#save-short-form').click(

        function() {

            if ( saveShortFormHasRun ) { return false; }
                                   
            _webc.log("Click Submit");                                
            _webc.clearErrors();
            
            if (!_webc.validateShortForm()) {
                grecaptcha.reset();
                return false;
            }
            
            _webc.submitShortForm();           
            saveShortFormHasRun = true;       
            return false;
    
   });
                          

/*==================== Register Newsletter FORM SUBMIT =====================================*/


 _webc.submitShortForm = function () {           



    var message = "";
    _webc.clearErrors();
    
    _webc.disableForm('short-form');
    
    var formData = {};
    formData['data'] = {};

    formData.data['firstName'] = _webc.getFieldValue('firstName');
    formData.data['lastName'] = _webc.getFieldValue('lastName');
    formData.data['emailAddress'] = _webc.getFieldValue('emailAddress');
    formData.data['emailAddress2'] = _webc.getFieldValue('emailAddress2');                                
    formData.data['newsletter'] = true;
         
    formData.data['doRecaptcha'] = true;                        
    formData.data['recaptcha_challenge'] = '';
    formData.data['recaptcha_response'] = grecaptcha.getResponse();
    formData = _webc.putGdprSettings(formData);
     
    var sJson = JSON.stringify(formData.data);                    
    _webc.log(sJson);
    _webc.invokeShortSubmitAction(sJson);                
    
};


_webc.handleShortResult = function(response, event) {
        
        _webc.log('Show Response');    
        for (var v in response) {
          if (response.hasOwnProperty(v)) {
            _webc.log("v : " + response[v]);
          }
        }

        if ( !event.status ) {

            _webc.setErrorMessage('shortServer', event.message);  
            _webc.enableForm('short-form');

        } else {


            if (response.returnCode == 0) {

               _webc.setErrorMessage('shortServer', 'Error: ' + response.standardErrorMsg);

            }

            else {

                $("#shortServerError").hide();
                $('#form-container').hide();
                $('#success-container').fadeIn();                        
                //Google tracking vpv-0
                _webc.googleTracking("/vpv/subscribe/success", "VPV - Newsletter Subscription - Success" );
  
            }

       }

};


_webc.validateShortForm = function() {

    var isError = false;
    if (_webc.isNull('firstName')) {
        _webc.setErrorMessage('firstName', "Please enter First Name");
        isError= true;
    }
    
    if (_webc.isNull('lastName')) {
        _webc.setErrorMessage('lastName', "Please enter Last Name");
        isError= true;
    }
    
    if (_webc.isNull('emailAddress')) {
        _webc.setErrorMessage('emailAddress', "Please enter your email address");
        isError= true;
    }
    
    if ( _webc.getFieldValue('emailAddress') !== _webc.getFieldValue("emailAddress2") ) {
        _webc.setErrorMessage('emailAddress', "Email Addresses do not match");
        isError= true;
    }
    
    if ( !_webc.isValidEmail('emailAddress') ) {
        _webc.setErrorMessage('emailAddress', "Email Address is a not a valid format");
        isError= true;
    }
    
    return !isError;            
            
}

/*==================== Register Newsletter Error Management ======================================*/

_webc.populateErrors = function(response) {             

    _webc.setErrorMessage('shortServer',response.standardErrorMsg);
    _webc.setErrorMessage('firstName',response.firstNameError);
    _webc.setErrorMessage('lastName',response.lastNameError);
    _webc.setErrorMessage('emailAddress',response.emailAddressError);
    _webc.setErrorMessage('reCAPTCHA',response.reCAPTCHAError);                                             

}

} /* End _webc.RegisterNewsletter_init */        


/*============================ Register Newsletter End ==================================================*/


/*==================== Register Dementia Friend SETUP =====================================*/

_webc.RegisterFriend_init = function() {

    _webc.iphoneSetup();
        
    $('[id$=title-other-container]').hide();
    $('#success-message').hide();
    $('#long-register-form').hide();
    $('#demoInfo-register-form').hide();

    /* On intial Page Load the optoins are presented based on location */
    $('[id^=friend-options-text]').hide();

    // This is from the generic sub form that displays the form
    // Pack Request is not relevant in this case
    $('#little-book').hide();
    $('#packRequest').hide();
    $('#packRequest_container').hide();
    $('#packRequest').val('');
    $('#packRequest').prop('checked', false);

    $('#newsletter').val('');
    $('#newsletter').prop('checked', false);

     $('#birthDate-container').show();
     $('#birthDate-container').removeClass('required');
     $('#helptext').hide();
     $('#birthDateError').show();
     $('[id$=ethnicGroup-other-container]').hide();

    _webc.clearErrors();
    _webc.setupLongFormEvents();

    /* Hook the Country select in to the change action */ 
    $('#friend-options-select').val('0');
    $('#friend-options-select').change(
       
        function() {

            var country = $(this).val();                                        
            
            // England, Guernsey, Wales
            if ( country=='1'|| country == '2' || country == '3' ){ 

                $('[id^=friend-options-text]').hide();
                $('#intro-text-container').show();                        
                $('#intro-text-step-1').fadeIn();
                $('#long-register-form').fadeIn();
                $('#demoInfo-register-form').fadeIn();
                _webc.setActivePanel('2');
                //google tracking vpv-5
                _webc.googleTracking("/vpv/register_friend/step_2", "VPV - Register Dementia Friend - Step 2" );
                         
            }

            // People from Northern Ireland, Scotland or outside the UK cannot register as Friends
            if (  country=='4'|| country == '5' || country == '99' ){ 
                
                $('#intro-text-container').hide();                        
                $('#intro-text-step-1').hide();
                $('#long-register-form').hide();
                $('#demoInfo-register-form').hide();
                $('#friend-options-texts').show();
                $('[id^=friend-options-text-]').hide();
                $('#friend-options-text-'+country).fadeIn();
                _webc.setActivePanel('1');
            }        

    });            

    /*==================== Register Friend LONG FORM SUBMIT =====================================*/

    _webc.submitLongForm = function () {
        
        var message = "";
        _webc.clearErrors();

        /* Fix the country options now the user has entered their data */
        $('[id^=friend-options]').hide();
        
        _webc.disableForm('long-form'); 
        
        var formData = {};            
        formData['data'] = {};
        _webc.putRegistrationBaseData(formData, false);    
        _webc.putDemoInfoData(formData);
        formData = _webc.putGdprSettings(formData);
        
        formData.data['birthDate'] = _webc.getFieldValue('birthDate');

        var b = _webc.isChecked('newsletter');
        formData.data['newsletter'] = b; 
        formaData = _webc.putGdprSettings(formData);
                        
        var sJson = JSON.stringify(formData.data);
        _webc.invokeSubmitAction(sJson);    
    
    };


    _webc.handleResult = function(response, event) {
        
        if ( !event.status || !response.returnCode ) {

            _webc.setErrorMessage('longServer', event.message);  
            console.log(event.where);                 
            _webc.enableForm('long-form');

        } else {


            if (response.returnCode == 0) {

                _webc.populateLongFormErrors(response);
                grecaptcha.reset();
                //Recaptcha.reload_internal('t');
                _webc.enableForm('long-form'); 

            }

            else if ( response.returnCode == -2 ) {                                                

                 _webc.populateLongFormErrors(response);   
                grecaptcha.reset();
                //Recaptcha.reload_internal('t');
                 _webc.enableForm('long-form');
                
            }

            else {

                _webc.hideLongForm(true);    
                $('#success-message').fadeIn();   
                _webc.setActivePanel('3'); 
                 //google tracking vpv-6
                _webc.googleTracking("/vpv/register_friend/step_3", "VPV - Register Dementia Friend - Step 3" );
                
            }

        }

    };
    

    _webc.validateLongForm = function() {


        var isError = false;
   
        isError = _webc.validateLongFormBaseData();

        var addrOk = false;
        addrOk = _webc.getFieldValue('df_pca_country') == 'England' ? true : addrOk; 
        addrOk = _webc.getFieldValue('df_pca_country') == 'Guernsey' ? true : addrOk;
        addrOk = _webc.getFieldValue('df_pca_country') == 'Isle of Man' ? true : addrOk;
        addrOk = _webc.getFieldValue('df_pca_country') == 'Wales' ? true : addrOk;

        if ( !addrOk ) {
       
          _webc.setErrorMessage('country', "Sorry. We can only register Friends in England, Guernsey, Isle of Man and Wales.");
           isError=true;
           
       }

    if ( !_webc.isValidDateString(_webc.getFieldValue('birthDate')) && !_webc.isNull('birthDate') ) {
             
                    _webc.setErrorMessage('birthDate', "Please enter a valid date in the format DD/MM/YYYY");
                    isError = true;
             
         } else {
             
                     if ( _webc.getAge(_webc.getFieldValue('birthDate')) < 0 ) {
                     
                        _webc.setErrorMessage('birthDate', "Sorry, birthdate can not be a date in future.");
                         isError= true;
                     
                     }              
        } 
        
                    
       /* Return false if the form fails validation, hence the negative */            
       return !isError;            
                
    };
    
    /*==================== Register Friend Error Management ======================================*/

    _webc.populateLongFormErrors = function(response) {
    
        _webc.populateLongFormBaseErrors(response);
        _webc.setErrorMessage('birthDate',response.birthDateError);
    
    };

    _webc.showLongForm = function() {
    
        $('#intro-text-step-1').hide();
        $('#intro-text-step-2').hide();

        $('#intro-text-step-3').fadeIn();        
        $('#long-register-form').fadeIn();                       
    };

    _webc.hideLongForm = function(isComplete) {
    
       _webc.isLongFormCompleted = isComplete;
       $('#long-register-form').hide();
       $('#intro-text-container').hide();

    };

}; /* End Init Function */

/*==================== Register Dementia Friend SETUP =====================================*/

/*==================== PAGE SETUP =====================================*/

_webc.WebHeader_init = function() {
                                     
                            
    /* Hook the submit up to the action button */ 
    $('#webheader-subscribe-button').click(
        
        function() {
              
            afToggleSubscription(true);                                                                    
            //_webc.doSubscribeAction(true);  
            //_webc.isSubscriber = true;                
            return false;
        
     });
        
     /* Hook the submit up to the action button */ 
    $('#webheader-un-subscribe-button').click(
        
        function() {
            
            afToggleSubscription(false);                                                        
            //_webc.doSubscribeAction(false);
            //_webc.isSubscriber = false;                  
            return false;
        
     });
     
   /*==================== HANDLE SUBSCRIBE BUTTON  =====================================*/
   
   /*=========== SET TOGGLE FUNCTION ==================*/
   _webc.toggleSubscribeDisplay = function(option) {
    
        if ( option ) {

$('[id$=webheader-un-subscribe-container]').show();
$('[id$=webheader-subscribe-container]').hide();
         
         } else {
         
          $('[id$=webheader-un-subscribe-container]').hide();
          $('[id$=webheader-subscribe-container]').show();
         
         }            
    
    };

/*=========== DO TOGGLE ==================*/
_webc.toggleSubscribeDisplay(_webc.isSubscriber);            
    
    _webc.doSubscribeAction = function (option) {           
    
        var message = "";

        var formData = {};
        formData['data'] = {};    
       formData.data['action'] = (option ? 'on' : 'off');
        
        var sJson = JSON.stringify(formData);
        
        $.ajax({
            url: "services/apexrest/friend/toggle-subscribe",
            type: "POST",
            contentType: "application/json",
            data: sJson,
            processData:false,
            dataType: "json",
            beforeSend: function (xhr) { xhr.setRequestHeader('Authorization', "OAuth " + _webc.token); },
            success: function (response, textStatus, jqXHR) {
        
                if (response.returnCode == 0) {

					alert (response.message);
                }
                                    
                else {
                     
         			_webc.toggleSubscribeDisplay(option);
                    
                }

            },
            error: function (jqXHR, textStatus, errorThrown) {
                
                alert(jqXHR.responseText);                    
                
            },
            
            // callback handler that will be called on completion
            // which means, either on success or error
            complete: function () {
            
            }

        })
        
    
   };


} /* End _webc.WebHeaderSubscribe_init */

   /*==================== Register ORG ADMIN SETUP =====================================*/

        _webc.RegisterOrgAdmin_init = function() {

            _webc.iphoneSetup();
             
            /* On intial Page Load the optoins are presented based on location */
            $('[id^=friend-options-text]').hide();
            $('#success-message').hide();
            $('#long-register-form').hide();
            
            
           
            _webc.clearErrors();
             /* Hook the Country select in to the change action */ 
             $('#friend-options-select').val('0');
            // This is from the generic sub form that displays the form
            // Pack Request is not relevant in this case
            $('#little-book').hide();
            $('#packRequest').hide();
            $('#packRequest_container').hide();
            $('#packRequest').val('');
            $('#packRequest').prop('checked', false);
            $('[id$=title-other-container]').hide();
            $('#newsletter').val('');
            $('#newsletter').prop('checked', false);
            $('#birthDate-container').show();
            $('#birthDate-container').removeClass('required');
            $('#helptext').hide();
            $('#birthDateError').show();
            $('[id$=ethnicGroup-other-container]').hide();
            $('[id$=sector-other-container]').hide();
            $('#newsletter').val('');
            $("input[name='proximity']").val('');
            $('[id$=counter]').hide();

            _webc.setupLongFormEvents();
 
           
             
            if ( _webc.inviteId == '' ) {

                    $('#standard-registration').show();
                    $('#friend-options-select').change(
               
                    function() {

                       var country = $(this).val();                                        
                    
                    
                    // England, Guernsey, Wales
                      if ( country=='1'|| country == '2' || country == '3' ){ 

                          $('[id^=friend-options-text]').hide();
                          $('#intro-text-container').show(); 
                          $('#intro-text-step-1').fadeIn();
                          $('#long-register-form').fadeIn();
                          $('#org-register-form').fadeIn();
                          $('#demoInfo-register-form').fadeIn();
                          _webc.setActivePanel('2');
                          //google tracking vpv-9
                          _webc.googleTracking("/vpv/register_organisation/step_2", "VPV - Register Organisation - Step 2" );
                        
                        
                       }

                    // People from Northern Ireland, Scotland or outside the UK cannot register as Friends
                    if (  country=='4'|| country == '5' || country == '99' ){ 
                        
                        $('[id^=intro-text-]').hide();                                      
                        $('#long-register-form').hide();
                        $('#org-register-form').hide();
                        $('#demoInfo-register-form').hide();
                        $('[id^=friend-options-text-]').hide();                  
                        $('#friend-options-texts').show(); 
                        $('#friend-options-text-'+country).fadeIn(); 


            _webc.setActivePanel('1');
                    }            
                           

            });        
            
           }else{
           
                 $('#invite-registration').show();
                 $('#friend-options-title').hide(); 
                 $('#friend-options-select').hide(); 
                 $('[id^=friend-options-text]').hide();                
                 $('#intro-text-container').show();
            
                 $('#intro-text-step-invite').show();
                 $('#long-register-form').show();
                 $('#demoInfo-register-form').show();
                
                 $('[id$=firstName]').val(_webc.inviteName.split(' ')[0]); 
                 $('[id$=lastName]').val(_webc.inviteName.split(' ')[1]);
                                           
                 $('[id$=emailAddress]').val(_webc.inviteEmail);
                 $('[id$=emailAddress]').prop('readonly', true);
                        
                 $('[id$=emailAddress2]').val(_webc.inviteEmail);
                 $('[id$=emailAddress2]').prop('readonly', true);
                 $('[id$=emailAddress2]').hide();
                 $('[id$=emailAddress2_container]').hide();

                 _webc.setActivePanel('2'); 
           
           
           }    

            /*==================== Register Org Admin LONG FORM SUBMIT =====================================*/

            _webc.submitLongForm = function () {

                var message = "";
                _webc.clearErrors();
               
                /* Fix the country options now the user has entered their data */
                $('[id^=friend-options]').hide();
                
                _webc.disableForm('long-form');
                
                var formData = {};            
                formData['data'] = {};
                _webc.putRegistrationBaseData(formData, false);    
                _webc.putDemoInfoData(formData);
                formData = _webc.putGdprSettings(formData);
                _webc.putOrgRegData(formData);                 
                formData.data['birthDate'] = _webc.getFieldValue('birthDate');
                formData.data['inviteId'] = _webc.inviteId;
                var b = _webc.isChecked('newsletter');
                formData.data['newsletter'] = b; 
                                
                var sJson = JSON.stringify(formData.data);
                _webc.invokeSubmitAction(sJson);    
            
            };

            _webc.handleResult = function(response, event) {
                                
                if ( !event.status ) {

                    _webc.setErrorMessage('longServer', event.message);  
                    console.log(event.where);                 
                    _webc.enableForm('long-form');

                } else {


                    if (response.returnCode == 0) {

                        _webc.populateLongFormErrors(response);
                        grecaptcha.reset();
                        //Recaptcha.reload_internal('t');
                        _webc.enableForm('long-form');               

                    }

                    else if ( response.returnCode == -2 ) {                                                

                         _webc.populateLongFormErrors(response);   
                        grecaptcha.reset();
                        //Recaptcha.reload_internal('t');
                         _webc.enableForm('long-form');

                    }
                    
                     else if ( response.returnCode == 3 ) {

                         var e = document.createElement('textarea');
                         e.innerHTML = response.redirectUrl;
                         var decodedUrl = e.value;
                         
                         window.location.replace(decodedUrl);                                           

                    }

                    else {

                        _webc.hideLongForm(true);
                        $('#invite-registration').hide();    
                        $('#success-message').fadeIn(); 
                          
                        _webc.setActivePanel('3');
                        //google tracking vpv-10
                        _webc.googleTracking("/vpv/register_organisation/step_3", "VPV - Register Organisation - Step 3" );                    
                        
                    }

                }

            };
            

            _webc.validateLongForm = function() {
               
              

                var isError = false;
           
                isError = _webc.validateLongFormBaseData();

                var addrOk = false;
                addrOk = _webc.getFieldValue('df_pca_country') == 'England' ? true : addrOk; 
                addrOk = _webc.getFieldValue('df_pca_country') == 'Guernsey' ? true : addrOk;
                addrOk = _webc.getFieldValue('df_pca_country') == 'Isle of Man' ? true : addrOk;
                addrOk = _webc.getFieldValue('df_pca_country') == 'Wales' ? true : addrOk;

                if ( !addrOk ) {
               
                  _webc.setErrorMessage('country', "Sorry. We can only register Friends in England, Guernsey, Isle of Man and Wales.");
                   isError=true;
                   
               }
               
                if ( !_webc.isValidDateStringWithOutNull(_webc.getFieldValue('birthDate')) ) {
             
                    _webc.setErrorMessage('birthDate', "Please enter a valid date in the format DD/MM/YYYY");
                    isError = true;
             
                } else {
             
                     if ( _webc.getAge(_webc.getFieldValue('birthDate')) < 18 ) {
                     
                        _webc.setErrorMessage('birthDate', "Sorry, you need to be over 18 to be an Organisation Admin.");
                         isError= true;
                     
                     }              
                } 
                        
               if ( _webc.inviteId == '' ) {
                var addcOk = false;
                addcOk = _webc.getFieldValue('df_pca_orgCountry') == 'England' ? true : addcOk; 
                addcOk = _webc.getFieldValue('df_pca_orgCountry') == 'Guernsey' ? true : addcOk;
                addcOk = _webc.getFieldValue('df_pca_orgCountry') == 'Isle of Man' ? true : addcOk;
                addcOk = _webc.getFieldValue('df_pca_orgCountry') == 'Wales' ? true : addcOk; 
                   
                if ( !addcOk ) {
               
                  _webc.setErrorMessage('orgCountry', "Sorry. We can only register Organisations in England, Wales, Guernsey and Isle of Man.");
                   isError=true;
                   
                }
                
                if (_webc.isNull('orgName')) {
                    _webc.setErrorMessage('orgName', "** Please enter Organisation Name");
                    isError= true;
                }
                
                if (_webc.isNull('sector') || _webc.getFieldValue('sector')=='NULL') {
                    _webc.setErrorMessage('sector', "** Please enter Sector ");
                    isError= true;
                }
           
                if (_webc.isNull('employees') || _webc.getFieldValue('employees')=='NULL' ) {
                    _webc.setErrorMessage('employees', "** Please enter number of employees");
                    isError= true;
                }
              
                
                 if (_webc.isNull('df_pca_orgPostcode')) {
                    _webc.setErrorMessage('orgPostCode', "Please enter a postcode");
                    isError= true;
                }
                 
                if (_webc.isNull('df_pca_orgStreet') ) {
                    _webc.setErrorMessage('orgStreet', "Please enter the building/street address");
                    isError= true;
                } 
                
                if (_webc.isNull('df_pca_orgCity') && _webc.isNull('df_pca_county') ) {
                    _webc.setErrorMessage('orgCity', "Please enter the city or county");
                    isError= true;
                }
                
                
                
                if (_webc.isNull('orgTelephone') ) {
                    _webc.setErrorMessage('orgTelephone', "Please enter a phone number");
                    isError= true;
                } 
                
                if (!_webc.isValidPhone('orgTelephone') ) {
                
                    _webc.setErrorMessage('orgTelephone', "Please enter your contact number in correct format");
                    isError= true;
                }       
               }   
               /* Return false if the form fails validation, hence the negative */            
               return !isError;            
                        
            };
            
            /*==================== Register Org Admin Error Management ======================================*/

            _webc.populateLongFormErrors = function(response) {
            
             _webc.populateLongFormBaseErrors(response);
             _webc.setErrorMessage('birthDate',response.birthDateError);
             _webc.setErrorMessage('orgName',response.orgNameError);
             _webc.setErrorMessage('sector',response.sectorError);
             _webc.setErrorMessage('employees',response.employeesError);
             _webc.setErrorMessage('orgTelephone',response.orgTelephoneError);
             _webc.setErrorMessage('orgCity',response.orgCityError);
             _webc.setErrorMessage('orgPostcode',response.orgPostCodeError);
             _webc.setErrorMessage('orgCounty',response.orgCountyError);
             _webc.setErrorMessage('orgStreet',response.orgStreetError);
             _webc.setErrorMessage('orgCountry',response.orgCountryError);
            
            };

            _webc.showLongForm = function() {
            
                $('#intro-text-step-1').hide();
                $('#intro-text-step-2').hide();

                $('#intro-text-step-3').fadeIn();        
                $('#long-register-form').fadeIn();                       
            };

            _webc.hideLongForm = function(isComplete) {
            
               _webc.isLongFormCompleted = isComplete;
               $('#long-register-form').hide();
               $('#intro-text-container').hide();

            };
            
            
    /*======================== DF_WEBC_RegisterOrg Data Methods =======================================================*/
    // These methods are relevant where the DF_WEBC_RegisterOrg component is used
    _webc.putOrgRegData = function(formData) {
      formData.data['orgName'] = _webc.getFieldValue('orgName');
      formData.data['sector'] = _webc.getFieldValue('sector');
      formData.data['sectorOther'] = _webc.getFieldValue('sectorOther');
      formData.data['employees'] = _webc.getFieldValue('employees');
      formData.data['orgPostCode'] = _webc.getFieldValue('df_pca_orgPostcode');
      formData.data['orgStreet'] = _webc.getFieldValue('df_pca_orgStreet');
      formData.data['orgCity'] = _webc.getFieldValue('df_pca_orgCity');
      formData.data['orgCounty'] = _webc.getFieldValue('df_pca_orgCounty');
      formData.data['orgCountry'] = _webc.getFieldValue('df_pca_orgCountry');
      formData.data['orgTelephone'] = _webc.getFieldValue('orgTelephone');
     
     }
    
    /*=================================================================================================*/
 
    
        }; /* End Init Function */

    /*==================== Register ORG ADMIN SETUP END =====================================*/