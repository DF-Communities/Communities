/* Styles for editing tools */

 edit-text .text-copy-btn {

    opacity:0;
    position: absolute;
    top: 4px;
    right: 4px;
    line-height: 18px;
    z-index: 99999;
    transition: opacity .75s ease;
    border: 1px solid #d3d3d3;
    width: auto !important;
    font-weight: normal !important;
    padding: 1px 5px 1px 5px;
    font-size: 12px;
    border-radius: 3px;
 
 }   

 edit-text {
    position:relative;
 }

 edit-text:hover .text-copy-btn {
    opacity: .75;
 }

 edit-text:hover {

    display:inherit;
    border:1px solid #ccc;
    background-color:#eee;
    padding:5px;
    z-index:99999;
    border-radius: 5px;

 }
