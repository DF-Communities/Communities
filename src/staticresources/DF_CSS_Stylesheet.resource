/*******************************************
 * Dementia Friends - Alzheimer's Society
 * Designed and built by CloudSymphony
 * Version 1.0 - 14th April 2015
******************************************/

/************ Additions / Updates *********/

    /* This styling is necessary to prevent iPhone from zooming the text and the form 
	   Overrides the standard bootstrap styling of 14px */	
    select, select.form-control {
    	font-size : 16px;
    }

    /* Override for single-selects to reset the default 
	   VF puts a Size param on the select which catches one of the Bootstrap std styles
	*/
    select.single-select {
    	height : 34px;
    }
    select.form-control>option {
        background-color:#0073FF;
        color:#ffffff;
    }
    select.form-control>option:hover {
        background-color:#1C1463 !important;
        color:#ffffff;
    }


    .nav>li { 
        list-style-image: none;
    }

/******************************************/



/*******************************************
    Global Styles
******************************************/body {
    background: #eeecec;
    font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif;
    line-height: 1.429em;
    color: #3C3C3C;
    font-size: 14px;    
}
p {
    margin-bottom: 1em;
    line-height: 1.3em;
    color: #3C3C3C;
}
span p {
    
    color: #3C3C3C;
}
p.lead{
    color:#1C1463;
}

h1 { font-size:24px; }

h1,
h2,
h3,
h4,
h5,
h6 {
    font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif;
    font-weight: bold;
    color:#1C1463;
    margin: 0 0 0.714em 0;
}
a{
    color: #0073FF ;
}

a:hover{
   // text-decoration: underline;
   color: #1C1463;
}
p>a.external{
    color: #0073FF !important;
}
p>a.external>font{
    color: #0073FF !important;
}
p>a.external>font:hover{
    color: #1C1463 !important;
}
p>a.external:hover {
   
   color: #1C1463 !important;
}
p>a{
    color: #0073FF !important;
}
p>a:hover{
     color: #1C1463 !important;
}

ul {
    padding: 0 0 0 2.143em;
}
ul li {
    list-style-image: url('DF_WEBR_Assets/img/flower-icon.png');
}

ul li a,ul >li a.external {
    color: #0073FF;
}
ul li.active {
    color: #1C1463;
    font-weight: bold;
}
ul li a:active 
ul li a:hover,
ul li a:active,
ul li a:focus,
ul li a:hover,
ul li a:focus,
ul li a.external:hover,
ul li a.external:active {
    color: #1C1463;
    font-weight: bold;
}
ul li.inactive {
    list-style-image: url('DF_WEBR_Assets/img/padlock-icon.png');
    color: #999;
}
.external > span {
  position: absolute;
  left: -999px;
  top: auto;
  width: 1px;
  height: 1px;
  overflow: hidden;
}

@media(min-width:1200px){
    .container{width:970px !important;}
}

ul.plain {
	padding : 0;
}

ul.plain li {
  list-style-type: none;
  list-style-image: none;
 }

/*******************************************
    Brand Styles
******************************************/

.primary {
    color: #1C1463;
}
//reskin twitter icon
.social-icon{
  color:#0073FF;
}
.webarticle-link{
  color:#0073FF !imporatant;  
}

.i.fa.fa-twitter.social-icon{
  color:#0073FF;
    
}
.light {
    color: #fff;
}
.dark {
    color: #330000;
}
.rounded {
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
}

/*** Button Styles ***/

.btn-sm {
    font-size: 1em;
}
.btn {
    font-size: 1em;
	white-space: normal;
}

.btn-lg {
    font-size: 1.429em;
}
.btn-default {
    font-weight: bold !important;
    color: #3C3C3C !important;
    background: #DEE0E2 !important;
    padding: 0.571em 1.071em !important;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    text-decoration: none !important;
    border: 0pt none;   
}
.btn-primary {
    font-weight: bold !important;
    color: #1C1463 !important;
    background: #FFDE00 !important;
    padding: 0.571em 1.071em !important;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    text-decoration: none !important;
    border: 0pt none;  
}

.btn-slider {
    font-weight: bold !important;
    color: #fff !important;
    background: #38A64A !important;
    padding: 0.571em 1.071em !important;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    text-decoration: none !important;
    border: 0pt none;  
}

.btn-action {
    font-weight: bold !important;
    color: #fff !important;
    background: #1C1463 !important;
    padding: 0.571em 1.071em !important;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    text-decoration: none !important;
    border: 0pt none;  
}
.btn-inactive {
    font-weight: bold !important;
    color: #999 !important;
    background: #eeecec !important;
    padding: 0.571em 1.071em !important;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    text-decoration: none !important;
    border: 0pt none;   
}
.btn-dashboard {
    font-weight: bold !important;
    color: #1C1463 !important;
    background: #FFDE00 !important;
    padding: 0.571em 1.071em !important;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    text-decoration: none !important;
    border: 0pt none;  
}
.btn-default:hover{
   color: #fff !important;
   background: #3C3C3C !important;  
}
.btn-action:hover {
    color: #1C1463 !important;
    background: #FFDE00 !important;
}
.btn-primary:hover {
    color: #fff !important;
    background: #1C1463 !important;
}
.btn-dashboard:hover {
    color: #fff !important;
    background: #0073FF !important;
}
.btn-slider:hover {
    color: #fff !important;
    background: #006938 !important;
}
.btn-inactive:hover {
    color: #999;
}

/*******************************************
    General Styles
******************************************/

.container {
    background: #fff;
}

/*** Header ***/

.header {
    padding: 1.429em 0 .5em 0;
}
.counter {
    margin: 1.071em 0 0 0;
}
.counter span strong {
	color: #330000;
}
.org-counter {
	margin: -1.071em 0 0 0;
}
.register {
    margin: 1.429em 0 0 0;
    text-align: right;
}
.logged-in {
    margin: 0.714em 0 0 0;
    text-align: right;
}
.logged-in p {
    margin: 0 0 0.714em 0;
}
/*** .newsletter-subscribe {
	margin: 10px 0 0 0;
} ***/

.newsletter-subscribe {
	text-align: right;
	margin: -30px 0 0 0;
}

/*** Navigation ***/

.navbar-default {
    background:#1C1463;
    border: 0pt none;
    color: #fff;
    font-weight: bold;
    font-size: 1.143em;
}
.navbar-default .navbar-nav>li>a {
    color: #fff;
}
.navbar-default .navbar-nav>li>a:hover,
.navbar-default .navbar-nav>li>a:active,
.navbar-default .navbar-nav>li>a:focus,
.navbar-default .navbar-nav>.open>a,
.navbar-default .navbar-nav>.open>a:hover,
.navbar-default .navbar-nav>.open>a:focus
{
    color: #fff;
    background: #0073FF;
}
.navbar-default .navbar-nav>.active>a,
.navbar-default .navbar-nav>.active>a:hover,
.navbar-default .navbar-nav>.active>a:focus,
.navbar-default .navbar-nav>li>a.twitter,
.navbar-default .navbar-nav>li>a.facebook,
.navbar-default .navbar-nav>li>a.blog {
    background: #0073FF;
    border: 0pt none;
    color: #fff;    
}
.navbar-default .navbar-nav>li>a.twitter:hover,
.navbar-default .navbar-nav>li>a.facebook:hover,
.navbar-default .navbar-nav>li>a.blog:hover {
    color: #fff !important;
  	background: #1C1463 !important;
	border: 0pt none !important;
}
.navbar-default .navbar-nav>.dropdown>a .caret {
    border-top-color: #fff;
    border-bottom-color: #fff;
}
.nav>li>a {
    padding: 1.071em 1.071em;
}
.navbar-default .navbar-toggle .icon-bar {
    background-color: #fff; 
}
.navbar-default .navbar-toggle {
  border-color: #fff;
}
.navbar-collapse {
    box-shadow: none;
}
.dropdown-menu {
    background: #0073FF;
    border: 0pt none;
}
.dropdown-menu>li {
    list-style-image: none;
}
.dropdown-menu>li>a {
    color: #fff;
    font-weight: bold;
    padding: 0.714em 1.429em;
}
.dropdown-menu>li>a:hover {
    background: #1C1463;
    color: #fff;
}

/*** Dropdown ***/

@media only screen and (min-width:769px) {
.dropdown:hover .dropdown-menu {
    display: block;
}
.dropdown-submenu {
    position: relative !important;
}

.dropdown-submenu>.dropdown-menu {
    top: 0 !important;
    left: 100% !important;
    margin-top: -6px !important;
    margin-left: -1px !important;
    border-radius: 0 !important;
}

.dropdown-submenu:hover>.dropdown-menu {
    display: block !important;
}

.dropdown-submenu>a:after {
    display: block;
    content: "\f105";
    font-family: 'FontAwesome';
    margin-top: -18px;
    right: 15px;
    position: absolute;
    font-weight: 300;
}
}

/*** Social icons ***/

a.facebook,
a.twitter {
    font-size: 28px;
    padding: 13px 15px !important;
    margin: 0 0 0 0;
}
a.blog {
    font-size: 28px;
    padding: 17px 15px !important;
    margin: 0 0 0 0;
}



/*** Breadcrumb navigation ***/

.breadcrumb {
    padding: 0px;
    background: transparent;
}
.breadcrumb>.active {
    color: #3C3C3C;
}

/*** Sidebar ***/

.sidebar {
    margin: 2.857em 0 0 0;
}
.sidebar-block {
    border-top: solid 10px #38A64A;
    margin: 2.857em 0 0 0;
    padding: 0 0 0 0; 
}
.sidebar-block h3 {
    margin: 1.429em 0 0.714em 0;
}

/*** Tabs ***/

.nav-tabs>li.active>a,
.nav-tabs>li.active>a:focus,
.nav-tabs>li.active>a:hover {
	font-weight: bold;
	font-size: 1.143em;
  	color: #fff;
  	background: #0073FF;
	border: 0pt none;
	-webkit-border-radius-top-left: 5px !important;
    -moz-border-radius-top-left: 5px !important;
    border-radius-top-left: 5px !important;
	-webkit-border-radius-top-right: 5px !important;
    -moz-border-radius-top-right: 5px !important;
    border-radius-top-right: 5px !important;
	padding: 0.714em 1.071em;
}

.nav-tabs>li>a {
	font-weight: bold;
	font-size: 1.143em;
  	color: #fff;
  	background: #1C1463;
	border: 0pt none;
	-webkit-border-radius-top-left: 5px !important;
    -moz-border-radius-top-left: 5px !important;
    border-radius-top-left: 5px !important;
	-webkit-border-radius-top-right: 5px !important;
    -moz-border-radius-top-right: 5px !important;
    border-radius-top-right: 5px !important;
	padding: 0.714em 1.071em;
  	margin-right: 2px;
}
.nav-tabs>li>a:hover {
	font-weight: bold;
	font-size: 1.143em;
  	color: #330000;
  	background: #eeecec;
	border: 0pt none;
	-webkit-border-radius-top-left: 5px !important;
    -moz-border-radius-top-left: 5px !important;
    border-radius-top-left: 5px !important;
	-webkit-border-radius-top-right: 5px !important;
    -moz-border-radius-top-right: 5px !important;
    border-radius-top-right: 5px !important;
	padding: 0.714em 1.071em;
  	margin-right: 2px;
}

/*** Datepicker ***/

.datepicker.dropdown-menu {
    background : #ccc;
}

/*** Collapsible Panels ***/

.panel {
    box-shadow: none;
}
.panel-group {
    margin-bottom: 0.714em;
}
.panel-default {
    border-color: transparent;
}
.panel-default>.panel-heading {
    background: #1C1463;
    color: #fff;
    border-color: transparent;
}
.panel-heading {
    -webkit-border-top-left-radius: 5px !important;
    -moz-border-top-left-radius: 5px !important;
    border-top-left-radius: 5px !important;
    -webkit-border-top-right-radius: 5px !important;
    -moz-border-top-right-radius: 5px !important;
    border-top-right-radius: 5px !important;
}

.panel-title>a {
    color: #fff;
}

.panel-body {
    background: #F4F4F4;
    border-bottom: solid 4px #ccc;
}

/*** Well Styling ***/

.well {
    background: #F4F4F4;
    border: 0pt none;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    box-shadow: none;
    border-bottom: solid 4px #ccc;
    padding: 1.071em;
}
.well-primary {
    background: #ffcc00;
    color: #330000;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    box-shadow: none;
    border-bottom: 4px solid #e6bd00 !important;
    padding: 2.143em 1.071em 1.071em 1.071em;
    text-align: center;
    margin-bottom: 1.429em;
}
.well-primarynew {
    background: #38A64A;
    color: #FFFFFF;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    box-shadow: none;
    border-bottom: 4px solid #38A64A !important;
    padding: 2.143em 1.071em 1.071em 1.071em;
    text-align: center;
    margin-bottom: 1.429em;
}
.well-primary p {
    color: #330000;
    font-size: 1.286em;
}
label {
    color: #330000;
    text-align: left !important;
}

/*** Table Styling ***/

/*Additions - June 2015 */

table td.single-cell div.btn-container {
   text-align : center;
   vertical-align: middle;   
   margin-top : 1.5em;     
}

table td.single-cell div.btn-group >.btn-xs {
           margin-top: 8px;
           display: block;
           width: 120px;
}

table td.single-cell div.btn-single >.btn-xs {
           display: block;
	   width:120px;
}

table>tr.session>td.single-cell {
   border-right: solid 1px #fff;
}

/* End additions *********************/

/* Jan 2016 */

table td.single-cell div.btn-stacked {
           margin-bottom: 12px;           
}
div.eventdetails{
  color:#3C3C3C;  
}

/* End Jan 2016 */


.table {
    border-spacing: 2px;
}
tr th {
    font-size: 1.286em;
    color: #330000;
}
.table>thead>tr>th {
    border-bottom: 0pt none;
}
.table>tbody>tr>td.date,
.table>tbody>tr>td.time,
.table>tbody>tr>td.details {
    text-align: center;
    vertical-align: middle;
    border-right: solid 1px #fff;
}
.available {
    border-left: solid 5px #66cc33;
}

.available.sessions{
    border-left: solid 5px #38A64A;
}
.unavailable {
    border-left: solid 5px #ff0000;
}
.available-highlight,
.unavailable-highlight {
    color: #fff;
    padding: 0.571em 1.071em;
    margin-top: 0.357em;
    display: inline-block;   
}
.available-highlight {
    background: #66cc33;
}
.unavailable-highlight {
    background: red;
}
.table>tbody>tr>td.location,
.table>tbody>tr>td.description {
    text-align: left;
    vertical-align: middle;
    border-right: solid 1px #fff;
}
.table>tbody>tr>td.location {
    color: #330000;
}

/*** Form Styling ***/

.form-horizontal hr {
  margin-top: 20px;
  margin-bottom: 20px;
  border: 0;
  border-top: 2px solid #fff;
}
/* Adds red asterisk after label if form element is required */

.form-group.required .control-label:after {
  content:" *";
  color:#bc2220;
}

/*** Counter ***/

.pricing-unit {
    float: left;
    margin: 0 0 5px 0;
    padding: 0 0 0 0;
}
.pricing-unit-value {
    padding: 0.3125em 0.5em 0.3125em 0.5em;
    border: #111 0.0625em solid;
    border-radius: 0.125em;
    background: #111 url('DF_WEBR_Assets/img/counter-bg.gif') center center;

    font-weight: bold;
    font-size: 1.2em;
    margin-right: -0.125em;
    color: #fff;
    line-height: 3em;
}
.pricing-unit-comma {
    font-weight: bold;
    font-size: 1.2em;
    margin-right: -0.125em;
    color: #333;
}

.fb-like-box,
.twitter-box1 {
    padding: 0px 10px 0px 10px;
    margin-bottom: 30px;
}

/*** Footer ***/

.footer {
    border-top: solid 10px #38A64A;
    margin: 2.857em 0 0 0;
    padding: 1.429em 0; 
}

/*******************************************
    Page Styles
******************************************/

/*** Home Page ***/

.thumbnail {
    padding: 0px;
    border: 0pt none;
}
.thumbnail img {
    -webkit-border-top-left-radius: 5px !important;
    -moz-border-top-left-radius: 5px !important;
    border-top-left-radius: 5px !important;
    -webkit-border-top-right-radius: 5px !important;
    -moz-border-top-right-radius: 5px !important;
    border-top-right-radius: 5px !important;
}
.primary-process {
    background: #ffcc00;
    color: #330000;
    -webkit-border-bottom-left-radius: 5px !important;
    -moz-border-bottom-left-radius: 5px !important;
    border-bottom-left-radius: 5px !important;
    -webkit-border-bottom-right-radius: 5px !important;
    -moz-border-bottom-right-radius: 5px !important;
    border-bottom-right-radius: 5px !important;
    border-bottom: 4px solid #e6bd00 !important;
}
.secondary-process {
    background: #1C1463;
    color: #fff;
    -webkit-border-bottom-left-radius: 5px !important;
    -moz-border-bottom-left-radius: 5px !important;
    border-bottom-left-radius: 5px !important;
    -webkit-border-bottom-right-radius: 5px !important;
    -moz-border-bottom-right-radius: 5px !important;
    border-bottom-right-radius: 5px !important;
    border-bottom: 4px solid #1c4062 !important;
}
.primary-process h3 a {
    color: #330000;
}
.secondary-process h3 a {
    color: #fff;
}
.secondary-process {
    background: #1C1463;
    color: #fff;
}
.primary-process h3,
.secondary-process h3 {
    padding: 0.714em;
    margin: 0px;
    font-size: 1.571em;
}
.thumbnail a:hover {
    text-decoration: underline !important;
}
.home-about {
    border-bottom: solid 10px #38A64A;
    margin: 0 0 1.429em 0;
    padding: 0.714em 0 2.143em 0; 
}
.{
color:#0073FF !important;
}

/*** Home Page Carousel ***/

#myCarousel {
    margin-bottom: 1.429em;
}
#myCarousel  .carousel-caption {
	top: 75%;
	right: 1.429em;
	bottom: 1.429em;
	text-align: right;
  	height:auto;
	color:#432A18;/*#FFF*/
	text-shadow:none;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
}
#myCarousel  .carousel-caption a {
    font-size: 20px;
}
i.fa.fa-chevron-right{
    height: 1px;
    width: 10px;
}
i.fa.fa-chevron-left{
    height: 1px;
    width: 15px;
}
.carousel-control {
	color: #fff;
	top: 44%;
	background: #fff;
	bottom: auto;
	padding-top: 0.450em;
	width: 36px;
	border-radius: 50%;
	height: 36px;
	opacity: 1;
}
.carousel-control.left, .carousel-control.right {
	background-image:none !important;
    background:#38A64A;
}
.carousel-control.left:hover, .carousel-control.right:hover {
    background-image:none !important;
    background:#006938;
}
.carousel-control.right,
.carousel-control .glyphicon-chevron-right {
	left:auto;
	right:-1.143em;
    color: #FFFFFF;
    text-shadow:none;
}
.carousel-control.left {
	right:auto;
	left:-1.143em;
    color: #FFFFFF;
    text-shadow:none;
}

.glyphicon{
  color:#38A64A;   
}


/*** Register Pages ***/

.step-container {
    border-bottom: solid 10px #38A64A;
    margin: 0 0 2.857em 0;
    padding: 0 0 1.429em 0; 
}
.step {
    background: #F4F4F4;
    border: 0pt none;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    box-shadow: none;
    display: inline-block;
    padding: 10px;
}
.step-active {
    background: #1C1463;
    border: 0pt none;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    box-shadow: none;
    display: inline-block;
    padding: 10px;
}
.step-active h5 {
    color: #FFDE00;
}
.step-active p {
    color: #fff;
}


/*** Dashboard Page ***/

ul.status li {
    list-style-image: url('DF_WEBR_Assets/img/complete-icon.png');
    color:#3C3C3C;
    font-size: 1.143em;
    line-height: 2.143em;
}
ul.status li.incomplete {
    list-style-image: url('DF_WEBR_Assets/img/incomplete-icon.png');
    font-size: 1.143em;
    line-height: 2.143em;
}

.dashboard-block {
    background: #1C1463;
    color:#FFFFFF;
    padding: 1.071em 1.071em 0px 1.071em;
    text-align: center;
    margin-bottom: 2.143em;
    border-bottom: 4px solid #1C1463 !important;  
}
.dashboard-block h3,
.dashboard-block p {
    color: #fff;
}
.dashboard-block h3 {
    margin: 0 0 0.714em 0;
}

/*** Organisation Dashboard Page ***/


.play-icon {
    background: url("DF_WEBR_Assets/img/play-icon-small.png") no-repeat;
    width: 66px;
    height: 65px;
    position: absolute;
    left: 50%;
    margin-left: -33px;
    top: 50%;
    margin-top: -100px;
    cursor: pointer;
}
.video-time {
    position: absolute;
    top: 0px;
    right: 15px;
    padding: 5px 10px;
    color: white;
    background: #000;
    background: rgba(0 ,0, 0, 0.5);
}
.captions {
  background: url("DF_WEBR_Assets/img/captions-icon.gif") center no-repeat rgba(0,0,0, 0.3);
  width: 38px;
  height: 28px;
  position: absolute;
  bottom: 11px;
  right: 0px;
  cursor: pointer;
}
a.translink {
  color: #5c93c7;
  text-decoration: underline;
  font-size: 12px;
  padding-left: 25px;
  background: url("DF_WEBR_Assets/img/transcript-icon.png") no-repeat;
  min-height: 19px;
  display: block;
  cursor: pointer;
}

/*** Sessions Page ***/

span.day {
    font-size: 2.143em;
    font-weight: bold;
    color: #1C1463;
    margin-top: -0.714em;
}
span.has-error{
    color:#a94442;
}
.panel-default>.panel-alt-heading {
    background: #1C1463;
}
.panel-default>.panel-alt-heading.paneltitle {
   background: #38A64A !important;
}
.filter h4 {
    margin-bottom: 0px;
}
.session {
    background: #eeeced;
    background: #eeedec; /* Old browsers */
    background: -moz-linear-gradient(top,  #eeedec 0%, #ffffff 100%); /* FF3.6+ */
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#eeedec), color-stop(100%,#ffffff)); /* Chrome,Safari4+ */
    background: -webkit-linear-gradient(top,  #eeedec 0%,#ffffff 100%); /* Chrome10+,Safari5.1+ */
    background: -o-linear-gradient(top,  #eeedec 0%,#ffffff 100%); /* Opera 11.10+ */
    background: -ms-linear-gradient(top,  #eeedec 0%,#ffffff 100%); /* IE10+ */
    background: linear-gradient(to bottom,  #eeedec 0%,#ffffff 100%); /* W3C */
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#eeedec', endColorstr='#ffffff',GradientType=0 ); /* IE6-9 */
}
.paging {
    margin: 1.429em 0 0 0;
}
.paging p {
    margin-bottom: 1.429em;
}

/*** Press Page ***/

.press-thumb {
    margin: 0 0 1.429em 1.429em;
}

/*************************************************
    Customise elements for tablet portrait view
************************************************/

@media (max-width: 991px) {
    .counter {
        display: none;
    }
    .navbar-header {
        float: none;
    }
    .navbar-toggle {
        display: block;
    }
    .navbar-collapse {
        border-top: 1px solid transparent;
        box-shadow: inset 0 1px 0 rgba(255,255,255,0.1);
    }
    .navbar-collapse.collapse {
        display: none!important;
    }
    .navbar-nav {
        float: none!important;
        margin: 7.5px -15px;
    }
    .navbar-nav>li {
        float: none;
    }
    .navbar-nav>li>a {
        padding-top: 10px;
        padding-bottom: 10px;
    }
    .navbar-text {
        float: none;
        margin: 15px 0;
    }
    /* since 3.1.0 */
    .navbar-collapse.collapse.in { 
        display: block !important;
    }
    .collapsing {
        overflow: hidden!important;
    }
    #myCarousel  .carousel-caption {
		top: 68%;
		right: 1.429em;
		bottom: 1.429em;
		text-align: right;
		height:auto;
		color:#432A18;/*#FFF*/
		text-shadow:none;
		-webkit-border-radius: 5px !important;
		-moz-border-radius: 5px !important;
		border-radius: 5px !important;
	}
}

/*******************************************
    Customise elements for mobile view
******************************************/
@media ( max-width: 550px ) {

    .register .btn-default {
        margin-top: -30px;
        width: 120px;
    }

}

.register .btn-default, .register .btn-action ,.register .btn-primary {

	width : 120px;

	}

/*
	.register .btn-default {
        margin-top: -30px;
        width: 120px;
    }
*/
	
@media (max-width: 767px) {

    .counter,
    .step-container {
        display: none;
    }
    .navbar-default .navbar-nav .open .dropdown-menu>li>a {
        color: #fff !important;
        font-size: 1.143em;
        line-height: 2.143em;
    }
    .navbar-nav .open .dropdown-menu {
        background: #0073FF;  
    }
    
	.register .btn-action {
        margin-top: 0em;
        width: 120px;
    }
	
    .logged-in .btn-default {
        margin-top: 0;
        width: 150px;
    }
    .logged-in .btn-primary {
        margin-top: 0;
        width: 150px;
    }
    .logged-in .btn-action {
        margin-top: 0.714em;
        width: 150px;
    }

    #webheader-subscribe-link {
        margin : 35px 0 10px 0;
    }

	#myCarousel  .carousel-caption {
		top: 50%;
		right: 1.429em;
		bottom: 1.429em;
		text-align: right;
		height:auto;
		color:#432A18;/*#FFF*/
		text-shadow:none;
		-webkit-border-radius: 5px !important;
		-moz-border-radius: 5px !important;
		border-radius: 5px !important;
	}

	#myCarousel  .carousel-caption a {
		font-size: 15px;
	}
	.about {
    	border-top: solid 4px #ccc;
    	padding: 2.143em 0 2.143em 0; 
		margin: 0 0 0 0;	
	}
	
	
	
}