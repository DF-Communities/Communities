/*******************************************
 * Dementia Friendly Communities - Alzheimer's Society
 * Designed by Lakshmi Vasudevan
 * Version 1.0 - 28th April 2017
******************************************/

label.required:after {
    content: " *";
    color: #bc2220;
}
.radioinputlabel{
display: inline-block;
    margin-right: 4px;
    font-weight: 500;
    margin-right: 18px;
    margin-left: 0;
}
.nav-buttons {
    padding:0 10px;
    margin-top: 24px;
    width:100%;
    text-align:center; 
}

.step,.stepactive{
    min-height: 120px; 
    width: 100%;
    border: 1px solid white;
  }

  .stepactive {
    background: #1C1463 ;
    border: 0pt none;
    -webkit-border-radius: 5px !important;
    -moz-border-radius: 5px !important;
    border-radius: 5px !important;
    box-shadow: none;
    display: inline-block;
    padding: 10px;
}
.stepactive p {
    color: #fff;
}
.stepactive h5 {
    color: #FFDE00;
}

  .step-container
{
    width:100%;
    padding:0 0 1em 0;
    margin:0 0 2em 0;
}

.step-tile
{ 
    position:relative;
    float:left;
    width:15%;
    margin: 0 14px 10px 0;
}


.step:hover
{
  border: 1px solid #285987;
}

.step-tile .badge {
  position:absolute;
    top:-4px;
    right:-2px;
    padding: 5px 7px;
    background-color: #ce3c39;
}

.badge {
 background-color: #ce3c39;
}
.badge {
 background-color: #ce3c39;
}


.step-tile .badge.dfc-badge-ok {
    background-color: #0ca90c ;
}
span.validation {
    
    display: inline-block;
    color: white;
    background-color: #ce3c39;
    margin-right: 8px;
    padding: 3px 6px;
    border-radius: 4px;
}
.validation {
    
    display: inline-block;
    color: white;
    background-color: #ce3c39;
    margin-right: 8px;
    margin-top: 8px;
    padding: 3px 6px;
    border-radius: 4px;
}
.hide{
  display: none;

}
.inputText {
    height: 42px;
}
.select{
    font-size: 15px!important;
    height: 42px!important;

}
.user-card {
    background-color: #eeecec;
    border: 1px solid #a5a5a5;
    border-radius: 4px;
    margin: 10px 0px 20px 0;
    padding: 15px 10px 10px 30px;
}

.user-card {
    padding: 15px 10px 10px 10px;    
}

.user-card .form-control {
    display: inline-block;
    width: 60%;
    margin: 0 0 4px 0;
}

.PHONE .user-card {
    padding: 15px 10px 10px 10px;    
}

.user-card label {
    display: inline-block;
    width: 9em;
}

.PHONE .user-card label {
    display: block;
    margin: 8px 0 2px 0;
}

.user-card input[type="text"] {
    display: inline-block;
    margin-top:4px;
    width: 55%;
}

.PHONE .user-card input[type="text"] {
    margin-bottom:4px;
    width: 100%;
}

.add-rep button {
    display: inline-block;
    margin-left: 10px;
}

.add-rep-text {
    display: inline-block;
    margin:10px 0;
}

.add-rep-text:empty {
    display: none;
}


.user-card button {
    display:inline-block;
    margin-right:10px;
  font-size:11px;
}



.form-group {
    margin-bottom: 24px;
}



.dfc-selected-region{
    display: table;
    border-radius: 4px;
    margin:3px 0 40px 0;
    width: 100%;
    border-collapse: collapse;
}
.dfc-selected-region>div {
    display: table-row;
}
.dfc-selected-region>div>div:first-child {
    width: 130px;
    vertical-align: middle;
    text-align: center;
}
.dfc-selected-region>div>div {
    display: table-cell;
    padding: 10px 20px;
    font-weight: bold;
    border: 1px solid #c0c0c0;
    vertical-align: middle;
}
.dfc-selected-daa {
    border: 1px solid #c0c0c0;
    border-radius: 4px;
    padding: 20px 20px;
    margin-bottom: 20px;
    font-weight: bold;
}
 .dfc-selected-daa>div>div {
    display: table-cell;
    vertical-align: middle;
}
.dfc-selected-daa>div>div:first-child {
    width: 90%;
}
.btn-primary2 {
    font-size:11px;
    float:right !important;
}

.btn-action:hover {
    color: #1C1463 !important;
    background: #FFDE00 !important;
}

.selected-region>div {
    display: table-row;
}


div.dfc-selected-region > div {
    display: table-row;
}

.dfc-selected-region > div > div {
    display: table-cell;
    padding:10px 20px;
    font-weight: bold;
    border: 1px solid #c0c0c0;
     vertical-align:middle;
}


.dfc-regions{
    display: table;
    border-radius: 4px;
    margin:3px 0 40px 0;
    width: 100%;
    border-collapse: collapse;
}




.dfc-regions > div >div>div:first-child {
  width:120px;
}
.dfc-regions> div > div>div{
    display: table-cell;
    padding: 10px 20px;
    font-weight: bold;
    border: 1px solid #c0c0c0;
    width: 100%;
}

.dfc-regions> div >div {
    
    display: table-row;
}
.dfc-regions> div > div:hover >div {
    background-color: #f0f0f0;
}


.dfc-regions > div >div>div img {
  width:60px;
    height:74px;
}

.dfc-location>div{
    display: table;
    border-radius: 4px;
    margin:3px 0 40px 0;
    width: 100%;
    border-collapse: collapse;
}




.dfc-location > div >div>div:first-child {
  width:120px;
}
.dfc-location> div > div>div{
    display: table-cell;
    padding: 10px 20px;
    font-weight: bold;
    border: 1px solid #c0c0c0;
    
}

.dfc-location> div >div {
    
    display: table-row;
}
.dfc-location> div > div:hover >div {
    background-color: #f0f0f0;
}


.dfc-location > div >div>div img {
  width:60px;
    height:74px;
}

/* Use less space when displaying the selecte one  than we use when selecting */
.dfc-selected-region > div > div img {
  width:45px;
    height:56px
}

.dfc-selected-region >div > div:first-child {
  width: 130px;
    vertical-align:middle; 
    text-align:center;
}


.dfc-countries {
    display: table;
    border-radius: 4px;
    margin:3px 0 40px 0;
    width: 100%;
    border-collapse: collapse;
}

.dfc-countries > div {
    display: table-row;
}

.dfc-countries > div > div {
    display: table-cell;
    padding: 20px 20px 20px 10px;
    font-weight: bold;
    border: 1px solid #c0c0c0; 
    vertical-align:middle;
}

.dfc-countries > div > div {
    cursor:pointer;
}

.dfc-countries > div:hover > div {
    background-color: #f0f0f0;
}
.one-col-list>div>div:first-child {
    border-top: 0;
}


.one-col-list>div>div>div {
    border-top: 1px solid #c0c0c0;
    border: 1px solid #c0c0c0;
    padding: 10px 16px;
    cursor: pointer;
    
}


.one-col-list > div >div>div:hover{
    background-color: #f0f0f0;
}


.dfc-dup-list >div>div>p>span {
    display: table-cell;
    padding: 10px;
    color: #666;
    border-top: 1px solid #c0c0c0;
}
.dfc-dup-list>div>div{
    display: table;
    width: 100%;
    border-collapse: collapse;
}
.dfc-dup-list>div>div>p {
    display: table-row;
}
.dfc-dup-list>div>div>p>span:last-child {
    text-align: right;
}

.dfc-dup-list {
    width: 100%;
    border: 1px solid #c0c0c0;
    border-radius: 4px;
}
.action-area-option {
    background-color: #eeecec;
    border: 1px solid #a5a5a5;
    border-radius: 4px;
    margin: 10px 0;
    padding: 10px;
}

.action-area-option textarea {
    display: block;
    margin-top: 10px;
    height: 8em;
    width:100%;
    max-width:100%;
    padding: 10px;
    font-size: 14px;
}

.validation {
    
    display: inline-block;
    color: white;
    background-color: #ce3c39;
    margin-right: 8px;
    padding: 3px 6px;
    border-radius: 4px;
}
.wordCount{
    float: right;
}

.uiOutputTextArea {
    height: auto!important;
    min-height: 6em;
    white-space: pre-line;
}


