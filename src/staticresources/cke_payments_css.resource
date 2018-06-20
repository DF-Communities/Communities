
@media screen and (max-width: 720px) {
    ::-webkit-input-placeholder {
        font-size:12px;
    }
}

.navigation--main {
    z-index: 999999;
}
    
span.wait {
    color: white;
    height:50px;
    background-color: #45882d;
    white-space: nowrap;
    cursor:pointer;
}
    
span.wait img {
    top:-1px;
    position:relative;
}    
    
.show-errors input.invalid,
.show-errors input.ng-invalid, 
.show-errors select.invalid,
.show-errors select.ng-invalid {
   border: 1px solid red;   
   box-shadow: none;
}

.show-errors input[type="radio"].invalid,
.show-errors input[type="radio"].ng-invalid {
   border: none !important;   
}

.show-errors input.invalid:focus,
.show-errors input.ng-invalid:focus {
   border: 2px solid #EF6F6F;
   outline: 0;
}

.form {
   padding-bottom:0;   
}
    
form span.ui-state-error.message {
    display:inline-block;
    visibility:hidden;
}
form span.ui-state-error.message.active {
    visibility:visible;
}
.form-group {
    margin-bottom:0;
}
.container fieldset .row,
.container fieldset .inner-row {
    margin-bottom: 2px;
}

.ng-cloak {
  display: none !important;
}

.waiting fieldset {
    opacity:0.6;
}
    
img.fade {
    opacity:0.4;
}

.alert {
	visibility:hidden;
	margin:12px 0 0 0;    
    min-height:45px;
}

.alert.active {
	visibility:visible;
} 
    
.ui-state-error {
 background:none;   
}

.donation-outline legend {
    margin-bottom: 0px;
}

.pay-line .col-xs-4 {
    padding-left: 6px;
    padding-right: 0;
}

.pay-line .graphic {
  margin-left:6px;
}
