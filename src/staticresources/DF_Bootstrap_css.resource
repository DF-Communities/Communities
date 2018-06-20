/* Bootstrap 
   Namespaced to .dfbs
   V1.0
*/

html {
	font-family: sans-serif;
	-ms-text-size-adjust: 100%;
	-webkit-text-size-adjust: 100%
}

.dfbs body {
	margin: 0
}

.dfbs article,
.dfbs aside,
.dfbs details,
.dfbs figcaption,
.dfbs figure,
.dfbs footer,
.dfbs header,
.dfbs hgroup,
.dfbs main,
.dfbs menu,
.dfbs nav,
.dfbs section,
.dfbs summary {
	display: block
}

.dfbs audio,
.dfbs canvas,
.dfbs progress,
.dfbs video {
	display: inline-block;
	vertical-align: baseline
}

.dfbs audio:not([controls]) {
	display: none;
	height: 0
}

.dfbs [hidden],
.dfbs template {
	display: none
}

.dfbs a {
	background-color: transparent
}

.dfbs a:active,
.dfbs a:hover {
	outline: 0
}

.dfbs abbr[title] {
	border-bottom: 1px dotted
}

.dfbs b,
.dfbs strong {
	font-weight: 700
}

.dfbs dfn {
	font-style: italic
}

.dfbs h1 {
	font-size: 2em;
	margin: .67em 0
}

.dfbs mark {
	background: #ff0;
	color: #000
}

.dfbs small {
	font-size: 80%
}

.dfbs sub,
.dfbs sup {
	font-size: 75%;
	line-height: 0;
	position: relative;
	vertical-align: baseline
}

.dfbs sup {
	top: -.5em
}

.dfbs sub {
	bottom: -.25em
}

.dfbs img {
	border: 0
}

.dfbs svg:not(:root) {
	overflow: hidden
}

.dfbs figure {
	margin: 1em 40px
}

.dfbs hr {
	box-sizing: content-box;
	height: 0
}

.dfbs pre {
	overflow: auto
}

.dfbs code,
.dfbs kbd,
.dfbs pre,
.dfbs samp {
	font-family: monospace, monospace;
	font-size: 1em
}

.dfbs button,
.dfbs input,
.dfbs optgroup,
.dfbs select,
.dfbs textarea {
	color: inherit;
	font: inherit;
	margin: 0
}

.dfbs button {
	overflow: visible
}

.dfbs button,
.dfbs select {
	text-transform: none
}

.dfbs button,
.dfbs html input[type=button],
.dfbs input[type=reset],
.dfbs input[type=submit] {
	-webkit-appearance: button;
	cursor: pointer
}

.dfbs button[disabled],
.dfbs html input[disabled] {
	cursor: default
}

.dfbs button::-moz-focus-inner,
.dfbs input::-moz-focus-inner {
	border: 0;
	padding: 0
}

.dfbs input {
	line-height: normal
}

.dfbs input[type=checkbox],
.dfbs input[type=radio] {
	box-sizing: border-box;
	padding: 0
}

.dfbs input[type=number]::-webkit-inner-spin-button,
.dfbs input[type=number]::-webkit-outer-spin-button {
	height: auto
}

.dfbs input[type=search] {
	-webkit-appearance: textfield;
	box-sizing: content-box
}

.dfbs input[type=search]::-webkit-search-cancel-button,
.dfbs input[type=search]::-webkit-search-decoration {
	-webkit-appearance: none
}

.dfbs fieldset {
	border: 1px solid silver;
	margin: 0 2px;
	padding: .35em .625em .75em
}

.dfbs legend {
	border: 0;
	padding: 0
}

.dfbs textarea {
	overflow: auto
}

.dfbs optgroup {
	font-weight: 700
}

.dfbs table {
	border-collapse: collapse;
	border-spacing: 0
}

.dfbs td,
.dfbs th {
	padding: 0
}

@media print {
	.dfbs *,
	.dfbs :after,
	.dfbs :before {
		background: 0 0!important;
		color: #000!important;
		box-shadow: none!important;
		text-shadow: none!important
	}
	.dfbs a,
	.dfbs a:visited {
		text-decoration: underline
	}
	.dfbs a[href]:after {
		content: " (" attr(href) ")"
	}
	.dfbs abbr[title]:after {
		content: " (" attr(title) ")"
	}
	.dfbs a[href^="javascript:"]:after,
	.dfbs a[href^="#"]:after {
		content: ""
	}
	.dfbs blockquote,
	.dfbs pre {
		border: 1px solid #999;
		page-break-inside: avoid
	}
	.dfbs thead {
		display: table-header-group
	}
	.dfbs img,
	.dfbs tr {
		page-break-inside: avoid
	}
	.dfbs img {
		max-width: 100%!important
	}
	.dfbs h2,
	.dfbs h3,
	.dfbs p {
		orphans: 3;
		widows: 3
	}
	.dfbs h2,
	.dfbs h3 {
		page-break-after: avoid
	}
	.dfbs .navbar {
		display: none
	}
	.dfbs .btn>.caret,
	.dfbs .dropup>.btn>.caret {
		border-top-color: #000!important
	}
	.dfbs .label {
		border: 1px solid #000
	}
	.dfbs .table {
		border-collapse: collapse!important
	}
	.dfbs .table td,
	.dfbs .table th {
		background-color: #fff!important
	}
	.dfbs .table-bordered td,
	.dfbs .table-bordered th {
		border: 1px solid #ddd!important
	}
}

@font-face {
	font-family: 'Glyphicons Halflings';
	src: url(../fonts/glyphicons-halflings-regular.eot);
	src: url(../fonts/glyphicons-halflings-regular.eot?#iefix) format('embedded-opentype'), url(../fonts/glyphicons-halflings-regular.woff2) format('woff2'), url(../fonts/glyphicons-halflings-regular.woff) format('woff'), url(../fonts/glyphicons-halflings-regular.ttf) format('truetype'), url(../fonts/glyphicons-halflings-regular.svg#glyphicons_halflingsregular) format('svg')
}

.dfbs .glyphicon {
	position: relative;
	top: 1px;
	display: inline-block;
	font-family: 'Glyphicons Halflings';
	font-style: normal;
	font-weight: 400;
	line-height: 1;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale
}

.dfbs .glyphicon-asterisk:before {
	content: "\002a"
}

.dfbs .glyphicon-plus:before {
	content: "\002b"
}

.dfbs .glyphicon-eur:before,
.dfbs .glyphicon-euro:before {
	content: "\20ac"
}

.dfbs .glyphicon-minus:before {
	content: "\2212"
}

.dfbs .glyphicon-cloud:before {
	content: "\2601"
}

.dfbs .glyphicon-envelope:before {
	content: "\2709"
}

.dfbs .glyphicon-pencil:before {
	content: "\270f"
}

.dfbs .glyphicon-glass:before {
	content: "\e001"
}

.dfbs .glyphicon-music:before {
	content: "\e002"
}

.dfbs .glyphicon-search:before {
	content: "\e003"
}

.dfbs .glyphicon-heart:before {
	content: "\e005"
}

.dfbs .glyphicon-star:before {
	content: "\e006"
}

.dfbs .glyphicon-star-empty:before {
	content: "\e007"
}

.dfbs .glyphicon-user:before {
	content: "\e008"
}

.dfbs .glyphicon-film:before {
	content: "\e009"
}

.dfbs .glyphicon-th-large:before {
	content: "\e010"
}

.dfbs .glyphicon-th:before {
	content: "\e011"
}

.dfbs .glyphicon-th-list:before {
	content: "\e012"
}

.dfbs .glyphicon-ok:before {
	content: "\e013"
}

.dfbs .glyphicon-remove:before {
	content: "\e014"
}

.dfbs .glyphicon-zoom-in:before {
	content: "\e015"
}

.dfbs .glyphicon-zoom-out:before {
	content: "\e016"
}

.dfbs .glyphicon-off:before {
	content: "\e017"
}

.dfbs .glyphicon-signal:before {
	content: "\e018"
}

.dfbs .glyphicon-cog:before {
	content: "\e019"
}

.dfbs .glyphicon-trash:before {
	content: "\e020"
}

.dfbs .glyphicon-home:before {
	content: "\e021"
}

.dfbs .glyphicon-file:before {
	content: "\e022"
}

.dfbs .glyphicon-time:before {
	content: "\e023"
}

.dfbs .glyphicon-road:before {
	content: "\e024"
}

.dfbs .glyphicon-download-alt:before {
	content: "\e025"
}

.dfbs .glyphicon-download:before {
	content: "\e026"
}

.dfbs .glyphicon-upload:before {
	content: "\e027"
}

.dfbs .glyphicon-inbox:before {
	content: "\e028"
}

.dfbs .glyphicon-play-circle:before {
	content: "\e029"
}

.dfbs .glyphicon-repeat:before {
	content: "\e030"
}

.dfbs .glyphicon-refresh:before {
	content: "\e031"
}

.dfbs .glyphicon-list-alt:before {
	content: "\e032"
}

.dfbs .glyphicon-lock:before {
	content: "\e033"
}

.dfbs .glyphicon-flag:before {
	content: "\e034"
}

.dfbs .glyphicon-headphones:before {
	content: "\e035"
}

.dfbs .glyphicon-volume-off:before {
	content: "\e036"
}

.dfbs .glyphicon-volume-down:before {
	content: "\e037"
}

.dfbs .glyphicon-volume-up:before {
	content: "\e038"
}

.dfbs .glyphicon-qrcode:before {
	content: "\e039"
}

.dfbs .glyphicon-barcode:before {
	content: "\e040"
}

.dfbs .glyphicon-tag:before {
	content: "\e041"
}

.dfbs .glyphicon-tags:before {
	content: "\e042"
}

.dfbs .glyphicon-book:before {
	content: "\e043"
}

.dfbs .glyphicon-bookmark:before {
	content: "\e044"
}

.dfbs .glyphicon-print:before {
	content: "\e045"
}

.dfbs .glyphicon-camera:before {
	content: "\e046"
}

.dfbs .glyphicon-font:before {
	content: "\e047"
}

.dfbs .glyphicon-bold:before {
	content: "\e048"
}

.dfbs .glyphicon-italic:before {
	content: "\e049"
}

.dfbs .glyphicon-text-height:before {
	content: "\e050"
}

.dfbs .glyphicon-text-width:before {
	content: "\e051"
}

.dfbs .glyphicon-align-left:before {
	content: "\e052"
}

.dfbs .glyphicon-align-center:before {
	content: "\e053"
}

.dfbs .glyphicon-align-right:before {
	content: "\e054"
}

.dfbs .glyphicon-align-justify:before {
	content: "\e055"
}

.dfbs .glyphicon-list:before {
	content: "\e056"
}

.dfbs .glyphicon-indent-left:before {
	content: "\e057"
}

.dfbs .glyphicon-indent-right:before {
	content: "\e058"
}

.dfbs .glyphicon-facetime-video:before {
	content: "\e059"
}

.dfbs .glyphicon-picture:before {
	content: "\e060"
}

.dfbs .glyphicon-map-marker:before {
	content: "\e062"
}

.dfbs .glyphicon-adjust:before {
	content: "\e063"
}

.dfbs .glyphicon-tint:before {
	content: "\e064"
}

.dfbs .glyphicon-edit:before {
	content: "\e065"
}

.dfbs .glyphicon-share:before {
	content: "\e066"
}

.dfbs .glyphicon-check:before {
	content: "\e067"
}

.dfbs .glyphicon-move:before {
	content: "\e068"
}

.dfbs .glyphicon-step-backward:before {
	content: "\e069"
}

.dfbs .glyphicon-fast-backward:before {
	content: "\e070"
}

.dfbs .glyphicon-backward:before {
	content: "\e071"
}

.dfbs .glyphicon-play:before {
	content: "\e072"
}

.dfbs .glyphicon-pause:before {
	content: "\e073"
}

.dfbs .glyphicon-stop:before {
	content: "\e074"
}

.dfbs .glyphicon-forward:before {
	content: "\e075"
}

.dfbs .glyphicon-fast-forward:before {
	content: "\e076"
}

.dfbs .glyphicon-step-forward:before {
	content: "\e077"
}

.dfbs .glyphicon-eject:before {
	content: "\e078"
}

.dfbs .glyphicon-chevron-left:before {
	content: "\e079"
}

.dfbs .glyphicon-chevron-right:before {
	content: "\e080"
}

.dfbs .glyphicon-plus-sign:before {
	content: "\e081"
}

.dfbs .glyphicon-minus-sign:before {
	content: "\e082"
}

.dfbs .glyphicon-remove-sign:before {
	content: "\e083"
}

.dfbs .glyphicon-ok-sign:before {
	content: "\e084"
}

.dfbs .glyphicon-question-sign:before {
	content: "\e085"
}

.dfbs .glyphicon-info-sign:before {
	content: "\e086"
}

.dfbs .glyphicon-screenshot:before {
	content: "\e087"
}

.dfbs .glyphicon-remove-circle:before {
	content: "\e088"
}

.dfbs .glyphicon-ok-circle:before {
	content: "\e089"
}

.dfbs .glyphicon-ban-circle:before {
	content: "\e090"
}

.dfbs .glyphicon-arrow-left:before {
	content: "\e091"
}

.dfbs .glyphicon-arrow-right:before {
	content: "\e092"
}

.dfbs .glyphicon-arrow-up:before {
	content: "\e093"
}

.dfbs .glyphicon-arrow-down:before {
	content: "\e094"
}

.dfbs .glyphicon-share-alt:before {
	content: "\e095"
}

.dfbs .glyphicon-resize-full:before {
	content: "\e096"
}

.dfbs .glyphicon-resize-small:before {
	content: "\e097"
}

.dfbs .glyphicon-exclamation-sign:before {
	content: "\e101"
}

.dfbs .glyphicon-gift:before {
	content: "\e102"
}

.dfbs .glyphicon-leaf:before {
	content: "\e103"
}

.dfbs .glyphicon-fire:before {
	content: "\e104"
}

.dfbs .glyphicon-eye-open:before {
	content: "\e105"
}

.dfbs .glyphicon-eye-close:before {
	content: "\e106"
}

.dfbs .glyphicon-warning-sign:before {
	content: "\e107"
}

.dfbs .glyphicon-plane:before {
	content: "\e108"
}

.dfbs .glyphicon-calendar:before {
	content: "\e109"
}

.dfbs .glyphicon-random:before {
	content: "\e110"
}

.dfbs .glyphicon-comment:before {
	content: "\e111"
}

.dfbs .glyphicon-magnet:before {
	content: "\e112"
}

.dfbs .glyphicon-chevron-up:before {
	content: "\e113"
}

.dfbs .glyphicon-chevron-down:before {
	content: "\e114"
}

.dfbs .glyphicon-retweet:before {
	content: "\e115"
}

.dfbs .glyphicon-shopping-cart:before {
	content: "\e116"
}

.dfbs .glyphicon-folder-close:before {
	content: "\e117"
}

.dfbs .glyphicon-folder-open:before {
	content: "\e118"
}

.dfbs .glyphicon-resize-vertical:before {
	content: "\e119"
}

.dfbs .glyphicon-resize-horizontal:before {
	content: "\e120"
}

.dfbs .glyphicon-hdd:before {
	content: "\e121"
}

.dfbs .glyphicon-bullhorn:before {
	content: "\e122"
}

.dfbs .glyphicon-bell:before {
	content: "\e123"
}

.dfbs .glyphicon-certificate:before {
	content: "\e124"
}

.dfbs .glyphicon-thumbs-up:before {
	content: "\e125"
}

.dfbs .glyphicon-thumbs-down:before {
	content: "\e126"
}

.dfbs .glyphicon-hand-right:before {
	content: "\e127"
}

.dfbs .glyphicon-hand-left:before {
	content: "\e128"
}

.dfbs .glyphicon-hand-up:before {
	content: "\e129"
}

.dfbs .glyphicon-hand-down:before {
	content: "\e130"
}

.dfbs .glyphicon-circle-arrow-right:before {
	content: "\e131"
}

.dfbs .glyphicon-circle-arrow-left:before {
	content: "\e132"
}

.dfbs .glyphicon-circle-arrow-up:before {
	content: "\e133"
}

.dfbs .glyphicon-circle-arrow-down:before {
	content: "\e134"
}

.dfbs .glyphicon-globe:before {
	content: "\e135"
}

.dfbs .glyphicon-wrench:before {
	content: "\e136"
}

.dfbs .glyphicon-tasks:before {
	content: "\e137"
}

.dfbs .glyphicon-filter:before {
	content: "\e138"
}

.dfbs .glyphicon-briefcase:before {
	content: "\e139"
}

.dfbs .glyphicon-fullscreen:before {
	content: "\e140"
}

.dfbs .glyphicon-dashboard:before {
	content: "\e141"
}

.dfbs .glyphicon-paperclip:before {
	content: "\e142"
}

.dfbs .glyphicon-heart-empty:before {
	content: "\e143"
}

.dfbs .glyphicon-link:before {
	content: "\e144"
}

.dfbs .glyphicon-phone:before {
	content: "\e145"
}

.dfbs .glyphicon-pushpin:before {
	content: "\e146"
}

.dfbs .glyphicon-usd:before {
	content: "\e148"
}

.dfbs .glyphicon-gbp:before {
	content: "\e149"
}

.dfbs .glyphicon-sort:before {
	content: "\e150"
}

.dfbs .glyphicon-sort-by-alphabet:before {
	content: "\e151"
}

.dfbs .glyphicon-sort-by-alphabet-alt:before {
	content: "\e152"
}

.dfbs .glyphicon-sort-by-order:before {
	content: "\e153"
}

.dfbs .glyphicon-sort-by-order-alt:before {
	content: "\e154"
}

.dfbs .glyphicon-sort-by-attributes:before {
	content: "\e155"
}

.dfbs .glyphicon-sort-by-attributes-alt:before {
	content: "\e156"
}

.dfbs .glyphicon-unchecked:before {
	content: "\e157"
}

.dfbs .glyphicon-expand:before {
	content: "\e158"
}

.dfbs .glyphicon-collapse-down:before {
	content: "\e159"
}

.dfbs .glyphicon-collapse-up:before {
	content: "\e160"
}

.dfbs .glyphicon-log-in:before {
	content: "\e161"
}

.dfbs .glyphicon-flash:before {
	content: "\e162"
}

.dfbs .glyphicon-log-out:before {
	content: "\e163"
}

.dfbs .glyphicon-new-window:before {
	content: "\e164"
}

.dfbs .glyphicon-record:before {
	content: "\e165"
}

.dfbs .glyphicon-save:before {
	content: "\e166"
}

.dfbs .glyphicon-open:before {
	content: "\e167"
}

.dfbs .glyphicon-saved:before {
	content: "\e168"
}

.dfbs .glyphicon-import:before {
	content: "\e169"
}

.dfbs .glyphicon-export:before {
	content: "\e170"
}

.dfbs .glyphicon-send:before {
	content: "\e171"
}

.dfbs .glyphicon-floppy-disk:before {
	content: "\e172"
}

.dfbs .glyphicon-floppy-saved:before {
	content: "\e173"
}

.dfbs .glyphicon-floppy-remove:before {
	content: "\e174"
}

.dfbs .glyphicon-floppy-save:before {
	content: "\e175"
}

.dfbs .glyphicon-floppy-open:before {
	content: "\e176"
}

.dfbs .glyphicon-credit-card:before {
	content: "\e177"
}

.dfbs .glyphicon-transfer:before {
	content: "\e178"
}

.dfbs .glyphicon-cutlery:before {
	content: "\e179"
}

.dfbs .glyphicon-header:before {
	content: "\e180"
}

.dfbs .glyphicon-compressed:before {
	content: "\e181"
}

.dfbs .glyphicon-earphone:before {
	content: "\e182"
}

.dfbs .glyphicon-phone-alt:before {
	content: "\e183"
}

.dfbs .glyphicon-tower:before {
	content: "\e184"
}

.dfbs .glyphicon-stats:before {
	content: "\e185"
}

.dfbs .glyphicon-sd-video:before {
	content: "\e186"
}

.dfbs .glyphicon-hd-video:before {
	content: "\e187"
}

.dfbs .glyphicon-subtitles:before {
	content: "\e188"
}

.dfbs .glyphicon-sound-stereo:before {
	content: "\e189"
}

.dfbs .glyphicon-sound-dolby:before {
	content: "\e190"
}

.dfbs .glyphicon-sound-5-1:before {
	content: "\e191"
}

.dfbs .glyphicon-sound-6-1:before {
	content: "\e192"
}

.dfbs .glyphicon-sound-7-1:before {
	content: "\e193"
}

.dfbs .glyphicon-copyright-mark:before {
	content: "\e194"
}

.dfbs .glyphicon-registration-mark:before {
	content: "\e195"
}

.dfbs .glyphicon-cloud-download:before {
	content: "\e197"
}

.dfbs .glyphicon-cloud-upload:before {
	content: "\e198"
}

.dfbs .glyphicon-tree-conifer:before {
	content: "\e199"
}

.dfbs .glyphicon-tree-deciduous:before {
	content: "\e200"
}

.dfbs .glyphicon-cd:before {
	content: "\e201"
}

.dfbs .glyphicon-save-file:before {
	content: "\e202"
}

.dfbs .glyphicon-open-file:before {
	content: "\e203"
}

.dfbs .glyphicon-level-up:before {
	content: "\e204"
}

.dfbs .glyphicon-copy:before {
	content: "\e205"
}

.dfbs .glyphicon-paste:before {
	content: "\e206"
}

.dfbs .glyphicon-alert:before {
	content: "\e209"
}

.dfbs .glyphicon-equalizer:before {
	content: "\e210"
}

.dfbs .glyphicon-king:before {
	content: "\e211"
}

.dfbs .glyphicon-queen:before {
	content: "\e212"
}

.dfbs .glyphicon-pawn:before {
	content: "\e213"
}

.dfbs .glyphicon-bishop:before {
	content: "\e214"
}

.dfbs .glyphicon-knight:before {
	content: "\e215"
}

.dfbs .glyphicon-baby-formula:before {
	content: "\e216"
}

.dfbs .glyphicon-tent:before {
	content: "\26fa"
}

.dfbs .glyphicon-blackboard:before {
	content: "\e218"
}

.dfbs .glyphicon-bed:before {
	content: "\e219"
}

.dfbs .glyphicon-apple:before {
	content: "\f8ff"
}

.dfbs .glyphicon-erase:before {
	content: "\e221"
}

.dfbs .glyphicon-hourglass:before {
	content: "\231b"
}

.dfbs .glyphicon-lamp:before {
	content: "\e223"
}

.dfbs .glyphicon-duplicate:before {
	content: "\e224"
}

.dfbs .glyphicon-piggy-bank:before {
	content: "\e225"
}

.dfbs .glyphicon-scissors:before {
	content: "\e226"
}

.dfbs .glyphicon-bitcoin:before {
	content: "\e227"
}

.dfbs .glyphicon-btc:before {
	content: "\e227"
}

.dfbs .glyphicon-xbt:before {
	content: "\e227"
}

.dfbs .glyphicon-yen:before {
	content: "\00a5"
}

.dfbs .glyphicon-jpy:before {
	content: "\00a5"
}

.dfbs .glyphicon-ruble:before {
	content: "\20bd"
}

.dfbs .glyphicon-rub:before {
	content: "\20bd"
}

.dfbs .glyphicon-scale:before {
	content: "\e230"
}

.dfbs .glyphicon-ice-lolly:before {
	content: "\e231"
}

.dfbs .glyphicon-ice-lolly-tasted:before {
	content: "\e232"
}

.dfbs .glyphicon-education:before {
	content: "\e233"
}

.dfbs .glyphicon-option-horizontal:before {
	content: "\e234"
}

.dfbs .glyphicon-option-vertical:before {
	content: "\e235"
}

.dfbs .glyphicon-menu-hamburger:before {
	content: "\e236"
}

.dfbs .glyphicon-modal-window:before {
	content: "\e237"
}

.dfbs .glyphicon-oil:before {
	content: "\e238"
}

.dfbs .glyphicon-grain:before {
	content: "\e239"
}

.dfbs .glyphicon-sunglasses:before {
	content: "\e240"
}

.dfbs .glyphicon-text-size:before {
	content: "\e241"
}

.dfbs .glyphicon-text-color:before {
	content: "\e242"
}

.dfbs .glyphicon-text-background:before {
	content: "\e243"
}

.dfbs .glyphicon-object-align-top:before {
	content: "\e244"
}

.dfbs .glyphicon-object-align-bottom:before {
	content: "\e245"
}

.dfbs .glyphicon-object-align-horizontal:before {
	content: "\e246"
}

.dfbs .glyphicon-object-align-left:before {
	content: "\e247"
}

.dfbs .glyphicon-object-align-vertical:before {
	content: "\e248"
}

.dfbs .glyphicon-object-align-right:before {
	content: "\e249"
}

.dfbs .glyphicon-triangle-right:before {
	content: "\e250"
}

.dfbs .glyphicon-triangle-left:before {
	content: "\e251"
}

.dfbs .glyphicon-triangle-bottom:before {
	content: "\e252"
}

.dfbs .glyphicon-triangle-top:before {
	content: "\e253"
}

.dfbs .glyphicon-console:before {
	content: "\e254"
}

.dfbs .glyphicon-superscript:before {
	content: "\e255"
}

.dfbs .glyphicon-subscript:before {
	content: "\e256"
}

.dfbs .glyphicon-menu-left:before {
	content: "\e257"
}

.dfbs .glyphicon-menu-right:before {
	content: "\e258"
}

.dfbs .glyphicon-menu-down:before {
	content: "\e259"
}

.dfbs .glyphicon-menu-up:before {
	content: "\e260"
}

.dfbs * {
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	box-sizing: border-box
}

.dfbs :after,
.dfbs :before {
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	box-sizing: border-box
}

.dfbs html {
	font-size: 10px;
	-webkit-tap-highlight-color: transparent
}

.dfbs body {
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	font-size: 14px;
	line-height: 1.42857143;
	color: #333;
	background-color: #fff
}

.dfbs button,
.dfbs input,
.dfbs select,
.dfbs textarea {
	font-family: inherit;
	font-size: inherit;
	line-height: inherit
}

.dfbs a {
	color: #337ab7;
	text-decoration: none
}

.dfbs a:focus,
.dfbs a:hover {
	color: #23527c;
	text-decoration: underline
}

.dfbs a:focus {
	outline: 5px auto -webkit-focus-ring-color;
	outline-offset: -2px
}

.dfbs figure {
	margin: 0
}

.dfbs img {
	vertical-align: middle
}

.dfbs .img-responsive {
	display: block;
	max-width: 100%;
	height: auto
}

.dfbs .img-rounded {
	border-radius: 6px
}

.dfbs .img-thumbnail {
	padding: 4px;
	line-height: 1.42857143;
	background-color: #fff;
	border: 1px solid #ddd;
	border-radius: 4px;
	-webkit-transition: all .2s ease-in-out;
	-o-transition: all .2s ease-in-out;
	transition: all .2s ease-in-out;
	display: inline-block;
	max-width: 100%;
	height: auto
}

.dfbs .img-circle {
	border-radius: 50%
}

.dfbs hr {
	margin-top: 20px;
	margin-bottom: 20px;
	border: 0;
	border-top: 1px solid #eee
}

.dfbs .sr-only {
	position: absolute;
	width: 1px;
	height: 1px;
	margin: -1px;
	padding: 0;
	overflow: hidden;
	clip: rect(0, 0, 0, 0);
	border: 0
}

.dfbs .sr-only-focusable:active,
.dfbs .sr-only-focusable:focus {
	position: static;
	width: auto;
	height: auto;
	margin: 0;
	overflow: visible;
	clip: auto
}

.dfbs [role=button] {
	cursor: pointer
}

.dfbs .h1,
.dfbs .h2,
.dfbs .h3,
.dfbs .h4,
.dfbs .h5,
.dfbs .h6,
.dfbs h1,
.dfbs h2,
.dfbs h3,
.dfbs h4,
.dfbs h5,
.dfbs h6 {
	font-family: inherit;
	font-weight: 500;
	line-height: 1.1;
	color: inherit
}

.dfbs .h1 .small,
.dfbs .h1 small,
.dfbs .h2 .small,
.dfbs .h2 small,
.dfbs .h3 .small,
.dfbs .h3 small,
.dfbs .h4 .small,
.dfbs .h4 small,
.dfbs .h5 .small,
.dfbs .h5 small,
.dfbs .h6 .small,
.dfbs .h6 small,
.dfbs h1 .small,
.dfbs h1 small,
.dfbs h2 .small,
.dfbs h2 small,
.dfbs h3 .small,
.dfbs h3 small,
.dfbs h4 .small,
.dfbs h4 small,
.dfbs h5 .small,
.dfbs h5 small,
.dfbs h6 .small,
.dfbs h6 small {
	font-weight: 400;
	line-height: 1;
	color: #777
}

.dfbs .h1,
.dfbs .h2,
.dfbs .h3,
.dfbs h1,
.dfbs h2,
.dfbs h3 {
	margin-top: 20px;
	margin-bottom: 10px
}

.dfbs .h1 .small,
.dfbs .h1 small,
.dfbs .h2 .small,
.dfbs .h2 small,
.dfbs .h3 .small,
.dfbs .h3 small,
.dfbs h1 .small,
.dfbs h1 small,
.dfbs h2 .small,
.dfbs h2 small,
.dfbs h3 .small,
.dfbs h3 small {
	font-size: 65%
}

.dfbs .h4,
.dfbs .h5,
.dfbs .h6,
.dfbs h4,
.dfbs h5,
.dfbs h6 {
	margin-top: 10px;
	margin-bottom: 10px
}

.dfbs .h4 .small,
.dfbs .h4 small,
.dfbs .h5 .small,
.dfbs .h5 small,
.dfbs .h6 .small,
.dfbs .h6 small,
.dfbs h4 .small,
.dfbs h4 small,
.dfbs h5 .small,
.dfbs h5 small,
.dfbs h6 .small,
.dfbs h6 small {
	font-size: 75%
}

.dfbs .h1,
.dfbs h1 {
	font-size: 36px
}

.dfbs .h2,
.dfbs h2 {
	font-size: 30px
}

.dfbs .h3,
.dfbs h3 {
	font-size: 24px
}

.dfbs .h4,
.dfbs h4 {
	font-size: 18px
}

.dfbs .h5,
.dfbs h5 {
	font-size: 14px
}

.dfbs .h6,
.dfbs h6 {
	font-size: 12px
}

.dfbs p {
	margin: 0 0 10px
}

.dfbs .lead {
	margin-bottom: 20px;
	font-size: 16px;
	font-weight: 300;
	line-height: 1.4
}

@media (min-width:768px) {
	.dfbs .lead {
		font-size: 21px
	}
}

.dfbs .small,
.dfbs small {
	font-size: 85%
}

.dfbs .mark,
.dfbs mark {
	background-color: #fcf8e3;
	padding: .2em
}

.dfbs .text-left {
	text-align: left
}

.dfbs .text-right {
	text-align: right
}

.dfbs .text-center {
	text-align: center
}

.dfbs .text-justify {
	text-align: justify
}

.dfbs .text-nowrap {
	white-space: nowrap
}

.dfbs .text-lowercase {
	text-transform: lowercase
}

.dfbs .text-uppercase {
	text-transform: uppercase
}

.dfbs .text-capitalize {
	text-transform: capitalize
}

.dfbs .text-muted {
	color: #777
}

.dfbs .text-primary {
	color: #337ab7
}

a.dfbs .text-primary:focus,
a.dfbs .text-primary:hover {
	color: #286090
}

.dfbs .text-success {
	color: #3c763d
}

a.dfbs .text-success:focus,
a.dfbs .text-success:hover {
	color: #2b542c
}

.dfbs .text-info {
	color: #31708f
}

a.dfbs .text-info:focus,
a.dfbs .text-info:hover {
	color: #245269
}

.dfbs .text-warning {
	color: #8a6d3b
}

a.dfbs .text-warning:focus,
a.dfbs .text-warning:hover {
	color: #66512c
}

.dfbs .text-danger {
	color: #a94442
}

a.dfbs .text-danger:focus,
a.dfbs .text-danger:hover {
	color: #843534
}

.dfbs .bg-primary {
	color: #fff;
	background-color: #337ab7
}

a.dfbs .bg-primary:focus,
a.dfbs .bg-primary:hover {
	background-color: #286090
}

.dfbs .bg-success {
	background-color: #dff0d8
}

a.dfbs .bg-success:focus,
a.dfbs .bg-success:hover {
	background-color: #c1e2b3
}

.dfbs .bg-info {
	background-color: #d9edf7
}

a.dfbs .bg-info:focus,
a.dfbs .bg-info:hover {
	background-color: #afd9ee
}

.dfbs .bg-warning {
	background-color: #fcf8e3
}

a.dfbs .bg-warning:focus,
a.dfbs .bg-warning:hover {
	background-color: #f7ecb5
}

.dfbs .bg-danger {
	background-color: #f2dede
}

a.dfbs .bg-danger:focus,
a.dfbs .bg-danger:hover {
	background-color: #e4b9b9
}

.dfbs .page-header {
	padding-bottom: 9px;
	margin: 40px 0 20px;
	border-bottom: 1px solid #eee
}

.dfbs ol,
.dfbs ul {
	margin-top: 0;
	margin-bottom: 10px
}

.dfbs ol ol,
.dfbs ol ul,
.dfbs ul ol,
.dfbs ul ul {
	margin-bottom: 0
}

.dfbs .list-unstyled {
	padding-left: 0;
	list-style: none
}

.dfbs .list-inline {
	padding-left: 0;
	list-style: none;
	margin-left: -5px
}

.dfbs .list-inline>li {
	display: inline-block;
	padding-left: 5px;
	padding-right: 5px
}

.dfbs dl {
	margin-top: 0;
	margin-bottom: 20px
}

.dfbs dd,
.dfbs dt {
	line-height: 1.42857143
}

.dfbs dt {
	font-weight: 700
}

.dfbs dd {
	margin-left: 0
}

@media (min-width:768px) {
	.dfbs .dl-horizontal dt {
		float: left;
		width: 160px;
		clear: left;
		text-align: right;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap
	}
	.dfbs .dl-horizontal dd {
		margin-left: 180px
	}
}

.dfbs abbr[data-original-title],
.dfbs abbr[title] {
	cursor: help;
	border-bottom: 1px dotted #777
}

.dfbs .initialism {
	font-size: 90%;
	text-transform: uppercase
}

.dfbs blockquote {
	padding: 10px 20px;
	margin: 0 0 20px;
	font-size: 17.5px;
	border-left: 5px solid #eee
}

.dfbs blockquote ol:last-child,
.dfbs blockquote p:last-child,
.dfbs blockquote ul:last-child {
	margin-bottom: 0
}

.dfbs blockquote .small,
.dfbs blockquote footer,
.dfbs blockquote small {
	display: block;
	font-size: 80%;
	line-height: 1.42857143;
	color: #777
}

.dfbs blockquote .small:before,
.dfbs blockquote footer:before,
.dfbs blockquote small:before {
	content: '\2014 \00A0'
}

.dfbs .blockquote-reverse,
.dfbs blockquote.pull-right {
	padding-right: 15px;
	padding-left: 0;
	border-right: 5px solid #eee;
	border-left: 0;
	text-align: right
}

.dfbs .blockquote-reverse .small:before,
.dfbs .blockquote-reverse footer:before,
.dfbs .blockquote-reverse small:before,
.dfbs blockquote.pull-right .small:before,
.dfbs blockquote.pull-right footer:before,
.dfbs blockquote.pull-right small:before {
	content: ''
}

.dfbs .blockquote-reverse .small:after,
.dfbs .blockquote-reverse footer:after,
.dfbs .blockquote-reverse small:after,
.dfbs blockquote.pull-right .small:after,
.dfbs blockquote.pull-right footer:after,
.dfbs blockquote.pull-right small:after {
	content: '\00A0 \2014'
}

.dfbs address {
	margin-bottom: 20px;
	font-style: normal;
	line-height: 1.42857143
}

.dfbs code,
.dfbs kbd,
.dfbs pre,
.dfbs samp {
	font-family: Menlo, Monaco, Consolas, "Courier New", monospace
}

.dfbs code {
	padding: 2px 4px;
	font-size: 90%;
	color: #c7254e;
	background-color: #f9f2f4;
	border-radius: 4px
}

.dfbs kbd {
	padding: 2px 4px;
	font-size: 90%;
	color: #fff;
	background-color: #333;
	border-radius: 3px;
	box-shadow: inset 0 -1px 0 rgba(0, 0, 0, .25)
}

.dfbs kbd kbd {
	padding: 0;
	font-size: 100%;
	font-weight: 700;
	box-shadow: none
}

.dfbs pre {
	display: block;
	padding: 9.5px;
	margin: 0 0 10px;
	font-size: 13px;
	line-height: 1.42857143;
	word-break: break-all;
	word-wrap: break-word;
	color: #333;
	background-color: #f5f5f5;
	border: 1px solid #ccc;
	border-radius: 4px
}

.dfbs pre code {
	padding: 0;
	font-size: inherit;
	color: inherit;
	white-space: pre-wrap;
	background-color: transparent;
	border-radius: 0
}

.dfbs .pre-scrollable {
	max-height: 340px;
	overflow-y: scroll
}

.dfbs .container {
	margin-right: auto;
	margin-left: auto;
	padding-left: 15px;
	padding-right: 15px
}

@media (min-width:768px) {
	.dfbs .container {
		width: 750px
	}
}

@media (min-width:992px) {
	.dfbs .container {
		width: 970px
	}
}

@media (min-width:1200px) {
	.dfbs .container {
		width: 1170px
	}
}

.dfbs .container-fluid {
	margin-right: auto;
	margin-left: auto;
	padding-left: 15px;
	padding-right: 15px
}

.dfbs .row {
	margin-left: -15px;
	margin-right: -15px
}

.col-lg-1,
.col-lg-10,
.col-lg-11,
.col-lg-12,
.col-lg-2,
.col-lg-3,
.col-lg-4,
.col-lg-5,
.col-lg-6,
.col-lg-7,
.col-lg-8,
.col-lg-9,
.col-md-1,
.col-md-10,
.col-md-11,
.col-md-12,
.col-md-2,
.col-md-3,
.col-md-4,
.col-md-5,
.col-md-6,
.col-md-7,
.col-md-8,
.col-md-9,
.col-sm-1,
.col-sm-10,
.col-sm-11,
.col-sm-12,
.col-sm-2,
.col-sm-3,
.col-sm-4,
.col-sm-5,
.col-sm-6,
.col-sm-7,
.col-sm-8,
.col-sm-9,
.col-xs-10,
.col-xs-11,
.col-xs-12,
.col-xs-2,
.col-xs-3,
.col-xs-4,
.col-xs-5,
.col-xs-6,
.col-xs-7,
.col-xs-8,
.col-xs-9,
.dfbs .col-xs-1 {
	position: relative;
	min-height: 1px;
	padding-left: 15px;
	padding-right: 15px
}

.col-xs-10,
.col-xs-11,
.col-xs-12,
.col-xs-2,
.col-xs-3,
.col-xs-4,
.col-xs-5,
.col-xs-6,
.col-xs-7,
.col-xs-8,
.col-xs-9,
.dfbs .col-xs-1 {
	float: left
}

.dfbs .col-xs-12 {
	width: 100%
}

.dfbs .col-xs-11 {
	width: 91.66666667%
}

.dfbs .col-xs-10 {
	width: 83.33333333%
}

.dfbs .col-xs-9 {
	width: 75%
}

.dfbs .col-xs-8 {
	width: 66.66666667%
}

.dfbs .col-xs-7 {
	width: 58.33333333%
}

.dfbs .col-xs-6 {
	width: 50%
}

.dfbs .col-xs-5 {
	width: 41.66666667%
}

.dfbs .col-xs-4 {
	width: 33.33333333%
}

.dfbs .col-xs-3 {
	width: 25%
}

.dfbs .col-xs-2 {
	width: 16.66666667%
}

.dfbs .col-xs-1 {
	width: 8.33333333%
}

.dfbs .col-xs-pull-12 {
	right: 100%
}

.dfbs .col-xs-pull-11 {
	right: 91.66666667%
}

.dfbs .col-xs-pull-10 {
	right: 83.33333333%
}

.dfbs .col-xs-pull-9 {
	right: 75%
}

.dfbs .col-xs-pull-8 {
	right: 66.66666667%
}

.dfbs .col-xs-pull-7 {
	right: 58.33333333%
}

.dfbs .col-xs-pull-6 {
	right: 50%
}

.dfbs .col-xs-pull-5 {
	right: 41.66666667%
}

.dfbs .col-xs-pull-4 {
	right: 33.33333333%
}

.dfbs .col-xs-pull-3 {
	right: 25%
}

.dfbs .col-xs-pull-2 {
	right: 16.66666667%
}

.dfbs .col-xs-pull-1 {
	right: 8.33333333%
}

.dfbs .col-xs-pull-0 {
	right: auto
}

.dfbs .col-xs-push-12 {
	left: 100%
}

.dfbs .col-xs-push-11 {
	left: 91.66666667%
}

.dfbs .col-xs-push-10 {
	left: 83.33333333%
}

.dfbs .col-xs-push-9 {
	left: 75%
}

.dfbs .col-xs-push-8 {
	left: 66.66666667%
}

.dfbs .col-xs-push-7 {
	left: 58.33333333%
}

.dfbs .col-xs-push-6 {
	left: 50%
}

.dfbs .col-xs-push-5 {
	left: 41.66666667%
}

.dfbs .col-xs-push-4 {
	left: 33.33333333%
}

.dfbs .col-xs-push-3 {
	left: 25%
}

.dfbs .col-xs-push-2 {
	left: 16.66666667%
}

.dfbs .col-xs-push-1 {
	left: 8.33333333%
}

.dfbs .col-xs-push-0 {
	left: auto
}

.dfbs .col-xs-offset-12 {
	margin-left: 100%
}

.dfbs .col-xs-offset-11 {
	margin-left: 91.66666667%
}

.dfbs .col-xs-offset-10 {
	margin-left: 83.33333333%
}

.dfbs .col-xs-offset-9 {
	margin-left: 75%
}

.dfbs .col-xs-offset-8 {
	margin-left: 66.66666667%
}

.dfbs .col-xs-offset-7 {
	margin-left: 58.33333333%
}

.dfbs .col-xs-offset-6 {
	margin-left: 50%
}

.dfbs .col-xs-offset-5 {
	margin-left: 41.66666667%
}

.dfbs .col-xs-offset-4 {
	margin-left: 33.33333333%
}

.dfbs .col-xs-offset-3 {
	margin-left: 25%
}

.dfbs .col-xs-offset-2 {
	margin-left: 16.66666667%
}

.dfbs .col-xs-offset-1 {
	margin-left: 8.33333333%
}

.dfbs .col-xs-offset-0 {
	margin-left: 0
}

@media (min-width:768px) {
	.col-sm-10,
	.col-sm-11,
	.col-sm-12,
	.col-sm-2,
	.col-sm-3,
	.col-sm-4,
	.col-sm-5,
	.col-sm-6,
	.col-sm-7,
	.col-sm-8,
	.col-sm-9,
	.dfbs .col-sm-1 {
		float: left
	}
	.dfbs .col-sm-12 {
		width: 100%
	}
	.dfbs .col-sm-11 {
		width: 91.66666667%
	}
	.dfbs .col-sm-10 {
		width: 83.33333333%
	}
	.dfbs .col-sm-9 {
		width: 75%
	}
	.dfbs .col-sm-8 {
		width: 66.66666667%
	}
	.dfbs .col-sm-7 {
		width: 58.33333333%
	}
	.dfbs .col-sm-6 {
		width: 50%
	}
	.dfbs .col-sm-5 {
		width: 41.66666667%
	}
	.dfbs .col-sm-4 {
		width: 33.33333333%
	}
	.dfbs .col-sm-3 {
		width: 25%
	}
	.dfbs .col-sm-2 {
		width: 16.66666667%
	}
	.dfbs .col-sm-1 {
		width: 8.33333333%
	}
	.dfbs .col-sm-pull-12 {
		right: 100%
	}
	.dfbs .col-sm-pull-11 {
		right: 91.66666667%
	}
	.dfbs .col-sm-pull-10 {
		right: 83.33333333%
	}
	.dfbs .col-sm-pull-9 {
		right: 75%
	}
	.dfbs .col-sm-pull-8 {
		right: 66.66666667%
	}
	.dfbs .col-sm-pull-7 {
		right: 58.33333333%
	}
	.dfbs .col-sm-pull-6 {
		right: 50%
	}
	.dfbs .col-sm-pull-5 {
		right: 41.66666667%
	}
	.dfbs .col-sm-pull-4 {
		right: 33.33333333%
	}
	.dfbs .col-sm-pull-3 {
		right: 25%
	}
	.dfbs .col-sm-pull-2 {
		right: 16.66666667%
	}
	.dfbs .col-sm-pull-1 {
		right: 8.33333333%
	}
	.dfbs .col-sm-pull-0 {
		right: auto
	}
	.dfbs .col-sm-push-12 {
		left: 100%
	}
	.dfbs .col-sm-push-11 {
		left: 91.66666667%
	}
	.dfbs .col-sm-push-10 {
		left: 83.33333333%
	}
	.dfbs .col-sm-push-9 {
		left: 75%
	}
	.dfbs .col-sm-push-8 {
		left: 66.66666667%
	}
	.dfbs .col-sm-push-7 {
		left: 58.33333333%
	}
	.dfbs .col-sm-push-6 {
		left: 50%
	}
	.dfbs .col-sm-push-5 {
		left: 41.66666667%
	}
	.dfbs .col-sm-push-4 {
		left: 33.33333333%
	}
	.dfbs .col-sm-push-3 {
		left: 25%
	}
	.dfbs .col-sm-push-2 {
		left: 16.66666667%
	}
	.dfbs .col-sm-push-1 {
		left: 8.33333333%
	}
	.dfbs .col-sm-push-0 {
		left: auto
	}
	.dfbs .col-sm-offset-12 {
		margin-left: 100%
	}
	.dfbs .col-sm-offset-11 {
		margin-left: 91.66666667%
	}
	.dfbs .col-sm-offset-10 {
		margin-left: 83.33333333%
	}
	.dfbs .col-sm-offset-9 {
		margin-left: 75%
	}
	.dfbs .col-sm-offset-8 {
		margin-left: 66.66666667%
	}
	.dfbs .col-sm-offset-7 {
		margin-left: 58.33333333%
	}
	.dfbs .col-sm-offset-6 {
		margin-left: 50%
	}
	.dfbs .col-sm-offset-5 {
		margin-left: 41.66666667%
	}
	.dfbs .col-sm-offset-4 {
		margin-left: 33.33333333%
	}
	.dfbs .col-sm-offset-3 {
		margin-left: 25%
	}
	.dfbs .col-sm-offset-2 {
		margin-left: 16.66666667%
	}
	.dfbs .col-sm-offset-1 {
		margin-left: 8.33333333%
	}
	.dfbs .col-sm-offset-0 {
		margin-left: 0
	}
}

@media (min-width:992px) {
	.col-md-10,
	.col-md-11,
	.col-md-12,
	.col-md-2,
	.col-md-3,
	.col-md-4,
	.col-md-5,
	.col-md-6,
	.col-md-7,
	.col-md-8,
	.col-md-9,
	.dfbs .col-md-1 {
		float: left
	}
	.dfbs .col-md-12 {
		width: 100%
	}
	.dfbs .col-md-11 {
		width: 91.66666667%
	}
	.dfbs .col-md-10 {
		width: 83.33333333%
	}
	.dfbs .col-md-9 {
		width: 75%
	}
	.dfbs .col-md-8 {
		width: 66.66666667%
	}
	.dfbs .col-md-7 {
		width: 58.33333333%
	}
	.dfbs .col-md-6 {
		width: 50%
	}
	.dfbs .col-md-5 {
		width: 41.66666667%
	}
	.dfbs .col-md-4 {
		width: 33.33333333%
	}
	.dfbs .col-md-3 {
		width: 25%
	}
	.dfbs .col-md-2 {
		width: 16.66666667%
	}
	.dfbs .col-md-1 {
		width: 8.33333333%
	}
	.dfbs .col-md-pull-12 {
		right: 100%
	}
	.dfbs .col-md-pull-11 {
		right: 91.66666667%
	}
	.dfbs .col-md-pull-10 {
		right: 83.33333333%
	}
	.dfbs .col-md-pull-9 {
		right: 75%
	}
	.dfbs .col-md-pull-8 {
		right: 66.66666667%
	}
	.dfbs .col-md-pull-7 {
		right: 58.33333333%
	}
	.dfbs .col-md-pull-6 {
		right: 50%
	}
	.dfbs .col-md-pull-5 {
		right: 41.66666667%
	}
	.dfbs .col-md-pull-4 {
		right: 33.33333333%
	}
	.dfbs .col-md-pull-3 {
		right: 25%
	}
	.dfbs .col-md-pull-2 {
		right: 16.66666667%
	}
	.dfbs .col-md-pull-1 {
		right: 8.33333333%
	}
	.dfbs .col-md-pull-0 {
		right: auto
	}
	.dfbs .col-md-push-12 {
		left: 100%
	}
	.dfbs .col-md-push-11 {
		left: 91.66666667%
	}
	.dfbs .col-md-push-10 {
		left: 83.33333333%
	}
	.dfbs .col-md-push-9 {
		left: 75%
	}
	.dfbs .col-md-push-8 {
		left: 66.66666667%
	}
	.dfbs .col-md-push-7 {
		left: 58.33333333%
	}
	.dfbs .col-md-push-6 {
		left: 50%
	}
	.dfbs .col-md-push-5 {
		left: 41.66666667%
	}
	.dfbs .col-md-push-4 {
		left: 33.33333333%
	}
	.dfbs .col-md-push-3 {
		left: 25%
	}
	.dfbs .col-md-push-2 {
		left: 16.66666667%
	}
	.dfbs .col-md-push-1 {
		left: 8.33333333%
	}
	.dfbs .col-md-push-0 {
		left: auto
	}
	.dfbs .col-md-offset-12 {
		margin-left: 100%
	}
	.dfbs .col-md-offset-11 {
		margin-left: 91.66666667%
	}
	.dfbs .col-md-offset-10 {
		margin-left: 83.33333333%
	}
	.dfbs .col-md-offset-9 {
		margin-left: 75%
	}
	.dfbs .col-md-offset-8 {
		margin-left: 66.66666667%
	}
	.dfbs .col-md-offset-7 {
		margin-left: 58.33333333%
	}
	.dfbs .col-md-offset-6 {
		margin-left: 50%
	}
	.dfbs .col-md-offset-5 {
		margin-left: 41.66666667%
	}
	.dfbs .col-md-offset-4 {
		margin-left: 33.33333333%
	}
	.dfbs .col-md-offset-3 {
		margin-left: 25%
	}
	.dfbs .col-md-offset-2 {
		margin-left: 16.66666667%
	}
	.dfbs .col-md-offset-1 {
		margin-left: 8.33333333%
	}
	.dfbs .col-md-offset-0 {
		margin-left: 0
	}
}

@media (min-width:1200px) {
	.col-lg-10,
	.col-lg-11,
	.col-lg-12,
	.col-lg-2,
	.col-lg-3,
	.col-lg-4,
	.col-lg-5,
	.col-lg-6,
	.col-lg-7,
	.col-lg-8,
	.col-lg-9,
	.dfbs .col-lg-1 {
		float: left
	}
	.dfbs .col-lg-12 {
		width: 100%
	}
	.dfbs .col-lg-11 {
		width: 91.66666667%
	}
	.dfbs .col-lg-10 {
		width: 83.33333333%
	}
	.dfbs .col-lg-9 {
		width: 75%
	}
	.dfbs .col-lg-8 {
		width: 66.66666667%
	}
	.dfbs .col-lg-7 {
		width: 58.33333333%
	}
	.dfbs .col-lg-6 {
		width: 50%
	}
	.dfbs .col-lg-5 {
		width: 41.66666667%
	}
	.dfbs .col-lg-4 {
		width: 33.33333333%
	}
	.dfbs .col-lg-3 {
		width: 25%
	}
	.dfbs .col-lg-2 {
		width: 16.66666667%
	}
	.dfbs .col-lg-1 {
		width: 8.33333333%
	}
	.dfbs .col-lg-pull-12 {
		right: 100%
	}
	.dfbs .col-lg-pull-11 {
		right: 91.66666667%
	}
	.dfbs .col-lg-pull-10 {
		right: 83.33333333%
	}
	.dfbs .col-lg-pull-9 {
		right: 75%
	}
	.dfbs .col-lg-pull-8 {
		right: 66.66666667%
	}
	.dfbs .col-lg-pull-7 {
		right: 58.33333333%
	}
	.dfbs .col-lg-pull-6 {
		right: 50%
	}
	.dfbs .col-lg-pull-5 {
		right: 41.66666667%
	}
	.dfbs .col-lg-pull-4 {
		right: 33.33333333%
	}
	.dfbs .col-lg-pull-3 {
		right: 25%
	}
	.dfbs .col-lg-pull-2 {
		right: 16.66666667%
	}
	.dfbs .col-lg-pull-1 {
		right: 8.33333333%
	}
	.dfbs .col-lg-pull-0 {
		right: auto
	}
	.dfbs .col-lg-push-12 {
		left: 100%
	}
	.dfbs .col-lg-push-11 {
		left: 91.66666667%
	}
	.dfbs .col-lg-push-10 {
		left: 83.33333333%
	}
	.dfbs .col-lg-push-9 {
		left: 75%
	}
	.dfbs .col-lg-push-8 {
		left: 66.66666667%
	}
	.dfbs .col-lg-push-7 {
		left: 58.33333333%
	}
	.dfbs .col-lg-push-6 {
		left: 50%
	}
	.dfbs .col-lg-push-5 {
		left: 41.66666667%
	}
	.dfbs .col-lg-push-4 {
		left: 33.33333333%
	}
	.dfbs .col-lg-push-3 {
		left: 25%
	}
	.dfbs .col-lg-push-2 {
		left: 16.66666667%
	}
	.dfbs .col-lg-push-1 {
		left: 8.33333333%
	}
	.dfbs .col-lg-push-0 {
		left: auto
	}
	.dfbs .col-lg-offset-12 {
		margin-left: 100%
	}
	.dfbs .col-lg-offset-11 {
		margin-left: 91.66666667%
	}
	.dfbs .col-lg-offset-10 {
		margin-left: 83.33333333%
	}
	.dfbs .col-lg-offset-9 {
		margin-left: 75%
	}
	.dfbs .col-lg-offset-8 {
		margin-left: 66.66666667%
	}
	.dfbs .col-lg-offset-7 {
		margin-left: 58.33333333%
	}
	.dfbs .col-lg-offset-6 {
		margin-left: 50%
	}
	.dfbs .col-lg-offset-5 {
		margin-left: 41.66666667%
	}
	.dfbs .col-lg-offset-4 {
		margin-left: 33.33333333%
	}
	.dfbs .col-lg-offset-3 {
		margin-left: 25%
	}
	.dfbs .col-lg-offset-2 {
		margin-left: 16.66666667%
	}
	.dfbs .col-lg-offset-1 {
		margin-left: 8.33333333%
	}
	.dfbs .col-lg-offset-0 {
		margin-left: 0
	}
}

.dfbs table {
	background-color: transparent
}

.dfbs caption {
	padding-top: 8px;
	padding-bottom: 8px;
	color: #777;
	text-align: left
}

.dfbs th {
	text-align: left
}

.dfbs .table {
	width: 100%;
	max-width: 100%;
	margin-bottom: 20px
}

.dfbs .table>tbody>tr>td,
.dfbs .table>tbody>tr>th,
.dfbs .table>tfoot>tr>td,
.dfbs .table>tfoot>tr>th,
.dfbs .table>thead>tr>td,
.dfbs .table>thead>tr>th {
	padding: 8px;
	line-height: 1.42857143;
	vertical-align: top;
	border-top: 1px solid #ddd
}

.dfbs .table>thead>tr>th {
	vertical-align: bottom;
	border-bottom: 2px solid #ddd
}

.dfbs .table>caption+thead>tr:first-child>td,
.dfbs .table>caption+thead>tr:first-child>th,
.dfbs .table>colgroup+thead>tr:first-child>td,
.dfbs .table>colgroup+thead>tr:first-child>th,
.dfbs .table>thead:first-child>tr:first-child>td,
.dfbs .table>thead:first-child>tr:first-child>th {
	border-top: 0
}

.dfbs .table>tbody+tbody {
	border-top: 2px solid #ddd
}

.dfbs .table .table {
	background-color: #fff
}

.dfbs .table-condensed>tbody>tr>td,
.dfbs .table-condensed>tbody>tr>th,
.dfbs .table-condensed>tfoot>tr>td,
.dfbs .table-condensed>tfoot>tr>th,
.dfbs .table-condensed>thead>tr>td,
.dfbs .table-condensed>thead>tr>th {
	padding: 5px
}

.dfbs .table-bordered {
	border: 1px solid #ddd
}

.dfbs .table-bordered>tbody>tr>td,
.dfbs .table-bordered>tbody>tr>th,
.dfbs .table-bordered>tfoot>tr>td,
.dfbs .table-bordered>tfoot>tr>th,
.dfbs .table-bordered>thead>tr>td,
.dfbs .table-bordered>thead>tr>th {
	border: 1px solid #ddd
}

.dfbs .table-bordered>thead>tr>td,
.dfbs .table-bordered>thead>tr>th {
	border-bottom-width: 2px
}

.dfbs .table-striped>tbody>tr:nth-of-type(odd) {
	background-color: #f9f9f9
}

.dfbs .table-hover>tbody>tr:hover {
	background-color: #f5f5f5
}

.dfbs table col[class*=col-] {
	position: static;
	float: none;
	display: table-column
}

.dfbs table td[class*=col-],
.dfbs table th[class*=col-] {
	position: static;
	float: none;
	display: table-cell
}

.dfbs .table>tbody>tr.active>td,
.dfbs .table>tbody>tr.active>th,
.dfbs .table>tbody>tr>td.active,
.dfbs .table>tbody>tr>th.active,
.dfbs .table>tfoot>tr.active>td,
.dfbs .table>tfoot>tr.active>th,
.dfbs .table>tfoot>tr>td.active,
.dfbs .table>tfoot>tr>th.active,
.dfbs .table>thead>tr.active>td,
.dfbs .table>thead>tr.active>th,
.dfbs .table>thead>tr>td.active,
.dfbs .table>thead>tr>th.active {
	background-color: #f5f5f5
}

.dfbs .table-hover>tbody>tr.active:hover>td,
.dfbs .table-hover>tbody>tr.active:hover>th,
.dfbs .table-hover>tbody>tr:hover>.active,
.dfbs .table-hover>tbody>tr>td.active:hover,
.dfbs .table-hover>tbody>tr>th.active:hover {
	background-color: #e8e8e8
}

.dfbs .table>tbody>tr.success>td,
.dfbs .table>tbody>tr.success>th,
.dfbs .table>tbody>tr>td.success,
.dfbs .table>tbody>tr>th.success,
.dfbs .table>tfoot>tr.success>td,
.dfbs .table>tfoot>tr.success>th,
.dfbs .table>tfoot>tr>td.success,
.dfbs .table>tfoot>tr>th.success,
.dfbs .table>thead>tr.success>td,
.dfbs .table>thead>tr.success>th,
.dfbs .table>thead>tr>td.success,
.dfbs .table>thead>tr>th.success {
	background-color: #dff0d8
}

.dfbs .table-hover>tbody>tr.success:hover>td,
.dfbs .table-hover>tbody>tr.success:hover>th,
.dfbs .table-hover>tbody>tr:hover>.success,
.dfbs .table-hover>tbody>tr>td.success:hover,
.dfbs .table-hover>tbody>tr>th.success:hover {
	background-color: #d0e9c6
}

.dfbs .table>tbody>tr.info>td,
.dfbs .table>tbody>tr.info>th,
.dfbs .table>tbody>tr>td.info,
.dfbs .table>tbody>tr>th.info,
.dfbs .table>tfoot>tr.info>td,
.dfbs .table>tfoot>tr.info>th,
.dfbs .table>tfoot>tr>td.info,
.dfbs .table>tfoot>tr>th.info,
.dfbs .table>thead>tr.info>td,
.dfbs .table>thead>tr.info>th,
.dfbs .table>thead>tr>td.info,
.dfbs .table>thead>tr>th.info {
	background-color: #d9edf7
}

.dfbs .table-hover>tbody>tr.info:hover>td,
.dfbs .table-hover>tbody>tr.info:hover>th,
.dfbs .table-hover>tbody>tr:hover>.info,
.dfbs .table-hover>tbody>tr>td.info:hover,
.dfbs .table-hover>tbody>tr>th.info:hover {
	background-color: #c4e3f3
}

.dfbs .table>tbody>tr.warning>td,
.dfbs .table>tbody>tr.warning>th,
.dfbs .table>tbody>tr>td.warning,
.dfbs .table>tbody>tr>th.warning,
.dfbs .table>tfoot>tr.warning>td,
.dfbs .table>tfoot>tr.warning>th,
.dfbs .table>tfoot>tr>td.warning,
.dfbs .table>tfoot>tr>th.warning,
.dfbs .table>thead>tr.warning>td,
.dfbs .table>thead>tr.warning>th,
.dfbs .table>thead>tr>td.warning,
.dfbs .table>thead>tr>th.warning {
	background-color: #fcf8e3
}

.dfbs .table-hover>tbody>tr.warning:hover>td,
.dfbs .table-hover>tbody>tr.warning:hover>th,
.dfbs .table-hover>tbody>tr:hover>.warning,
.dfbs .table-hover>tbody>tr>td.warning:hover,
.dfbs .table-hover>tbody>tr>th.warning:hover {
	background-color: #faf2cc
}

.dfbs .table>tbody>tr.danger>td,
.dfbs .table>tbody>tr.danger>th,
.dfbs .table>tbody>tr>td.danger,
.dfbs .table>tbody>tr>th.danger,
.dfbs .table>tfoot>tr.danger>td,
.dfbs .table>tfoot>tr.danger>th,
.dfbs .table>tfoot>tr>td.danger,
.dfbs .table>tfoot>tr>th.danger,
.dfbs .table>thead>tr.danger>td,
.dfbs .table>thead>tr.danger>th,
.dfbs .table>thead>tr>td.danger,
.dfbs .table>thead>tr>th.danger {
	background-color: #f2dede
}

.dfbs .table-hover>tbody>tr.danger:hover>td,
.dfbs .table-hover>tbody>tr.danger:hover>th,
.dfbs .table-hover>tbody>tr:hover>.danger,
.dfbs .table-hover>tbody>tr>td.danger:hover,
.dfbs .table-hover>tbody>tr>th.danger:hover {
	background-color: #ebcccc
}

.dfbs .table-responsive {
	overflow-x: auto;
	min-height: .01%
}

@media screen and (max-width:767px) {
	.dfbs .table-responsive {
		width: 100%;
		margin-bottom: 15px;
		overflow-y: hidden;
		-ms-overflow-style: -ms-autohiding-scrollbar;
		border: 1px solid #ddd
	}
	.dfbs .table-responsive>.table {
		margin-bottom: 0
	}
	.dfbs .table-responsive>.table>tbody>tr>td,
	.dfbs .table-responsive>.table>tbody>tr>th,
	.dfbs .table-responsive>.table>tfoot>tr>td,
	.dfbs .table-responsive>.table>tfoot>tr>th,
	.dfbs .table-responsive>.table>thead>tr>td,
	.dfbs .table-responsive>.table>thead>tr>th {
		white-space: nowrap
	}
	.dfbs .table-responsive>.table-bordered {
		border: 0
	}
	.dfbs .table-responsive>.table-bordered>tbody>tr>td:first-child,
	.dfbs .table-responsive>.table-bordered>tbody>tr>th:first-child,
	.dfbs .table-responsive>.table-bordered>tfoot>tr>td:first-child,
	.dfbs .table-responsive>.table-bordered>tfoot>tr>th:first-child,
	.dfbs .table-responsive>.table-bordered>thead>tr>td:first-child,
	.dfbs .table-responsive>.table-bordered>thead>tr>th:first-child {
		border-left: 0
	}
	.dfbs .table-responsive>.table-bordered>tbody>tr>td:last-child,
	.dfbs .table-responsive>.table-bordered>tbody>tr>th:last-child,
	.dfbs .table-responsive>.table-bordered>tfoot>tr>td:last-child,
	.dfbs .table-responsive>.table-bordered>tfoot>tr>th:last-child,
	.dfbs .table-responsive>.table-bordered>thead>tr>td:last-child,
	.dfbs .table-responsive>.table-bordered>thead>tr>th:last-child {
		border-right: 0
	}
	.dfbs .table-responsive>.table-bordered>tbody>tr:last-child>td,
	.dfbs .table-responsive>.table-bordered>tbody>tr:last-child>th,
	.dfbs .table-responsive>.table-bordered>tfoot>tr:last-child>td,
	.dfbs .table-responsive>.table-bordered>tfoot>tr:last-child>th {
		border-bottom: 0
	}
}

.dfbs fieldset {
	padding: 0;
	margin: 0;
	border: 0;
	min-width: 0
}

.dfbs legend {
	display: block;
	width: 100%;
	padding: 0;
	margin-bottom: 20px;
	font-size: 21px;
	line-height: inherit;
	color: #333;
	border: 0;
	border-bottom: 1px solid #e5e5e5
}

.dfbs label {
	display: inline-block;
	max-width: 100%;
	margin-bottom: 5px;
	font-weight: 700
}

.dfbs input[type=search] {
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	box-sizing: border-box
}

.dfbs input[type=checkbox],
.dfbs input[type=radio] {
	margin: 4px 0 0;
	margin-top: 1px;
	line-height: normal
}

.dfbs input[type=file] {
	display: block
}

.dfbs input[type=range] {
	display: block;
	width: 100%
}

.dfbs select[multiple],
.dfbs select[size] {
	height: auto
}

.dfbs input[type=file]:focus,
.dfbs input[type=checkbox]:focus,
.dfbs input[type=radio]:focus {
	outline: 5px auto -webkit-focus-ring-color;
	outline-offset: -2px
}

.dfbs output {
	display: block;
	padding-top: 7px;
	font-size: 14px;
	line-height: 1.42857143;
	color: #555
}

.dfbs .form-control {
	display: block;
	width: 100%;
	height: 34px;
	padding: 6px 12px;
	font-size: 14px;
	line-height: 1.42857143;
	color: #555;
	background-color: #fff;
	background-image: none;
	border: 1px solid #ccc;
	border-radius: 4px;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
	-webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	-o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s
}

.dfbs .form-control:focus {
	border-color: #66afe9;
	outline: 0;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px rgba(102, 175, 233, .6);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px rgba(102, 175, 233, .6)
}

.dfbs .form-control::-moz-placeholder {
	color: #999;
	opacity: 1
}

.dfbs .form-control:-ms-input-placeholder {
	color: #999
}

.dfbs .form-control::-webkit-input-placeholder {
	color: #999
}

.dfbs .form-control::-ms-expand {
	border: 0;
	background-color: transparent
}

.dfbs .form-control[disabled],
.dfbs .form-control[readonly],
fieldset[disabled] .dfbs .form-control {
	background-color: #eee;
	opacity: 1
}

.dfbs .form-control[disabled],
fieldset[disabled] .dfbs .form-control {
	cursor: not-allowed
}

textarea.dfbs .form-control {
	height: auto
}

.dfbs input[type=search] {
	-webkit-appearance: none
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
	.dfbs input[type=date].form-control,
	.dfbs input[type=time].form-control,
	.dfbs input[type=datetime-local].form-control,
	.dfbs input[type=month].form-control {
		line-height: 34px
	}
	.dfbs input[type=date].input-sm,
	.dfbs input[type=time].input-sm,
	.dfbs input[type=datetime-local].input-sm,
	.dfbs input[type=month].input-sm,
	.input-group-sm .dfbs input[type=date],
	.input-group-sm .dfbs input[type=time],
	.input-group-sm .dfbs input[type=datetime-local],
	.input-group-sm .dfbs input[type=month] {
		line-height: 30px
	}
	.dfbs input[type=date].input-lg,
	.dfbs input[type=time].input-lg,
	.dfbs input[type=datetime-local].input-lg,
	.dfbs input[type=month].input-lg,
	.input-group-lg .dfbs input[type=date],
	.input-group-lg .dfbs input[type=time],
	.input-group-lg .dfbs input[type=datetime-local],
	.input-group-lg .dfbs input[type=month] {
		line-height: 46px
	}
}

.dfbs .form-group {
	margin-bottom: 15px
}

.dfbs .checkbox,
.dfbs .radio {
	position: relative;
	display: block;
	margin-top: 10px;
	margin-bottom: 10px
}

.dfbs .checkbox label,
.dfbs .radio label {
	min-height: 20px;
	padding-left: 20px;
	margin-bottom: 0;
	font-weight: 400;
	cursor: pointer
}

.dfbs .checkbox input[type=checkbox],
.dfbs .checkbox-inline input[type=checkbox],
.dfbs .radio input[type=radio],
.dfbs .radio-inline input[type=radio] {
	position: absolute;
	margin-left: -20px;
	margin-top: 4px;
}

.dfbs .checkbox+.checkbox,
.dfbs .radio+.radio {
	margin-top: -5px
}

.dfbs .checkbox-inline,
.dfbs .radio-inline {
	position: relative;
	display: inline-block;
	padding-left: 20px;
	margin-bottom: 0;
	vertical-align: middle;
	font-weight: 400;
	cursor: pointer
}

.dfbs .checkbox-inline+.checkbox-inline,
.dfbs .radio-inline+.radio-inline {
	margin-top: 0;
	margin-left: 10px
}

.dfbs input[type=checkbox].disabled,
.dfbs input[type=checkbox][disabled],
.dfbs input[type=radio].disabled,
.dfbs input[type=radio][disabled],
fieldset[disabled] .dfbs input[type=checkbox],
fieldset[disabled] .dfbs input[type=radio] {
	cursor: not-allowed
}

.dfbs .checkbox-inline.disabled,
.dfbs .radio-inline.disabled,
fieldset[disabled] .dfbs .checkbox-inline,
fieldset[disabled] .dfbs .radio-inline {
	cursor: not-allowed
}

.dfbs .checkbox.disabled label,
.dfbs .radio.disabled label,
fieldset[disabled] .dfbs .checkbox label,
fieldset[disabled] .dfbs .radio label {
	cursor: not-allowed
}

.dfbs .form-control-static {
	padding-top: 7px;
	padding-bottom: 7px;
	margin-bottom: 0;
	min-height: 34px
}

.dfbs .form-control-static.input-lg,
.dfbs .form-control-static.input-sm {
	padding-left: 0;
	padding-right: 0
}

.dfbs .input-sm {
	height: 30px;
	padding: 5px 10px;
	font-size: 12px;
	line-height: 1.5;
	border-radius: 3px
}

select.dfbs .input-sm {
	height: 30px;
	line-height: 30px
}

select[multiple].dfbs .input-sm,
textarea.dfbs .input-sm {
	height: auto
}

.dfbs .form-group-sm .form-control {
	height: 30px;
	padding: 5px 10px;
	font-size: 12px;
	line-height: 1.5;
	border-radius: 3px
}

.dfbs .form-group-sm select.form-control {
	height: 30px;
	line-height: 30px
}

.dfbs .form-group-sm select[multiple].form-control,
.dfbs .form-group-sm textarea.form-control {
	height: auto
}

.dfbs .form-group-sm .form-control-static {
	height: 30px;
	min-height: 32px;
	padding: 6px 10px;
	font-size: 12px;
	line-height: 1.5
}

.dfbs .input-lg {
	height: 46px;
	padding: 10px 16px;
	font-size: 18px;
	line-height: 1.3333333;
	border-radius: 6px
}

select.dfbs .input-lg {
	height: 46px;
	line-height: 46px
}

select[multiple].dfbs .input-lg,
textarea.dfbs .input-lg {
	height: auto
}

.dfbs .form-group-lg .form-control {
	height: 46px;
	padding: 10px 16px;
	font-size: 18px;
	line-height: 1.3333333;
	border-radius: 6px
}

.dfbs .form-group-lg select.form-control {
	height: 46px;
	line-height: 46px
}

.dfbs .form-group-lg select[multiple].form-control,
.dfbs .form-group-lg textarea.form-control {
	height: auto
}

.dfbs .form-group-lg .form-control-static {
	height: 46px;
	min-height: 38px;
	padding: 11px 16px;
	font-size: 18px;
	line-height: 1.3333333
}

.dfbs .has-feedback {
	position: relative
}

.dfbs .has-feedback .form-control {
	padding-right: 42.5px
}

.dfbs .form-control-feedback {
	position: absolute;
	top: 0;
	right: 0;
	z-index: 2;
	display: block;
	width: 34px;
	height: 34px;
	line-height: 34px;
	text-align: center;
	pointer-events: none
}

.dfbs .form-group-lg .form-control+.form-control-feedback,
.dfbs .input-group-lg+.form-control-feedback,
.dfbs .input-lg+.form-control-feedback {
	width: 46px;
	height: 46px;
	line-height: 46px
}

.dfbs .form-group-sm .form-control+.form-control-feedback,
.dfbs .input-group-sm+.form-control-feedback,
.dfbs .input-sm+.form-control-feedback {
	width: 30px;
	height: 30px;
	line-height: 30px
}

.dfbs .has-success .checkbox,
.dfbs .has-success .checkbox-inline,
.dfbs .has-success .control-label,
.dfbs .has-success .help-block,
.dfbs .has-success .radio,
.dfbs .has-success .radio-inline,
.dfbs .has-success.checkbox label,
.dfbs .has-success.checkbox-inline label,
.dfbs .has-success.radio label,
.dfbs .has-success.radio-inline label {
	color: #3c763d
}

.dfbs .has-success .form-control {
	border-color: #3c763d;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075)
}

.dfbs .has-success .form-control:focus {
	border-color: #2b542c;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 6px #67b168;
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 6px #67b168
}

.dfbs .has-success .input-group-addon {
	color: #3c763d;
	border-color: #3c763d;
	background-color: #dff0d8
}

.dfbs .has-success .form-control-feedback {
	color: #3c763d
}

.dfbs .has-warning .checkbox,
.dfbs .has-warning .checkbox-inline,
.dfbs .has-warning .control-label,
.dfbs .has-warning .help-block,
.dfbs .has-warning .radio,
.dfbs .has-warning .radio-inline,
.dfbs .has-warning.checkbox label,
.dfbs .has-warning.checkbox-inline label,
.dfbs .has-warning.radio label,
.dfbs .has-warning.radio-inline label {
	color: #8a6d3b
}

.dfbs .has-warning .form-control {
	border-color: #8a6d3b;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075)
}

.dfbs .has-warning .form-control:focus {
	border-color: #66512c;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 6px #c0a16b;
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 6px #c0a16b
}

.dfbs .has-warning .input-group-addon {
	color: #8a6d3b;
	border-color: #8a6d3b;
	background-color: #fcf8e3
}

.dfbs .has-warning .form-control-feedback {
	color: #8a6d3b
}

.dfbs .has-error .checkbox,
.dfbs .has-error .checkbox-inline,
.dfbs .has-error .control-label,
.dfbs .has-error .help-block,
.dfbs .has-error .radio,
.dfbs .has-error .radio-inline,
.dfbs .has-error.checkbox label,
.dfbs .has-error.checkbox-inline label,
.dfbs .has-error.radio label,
.dfbs .has-error.radio-inline label {
	color: #a94442
}

.dfbs .has-error .form-control {
	border-color: #a94442;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075)
}

.dfbs .has-error .form-control:focus {
	border-color: #843534;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 6px #ce8483;
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 6px #ce8483
}

.dfbs .has-error .input-group-addon {
	color: #a94442;
	border-color: #a94442;
	background-color: #f2dede
}

.dfbs .has-error .form-control-feedback {
	color: #a94442
}

.dfbs .has-feedback label~.form-control-feedback {
	top: 25px
}

.dfbs .has-feedback label.sr-only~.form-control-feedback {
	top: 0
}

.dfbs .help-block {
	display: block;
	margin-top: 5px;
	margin-bottom: 10px;
	color: #737373
}

@media (min-width:768px) {
	.dfbs .form-inline .form-group {
		display: inline-block;
		margin-bottom: 0;
		vertical-align: middle
	}
	.dfbs .form-inline .form-control {
		display: inline-block;
		width: auto;
		vertical-align: middle
	}
	.dfbs .form-inline .form-control-static {
		display: inline-block
	}
	.dfbs .form-inline .input-group {
		display: inline-table;
		vertical-align: middle
	}
	.dfbs .form-inline .input-group .form-control,
	.dfbs .form-inline .input-group .input-group-addon,
	.dfbs .form-inline .input-group .input-group-btn {
		width: auto
	}
	.dfbs .form-inline .input-group>.form-control {
		width: 100%
	}
	.dfbs .form-inline .control-label {
		margin-bottom: 0;
		vertical-align: middle
	}
	.dfbs .form-inline .checkbox,
	.dfbs .form-inline .radio {
		display: inline-block;
		margin-top: 0;
		margin-bottom: 0;
		vertical-align: middle
	}
	.dfbs .form-inline .checkbox label,
	.dfbs .form-inline .radio label {
		padding-left: 0
	}
	.dfbs .form-inline .checkbox input[type=checkbox],
	.dfbs .form-inline .radio input[type=radio] {
		position: relative;
		margin-left: 0
	}
	.dfbs .form-inline .has-feedback .form-control-feedback {
		top: 0
	}
}

.dfbs .form-horizontal .checkbox,
.dfbs .form-horizontal .checkbox-inline,
.dfbs .form-horizontal .radio,
.dfbs .form-horizontal .radio-inline {
	margin-top: 0;
	margin-bottom: 0;
	padding-top: 7px
}

.dfbs .form-horizontal .checkbox,
.dfbs .form-horizontal .radio {
	min-height: 27px
}

.dfbs .form-horizontal .form-group {
	margin-left: -15px;
	margin-right: -15px
}

@media (min-width:768px) {
	.dfbs .form-horizontal .control-label {
		text-align: right;
		margin-bottom: 0;
		padding-top: 7px
	}
}

.dfbs .form-horizontal .has-feedback .form-control-feedback {
	right: 15px
}

@media (min-width:768px) {
	.dfbs .form-horizontal .form-group-lg .control-label {
		padding-top: 11px;
		font-size: 18px
	}
}

@media (min-width:768px) {
	.dfbs .form-horizontal .form-group-sm .control-label {
		padding-top: 6px;
		font-size: 12px
	}
}

.dfbs .btn {
	display: inline-block;
	margin-bottom: 0;
	font-weight: 400;
	text-align: center;
	vertical-align: middle;
	touch-action: manipulation;
	cursor: pointer;
	background-image: none;
	border: 1px solid transparent;
	white-space: nowrap;
	padding: 6px 12px;
	font-size: 14px;
	line-height: 1.42857143;
	border-radius: 4px;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none
}

.dfbs .btn.active.focus,
.dfbs .btn.active:focus,
.dfbs .btn.focus,
.dfbs .btn:active.focus,
.dfbs .btn:active:focus,
.dfbs .btn:focus {
	outline: 5px auto -webkit-focus-ring-color;
	outline-offset: -2px
}

.dfbs .btn.focus,
.dfbs .btn:focus,
.dfbs .btn:hover {
	color: #333;
	text-decoration: none
}

.dfbs .btn.active,
.dfbs .btn:active {
	outline: 0;
	background-image: none;
	-webkit-box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125);
	box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125)
}

.dfbs .btn.disabled,
.dfbs .btn[disabled],
fieldset[disabled] .dfbs .btn {
	cursor: not-allowed;
	opacity: .65;
	filter: alpha(opacity=65);
	-webkit-box-shadow: none;
	box-shadow: none
}

a.dfbs .btn.disabled,
fieldset[disabled] a.dfbs .btn {
	pointer-events: none
}

.dfbs .btn-default {
	color: #333;
	background-color: #fff;
	border-color: #ccc
}

.dfbs .btn-default.focus,
.dfbs .btn-default:focus {
	color: #333;
	background-color: #e6e6e6;
	border-color: #8c8c8c
}

.dfbs .btn-default:hover {
	color: #333;
	background-color: #e6e6e6;
	border-color: #adadad
}

.dfbs .btn-default.active,
.dfbs .btn-default:active,
.open>.dropdown-toggle.dfbs .btn-default {
	color: #333;
	background-color: #e6e6e6;
	border-color: #adadad
}

.dfbs .btn-default.active.focus,
.dfbs .btn-default.active:focus,
.dfbs .btn-default.active:hover,
.dfbs .btn-default:active.focus,
.dfbs .btn-default:active:focus,
.dfbs .btn-default:active:hover,
.open>.dropdown-toggle.dfbs .btn-default.focus,
.open>.dropdown-toggle.dfbs .btn-default:focus,
.open>.dropdown-toggle.dfbs .btn-default:hover {
	color: #333;
	background-color: #d4d4d4;
	border-color: #8c8c8c
}

.dfbs .btn-default.active,
.dfbs .btn-default:active,
.open>.dropdown-toggle.dfbs .btn-default {
	background-image: none
}

.dfbs .btn-default.disabled.focus,
.dfbs .btn-default.disabled:focus,
.dfbs .btn-default.disabled:hover,
.dfbs .btn-default[disabled].focus,
.dfbs .btn-default[disabled]:focus,
.dfbs .btn-default[disabled]:hover,
fieldset[disabled] .dfbs .btn-default.focus,
fieldset[disabled] .dfbs .btn-default:focus,
fieldset[disabled] .dfbs .btn-default:hover {
	background-color: #fff;
	border-color: #ccc
}

.dfbs .btn-default .badge {
	color: #fff;
	background-color: #333
}

.dfbs .btn-primary {
	color: #fff;
	background-color: #337ab7;
	border-color: #2e6da4
}

.dfbs .btn-primary.focus,
.dfbs .btn-primary:focus {
	color: #fff;
	background-color: #286090;
	border-color: #122b40
}

.dfbs .btn-primary:hover {
	color: #fff;
	background-color: #286090;
	border-color: #204d74
}

.dfbs .btn-primary.active,
.dfbs .btn-primary:active,
.open>.dropdown-toggle.dfbs .btn-primary {
	color: #fff;
	background-color: #286090;
	border-color: #204d74
}

.dfbs .btn-primary.active.focus,
.dfbs .btn-primary.active:focus,
.dfbs .btn-primary.active:hover,
.dfbs .btn-primary:active.focus,
.dfbs .btn-primary:active:focus,
.dfbs .btn-primary:active:hover,
.open>.dropdown-toggle.dfbs .btn-primary.focus,
.open>.dropdown-toggle.dfbs .btn-primary:focus,
.open>.dropdown-toggle.dfbs .btn-primary:hover {
	color: #fff;
	background-color: #204d74;
	border-color: #122b40
}

.dfbs .btn-primary.active,
.dfbs .btn-primary:active,
.open>.dropdown-toggle.dfbs .btn-primary {
	background-image: none
}

.dfbs .btn-primary.disabled.focus,
.dfbs .btn-primary.disabled:focus,
.dfbs .btn-primary.disabled:hover,
.dfbs .btn-primary[disabled].focus,
.dfbs .btn-primary[disabled]:focus,
.dfbs .btn-primary[disabled]:hover,
fieldset[disabled] .dfbs .btn-primary.focus,
fieldset[disabled] .dfbs .btn-primary:focus,
fieldset[disabled] .dfbs .btn-primary:hover {
	background-color: #337ab7;
	border-color: #2e6da4
}

.dfbs .btn-primary .badge {
	color: #337ab7;
	background-color: #fff
}

.dfbs .btn-success {
	color: #fff;
	background-color: #5cb85c;
	border-color: #4cae4c
}

.dfbs .btn-success.focus,
.dfbs .btn-success:focus {
	color: #fff;
	background-color: #449d44;
	border-color: #255625
}

.dfbs .btn-success:hover {
	color: #fff;
	background-color: #449d44;
	border-color: #398439
}

.dfbs .btn-success.active,
.dfbs .btn-success:active,
.open>.dropdown-toggle.dfbs .btn-success {
	color: #fff;
	background-color: #449d44;
	border-color: #398439
}

.dfbs .btn-success.active.focus,
.dfbs .btn-success.active:focus,
.dfbs .btn-success.active:hover,
.dfbs .btn-success:active.focus,
.dfbs .btn-success:active:focus,
.dfbs .btn-success:active:hover,
.open>.dropdown-toggle.dfbs .btn-success.focus,
.open>.dropdown-toggle.dfbs .btn-success:focus,
.open>.dropdown-toggle.dfbs .btn-success:hover {
	color: #fff;
	background-color: #398439;
	border-color: #255625
}

.dfbs .btn-success.active,
.dfbs .btn-success:active,
.open>.dropdown-toggle.dfbs .btn-success {
	background-image: none
}

.dfbs .btn-success.disabled.focus,
.dfbs .btn-success.disabled:focus,
.dfbs .btn-success.disabled:hover,
.dfbs .btn-success[disabled].focus,
.dfbs .btn-success[disabled]:focus,
.dfbs .btn-success[disabled]:hover,
fieldset[disabled] .dfbs .btn-success.focus,
fieldset[disabled] .dfbs .btn-success:focus,
fieldset[disabled] .dfbs .btn-success:hover {
	background-color: #5cb85c;
	border-color: #4cae4c
}

.dfbs .btn-success .badge {
	color: #5cb85c;
	background-color: #fff
}

.dfbs .btn-info {
	color: #fff;
	background-color: #5bc0de;
	border-color: #46b8da
}

.dfbs .btn-info.focus,
.dfbs .btn-info:focus {
	color: #fff;
	background-color: #31b0d5;
	border-color: #1b6d85
}

.dfbs .btn-info:hover {
	color: #fff;
	background-color: #31b0d5;
	border-color: #269abc
}

.dfbs .btn-info.active,
.dfbs .btn-info:active,
.open>.dropdown-toggle.dfbs .btn-info {
	color: #fff;
	background-color: #31b0d5;
	border-color: #269abc
}

.dfbs .btn-info.active.focus,
.dfbs .btn-info.active:focus,
.dfbs .btn-info.active:hover,
.dfbs .btn-info:active.focus,
.dfbs .btn-info:active:focus,
.dfbs .btn-info:active:hover,
.open>.dropdown-toggle.dfbs .btn-info.focus,
.open>.dropdown-toggle.dfbs .btn-info:focus,
.open>.dropdown-toggle.dfbs .btn-info:hover {
	color: #fff;
	background-color: #269abc;
	border-color: #1b6d85
}

.dfbs .btn-info.active,
.dfbs .btn-info:active,
.open>.dropdown-toggle.dfbs .btn-info {
	background-image: none
}

.dfbs .btn-info.disabled.focus,
.dfbs .btn-info.disabled:focus,
.dfbs .btn-info.disabled:hover,
.dfbs .btn-info[disabled].focus,
.dfbs .btn-info[disabled]:focus,
.dfbs .btn-info[disabled]:hover,
fieldset[disabled] .dfbs .btn-info.focus,
fieldset[disabled] .dfbs .btn-info:focus,
fieldset[disabled] .dfbs .btn-info:hover {
	background-color: #5bc0de;
	border-color: #46b8da
}

.dfbs .btn-info .badge {
	color: #5bc0de;
	background-color: #fff
}

.dfbs .btn-warning {
	color: #fff;
	background-color: #f0ad4e;
	border-color: #eea236
}

.dfbs .btn-warning.focus,
.dfbs .btn-warning:focus {
	color: #fff;
	background-color: #ec971f;
	border-color: #985f0d
}

.dfbs .btn-warning:hover {
	color: #fff;
	background-color: #ec971f;
	border-color: #d58512
}

.dfbs .btn-warning.active,
.dfbs .btn-warning:active,
.open>.dropdown-toggle.dfbs .btn-warning {
	color: #fff;
	background-color: #ec971f;
	border-color: #d58512
}

.dfbs .btn-warning.active.focus,
.dfbs .btn-warning.active:focus,
.dfbs .btn-warning.active:hover,
.dfbs .btn-warning:active.focus,
.dfbs .btn-warning:active:focus,
.dfbs .btn-warning:active:hover,
.open>.dropdown-toggle.dfbs .btn-warning.focus,
.open>.dropdown-toggle.dfbs .btn-warning:focus,
.open>.dropdown-toggle.dfbs .btn-warning:hover {
	color: #fff;
	background-color: #d58512;
	border-color: #985f0d
}

.dfbs .btn-warning.active,
.dfbs .btn-warning:active,
.open>.dropdown-toggle.dfbs .btn-warning {
	background-image: none
}

.dfbs .btn-warning.disabled.focus,
.dfbs .btn-warning.disabled:focus,
.dfbs .btn-warning.disabled:hover,
.dfbs .btn-warning[disabled].focus,
.dfbs .btn-warning[disabled]:focus,
.dfbs .btn-warning[disabled]:hover,
fieldset[disabled] .dfbs .btn-warning.focus,
fieldset[disabled] .dfbs .btn-warning:focus,
fieldset[disabled] .dfbs .btn-warning:hover {
	background-color: #f0ad4e;
	border-color: #eea236
}

.dfbs .btn-warning .badge {
	color: #f0ad4e;
	background-color: #fff
}

.dfbs .btn-danger {
	color: #fff;
	background-color: #d9534f;
	border-color: #d43f3a
}

.dfbs .btn-danger.focus,
.dfbs .btn-danger:focus {
	color: #fff;
	background-color: #c9302c;
	border-color: #761c19
}

.dfbs .btn-danger:hover {
	color: #fff;
	background-color: #c9302c;
	border-color: #ac2925
}

.dfbs .btn-danger.active,
.dfbs .btn-danger:active,
.open>.dropdown-toggle.dfbs .btn-danger {
	color: #fff;
	background-color: #c9302c;
	border-color: #ac2925
}

.dfbs .btn-danger.active.focus,
.dfbs .btn-danger.active:focus,
.dfbs .btn-danger.active:hover,
.dfbs .btn-danger:active.focus,
.dfbs .btn-danger:active:focus,
.dfbs .btn-danger:active:hover,
.open>.dropdown-toggle.dfbs .btn-danger.focus,
.open>.dropdown-toggle.dfbs .btn-danger:focus,
.open>.dropdown-toggle.dfbs .btn-danger:hover {
	color: #fff;
	background-color: #ac2925;
	border-color: #761c19
}

.dfbs .btn-danger.active,
.dfbs .btn-danger:active,
.open>.dropdown-toggle.dfbs .btn-danger {
	background-image: none
}

.dfbs .btn-danger.disabled.focus,
.dfbs .btn-danger.disabled:focus,
.dfbs .btn-danger.disabled:hover,
.dfbs .btn-danger[disabled].focus,
.dfbs .btn-danger[disabled]:focus,
.dfbs .btn-danger[disabled]:hover,
fieldset[disabled] .dfbs .btn-danger.focus,
fieldset[disabled] .dfbs .btn-danger:focus,
fieldset[disabled] .dfbs .btn-danger:hover {
	background-color: #d9534f;
	border-color: #d43f3a
}

.dfbs .btn-danger .badge {
	color: #d9534f;
	background-color: #fff
}

.dfbs .btn-link {
	color: #337ab7;
	font-weight: 400;
	border-radius: 0
}

.dfbs .btn-link,
.dfbs .btn-link.active,
.dfbs .btn-link:active,
.dfbs .btn-link[disabled],
fieldset[disabled] .dfbs .btn-link {
	background-color: transparent;
	-webkit-box-shadow: none;
	box-shadow: none
}

.dfbs .btn-link,
.dfbs .btn-link:active,
.dfbs .btn-link:focus,
.dfbs .btn-link:hover {
	border-color: transparent
}

.dfbs .btn-link:focus,
.dfbs .btn-link:hover {
	color: #23527c;
	text-decoration: underline;
	background-color: transparent
}

.dfbs .btn-link[disabled]:focus,
.dfbs .btn-link[disabled]:hover,
fieldset[disabled] .dfbs .btn-link:focus,
fieldset[disabled] .dfbs .btn-link:hover {
	color: #777;
	text-decoration: none
}

.dfbs .btn-lg {
	padding: 10px 16px;
	font-size: 18px;
	line-height: 1.3333333;
	border-radius: 6px
}

.dfbs .btn-sm {
	padding: 5px 10px;
	font-size: 12px;
	line-height: 1.5;
	border-radius: 3px
}

.dfbs .btn-xs {
	padding: 1px 5px;
	font-size: 12px;
	line-height: 1.5;
	border-radius: 3px
}

.dfbs .btn-block {
	display: block;
	width: 100%
}

.dfbs .btn-block+.btn-block {
	margin-top: 5px
}

.dfbs input[type=button].btn-block,
.dfbs input[type=reset].btn-block,
.dfbs input[type=submit].btn-block {
	width: 100%
}

.dfbs .fade {
	opacity: 0;
	-webkit-transition: opacity .15s linear;
	-o-transition: opacity .15s linear;
	transition: opacity .15s linear
}

.dfbs .fade.in {
	opacity: 1
}

.dfbs .collapse {
	display: none
}

.dfbs .collapse.in {
	display: block
}

tr.dfbs .collapse.in {
	display: table-row
}

tbody.dfbs .collapse.in {
	display: table-row-group
}

.dfbs .collapsing {
	position: relative;
	height: 0;
	overflow: hidden;
	-webkit-transition-property: height, visibility;
	transition-property: height, visibility;
	-webkit-transition-duration: .35s;
	transition-duration: .35s;
	-webkit-transition-timing-function: ease;
	transition-timing-function: ease
}

.dfbs .caret {
	display: inline-block;
	width: 0;
	height: 0;
	margin-left: 2px;
	vertical-align: middle;
	border-top: 4px dashed;
	border-top: 4px solid\9;
	border-right: 4px solid transparent;
	border-left: 4px solid transparent
}

.dfbs .dropdown,
.dfbs .dropup {
	position: relative
}

.dfbs .dropdown-toggle:focus {
	outline: 0
}

.dfbs .dropdown-menu {
	position: absolute;
	top: 100%;
	left: 0;
	z-index: 1000;
	display: none;
	float: left;
	min-width: 160px;
	padding: 5px 0;
	margin: 2px 0 0;
	list-style: none;
	font-size: 14px;
	text-align: left;
	background-color: #fff;
	border: 1px solid #ccc;
	border: 1px solid rgba(0, 0, 0, .15);
	border-radius: 4px;
	-webkit-box-shadow: 0 6px 12px rgba(0, 0, 0, .175);
	box-shadow: 0 6px 12px rgba(0, 0, 0, .175);
	background-clip: padding-box
}

.dfbs .dropdown-menu.pull-right {
	right: 0;
	left: auto
}

.dfbs .dropdown-menu .divider {
	height: 1px;
	margin: 9px 0;
	overflow: hidden;
	background-color: #e5e5e5
}

.dfbs .dropdown-menu>li>a {
	display: block;
	padding: 3px 20px;
	clear: both;
	font-weight: 400;
	line-height: 1.42857143;
	color: #333;
	white-space: nowrap
}

.dfbs .dropdown-menu>li>a:focus,
.dfbs .dropdown-menu>li>a:hover {
	text-decoration: none;
	color: #262626;
	background-color: #f5f5f5
}

.dfbs .dropdown-menu>.active>a,
.dfbs .dropdown-menu>.active>a:focus,
.dfbs .dropdown-menu>.active>a:hover {
	color: #fff;
	text-decoration: none;
	outline: 0;
	background-color: #337ab7
}

.dfbs .dropdown-menu>.disabled>a,
.dfbs .dropdown-menu>.disabled>a:focus,
.dfbs .dropdown-menu>.disabled>a:hover {
	color: #777
}

.dfbs .dropdown-menu>.disabled>a:focus,
.dfbs .dropdown-menu>.disabled>a:hover {
	text-decoration: none;
	background-color: transparent;
	background-image: none;
	filter: progid:DXImageTransform.Microsoft.gradient(enabled=false);
	cursor: not-allowed
}

.dfbs .open>.dropdown-menu {
	display: block
}

.dfbs .open>a {
	outline: 0
}

.dfbs .dropdown-menu-right {
	left: auto;
	right: 0
}

.dfbs .dropdown-menu-left {
	left: 0;
	right: auto
}

.dfbs .dropdown-header {
	display: block;
	padding: 3px 20px;
	font-size: 12px;
	line-height: 1.42857143;
	color: #777;
	white-space: nowrap
}

.dfbs .dropdown-backdrop {
	position: fixed;
	left: 0;
	right: 0;
	bottom: 0;
	top: 0;
	z-index: 990
}

.dfbs .pull-right>.dropdown-menu {
	right: 0;
	left: auto
}

.dfbs .dropup .caret,
.dfbs .navbar-fixed-bottom .dropdown .caret {
	border-top: 0;
	border-bottom: 4px dashed;
	border-bottom: 4px solid\9;
	content: ""
}

.dfbs .dropup .dropdown-menu,
.dfbs .navbar-fixed-bottom .dropdown .dropdown-menu {
	top: auto;
	bottom: 100%;
	margin-bottom: 2px
}

@media (min-width:768px) {
	.dfbs .navbar-right .dropdown-menu {
		left: auto;
		right: 0
	}
	.dfbs .navbar-right .dropdown-menu-left {
		left: 0;
		right: auto
	}
}

.dfbs .btn-group,
.dfbs .btn-group-vertical {
	position: relative;
	display: inline-block;
	vertical-align: middle
}

.dfbs .btn-group-vertical>.btn,
.dfbs .btn-group>.btn {
	position: relative;
	float: left
}

.dfbs .btn-group-vertical>.btn.active,
.dfbs .btn-group-vertical>.btn:active,
.dfbs .btn-group-vertical>.btn:focus,
.dfbs .btn-group-vertical>.btn:hover,
.dfbs .btn-group>.btn.active,
.dfbs .btn-group>.btn:active,
.dfbs .btn-group>.btn:focus,
.dfbs .btn-group>.btn:hover {
	z-index: 2
}

.dfbs .btn-group .btn+.btn,
.dfbs .btn-group .btn+.btn-group,
.dfbs .btn-group .btn-group+.btn,
.dfbs .btn-group .btn-group+.btn-group {
	margin-left: -1px
}

.dfbs .btn-toolbar {
	margin-left: -5px
}

.dfbs .btn-toolbar .btn,
.dfbs .btn-toolbar .btn-group,
.dfbs .btn-toolbar .input-group {
	float: left
}

.dfbs .btn-toolbar>.btn,
.dfbs .btn-toolbar>.btn-group,
.dfbs .btn-toolbar>.input-group {
	margin-left: 5px
}

.dfbs .btn-group>.btn:not(:first-child):not(:last-child):not(.dropdown-toggle) {
	border-radius: 0
}

.dfbs .btn-group>.btn:first-child {
	margin-left: 0
}

.dfbs .btn-group>.btn:first-child:not(:last-child):not(.dropdown-toggle) {
	border-bottom-right-radius: 0;
	border-top-right-radius: 0
}

.dfbs .btn-group>.btn:last-child:not(:first-child),
.dfbs .btn-group>.dropdown-toggle:not(:first-child) {
	border-bottom-left-radius: 0;
	border-top-left-radius: 0
}

.dfbs .btn-group>.btn-group {
	float: left
}

.dfbs .btn-group>.btn-group:not(:first-child):not(:last-child)>.btn {
	border-radius: 0
}

.dfbs .btn-group>.btn-group:first-child:not(:last-child)>.btn:last-child,
.dfbs .btn-group>.btn-group:first-child:not(:last-child)>.dropdown-toggle {
	border-bottom-right-radius: 0;
	border-top-right-radius: 0
}

.dfbs .btn-group>.btn-group:last-child:not(:first-child)>.btn:first-child {
	border-bottom-left-radius: 0;
	border-top-left-radius: 0
}

.dfbs .btn-group .dropdown-toggle:active,
.dfbs .btn-group.open .dropdown-toggle {
	outline: 0
}

.dfbs .btn-group>.btn+.dropdown-toggle {
	padding-left: 8px;
	padding-right: 8px
}

.dfbs .btn-group>.btn-lg+.dropdown-toggle {
	padding-left: 12px;
	padding-right: 12px
}

.dfbs .btn-group.open .dropdown-toggle {
	-webkit-box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125);
	box-shadow: inset 0 3px 5px rgba(0, 0, 0, .125)
}

.dfbs .btn-group.open .dropdown-toggle.btn-link {
	-webkit-box-shadow: none;
	box-shadow: none
}

.dfbs .btn .caret {
	margin-left: 0
}

.dfbs .btn-lg .caret {
	border-width: 5px 5px 0;
	border-bottom-width: 0
}

.dfbs .dropup .btn-lg .caret {
	border-width: 0 5px 5px
}

.dfbs .btn-group-vertical>.btn,
.dfbs .btn-group-vertical>.btn-group,
.dfbs .btn-group-vertical>.btn-group>.btn {
	display: block;
	float: none;
	width: 100%;
	max-width: 100%
}

.dfbs .btn-group-vertical>.btn-group>.btn {
	float: none
}

.dfbs .btn-group-vertical>.btn+.btn,
.dfbs .btn-group-vertical>.btn+.btn-group,
.dfbs .btn-group-vertical>.btn-group+.btn,
.dfbs .btn-group-vertical>.btn-group+.btn-group {
	margin-top: -1px;
	margin-left: 0
}

.dfbs .btn-group-vertical>.btn:not(:first-child):not(:last-child) {
	border-radius: 0
}

.dfbs .btn-group-vertical>.btn:first-child:not(:last-child) {
	border-top-right-radius: 4px;
	border-top-left-radius: 4px;
	border-bottom-right-radius: 0;
	border-bottom-left-radius: 0
}

.dfbs .btn-group-vertical>.btn:last-child:not(:first-child) {
	border-top-right-radius: 0;
	border-top-left-radius: 0;
	border-bottom-right-radius: 4px;
	border-bottom-left-radius: 4px
}

.dfbs .btn-group-vertical>.btn-group:not(:first-child):not(:last-child)>.btn {
	border-radius: 0
}

.dfbs .btn-group-vertical>.btn-group:first-child:not(:last-child)>.btn:last-child,
.dfbs .btn-group-vertical>.btn-group:first-child:not(:last-child)>.dropdown-toggle {
	border-bottom-right-radius: 0;
	border-bottom-left-radius: 0
}

.dfbs .btn-group-vertical>.btn-group:last-child:not(:first-child)>.btn:first-child {
	border-top-right-radius: 0;
	border-top-left-radius: 0
}

.dfbs .btn-group-justified {
	display: table;
	width: 100%;
	table-layout: fixed;
	border-collapse: separate
}

.dfbs .btn-group-justified>.btn,
.dfbs .btn-group-justified>.btn-group {
	float: none;
	display: table-cell;
	width: 1%
}

.dfbs .btn-group-justified>.btn-group .btn {
	width: 100%
}

.dfbs .btn-group-justified>.btn-group .dropdown-menu {
	left: auto
}

.dfbs [data-toggle=buttons]>.btn input[type=checkbox],
.dfbs [data-toggle=buttons]>.btn input[type=radio],
.dfbs [data-toggle=buttons]>.btn-group>.btn input[type=checkbox],
.dfbs [data-toggle=buttons]>.btn-group>.btn input[type=radio] {
	position: absolute;
	clip: rect(0, 0, 0, 0);
	pointer-events: none
}

.dfbs .input-group {
	position: relative;
	display: table;
	border-collapse: separate
}

.dfbs .input-group[class*=col-] {
	float: none;
	padding-left: 0;
	padding-right: 0
}

.dfbs .input-group .form-control {
	position: relative;
	z-index: 2;
	float: left;
	width: 100%;
	margin-bottom: 0
}

.dfbs .input-group .form-control:focus {
	z-index: 3
}

.dfbs .input-group-lg>.form-control,
.dfbs .input-group-lg>.input-group-addon,
.dfbs .input-group-lg>.input-group-btn>.btn {
	height: 46px;
	padding: 10px 16px;
	font-size: 18px;
	line-height: 1.3333333;
	border-radius: 6px
}

select.dfbs .input-group-lg>.form-control,
select.dfbs .input-group-lg>.input-group-addon,
select.dfbs .input-group-lg>.input-group-btn>.btn {
	height: 46px;
	line-height: 46px
}

select[multiple].dfbs .input-group-lg>.form-control,
select[multiple].dfbs .input-group-lg>.input-group-addon,
select[multiple].dfbs .input-group-lg>.input-group-btn>.btn,
textarea.dfbs .input-group-lg>.form-control,
textarea.dfbs .input-group-lg>.input-group-addon,
textarea.dfbs .input-group-lg>.input-group-btn>.btn {
	height: auto
}

.dfbs .input-group-sm>.form-control,
.dfbs .input-group-sm>.input-group-addon,
.dfbs .input-group-sm>.input-group-btn>.btn {
	height: 30px;
	padding: 5px 10px;
	font-size: 12px;
	line-height: 1.5;
	border-radius: 3px
}

select.dfbs .input-group-sm>.form-control,
select.dfbs .input-group-sm>.input-group-addon,
select.dfbs .input-group-sm>.input-group-btn>.btn {
	height: 30px;
	line-height: 30px
}

select[multiple].dfbs .input-group-sm>.form-control,
select[multiple].dfbs .input-group-sm>.input-group-addon,
select[multiple].dfbs .input-group-sm>.input-group-btn>.btn,
textarea.dfbs .input-group-sm>.form-control,
textarea.dfbs .input-group-sm>.input-group-addon,
textarea.dfbs .input-group-sm>.input-group-btn>.btn {
	height: auto
}

.dfbs .input-group .form-control,
.dfbs .input-group-addon,
.dfbs .input-group-btn {
	display: table-cell
}

.dfbs .input-group .form-control:not(:first-child):not(:last-child),
.dfbs .input-group-addon:not(:first-child):not(:last-child),
.dfbs .input-group-btn:not(:first-child):not(:last-child) {
	border-radius: 0
}

.dfbs .input-group-addon,
.dfbs .input-group-btn {
	width: 1%;
	white-space: nowrap;
	vertical-align: middle
}

.dfbs .input-group-addon {
	padding: 6px 12px;
	font-size: 14px;
	font-weight: 400;
	line-height: 1;
	color: #555;
	text-align: center;
	background-color: #eee;
	border: 1px solid #ccc;
	border-radius: 4px
}

.dfbs .input-group-addon.input-sm {
	padding: 5px 10px;
	font-size: 12px;
	border-radius: 3px
}

.dfbs .input-group-addon.input-lg {
	padding: 10px 16px;
	font-size: 18px;
	border-radius: 6px
}

.dfbs .input-group-addon input[type=checkbox],
.dfbs .input-group-addon input[type=radio] {
	margin-top: 0
}

.dfbs .input-group .form-control:first-child,
.dfbs .input-group-addon:first-child,
.dfbs .input-group-btn:first-child>.btn,
.dfbs .input-group-btn:first-child>.btn-group>.btn,
.dfbs .input-group-btn:first-child>.dropdown-toggle,
.dfbs .input-group-btn:last-child>.btn-group:not(:last-child)>.btn,
.dfbs .input-group-btn:last-child>.btn:not(:last-child):not(.dropdown-toggle) {
	border-bottom-right-radius: 0;
	border-top-right-radius: 0
}

.dfbs .input-group-addon:first-child {
	border-right: 0
}

.dfbs .input-group .form-control:last-child,
.dfbs .input-group-addon:last-child,
.dfbs .input-group-btn:first-child>.btn-group:not(:first-child)>.btn,
.dfbs .input-group-btn:first-child>.btn:not(:first-child),
.dfbs .input-group-btn:last-child>.btn,
.dfbs .input-group-btn:last-child>.btn-group>.btn,
.dfbs .input-group-btn:last-child>.dropdown-toggle {
	border-bottom-left-radius: 0;
	border-top-left-radius: 0
}

.dfbs .input-group-addon:last-child {
	border-left: 0
}

.dfbs .input-group-btn {
	position: relative;
	font-size: 0;
	white-space: nowrap
}

.dfbs .input-group-btn>.btn {
	position: relative
}

.dfbs .input-group-btn>.btn+.btn {
	margin-left: -1px
}

.dfbs .input-group-btn>.btn:active,
.dfbs .input-group-btn>.btn:focus,
.dfbs .input-group-btn>.btn:hover {
	z-index: 2
}

.dfbs .input-group-btn:first-child>.btn,
.dfbs .input-group-btn:first-child>.btn-group {
	margin-right: -1px
}

.dfbs .input-group-btn:last-child>.btn,
.dfbs .input-group-btn:last-child>.btn-group {
	z-index: 2;
	margin-left: -1px
}

.dfbs .nav {
	margin-bottom: 0;
	padding-left: 0;
	list-style: none
}

.dfbs .nav>li {
	position: relative;
	display: block
}

.dfbs .nav>li>a {
	position: relative;
	display: block;
	padding: 10px 15px
}

.dfbs .nav>li>a:focus,
.dfbs .nav>li>a:hover {
	text-decoration: none;
	background-color: #eee
}

.dfbs .nav>li.disabled>a {
	color: #777
}

.dfbs .nav>li.disabled>a:focus,
.dfbs .nav>li.disabled>a:hover {
	color: #777;
	text-decoration: none;
	background-color: transparent;
	cursor: not-allowed
}

.dfbs .nav .open>a,
.dfbs .nav .open>a:focus,
.dfbs .nav .open>a:hover {
	background-color: #eee;
	border-color: #337ab7
}

.dfbs .nav .nav-divider {
	height: 1px;
	margin: 9px 0;
	overflow: hidden;
	background-color: #e5e5e5
}

.dfbs .nav>li>a>img {
	max-width: none
}

.dfbs .nav-tabs {
	border-bottom: 1px solid #ddd
}

.dfbs .nav-tabs>li {
	float: left;
	margin-bottom: -1px
}

.dfbs .nav-tabs>li>a {
	margin-right: 2px;
	line-height: 1.42857143;
	border: 1px solid transparent;
	border-radius: 4px 4px 0 0
}

.dfbs .nav-tabs>li>a:hover {
	border-color: #eee #eee #ddd
}

.dfbs .nav-tabs>li.active>a,
.dfbs .nav-tabs>li.active>a:focus,
.dfbs .nav-tabs>li.active>a:hover {
	color: #555;
	background-color: #fff;
	border: 1px solid #ddd;
	border-bottom-color: transparent;
	cursor: default
}

.dfbs .nav-tabs.nav-justified {
	width: 100%;
	border-bottom: 0
}

.dfbs .nav-tabs.nav-justified>li {
	float: none
}

.dfbs .nav-tabs.nav-justified>li>a {
	text-align: center;
	margin-bottom: 5px
}

.dfbs .nav-tabs.nav-justified>.dropdown .dropdown-menu {
	top: auto;
	left: auto
}

@media (min-width:768px) {
	.dfbs .nav-tabs.nav-justified>li {
		display: table-cell;
		width: 1%
	}
	.dfbs .nav-tabs.nav-justified>li>a {
		margin-bottom: 0
	}
}

.dfbs .nav-tabs.nav-justified>li>a {
	margin-right: 0;
	border-radius: 4px
}

.dfbs .nav-tabs.nav-justified>.active>a,
.dfbs .nav-tabs.nav-justified>.active>a:focus,
.dfbs .nav-tabs.nav-justified>.active>a:hover {
	border: 1px solid #ddd
}

@media (min-width:768px) {
	.dfbs .nav-tabs.nav-justified>li>a {
		border-bottom: 1px solid #ddd;
		border-radius: 4px 4px 0 0
	}
	.dfbs .nav-tabs.nav-justified>.active>a,
	.dfbs .nav-tabs.nav-justified>.active>a:focus,
	.dfbs .nav-tabs.nav-justified>.active>a:hover {
		border-bottom-color: #fff
	}
}

.dfbs .nav-pills>li {
	float: left
}

.dfbs .nav-pills>li>a {
	border-radius: 4px
}

.dfbs .nav-pills>li+li {
	margin-left: 2px
}

.dfbs .nav-pills>li.active>a,
.dfbs .nav-pills>li.active>a:focus,
.dfbs .nav-pills>li.active>a:hover {
	color: #fff;
	background-color: #337ab7
}

.dfbs .nav-stacked>li {
	float: none
}

.dfbs .nav-stacked>li+li {
	margin-top: 2px;
	margin-left: 0
}

.dfbs .nav-justified {
	width: 100%
}

.dfbs .nav-justified>li {
	float: none
}

.dfbs .nav-justified>li>a {
	text-align: center;
	margin-bottom: 5px
}

.dfbs .nav-justified>.dropdown .dropdown-menu {
	top: auto;
	left: auto
}

@media (min-width:768px) {
	.dfbs .nav-justified>li {
		display: table-cell;
		width: 1%
	}
	.dfbs .nav-justified>li>a {
		margin-bottom: 0
	}
}

.dfbs .nav-tabs-justified {
	border-bottom: 0
}

.dfbs .nav-tabs-justified>li>a {
	margin-right: 0;
	border-radius: 4px
}

.dfbs .nav-tabs-justified>.active>a,
.dfbs .nav-tabs-justified>.active>a:focus,
.dfbs .nav-tabs-justified>.active>a:hover {
	border: 1px solid #ddd
}

@media (min-width:768px) {
	.dfbs .nav-tabs-justified>li>a {
		border-bottom: 1px solid #ddd;
		border-radius: 4px 4px 0 0
	}
	.dfbs .nav-tabs-justified>.active>a,
	.dfbs .nav-tabs-justified>.active>a:focus,
	.dfbs .nav-tabs-justified>.active>a:hover {
		border-bottom-color: #fff
	}
}

.dfbs .tab-content>.tab-pane {
	display: none
}

.dfbs .tab-content>.active {
	display: block
}

.dfbs .nav-tabs .dropdown-menu {
	margin-top: -1px;
	border-top-right-radius: 0;
	border-top-left-radius: 0
}

.dfbs .navbar {
	position: relative;
	min-height: 50px;
	margin-bottom: 20px;
	border: 1px solid transparent
}

@media (min-width:768px) {
	.dfbs .navbar {
		border-radius: 4px
	}
}

@media (min-width:768px) {
	.dfbs .navbar-header {
		float: left
	}
}

.dfbs .navbar-collapse {
	overflow-x: visible;
	padding-right: 15px;
	padding-left: 15px;
	border-top: 1px solid transparent;
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, .1);
	-webkit-overflow-scrolling: touch
}

.dfbs .navbar-collapse.in {
	overflow-y: auto
}

@media (min-width:768px) {
	.dfbs .navbar-collapse {
		width: auto;
		border-top: 0;
		box-shadow: none
	}
	.dfbs .navbar-collapse.collapse {
		display: block!important;
		height: auto!important;
		padding-bottom: 0;
		overflow: visible!important
	}
	.dfbs .navbar-collapse.in {
		overflow-y: visible
	}
	.navbar-fixed-bottom .dfbs .navbar-collapse,
	.navbar-fixed-top .dfbs .navbar-collapse,
	.navbar-static-top .dfbs .navbar-collapse {
		padding-left: 0;
		padding-right: 0
	}
}

.dfbs .navbar-fixed-bottom .navbar-collapse,
.dfbs .navbar-fixed-top .navbar-collapse {
	max-height: 340px
}

@media (max-device-width:480px) and (orientation:landscape) {
	.dfbs .navbar-fixed-bottom .navbar-collapse,
	.dfbs .navbar-fixed-top .navbar-collapse {
		max-height: 200px
	}
}

.dfbs .container-fluid>.navbar-collapse,
.dfbs .container-fluid>.navbar-header,
.dfbs .container>.navbar-collapse,
.dfbs .container>.navbar-header {
	margin-right: -15px;
	margin-left: -15px
}

@media (min-width:768px) {
	.dfbs .container-fluid>.navbar-collapse,
	.dfbs .container-fluid>.navbar-header,
	.dfbs .container>.navbar-collapse,
	.dfbs .container>.navbar-header {
		margin-right: 0;
		margin-left: 0
	}
}

.dfbs .navbar-static-top {
	z-index: 1000;
	border-width: 0 0 1px
}

@media (min-width:768px) {
	.dfbs .navbar-static-top {
		border-radius: 0
	}
}

.dfbs .navbar-fixed-bottom,
.dfbs .navbar-fixed-top {
	position: fixed;
	right: 0;
	left: 0;
	z-index: 1030
}

@media (min-width:768px) {
	.dfbs .navbar-fixed-bottom,
	.dfbs .navbar-fixed-top {
		border-radius: 0
	}
}

.dfbs .navbar-fixed-top {
	top: 0;
	border-width: 0 0 1px
}

.dfbs .navbar-fixed-bottom {
	bottom: 0;
	margin-bottom: 0;
	border-width: 1px 0 0
}

.dfbs .navbar-brand {
	float: left;
	padding: 15px 15px;
	font-size: 18px;
	line-height: 20px;
	height: 50px
}

.dfbs .navbar-brand:focus,
.dfbs .navbar-brand:hover {
	text-decoration: none
}

.dfbs .navbar-brand>img {
	display: block
}

@media (min-width:768px) {
	.navbar>.container .dfbs .navbar-brand,
	.navbar>.container-fluid .dfbs .navbar-brand {
		margin-left: -15px
	}
}

.dfbs .navbar-toggle {
	position: relative;
	float: right;
	margin-right: 15px;
	padding: 9px 10px;
	margin-top: 8px;
	margin-bottom: 8px;
	background-color: transparent;
	background-image: none;
	border: 1px solid transparent;
	border-radius: 4px
}

.dfbs .navbar-toggle:focus {
	outline: 0
}

.dfbs .navbar-toggle .icon-bar {
	display: block;
	width: 22px;
	height: 2px;
	border-radius: 1px
}

.dfbs .navbar-toggle .icon-bar+.icon-bar {
	margin-top: 4px
}

@media (min-width:768px) {
	.dfbs .navbar-toggle {
		display: none
	}
}

.dfbs .navbar-nav {
	margin: 7.5px -15px
}

.dfbs .navbar-nav>li>a {
	padding-top: 10px;
	padding-bottom: 10px;
	line-height: 20px
}

@media (max-width:767px) {
	.dfbs .navbar-nav .open .dropdown-menu {
		position: static;
		float: none;
		width: auto;
		margin-top: 0;
		background-color: transparent;
		border: 0;
		box-shadow: none
	}
	.dfbs .navbar-nav .open .dropdown-menu .dropdown-header,
	.dfbs .navbar-nav .open .dropdown-menu>li>a {
		padding: 5px 15px 5px 25px
	}
	.dfbs .navbar-nav .open .dropdown-menu>li>a {
		line-height: 20px
	}
	.dfbs .navbar-nav .open .dropdown-menu>li>a:focus,
	.dfbs .navbar-nav .open .dropdown-menu>li>a:hover {
		background-image: none
	}
}

@media (min-width:768px) {
	.dfbs .navbar-nav {
		float: left;
		margin: 0
	}
	.dfbs .navbar-nav>li {
		float: left
	}
	.dfbs .navbar-nav>li>a {
		padding-top: 15px;
		padding-bottom: 15px
	}
}

.dfbs .navbar-form {
	margin-left: -15px;
	margin-right: -15px;
	padding: 10px 15px;
	border-top: 1px solid transparent;
	border-bottom: 1px solid transparent;
	-webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, .1), 0 1px 0 rgba(255, 255, 255, .1);
	box-shadow: inset 0 1px 0 rgba(255, 255, 255, .1), 0 1px 0 rgba(255, 255, 255, .1);
	margin-top: 8px;
	margin-bottom: 8px
}

@media (min-width:768px) {
	.dfbs .navbar-form .form-group {
		display: inline-block;
		margin-bottom: 0;
		vertical-align: middle
	}
	.dfbs .navbar-form .form-control {
		display: inline-block;
		width: auto;
		vertical-align: middle
	}
	.dfbs .navbar-form .form-control-static {
		display: inline-block
	}
	.dfbs .navbar-form .input-group {
		display: inline-table;
		vertical-align: middle
	}
	.dfbs .navbar-form .input-group .form-control,
	.dfbs .navbar-form .input-group .input-group-addon,
	.dfbs .navbar-form .input-group .input-group-btn {
		width: auto
	}
	.dfbs .navbar-form .input-group>.form-control {
		width: 100%
	}
	.dfbs .navbar-form .control-label {
		margin-bottom: 0;
		vertical-align: middle
	}
	.dfbs .navbar-form .checkbox,
	.dfbs .navbar-form .radio {
		display: inline-block;
		margin-top: 0;
		margin-bottom: 0;
		vertical-align: middle
	}
	.dfbs .navbar-form .checkbox label,
	.dfbs .navbar-form .radio label {
		padding-left: 0
	}
	.dfbs .navbar-form .checkbox input[type=checkbox],
	.dfbs .navbar-form .radio input[type=radio] {
		position: relative;
		margin-left: 0
	}
	.dfbs .navbar-form .has-feedback .form-control-feedback {
		top: 0
	}
}

@media (max-width:767px) {
	.dfbs .navbar-form .form-group {
		margin-bottom: 5px
	}
	.dfbs .navbar-form .form-group:last-child {
		margin-bottom: 0
	}
}

@media (min-width:768px) {
	.dfbs .navbar-form {
		width: auto;
		border: 0;
		margin-left: 0;
		margin-right: 0;
		padding-top: 0;
		padding-bottom: 0;
		-webkit-box-shadow: none;
		box-shadow: none
	}
}

.dfbs .navbar-nav>li>.dropdown-menu {
	margin-top: 0;
	border-top-right-radius: 0;
	border-top-left-radius: 0
}

.dfbs .navbar-fixed-bottom .navbar-nav>li>.dropdown-menu {
	margin-bottom: 0;
	border-top-right-radius: 4px;
	border-top-left-radius: 4px;
	border-bottom-right-radius: 0;
	border-bottom-left-radius: 0
}

.dfbs .navbar-btn {
	margin-top: 8px;
	margin-bottom: 8px
}

.dfbs .navbar-btn.btn-sm {
	margin-top: 10px;
	margin-bottom: 10px
}

.dfbs .navbar-btn.btn-xs {
	margin-top: 14px;
	margin-bottom: 14px
}

.dfbs .navbar-text {
	margin-top: 15px;
	margin-bottom: 15px
}

@media (min-width:768px) {
	.dfbs .navbar-text {
		float: left;
		margin-left: 15px;
		margin-right: 15px
	}
}

@media (min-width:768px) {
	.dfbs .navbar-left {
		float: left!important
	}
	.dfbs .navbar-right {
		float: right!important;
		margin-right: -15px
	}
	.dfbs .navbar-right~.navbar-right {
		margin-right: 0
	}
}

.dfbs .navbar-default {
	background-color: #f8f8f8;
	border-color: #e7e7e7
}

.dfbs .navbar-default .navbar-brand {
	color: #777
}

.dfbs .navbar-default .navbar-brand:focus,
.dfbs .navbar-default .navbar-brand:hover {
	color: #5e5e5e;
	background-color: transparent
}

.dfbs .navbar-default .navbar-text {
	color: #777
}

.dfbs .navbar-default .navbar-nav>li>a {
	color: #777
}

.dfbs .navbar-default .navbar-nav>li>a:focus,
.dfbs .navbar-default .navbar-nav>li>a:hover {
	color: #333;
	background-color: transparent
}

.dfbs .navbar-default .navbar-nav>.active>a,
.dfbs .navbar-default .navbar-nav>.active>a:focus,
.dfbs .navbar-default .navbar-nav>.active>a:hover {
	color: #555;
	background-color: #e7e7e7
}

.dfbs .navbar-default .navbar-nav>.disabled>a,
.dfbs .navbar-default .navbar-nav>.disabled>a:focus,
.dfbs .navbar-default .navbar-nav>.disabled>a:hover {
	color: #ccc;
	background-color: transparent
}

.dfbs .navbar-default .navbar-toggle {
	border-color: #ddd
}

.dfbs .navbar-default .navbar-toggle:focus,
.dfbs .navbar-default .navbar-toggle:hover {
	background-color: #ddd
}

.dfbs .navbar-default .navbar-toggle .icon-bar {
	background-color: #888
}

.dfbs .navbar-default .navbar-collapse,
.dfbs .navbar-default .navbar-form {
	border-color: #e7e7e7
}

.dfbs .navbar-default .navbar-nav>.open>a,
.dfbs .navbar-default .navbar-nav>.open>a:focus,
.dfbs .navbar-default .navbar-nav>.open>a:hover {
	background-color: #e7e7e7;
	color: #555
}

@media (max-width:767px) {
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>li>a {
		color: #777
	}
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>li>a:focus,
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>li>a:hover {
		color: #333;
		background-color: transparent
	}
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>.active>a,
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>.active>a:focus,
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>.active>a:hover {
		color: #555;
		background-color: #e7e7e7
	}
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>.disabled>a,
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>.disabled>a:focus,
	.dfbs .navbar-default .navbar-nav .open .dropdown-menu>.disabled>a:hover {
		color: #ccc;
		background-color: transparent
	}
}

.dfbs .navbar-default .navbar-link {
	color: #777
}

.dfbs .navbar-default .navbar-link:hover {
	color: #333
}

.dfbs .navbar-default .btn-link {
	color: #777
}

.dfbs .navbar-default .btn-link:focus,
.dfbs .navbar-default .btn-link:hover {
	color: #333
}

.dfbs .navbar-default .btn-link[disabled]:focus,
.dfbs .navbar-default .btn-link[disabled]:hover,
fieldset[disabled] .dfbs .navbar-default .btn-link:focus,
fieldset[disabled] .dfbs .navbar-default .btn-link:hover {
	color: #ccc
}

.dfbs .navbar-inverse {
	background-color: #222;
	border-color: #080808
}

.dfbs .navbar-inverse .navbar-brand {
	color: #9d9d9d
}

.dfbs .navbar-inverse .navbar-brand:focus,
.dfbs .navbar-inverse .navbar-brand:hover {
	color: #fff;
	background-color: transparent
}

.dfbs .navbar-inverse .navbar-text {
	color: #9d9d9d
}

.dfbs .navbar-inverse .navbar-nav>li>a {
	color: #9d9d9d
}

.dfbs .navbar-inverse .navbar-nav>li>a:focus,
.dfbs .navbar-inverse .navbar-nav>li>a:hover {
	color: #fff;
	background-color: transparent
}

.dfbs .navbar-inverse .navbar-nav>.active>a,
.dfbs .navbar-inverse .navbar-nav>.active>a:focus,
.dfbs .navbar-inverse .navbar-nav>.active>a:hover {
	color: #fff;
	background-color: #080808
}

.dfbs .navbar-inverse .navbar-nav>.disabled>a,
.dfbs .navbar-inverse .navbar-nav>.disabled>a:focus,
.dfbs .navbar-inverse .navbar-nav>.disabled>a:hover {
	color: #444;
	background-color: transparent
}

.dfbs .navbar-inverse .navbar-toggle {
	border-color: #333
}

.dfbs .navbar-inverse .navbar-toggle:focus,
.dfbs .navbar-inverse .navbar-toggle:hover {
	background-color: #333
}

.dfbs .navbar-inverse .navbar-toggle .icon-bar {
	background-color: #fff
}

.dfbs .navbar-inverse .navbar-collapse,
.dfbs .navbar-inverse .navbar-form {
	border-color: #101010
}

.dfbs .navbar-inverse .navbar-nav>.open>a,
.dfbs .navbar-inverse .navbar-nav>.open>a:focus,
.dfbs .navbar-inverse .navbar-nav>.open>a:hover {
	background-color: #080808;
	color: #fff
}

@media (max-width:767px) {
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>.dropdown-header {
		border-color: #080808
	}
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu .divider {
		background-color: #080808
	}
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>li>a {
		color: #9d9d9d
	}
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>li>a:focus,
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>li>a:hover {
		color: #fff;
		background-color: transparent
	}
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>.active>a,
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>.active>a:focus,
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>.active>a:hover {
		color: #fff;
		background-color: #080808
	}
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>.disabled>a,
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>.disabled>a:focus,
	.dfbs .navbar-inverse .navbar-nav .open .dropdown-menu>.disabled>a:hover {
		color: #444;
		background-color: transparent
	}
}

.dfbs .navbar-inverse .navbar-link {
	color: #9d9d9d
}

.dfbs .navbar-inverse .navbar-link:hover {
	color: #fff
}

.dfbs .navbar-inverse .btn-link {
	color: #9d9d9d
}

.dfbs .navbar-inverse .btn-link:focus,
.dfbs .navbar-inverse .btn-link:hover {
	color: #fff
}

.dfbs .navbar-inverse .btn-link[disabled]:focus,
.dfbs .navbar-inverse .btn-link[disabled]:hover,
fieldset[disabled] .dfbs .navbar-inverse .btn-link:focus,
fieldset[disabled] .dfbs .navbar-inverse .btn-link:hover {
	color: #444
}

.dfbs .breadcrumb {
	padding: 8px 15px;
	margin-bottom: 20px;
	list-style: none;
	background-color: #f5f5f5;
	border-radius: 4px
}

.dfbs .breadcrumb>li {
	display: inline-block
}

.dfbs .breadcrumb>li+li:before {
	content: "/\00a0";
	padding: 0 5px;
	color: #ccc
}

.dfbs .breadcrumb>.active {
	color: #777
}

.dfbs .pagination {
	display: inline-block;
	padding-left: 0;
	margin: 20px 0;
	border-radius: 4px
}

.dfbs .pagination>li {
	display: inline
}

.dfbs .pagination>li>a,
.dfbs .pagination>li>span {
	position: relative;
	float: left;
	padding: 6px 12px;
	line-height: 1.42857143;
	text-decoration: none;
	color: #337ab7;
	background-color: #fff;
	border: 1px solid #ddd;
	margin-left: -1px
}

.dfbs .pagination>li:first-child>a,
.dfbs .pagination>li:first-child>span {
	margin-left: 0;
	border-bottom-left-radius: 4px;
	border-top-left-radius: 4px
}

.dfbs .pagination>li:last-child>a,
.dfbs .pagination>li:last-child>span {
	border-bottom-right-radius: 4px;
	border-top-right-radius: 4px
}

.dfbs .pagination>li>a:focus,
.dfbs .pagination>li>a:hover,
.dfbs .pagination>li>span:focus,
.dfbs .pagination>li>span:hover {
	z-index: 2;
	color: #23527c;
	background-color: #eee;
	border-color: #ddd
}

.dfbs .pagination>.active>a,
.dfbs .pagination>.active>a:focus,
.dfbs .pagination>.active>a:hover,
.dfbs .pagination>.active>span,
.dfbs .pagination>.active>span:focus,
.dfbs .pagination>.active>span:hover {
	z-index: 3;
	color: #fff;
	background-color: #337ab7;
	border-color: #337ab7;
	cursor: default
}

.dfbs .pagination>.disabled>a,
.dfbs .pagination>.disabled>a:focus,
.dfbs .pagination>.disabled>a:hover,
.dfbs .pagination>.disabled>span,
.dfbs .pagination>.disabled>span:focus,
.dfbs .pagination>.disabled>span:hover {
	color: #777;
	background-color: #fff;
	border-color: #ddd;
	cursor: not-allowed
}

.dfbs .pagination-lg>li>a,
.dfbs .pagination-lg>li>span {
	padding: 10px 16px;
	font-size: 18px;
	line-height: 1.3333333
}

.dfbs .pagination-lg>li:first-child>a,
.dfbs .pagination-lg>li:first-child>span {
	border-bottom-left-radius: 6px;
	border-top-left-radius: 6px
}

.dfbs .pagination-lg>li:last-child>a,
.dfbs .pagination-lg>li:last-child>span {
	border-bottom-right-radius: 6px;
	border-top-right-radius: 6px
}

.dfbs .pagination-sm>li>a,
.dfbs .pagination-sm>li>span {
	padding: 5px 10px;
	font-size: 12px;
	line-height: 1.5
}

.dfbs .pagination-sm>li:first-child>a,
.dfbs .pagination-sm>li:first-child>span {
	border-bottom-left-radius: 3px;
	border-top-left-radius: 3px
}

.dfbs .pagination-sm>li:last-child>a,
.dfbs .pagination-sm>li:last-child>span {
	border-bottom-right-radius: 3px;
	border-top-right-radius: 3px
}

.dfbs .pager {
	padding-left: 0;
	margin: 20px 0;
	list-style: none;
	text-align: center
}

.dfbs .pager li {
	display: inline
}

.dfbs .pager li>a,
.dfbs .pager li>span {
	display: inline-block;
	padding: 5px 14px;
	background-color: #fff;
	border: 1px solid #ddd;
	border-radius: 15px
}

.dfbs .pager li>a:focus,
.dfbs .pager li>a:hover {
	text-decoration: none;
	background-color: #eee
}

.dfbs .pager .next>a,
.dfbs .pager .next>span {
	float: right
}

.dfbs .pager .previous>a,
.dfbs .pager .previous>span {
	float: left
}

.dfbs .pager .disabled>a,
.dfbs .pager .disabled>a:focus,
.dfbs .pager .disabled>a:hover,
.dfbs .pager .disabled>span {
	color: #777;
	background-color: #fff;
	cursor: not-allowed
}

.dfbs .label {
	display: inline;
	padding: .2em .6em .3em;
	font-size: 75%;
	font-weight: 700;
	line-height: 1;
	color: #fff;
	text-align: center;
	white-space: nowrap;
	vertical-align: baseline;
	border-radius: .25em
}

a.dfbs .label:focus,
a.dfbs .label:hover {
	color: #fff;
	text-decoration: none;
	cursor: pointer
}

.dfbs .label:empty {
	display: none
}

.btn .dfbs .label {
	position: relative;
	top: -1px
}

.dfbs .label-default {
	background-color: #777
}

.dfbs .label-default[href]:focus,
.dfbs .label-default[href]:hover {
	background-color: #5e5e5e
}

.dfbs .label-primary {
	background-color: #337ab7
}

.dfbs .label-primary[href]:focus,
.dfbs .label-primary[href]:hover {
	background-color: #286090
}

.dfbs .label-success {
	background-color: #5cb85c
}

.dfbs .label-success[href]:focus,
.dfbs .label-success[href]:hover {
	background-color: #449d44
}

.dfbs .label-info {
	background-color: #5bc0de
}

.dfbs .label-info[href]:focus,
.dfbs .label-info[href]:hover {
	background-color: #31b0d5
}

.dfbs .label-warning {
	background-color: #f0ad4e
}

.dfbs .label-warning[href]:focus,
.dfbs .label-warning[href]:hover {
	background-color: #ec971f
}

.dfbs .label-danger {
	background-color: #d9534f
}

.dfbs .label-danger[href]:focus,
.dfbs .label-danger[href]:hover {
	background-color: #c9302c
}

.dfbs .badge {
	display: inline-block;
	min-width: 10px;
	padding: 3px 7px;
	font-size: 12px;
	font-weight: 700;
	color: #fff;
	line-height: 1;
	vertical-align: middle;
	white-space: nowrap;
	text-align: center;
	background-color: #777;
	border-radius: 10px
}

.dfbs .badge:empty {
	display: none
}

.btn .dfbs .badge {
	position: relative;
	top: -1px
}

.btn-group-xs>.btn .dfbs .badge,
.btn-xs .dfbs .badge {
	top: 0;
	padding: 1px 5px
}

a.dfbs .badge:focus,
a.dfbs .badge:hover {
	color: #fff;
	text-decoration: none;
	cursor: pointer
}

.list-group-item.active>.dfbs .badge,
.nav-pills>.active>a>.dfbs .badge {
	color: #337ab7;
	background-color: #fff
}

.list-group-item>.dfbs .badge {
	float: right
}

.list-group-item>.dfbs .badge+.dfbs .badge {
	margin-right: 5px
}

.nav-pills>li>a>.dfbs .badge {
	margin-left: 3px
}

.dfbs .jumbotron {
	padding-top: 30px;
	padding-bottom: 30px;
	margin-bottom: 30px;
	color: inherit;
	background-color: #eee
}

.dfbs .jumbotron .h1,
.dfbs .jumbotron h1 {
	color: inherit
}

.dfbs .jumbotron p {
	margin-bottom: 15px;
	font-size: 21px;
	font-weight: 200
}

.dfbs .jumbotron>hr {
	border-top-color: #d5d5d5
}

.container .dfbs .jumbotron,
.container-fluid .dfbs .jumbotron {
	border-radius: 6px;
	padding-left: 15px;
	padding-right: 15px
}

.dfbs .jumbotron .container {
	max-width: 100%
}

@media screen and (min-width:768px) {
	.dfbs .jumbotron {
		padding-top: 48px;
		padding-bottom: 48px
	}
	.container .dfbs .jumbotron,
	.container-fluid .dfbs .jumbotron {
		padding-left: 60px;
		padding-right: 60px
	}
	.dfbs .jumbotron .h1,
	.dfbs .jumbotron h1 {
		font-size: 63px
	}
}

.dfbs .thumbnail {
	display: block;
	padding: 4px;
	margin-bottom: 20px;
	line-height: 1.42857143;
	background-color: #fff;
	border: 1px solid #ddd;
	border-radius: 4px;
	-webkit-transition: border .2s ease-in-out;
	-o-transition: border .2s ease-in-out;
	transition: border .2s ease-in-out
}

.dfbs .thumbnail a>img,
.dfbs .thumbnail>img {
	margin-left: auto;
	margin-right: auto
}

a.dfbs .thumbnail.active,
a.dfbs .thumbnail:focus,
a.dfbs .thumbnail:hover {
	border-color: #337ab7
}

.dfbs .thumbnail .caption {
	padding: 9px;
	color: #333
}

.dfbs .alert {
	padding: 15px;
	margin-bottom: 20px;
	border: 1px solid transparent;
	border-radius: 4px
}

.dfbs .alert h4 {
	margin-top: 0;
	color: inherit
}

.dfbs .alert .alert-link {
	font-weight: 700
}

.dfbs .alert>p,
.dfbs .alert>ul {
	margin-bottom: 0
}

.dfbs .alert>p+p {
	margin-top: 5px
}

.dfbs .alert-dismissable,
.dfbs .alert-dismissible {
	padding-right: 35px
}

.dfbs .alert-dismissable .close,
.dfbs .alert-dismissible .close {
	position: relative;
	top: -2px;
	right: -21px;
	color: inherit
}

.dfbs .alert-success {
	background-color: #dff0d8;
	border-color: #d6e9c6;
	color: #3c763d
}

.dfbs .alert-success hr {
	border-top-color: #c9e2b3
}

.dfbs .alert-success .alert-link {
	color: #2b542c
}

.dfbs .alert-info {
	background-color: #d9edf7;
	border-color: #bce8f1;
	color: #31708f
}

.dfbs .alert-info hr {
	border-top-color: #a6e1ec
}

.dfbs .alert-info .alert-link {
	color: #245269
}

.dfbs .alert-warning {
	background-color: #fcf8e3;
	border-color: #faebcc;
	color: #8a6d3b
}

.dfbs .alert-warning hr {
	border-top-color: #f7e1b5
}

.dfbs .alert-warning .alert-link {
	color: #66512c
}

.dfbs .alert-danger {
	background-color: #f2dede;
	border-color: #ebccd1;
	color: #a94442
}

.dfbs .alert-danger hr {
	border-top-color: #e4b9c0
}

.dfbs .alert-danger .alert-link {
	color: #843534
}

@-webkit-keyframes progress-bar-stripes {
	from {
		background-position: 40px 0
	}
	to {
		background-position: 0 0
	}
}

@keyframes progress-bar-stripes {
	from {
		background-position: 40px 0
	}
	to {
		background-position: 0 0
	}
}

.dfbs .progress {
	overflow: hidden;
	height: 20px;
	margin-bottom: 20px;
	background-color: #f5f5f5;
	border-radius: 4px;
	-webkit-box-shadow: inset 0 1px 2px rgba(0, 0, 0, .1);
	box-shadow: inset 0 1px 2px rgba(0, 0, 0, .1)
}

.dfbs .progress-bar {
	float: left;
	width: 0;
	height: 100%;
	font-size: 12px;
	line-height: 20px;
	color: #fff;
	text-align: center;
	background-color: #337ab7;
	-webkit-box-shadow: inset 0 -1px 0 rgba(0, 0, 0, .15);
	box-shadow: inset 0 -1px 0 rgba(0, 0, 0, .15);
	-webkit-transition: width .6s ease;
	-o-transition: width .6s ease;
	transition: width .6s ease
}

.dfbs .progress-bar-striped,
.dfbs .progress-striped .progress-bar {
	background-image: -webkit-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: -o-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-size: 40px 40px
}

.dfbs .progress-bar.active,
.dfbs .progress.active .progress-bar {
	-webkit-animation: progress-bar-stripes 2s linear infinite;
	-o-animation: progress-bar-stripes 2s linear infinite;
	animation: progress-bar-stripes 2s linear infinite
}

.dfbs .progress-bar-success {
	background-color: #5cb85c
}

.progress-striped .dfbs .progress-bar-success {
	background-image: -webkit-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: -o-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent)
}

.dfbs .progress-bar-info {
	background-color: #5bc0de
}

.progress-striped .dfbs .progress-bar-info {
	background-image: -webkit-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: -o-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent)
}

.dfbs .progress-bar-warning {
	background-color: #f0ad4e
}

.progress-striped .dfbs .progress-bar-warning {
	background-image: -webkit-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: -o-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent)
}

.dfbs .progress-bar-danger {
	background-color: #d9534f
}

.progress-striped .dfbs .progress-bar-danger {
	background-image: -webkit-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: -o-linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent);
	background-image: linear-gradient(45deg, rgba(255, 255, 255, .15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .15) 50%, rgba(255, 255, 255, .15) 75%, transparent 75%, transparent)
}

.dfbs .media {
	margin-top: 15px
}

.dfbs .media:first-child {
	margin-top: 0
}

.dfbs .media,
.dfbs .media-body {
	zoom: 1;
	overflow: hidden
}

.dfbs .media-body {
	width: 10000px
}

.dfbs .media-object {
	display: block
}

.dfbs .media-object.img-thumbnail {
	max-width: none
}

.dfbs .media-right,
.dfbs .media>.pull-right {
	padding-left: 10px
}

.dfbs .media-left,
.dfbs .media>.pull-left {
	padding-right: 10px
}

.dfbs .media-body,
.dfbs .media-left,
.dfbs .media-right {
	display: table-cell;
	vertical-align: top
}

.dfbs .media-middle {
	vertical-align: middle
}

.dfbs .media-bottom {
	vertical-align: bottom
}

.dfbs .media-heading {
	margin-top: 0;
	margin-bottom: 5px
}

.dfbs .media-list {
	padding-left: 0;
	list-style: none
}

.dfbs .list-group {
	margin-bottom: 20px;
	padding-left: 0
}

.dfbs .list-group-item {
	position: relative;
	display: block;
	padding: 10px 15px;
	margin-bottom: -1px;
	background-color: #fff;
	border: 1px solid #ddd
}

.dfbs .list-group-item:first-child {
	border-top-right-radius: 4px;
	border-top-left-radius: 4px
}

.dfbs .list-group-item:last-child {
	margin-bottom: 0;
	border-bottom-right-radius: 4px;
	border-bottom-left-radius: 4px
}

.dfbs a.list-group-item,
.dfbs button.list-group-item {
	color: #555
}

.dfbs a.list-group-item .list-group-item-heading,
.dfbs button.list-group-item .list-group-item-heading {
	color: #333
}

.dfbs a.list-group-item:focus,
.dfbs a.list-group-item:hover,
.dfbs button.list-group-item:focus,
.dfbs button.list-group-item:hover {
	text-decoration: none;
	color: #555;
	background-color: #f5f5f5
}

.dfbs button.list-group-item {
	width: 100%;
	text-align: left
}

.dfbs .list-group-item.disabled,
.dfbs .list-group-item.disabled:focus,
.dfbs .list-group-item.disabled:hover {
	background-color: #eee;
	color: #777;
	cursor: not-allowed
}

.dfbs .list-group-item.disabled .list-group-item-heading,
.dfbs .list-group-item.disabled:focus .list-group-item-heading,
.dfbs .list-group-item.disabled:hover .list-group-item-heading {
	color: inherit
}

.dfbs .list-group-item.disabled .list-group-item-text,
.dfbs .list-group-item.disabled:focus .list-group-item-text,
.dfbs .list-group-item.disabled:hover .list-group-item-text {
	color: #777
}

.dfbs .list-group-item.active,
.dfbs .list-group-item.active:focus,
.dfbs .list-group-item.active:hover {
	z-index: 2;
	color: #fff;
	background-color: #337ab7;
	border-color: #337ab7
}

.dfbs .list-group-item.active .list-group-item-heading,
.dfbs .list-group-item.active .list-group-item-heading>.small,
.dfbs .list-group-item.active .list-group-item-heading>small,
.dfbs .list-group-item.active:focus .list-group-item-heading,
.dfbs .list-group-item.active:focus .list-group-item-heading>.small,
.dfbs .list-group-item.active:focus .list-group-item-heading>small,
.dfbs .list-group-item.active:hover .list-group-item-heading,
.dfbs .list-group-item.active:hover .list-group-item-heading>.small,
.dfbs .list-group-item.active:hover .list-group-item-heading>small {
	color: inherit
}

.dfbs .list-group-item.active .list-group-item-text,
.dfbs .list-group-item.active:focus .list-group-item-text,
.dfbs .list-group-item.active:hover .list-group-item-text {
	color: #c7ddef
}

.dfbs .list-group-item-success {
	color: #3c763d;
	background-color: #dff0d8
}

a.dfbs .list-group-item-success,
button.dfbs .list-group-item-success {
	color: #3c763d
}

a.dfbs .list-group-item-success .list-group-item-heading,
button.dfbs .list-group-item-success .list-group-item-heading {
	color: inherit
}

a.dfbs .list-group-item-success:focus,
a.dfbs .list-group-item-success:hover,
button.dfbs .list-group-item-success:focus,
button.dfbs .list-group-item-success:hover {
	color: #3c763d;
	background-color: #d0e9c6
}

a.dfbs .list-group-item-success.active,
a.dfbs .list-group-item-success.active:focus,
a.dfbs .list-group-item-success.active:hover,
button.dfbs .list-group-item-success.active,
button.dfbs .list-group-item-success.active:focus,
button.dfbs .list-group-item-success.active:hover {
	color: #fff;
	background-color: #3c763d;
	border-color: #3c763d
}

.dfbs .list-group-item-info {
	color: #31708f;
	background-color: #d9edf7
}

a.dfbs .list-group-item-info,
button.dfbs .list-group-item-info {
	color: #31708f
}

a.dfbs .list-group-item-info .list-group-item-heading,
button.dfbs .list-group-item-info .list-group-item-heading {
	color: inherit
}

a.dfbs .list-group-item-info:focus,
a.dfbs .list-group-item-info:hover,
button.dfbs .list-group-item-info:focus,
button.dfbs .list-group-item-info:hover {
	color: #31708f;
	background-color: #c4e3f3
}

a.dfbs .list-group-item-info.active,
a.dfbs .list-group-item-info.active:focus,
a.dfbs .list-group-item-info.active:hover,
button.dfbs .list-group-item-info.active,
button.dfbs .list-group-item-info.active:focus,
button.dfbs .list-group-item-info.active:hover {
	color: #fff;
	background-color: #31708f;
	border-color: #31708f
}

.dfbs .list-group-item-warning {
	color: #8a6d3b;
	background-color: #fcf8e3
}

a.dfbs .list-group-item-warning,
button.dfbs .list-group-item-warning {
	color: #8a6d3b
}

a.dfbs .list-group-item-warning .list-group-item-heading,
button.dfbs .list-group-item-warning .list-group-item-heading {
	color: inherit
}

a.dfbs .list-group-item-warning:focus,
a.dfbs .list-group-item-warning:hover,
button.dfbs .list-group-item-warning:focus,
button.dfbs .list-group-item-warning:hover {
	color: #8a6d3b;
	background-color: #faf2cc
}

a.dfbs .list-group-item-warning.active,
a.dfbs .list-group-item-warning.active:focus,
a.dfbs .list-group-item-warning.active:hover,
button.dfbs .list-group-item-warning.active,
button.dfbs .list-group-item-warning.active:focus,
button.dfbs .list-group-item-warning.active:hover {
	color: #fff;
	background-color: #8a6d3b;
	border-color: #8a6d3b
}

.dfbs .list-group-item-danger {
	color: #a94442;
	background-color: #f2dede
}

a.dfbs .list-group-item-danger,
button.dfbs .list-group-item-danger {
	color: #a94442
}

a.dfbs .list-group-item-danger .list-group-item-heading,
button.dfbs .list-group-item-danger .list-group-item-heading {
	color: inherit
}

a.dfbs .list-group-item-danger:focus,
a.dfbs .list-group-item-danger:hover,
button.dfbs .list-group-item-danger:focus,
button.dfbs .list-group-item-danger:hover {
	color: #a94442;
	background-color: #ebcccc
}

a.dfbs .list-group-item-danger.active,
a.dfbs .list-group-item-danger.active:focus,
a.dfbs .list-group-item-danger.active:hover,
button.dfbs .list-group-item-danger.active,
button.dfbs .list-group-item-danger.active:focus,
button.dfbs .list-group-item-danger.active:hover {
	color: #fff;
	background-color: #a94442;
	border-color: #a94442
}

.dfbs .list-group-item-heading {
	margin-top: 0;
	margin-bottom: 5px
}

.dfbs .list-group-item-text {
	margin-bottom: 0;
	line-height: 1.3
}

.dfbs .panel {
	margin-bottom: 20px;
	background-color: #fff;
	border: 1px solid transparent;
	border-radius: 4px;
	-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
	box-shadow: 0 1px 1px rgba(0, 0, 0, .05)
}

.dfbs .panel-body {
	padding: 15px
}

.dfbs .panel-heading {
	padding: 10px 15px;
	border-bottom: 1px solid transparent;
	border-top-right-radius: 3px;
	border-top-left-radius: 3px
}

.dfbs .panel-heading>.dropdown .dropdown-toggle {
	color: inherit
}

.dfbs .panel-title {
	margin-top: 0;
	margin-bottom: 0;
	font-size: 16px;
	color: inherit
}

.dfbs .panel-title>.small,
.dfbs .panel-title>.small>a,
.dfbs .panel-title>a,
.dfbs .panel-title>small,
.dfbs .panel-title>small>a {
	color: inherit
}

.dfbs .panel-footer {
	padding: 10px 15px;
	background-color: #f5f5f5;
	border-top: 1px solid #ddd;
	border-bottom-right-radius: 3px;
	border-bottom-left-radius: 3px
}

.dfbs .panel>.list-group,
.dfbs .panel>.panel-collapse>.list-group {
	margin-bottom: 0
}

.dfbs .panel>.list-group .list-group-item,
.dfbs .panel>.panel-collapse>.list-group .list-group-item {
	border-width: 1px 0;
	border-radius: 0
}

.dfbs .panel>.list-group:first-child .list-group-item:first-child,
.dfbs .panel>.panel-collapse>.list-group:first-child .list-group-item:first-child {
	border-top: 0;
	border-top-right-radius: 3px;
	border-top-left-radius: 3px
}

.dfbs .panel>.list-group:last-child .list-group-item:last-child,
.dfbs .panel>.panel-collapse>.list-group:last-child .list-group-item:last-child {
	border-bottom: 0;
	border-bottom-right-radius: 3px;
	border-bottom-left-radius: 3px
}

.dfbs .panel>.panel-heading+.panel-collapse>.list-group .list-group-item:first-child {
	border-top-right-radius: 0;
	border-top-left-radius: 0
}

.dfbs .panel-heading+.list-group .list-group-item:first-child {
	border-top-width: 0
}

.dfbs .list-group+.panel-footer {
	border-top-width: 0
}

.dfbs .panel>.panel-collapse>.table,
.dfbs .panel>.table,
.dfbs .panel>.table-responsive>.table {
	margin-bottom: 0
}

.dfbs .panel>.panel-collapse>.table caption,
.dfbs .panel>.table caption,
.dfbs .panel>.table-responsive>.table caption {
	padding-left: 15px;
	padding-right: 15px
}

.dfbs .panel>.table-responsive:first-child>.table:first-child,
.dfbs .panel>.table:first-child {
	border-top-right-radius: 3px;
	border-top-left-radius: 3px
}

.dfbs .panel>.table-responsive:first-child>.table:first-child>tbody:first-child>tr:first-child,
.dfbs .panel>.table-responsive:first-child>.table:first-child>thead:first-child>tr:first-child,
.dfbs .panel>.table:first-child>tbody:first-child>tr:first-child,
.dfbs .panel>.table:first-child>thead:first-child>tr:first-child {
	border-top-left-radius: 3px;
	border-top-right-radius: 3px
}

.dfbs .panel>.table-responsive:first-child>.table:first-child>tbody:first-child>tr:first-child td:first-child,
.dfbs .panel>.table-responsive:first-child>.table:first-child>tbody:first-child>tr:first-child th:first-child,
.dfbs .panel>.table-responsive:first-child>.table:first-child>thead:first-child>tr:first-child td:first-child,
.dfbs .panel>.table-responsive:first-child>.table:first-child>thead:first-child>tr:first-child th:first-child,
.dfbs .panel>.table:first-child>tbody:first-child>tr:first-child td:first-child,
.dfbs .panel>.table:first-child>tbody:first-child>tr:first-child th:first-child,
.dfbs .panel>.table:first-child>thead:first-child>tr:first-child td:first-child,
.dfbs .panel>.table:first-child>thead:first-child>tr:first-child th:first-child {
	border-top-left-radius: 3px
}

.dfbs .panel>.table-responsive:first-child>.table:first-child>tbody:first-child>tr:first-child td:last-child,
.dfbs .panel>.table-responsive:first-child>.table:first-child>tbody:first-child>tr:first-child th:last-child,
.dfbs .panel>.table-responsive:first-child>.table:first-child>thead:first-child>tr:first-child td:last-child,
.dfbs .panel>.table-responsive:first-child>.table:first-child>thead:first-child>tr:first-child th:last-child,
.dfbs .panel>.table:first-child>tbody:first-child>tr:first-child td:last-child,
.dfbs .panel>.table:first-child>tbody:first-child>tr:first-child th:last-child,
.dfbs .panel>.table:first-child>thead:first-child>tr:first-child td:last-child,
.dfbs .panel>.table:first-child>thead:first-child>tr:first-child th:last-child {
	border-top-right-radius: 3px
}

.dfbs .panel>.table-responsive:last-child>.table:last-child,
.dfbs .panel>.table:last-child {
	border-bottom-right-radius: 3px;
	border-bottom-left-radius: 3px
}

.dfbs .panel>.table-responsive:last-child>.table:last-child>tbody:last-child>tr:last-child,
.dfbs .panel>.table-responsive:last-child>.table:last-child>tfoot:last-child>tr:last-child,
.dfbs .panel>.table:last-child>tbody:last-child>tr:last-child,
.dfbs .panel>.table:last-child>tfoot:last-child>tr:last-child {
	border-bottom-left-radius: 3px;
	border-bottom-right-radius: 3px
}

.dfbs .panel>.table-responsive:last-child>.table:last-child>tbody:last-child>tr:last-child td:first-child,
.dfbs .panel>.table-responsive:last-child>.table:last-child>tbody:last-child>tr:last-child th:first-child,
.dfbs .panel>.table-responsive:last-child>.table:last-child>tfoot:last-child>tr:last-child td:first-child,
.dfbs .panel>.table-responsive:last-child>.table:last-child>tfoot:last-child>tr:last-child th:first-child,
.dfbs .panel>.table:last-child>tbody:last-child>tr:last-child td:first-child,
.dfbs .panel>.table:last-child>tbody:last-child>tr:last-child th:first-child,
.dfbs .panel>.table:last-child>tfoot:last-child>tr:last-child td:first-child,
.dfbs .panel>.table:last-child>tfoot:last-child>tr:last-child th:first-child {
	border-bottom-left-radius: 3px
}

.dfbs .panel>.table-responsive:last-child>.table:last-child>tbody:last-child>tr:last-child td:last-child,
.dfbs .panel>.table-responsive:last-child>.table:last-child>tbody:last-child>tr:last-child th:last-child,
.dfbs .panel>.table-responsive:last-child>.table:last-child>tfoot:last-child>tr:last-child td:last-child,
.dfbs .panel>.table-responsive:last-child>.table:last-child>tfoot:last-child>tr:last-child th:last-child,
.dfbs .panel>.table:last-child>tbody:last-child>tr:last-child td:last-child,
.dfbs .panel>.table:last-child>tbody:last-child>tr:last-child th:last-child,
.dfbs .panel>.table:last-child>tfoot:last-child>tr:last-child td:last-child,
.dfbs .panel>.table:last-child>tfoot:last-child>tr:last-child th:last-child {
	border-bottom-right-radius: 3px
}

.dfbs .panel>.panel-body+.table,
.dfbs .panel>.panel-body+.table-responsive,
.dfbs .panel>.table+.panel-body,
.dfbs .panel>.table-responsive+.panel-body {
	border-top: 1px solid #ddd
}

.dfbs .panel>.table>tbody:first-child>tr:first-child td,
.dfbs .panel>.table>tbody:first-child>tr:first-child th {
	border-top: 0
}

.dfbs .panel>.table-bordered,
.dfbs .panel>.table-responsive>.table-bordered {
	border: 0
}

.dfbs .panel>.table-bordered>tbody>tr>td:first-child,
.dfbs .panel>.table-bordered>tbody>tr>th:first-child,
.dfbs .panel>.table-bordered>tfoot>tr>td:first-child,
.dfbs .panel>.table-bordered>tfoot>tr>th:first-child,
.dfbs .panel>.table-bordered>thead>tr>td:first-child,
.dfbs .panel>.table-bordered>thead>tr>th:first-child,
.dfbs .panel>.table-responsive>.table-bordered>tbody>tr>td:first-child,
.dfbs .panel>.table-responsive>.table-bordered>tbody>tr>th:first-child,
.dfbs .panel>.table-responsive>.table-bordered>tfoot>tr>td:first-child,
.dfbs .panel>.table-responsive>.table-bordered>tfoot>tr>th:first-child,
.dfbs .panel>.table-responsive>.table-bordered>thead>tr>td:first-child,
.dfbs .panel>.table-responsive>.table-bordered>thead>tr>th:first-child {
	border-left: 0
}

.dfbs .panel>.table-bordered>tbody>tr>td:last-child,
.dfbs .panel>.table-bordered>tbody>tr>th:last-child,
.dfbs .panel>.table-bordered>tfoot>tr>td:last-child,
.dfbs .panel>.table-bordered>tfoot>tr>th:last-child,
.dfbs .panel>.table-bordered>thead>tr>td:last-child,
.dfbs .panel>.table-bordered>thead>tr>th:last-child,
.dfbs .panel>.table-responsive>.table-bordered>tbody>tr>td:last-child,
.dfbs .panel>.table-responsive>.table-bordered>tbody>tr>th:last-child,
.dfbs .panel>.table-responsive>.table-bordered>tfoot>tr>td:last-child,
.dfbs .panel>.table-responsive>.table-bordered>tfoot>tr>th:last-child,
.dfbs .panel>.table-responsive>.table-bordered>thead>tr>td:last-child,
.dfbs .panel>.table-responsive>.table-bordered>thead>tr>th:last-child {
	border-right: 0
}

.dfbs .panel>.table-bordered>tbody>tr:first-child>td,
.dfbs .panel>.table-bordered>tbody>tr:first-child>th,
.dfbs .panel>.table-bordered>thead>tr:first-child>td,
.dfbs .panel>.table-bordered>thead>tr:first-child>th,
.dfbs .panel>.table-responsive>.table-bordered>tbody>tr:first-child>td,
.dfbs .panel>.table-responsive>.table-bordered>tbody>tr:first-child>th,
.dfbs .panel>.table-responsive>.table-bordered>thead>tr:first-child>td,
.dfbs .panel>.table-responsive>.table-bordered>thead>tr:first-child>th {
	border-bottom: 0
}

.dfbs .panel>.table-bordered>tbody>tr:last-child>td,
.dfbs .panel>.table-bordered>tbody>tr:last-child>th,
.dfbs .panel>.table-bordered>tfoot>tr:last-child>td,
.dfbs .panel>.table-bordered>tfoot>tr:last-child>th,
.dfbs .panel>.table-responsive>.table-bordered>tbody>tr:last-child>td,
.dfbs .panel>.table-responsive>.table-bordered>tbody>tr:last-child>th,
.dfbs .panel>.table-responsive>.table-bordered>tfoot>tr:last-child>td,
.dfbs .panel>.table-responsive>.table-bordered>tfoot>tr:last-child>th {
	border-bottom: 0
}

.dfbs .panel>.table-responsive {
	border: 0;
	margin-bottom: 0
}

.dfbs .panel-group {
	margin-bottom: 20px
}

.dfbs .panel-group .panel {
	margin-bottom: 0;
	border-radius: 4px
}

.dfbs .panel-group .panel+.panel {
	margin-top: 5px
}

.dfbs .panel-group .panel-heading {
	border-bottom: 0
}

.dfbs .panel-group .panel-heading+.panel-collapse>.list-group,
.dfbs .panel-group .panel-heading+.panel-collapse>.panel-body {
	border-top: 1px solid #ddd
}

.dfbs .panel-group .panel-footer {
	border-top: 0
}

.dfbs .panel-group .panel-footer+.panel-collapse .panel-body {
	border-bottom: 1px solid #ddd
}

.dfbs .panel-default {
	border-color: #ddd
}

.dfbs .panel-default>.panel-heading {
	color: #333;
	background-color: #f5f5f5;
	border-color: #ddd
}

.dfbs .panel-default>.panel-heading+.panel-collapse>.panel-body {
	border-top-color: #ddd
}

.dfbs .panel-default>.panel-heading .badge {
	color: #f5f5f5;
	background-color: #333
}

.dfbs .panel-default>.panel-footer+.panel-collapse>.panel-body {
	border-bottom-color: #ddd
}

.dfbs .panel-primary {
	border-color: #337ab7
}

.dfbs .panel-primary>.panel-heading {
	color: #fff;
	background-color: #337ab7;
	border-color: #337ab7
}

.dfbs .panel-primary>.panel-heading+.panel-collapse>.panel-body {
	border-top-color: #337ab7
}

.dfbs .panel-primary>.panel-heading .badge {
	color: #337ab7;
	background-color: #fff
}

.dfbs .panel-primary>.panel-footer+.panel-collapse>.panel-body {
	border-bottom-color: #337ab7
}

.dfbs .panel-success {
	border-color: #d6e9c6
}

.dfbs .panel-success>.panel-heading {
	color: #3c763d;
	background-color: #dff0d8;
	border-color: #d6e9c6
}

.dfbs .panel-success>.panel-heading+.panel-collapse>.panel-body {
	border-top-color: #d6e9c6
}

.dfbs .panel-success>.panel-heading .badge {
	color: #dff0d8;
	background-color: #3c763d
}

.dfbs .panel-success>.panel-footer+.panel-collapse>.panel-body {
	border-bottom-color: #d6e9c6
}

.dfbs .panel-info {
	border-color: #bce8f1
}

.dfbs .panel-info>.panel-heading {
	color: #31708f;
	background-color: #d9edf7;
	border-color: #bce8f1
}

.dfbs .panel-info>.panel-heading+.panel-collapse>.panel-body {
	border-top-color: #bce8f1
}

.dfbs .panel-info>.panel-heading .badge {
	color: #d9edf7;
	background-color: #31708f
}

.dfbs .panel-info>.panel-footer+.panel-collapse>.panel-body {
	border-bottom-color: #bce8f1
}

.dfbs .panel-warning {
	border-color: #faebcc
}

.dfbs .panel-warning>.panel-heading {
	color: #8a6d3b;
	background-color: #fcf8e3;
	border-color: #faebcc
}

.dfbs .panel-warning>.panel-heading+.panel-collapse>.panel-body {
	border-top-color: #faebcc
}

.dfbs .panel-warning>.panel-heading .badge {
	color: #fcf8e3;
	background-color: #8a6d3b
}

.dfbs .panel-warning>.panel-footer+.panel-collapse>.panel-body {
	border-bottom-color: #faebcc
}

.dfbs .panel-danger {
	border-color: #ebccd1
}

.dfbs .panel-danger>.panel-heading {
	color: #a94442;
	background-color: #f2dede;
	border-color: #ebccd1
}

.dfbs .panel-danger>.panel-heading+.panel-collapse>.panel-body {
	border-top-color: #ebccd1
}

.dfbs .panel-danger>.panel-heading .badge {
	color: #f2dede;
	background-color: #a94442
}

.dfbs .panel-danger>.panel-footer+.panel-collapse>.panel-body {
	border-bottom-color: #ebccd1
}

.dfbs .embed-responsive {
	position: relative;
	display: block;
	height: 0;
	padding: 0;
	overflow: hidden
}

.dfbs .embed-responsive .embed-responsive-item,
.dfbs .embed-responsive embed,
.dfbs .embed-responsive iframe,
.dfbs .embed-responsive object,
.dfbs .embed-responsive video {
	position: absolute;
	top: 0;
	left: 0;
	bottom: 0;
	height: 100%;
	width: 100%;
	border: 0
}

.dfbs .embed-responsive-16by9 {
	padding-bottom: 56.25%
}

.dfbs .embed-responsive-4by3 {
	padding-bottom: 75%
}

.dfbs .well {
	min-height: 20px;
	padding: 19px;
	margin-bottom: 20px;
	background-color: #f5f5f5;
	border: 1px solid #e3e3e3;
	border-radius: 4px;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, .05)
}

.dfbs .well blockquote {
	border-color: #ddd;
	border-color: rgba(0, 0, 0, .15)
}

.dfbs .well-lg {
	padding: 24px;
	border-radius: 6px
}

.dfbs .well-sm {
	padding: 9px;
	border-radius: 3px
}

.dfbs .close {
	float: right;
	font-size: 21px;
	font-weight: 700;
	line-height: 1;
	color: #000;
	text-shadow: 0 1px 0 #fff;
	opacity: .2;
	filter: alpha(opacity=20)
}

.dfbs .close:focus,
.dfbs .close:hover {
	color: #000;
	text-decoration: none;
	cursor: pointer;
	opacity: .5;
	filter: alpha(opacity=50)
}

button.dfbs .close {
	padding: 0;
	cursor: pointer;
	background: 0 0;
	border: 0;
	-webkit-appearance: none
}

.dfbs .modal-open {
	overflow: hidden
}

.dfbs .modal {
	display: none;
	overflow: hidden;
	position: fixed;
	top: 0;
	right: 0;
	bottom: 0;
	left: 0;
	z-index: 1050;
	-webkit-overflow-scrolling: touch;
	outline: 0
}

.dfbs .modal.fade .modal-dialog {
	-webkit-transform: translate(0, -25%);
	-ms-transform: translate(0, -25%);
	-o-transform: translate(0, -25%);
	transform: translate(0, -25%);
	-webkit-transition: -webkit-transform .3s ease-out;
	-moz-transition: -moz-transform .3s ease-out;
	-o-transition: -o-transform .3s ease-out;
	transition: transform .3s ease-out
}

.dfbs .modal.in .modal-dialog {
	-webkit-transform: translate(0, 0);
	-ms-transform: translate(0, 0);
	-o-transform: translate(0, 0);
	transform: translate(0, 0)
}

.dfbs .modal-open .modal {
	overflow-x: hidden;
	overflow-y: auto
}

.dfbs .modal-dialog {
	position: relative;
	width: auto;
	margin: 10px
}

.dfbs .modal-content {
	position: relative;
	background-color: #fff;
	border: 1px solid #999;
	border: 1px solid rgba(0, 0, 0, .2);
	border-radius: 6px;
	-webkit-box-shadow: 0 3px 9px rgba(0, 0, 0, .5);
	box-shadow: 0 3px 9px rgba(0, 0, 0, .5);
	background-clip: padding-box;
	outline: 0
}

.dfbs .modal-backdrop {
	position: fixed;
	top: 0;
	right: 0;
	bottom: 0;
	left: 0;
	z-index: 1040;
	background-color: #000
}

.dfbs .modal-backdrop.fade {
	opacity: 0;
	filter: alpha(opacity=0)
}

.dfbs .modal-backdrop.in {
	opacity: .5;
	filter: alpha(opacity=50)
}

.dfbs .modal-header {
	padding: 15px;
	border-bottom: 1px solid #e5e5e5
}

.dfbs .modal-header .close {
	margin-top: -2px
}

.dfbs .modal-title {
	margin: 0;
	line-height: 1.42857143
}

.dfbs .modal-body {
	position: relative;
	padding: 15px
}

.dfbs .modal-footer {
	padding: 15px;
	text-align: right;
	border-top: 1px solid #e5e5e5
}

.dfbs .modal-footer .btn+.btn {
	margin-left: 5px;
	margin-bottom: 0
}

.dfbs .modal-footer .btn-group .btn+.btn {
	margin-left: -1px
}

.dfbs .modal-footer .btn-block+.btn-block {
	margin-left: 0
}

.dfbs .modal-scrollbar-measure {
	position: absolute;
	top: -9999px;
	width: 50px;
	height: 50px;
	overflow: scroll
}

@media (min-width:768px) {
	.dfbs .modal-dialog {
		width: 600px;
		margin: 30px auto
	}
	.dfbs .modal-content {
		-webkit-box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
		box-shadow: 0 5px 15px rgba(0, 0, 0, .5)
	}
	.dfbs .modal-sm {
		width: 300px
	}
}

@media (min-width:992px) {
	.dfbs .modal-lg {
		width: 900px
	}
}

.dfbs .tooltip {
	position: absolute;
	z-index: 1070;
	display: block;
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	font-style: normal;
	font-weight: 400;
	letter-spacing: normal;
	line-break: auto;
	line-height: 1.42857143;
	text-align: left;
	text-align: start;
	text-decoration: none;
	text-shadow: none;
	text-transform: none;
	white-space: normal;
	word-break: normal;
	word-spacing: normal;
	word-wrap: normal;
	font-size: 12px;
	opacity: 0;
	filter: alpha(opacity=0)
}

.dfbs .tooltip.in {
	opacity: .9;
	filter: alpha(opacity=90)
}

.dfbs .tooltip.top {
	margin-top: -3px;
	padding: 5px 0
}

.dfbs .tooltip.right {
	margin-left: 3px;
	padding: 0 5px
}

.dfbs .tooltip.bottom {
	margin-top: 3px;
	padding: 5px 0
}

.dfbs .tooltip.left {
	margin-left: -3px;
	padding: 0 5px
}

.dfbs .tooltip-inner {
	max-width: 200px;
	padding: 3px 8px;
	color: #fff;
	text-align: center;
	background-color: #000;
	border-radius: 4px
}

.dfbs .tooltip-arrow {
	position: absolute;
	width: 0;
	height: 0;
	border-color: transparent;
	border-style: solid
}

.dfbs .tooltip.top .tooltip-arrow {
	bottom: 0;
	left: 50%;
	margin-left: -5px;
	border-width: 5px 5px 0;
	border-top-color: #000
}

.dfbs .tooltip.top-left .tooltip-arrow {
	bottom: 0;
	right: 5px;
	margin-bottom: -5px;
	border-width: 5px 5px 0;
	border-top-color: #000
}

.dfbs .tooltip.top-right .tooltip-arrow {
	bottom: 0;
	left: 5px;
	margin-bottom: -5px;
	border-width: 5px 5px 0;
	border-top-color: #000
}

.dfbs .tooltip.right .tooltip-arrow {
	top: 50%;
	left: 0;
	margin-top: -5px;
	border-width: 5px 5px 5px 0;
	border-right-color: #000
}

.dfbs .tooltip.left .tooltip-arrow {
	top: 50%;
	right: 0;
	margin-top: -5px;
	border-width: 5px 0 5px 5px;
	border-left-color: #000
}

.dfbs .tooltip.bottom .tooltip-arrow {
	top: 0;
	left: 50%;
	margin-left: -5px;
	border-width: 0 5px 5px;
	border-bottom-color: #000
}

.dfbs .tooltip.bottom-left .tooltip-arrow {
	top: 0;
	right: 5px;
	margin-top: -5px;
	border-width: 0 5px 5px;
	border-bottom-color: #000
}

.dfbs .tooltip.bottom-right .tooltip-arrow {
	top: 0;
	left: 5px;
	margin-top: -5px;
	border-width: 0 5px 5px;
	border-bottom-color: #000
}

.dfbs .popover {
	position: absolute;
	top: 0;
	left: 0;
	z-index: 1060;
	display: none;
	max-width: 276px;
	padding: 1px;
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	font-style: normal;
	font-weight: 400;
	letter-spacing: normal;
	line-break: auto;
	line-height: 1.42857143;
	text-align: left;
	text-align: start;
	text-decoration: none;
	text-shadow: none;
	text-transform: none;
	white-space: normal;
	word-break: normal;
	word-spacing: normal;
	word-wrap: normal;
	font-size: 14px;
	background-color: #fff;
	background-clip: padding-box;
	border: 1px solid #ccc;
	border: 1px solid rgba(0, 0, 0, .2);
	border-radius: 6px;
	-webkit-box-shadow: 0 5px 10px rgba(0, 0, 0, .2);
	box-shadow: 0 5px 10px rgba(0, 0, 0, .2)
}

.dfbs .popover.top {
	margin-top: -10px
}

.dfbs .popover.right {
	margin-left: 10px
}

.dfbs .popover.bottom {
	margin-top: 10px
}

.dfbs .popover.left {
	margin-left: -10px
}

.dfbs .popover-title {
	margin: 0;
	padding: 8px 14px;
	font-size: 14px;
	background-color: #f7f7f7;
	border-bottom: 1px solid #ebebeb;
	border-radius: 5px 5px 0 0
}

.dfbs .popover-content {
	padding: 9px 14px
}

.dfbs .popover>.arrow,
.dfbs .popover>.arrow:after {
	position: absolute;
	display: block;
	width: 0;
	height: 0;
	border-color: transparent;
	border-style: solid
}

.dfbs .popover>.arrow {
	border-width: 11px
}

.dfbs .popover>.arrow:after {
	border-width: 10px;
	content: ""
}

.dfbs .popover.top>.arrow {
	left: 50%;
	margin-left: -11px;
	border-bottom-width: 0;
	border-top-color: #999;
	border-top-color: rgba(0, 0, 0, .25);
	bottom: -11px
}

.dfbs .popover.top>.arrow:after {
	content: " ";
	bottom: 1px;
	margin-left: -10px;
	border-bottom-width: 0;
	border-top-color: #fff
}

.dfbs .popover.right>.arrow {
	top: 50%;
	left: -11px;
	margin-top: -11px;
	border-left-width: 0;
	border-right-color: #999;
	border-right-color: rgba(0, 0, 0, .25)
}

.dfbs .popover.right>.arrow:after {
	content: " ";
	left: 1px;
	bottom: -10px;
	border-left-width: 0;
	border-right-color: #fff
}

.dfbs .popover.bottom>.arrow {
	left: 50%;
	margin-left: -11px;
	border-top-width: 0;
	border-bottom-color: #999;
	border-bottom-color: rgba(0, 0, 0, .25);
	top: -11px
}

.dfbs .popover.bottom>.arrow:after {
	content: " ";
	top: 1px;
	margin-left: -10px;
	border-top-width: 0;
	border-bottom-color: #fff
}

.dfbs .popover.left>.arrow {
	top: 50%;
	right: -11px;
	margin-top: -11px;
	border-right-width: 0;
	border-left-color: #999;
	border-left-color: rgba(0, 0, 0, .25)
}

.dfbs .popover.left>.arrow:after {
	content: " ";
	right: 1px;
	border-right-width: 0;
	border-left-color: #fff;
	bottom: -10px
}

.dfbs .carousel {
	position: relative
}

.dfbs .carousel-inner {
	position: relative;
	overflow: hidden;
	width: 100%
}

.dfbs .carousel-inner>.item {
	display: none;
	position: relative;
	-webkit-transition: .6s ease-in-out left;
	-o-transition: .6s ease-in-out left;
	transition: .6s ease-in-out left
}

.dfbs .carousel-inner>.item>a>img,
.dfbs .carousel-inner>.item>img {
	line-height: 1
}

@media all and (transform-3d),
(-webkit-transform-3d) {
	.dfbs .carousel-inner>.item {
		-webkit-transition: -webkit-transform .6s ease-in-out;
		-moz-transition: -moz-transform .6s ease-in-out;
		-o-transition: -o-transform .6s ease-in-out;
		transition: transform .6s ease-in-out;
		-webkit-backface-visibility: hidden;
		-moz-backface-visibility: hidden;
		backface-visibility: hidden;
		-webkit-perspective: 1000px;
		-moz-perspective: 1000px;
		perspective: 1000px
	}
	.dfbs .carousel-inner>.item.active.right,
	.dfbs .carousel-inner>.item.next {
		-webkit-transform: translate3d(100%, 0, 0);
		transform: translate3d(100%, 0, 0);
		left: 0
	}
	.dfbs .carousel-inner>.item.active.left,
	.dfbs .carousel-inner>.item.prev {
		-webkit-transform: translate3d(-100%, 0, 0);
		transform: translate3d(-100%, 0, 0);
		left: 0
	}
	.dfbs .carousel-inner>.item.active,
	.dfbs .carousel-inner>.item.next.left,
	.dfbs .carousel-inner>.item.prev.right {
		-webkit-transform: translate3d(0, 0, 0);
		transform: translate3d(0, 0, 0);
		left: 0
	}
}

.dfbs .carousel-inner>.active,
.dfbs .carousel-inner>.next,
.dfbs .carousel-inner>.prev {
	display: block
}

.dfbs .carousel-inner>.active {
	left: 0
}

.dfbs .carousel-inner>.next,
.dfbs .carousel-inner>.prev {
	position: absolute;
	top: 0;
	width: 100%
}

.dfbs .carousel-inner>.next {
	left: 100%
}

.dfbs .carousel-inner>.prev {
	left: -100%
}

.dfbs .carousel-inner>.next.left,
.dfbs .carousel-inner>.prev.right {
	left: 0
}

.dfbs .carousel-inner>.active.left {
	left: -100%
}

.dfbs .carousel-inner>.active.right {
	left: 100%
}

.dfbs .carousel-control {
	position: absolute;
	top: 0;
	left: 0;
	bottom: 0;
	width: 15%;
	opacity: .5;
	filter: alpha(opacity=50);
	font-size: 20px;
	color: #fff;
	text-align: center;
	text-shadow: 0 1px 2px rgba(0, 0, 0, .6);
	background-color: transparent
}

.dfbs .carousel-control.left {
	background-image: -webkit-linear-gradient(left, rgba(0, 0, 0, .5) 0, rgba(0, 0, 0, .0001) 100%);
	background-image: -o-linear-gradient(left, rgba(0, 0, 0, .5) 0, rgba(0, 0, 0, .0001) 100%);
	background-image: linear-gradient(to right, rgba(0, 0, 0, .5) 0, rgba(0, 0, 0, .0001) 100%);
	background-repeat: repeat-x;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#80000000', endColorstr='#00000000', GradientType=1)
}

.dfbs .carousel-control.right {
	left: auto;
	right: 0;
	background-image: -webkit-linear-gradient(left, rgba(0, 0, 0, .0001) 0, rgba(0, 0, 0, .5) 100%);
	background-image: -o-linear-gradient(left, rgba(0, 0, 0, .0001) 0, rgba(0, 0, 0, .5) 100%);
	background-image: linear-gradient(to right, rgba(0, 0, 0, .0001) 0, rgba(0, 0, 0, .5) 100%);
	background-repeat: repeat-x;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#00000000', endColorstr='#80000000', GradientType=1)
}

.dfbs .carousel-control:focus,
.dfbs .carousel-control:hover {
	outline: 0;
	color: #fff;
	text-decoration: none;
	opacity: .9;
	filter: alpha(opacity=90)
}

.dfbs .carousel-control .glyphicon-chevron-left,
.dfbs .carousel-control .glyphicon-chevron-right,
.dfbs .carousel-control .icon-next,
.dfbs .carousel-control .icon-prev {
	position: absolute;
	top: 50%;
	margin-top: -10px;
	z-index: 5;
	display: inline-block
}

.dfbs .carousel-control .glyphicon-chevron-left,
.dfbs .carousel-control .icon-prev {
	left: 50%;
	margin-left: -10px
}

.dfbs .carousel-control .glyphicon-chevron-right,
.dfbs .carousel-control .icon-next {
	right: 50%;
	margin-right: -10px
}

.dfbs .carousel-control .icon-next,
.dfbs .carousel-control .icon-prev {
	width: 20px;
	height: 20px;
	line-height: 1;
	font-family: serif
}

.dfbs .carousel-control .icon-prev:before {
	content: '\2039'
}

.dfbs .carousel-control .icon-next:before {
	content: '\203a'
}

.dfbs .carousel-indicators {
	position: absolute;
	bottom: 10px;
	left: 50%;
	z-index: 15;
	width: 60%;
	margin-left: -30%;
	padding-left: 0;
	list-style: none;
	text-align: center
}

.dfbs .carousel-indicators li {
	display: inline-block;
	width: 10px;
	height: 10px;
	margin: 1px;
	text-indent: -999px;
	border: 1px solid #fff;
	border-radius: 10px;
	cursor: pointer;
	background-color: #000\9;
	background-color: transparent
}

.dfbs .carousel-indicators .active {
	margin: 0;
	width: 12px;
	height: 12px;
	background-color: #fff
}

.dfbs .carousel-caption {
	position: absolute;
	left: 15%;
	right: 15%;
	bottom: 20px;
	z-index: 10;
	padding-top: 20px;
	padding-bottom: 20px;
	color: #fff;
	text-align: center;
	text-shadow: 0 1px 2px rgba(0, 0, 0, .6)
}

.dfbs .carousel-caption .btn {
	text-shadow: none
}

@media screen and (min-width:768px) {
	.dfbs .carousel-control .glyphicon-chevron-left,
	.dfbs .carousel-control .glyphicon-chevron-right,
	.dfbs .carousel-control .icon-next,
	.dfbs .carousel-control .icon-prev {
		width: 30px;
		height: 30px;
		margin-top: -10px;
		font-size: 30px
	}
	.dfbs .carousel-control .glyphicon-chevron-left,
	.dfbs .carousel-control .icon-prev {
		margin-left: -10px
	}
	.dfbs .carousel-control .glyphicon-chevron-right,
	.dfbs .carousel-control .icon-next {
		margin-right: -10px
	}
	.dfbs .carousel-caption {
		left: 20%;
		right: 20%;
		padding-bottom: 30px
	}
	.dfbs .carousel-indicators {
		bottom: 20px
	}
}

.dfbs .clearfix:after,
.dfbs .clearfix:before,
.dfbs .btn-group-vertical>.btn-group:after,
.dfbs .btn-group-vertical>.btn-group:before,
.dfbs .btn-toolbar:after,
.dfbs .btn-toolbar:before,
.dfbs .container-fluid:after,
.dfbs .container-fluid:before,
.dfbs .container:after,
.dfbs .container:before,
.dfbs .dl-horizontal dd:after,
.dfbs .dl-horizontal dd:before,
.dfbs .form-horizontal .form-group:after,
.dfbs .form-horizontal .form-group:before,
.dfbs .modal-footer:after,
.dfbs .modal-footer:before,
.dfbs .modal-header:after,
.dfbs .modal-header:before,
.dfbs .nav:after,
.dfbs .nav:before,
.dfbs .navbar-collapse:after,
.dfbs .navbar-collapse:before,
.dfbs .navbar-header:after,
.dfbs .navbar-header:before,
.dfbs .navbar:after,
.dfbs .navbar:before,
.dfbs .pager:after,
.dfbs .pager:before,
.dfbs .panel-body:after,
.dfbs .panel-body:before,
.dfbs .row:after,
.dfbs .row:before {
	content: " ";
	display: table
}

.dfbs .clearfix:after,
.dfbs .btn-group-vertical>.btn-group:after,
.dfbs .btn-toolbar:after,
.dfbs .container-fluid:after,
.dfbs .container:after,
.dfbs .dl-horizontal dd:after,
.dfbs .form-horizontal .form-group:after,
.dfbs .modal-footer:after,
.dfbs .modal-header:after,
.dfbs .nav:after,
.dfbs .navbar-collapse:after,
.dfbs .navbar-header:after,
.dfbs .navbar:after,
.dfbs .pager:after,
.dfbs .panel-body:after,
.dfbs .row:after {
	clear: both
}

.dfbs .center-block {
	display: block;
	margin-left: auto;
	margin-right: auto
}

.dfbs .pull-right {
	float: right!important
}

.dfbs .pull-left {
	float: left!important
}

.dfbs .hide {
	display: none!important
}

.dfbs .show {
	display: block!important
}

.dfbs .invisible {
	visibility: hidden
}

.dfbs .text-hide {
	font: 0/0 a;
	color: transparent;
	text-shadow: none;
	background-color: transparent;
	border: 0
}

.dfbs .hidden {
	display: none!important
}

.dfbs .affix {
	position: fixed
}

@-ms-viewport {
	width: device-width
}

.dfbs .visible-lg,
.dfbs .visible-md,
.dfbs .visible-sm,
.dfbs .visible-xs {
	display: none!important
}

.dfbs .visible-lg-block,
.dfbs .visible-lg-inline,
.dfbs .visible-lg-inline-block,
.dfbs .visible-md-block,
.dfbs .visible-md-inline,
.dfbs .visible-md-inline-block,
.dfbs .visible-sm-block,
.dfbs .visible-sm-inline,
.dfbs .visible-sm-inline-block,
.dfbs .visible-xs-block,
.dfbs .visible-xs-inline,
.dfbs .visible-xs-inline-block {
	display: none!important
}

@media (max-width:767px) {
	.dfbs .visible-xs {
		display: block!important
	}
	table.dfbs .visible-xs {
		display: table!important
	}
	tr.dfbs .visible-xs {
		display: table-row!important
	}
	td.dfbs .visible-xs,
	th.dfbs .visible-xs {
		display: table-cell!important
	}
}

@media (max-width:767px) {
	.dfbs .visible-xs-block {
		display: block!important
	}
}

@media (max-width:767px) {
	.dfbs .visible-xs-inline {
		display: inline!important
	}
}

@media (max-width:767px) {
	.dfbs .visible-xs-inline-block {
		display: inline-block!important
	}
}

@media (min-width:768px) and (max-width:991px) {
	.dfbs .visible-sm {
		display: block!important
	}
	table.dfbs .visible-sm {
		display: table!important
	}
	tr.dfbs .visible-sm {
		display: table-row!important
	}
	td.dfbs .visible-sm,
	th.dfbs .visible-sm {
		display: table-cell!important
	}
}

@media (min-width:768px) and (max-width:991px) {
	.dfbs .visible-sm-block {
		display: block!important
	}
}

@media (min-width:768px) and (max-width:991px) {
	.dfbs .visible-sm-inline {
		display: inline!important
	}
}

@media (min-width:768px) and (max-width:991px) {
	.dfbs .visible-sm-inline-block {
		display: inline-block!important
	}
}

@media (min-width:992px) and (max-width:1199px) {
	.dfbs .visible-md {
		display: block!important
	}
	table.dfbs .visible-md {
		display: table!important
	}
	tr.dfbs .visible-md {
		display: table-row!important
	}
	td.dfbs .visible-md,
	th.dfbs .visible-md {
		display: table-cell!important
	}
}

@media (min-width:992px) and (max-width:1199px) {
	.dfbs .visible-md-block {
		display: block!important
	}
}

@media (min-width:992px) and (max-width:1199px) {
	.dfbs .visible-md-inline {
		display: inline!important
	}
}

@media (min-width:992px) and (max-width:1199px) {
	.dfbs .visible-md-inline-block {
		display: inline-block!important
	}
}

@media (min-width:1200px) {
	.dfbs .visible-lg {
		display: block!important
	}
	table.dfbs .visible-lg {
		display: table!important
	}
	tr.dfbs .visible-lg {
		display: table-row!important
	}
	td.dfbs .visible-lg,
	th.dfbs .visible-lg {
		display: table-cell!important
	}
}

@media (min-width:1200px) {
	.dfbs .visible-lg-block {
		display: block!important
	}
}

@media (min-width:1200px) {
	.dfbs .visible-lg-inline {
		display: inline!important
	}
}

@media (min-width:1200px) {
	.dfbs .visible-lg-inline-block {
		display: inline-block!important
	}
}

@media (max-width:767px) {
	.dfbs .hidden-xs {
		display: none!important
	}
}

@media (min-width:768px) and (max-width:991px) {
	.dfbs .hidden-sm {
		display: none!important
	}
}

@media (min-width:992px) and (max-width:1199px) {
	.dfbs .hidden-md {
		display: none!important
	}
}

@media (min-width:1200px) {
	.dfbs .hidden-lg {
		display: none!important
	}
}

.dfbs .visible-print {
	display: none!important
}

@media print {
	.dfbs .visible-print {
		display: block!important
	}
	table.dfbs .visible-print {
		display: table!important
	}
	tr.dfbs .visible-print {
		display: table-row!important
	}
	td.dfbs .visible-print,
	th.dfbs .visible-print {
		display: table-cell!important
	}
}

.dfbs .visible-print-block {
	display: none!important
}

@media print {
	.dfbs .visible-print-block {
		display: block!important
	}
}

.dfbs .visible-print-inline {
	display: none!important
}

@media print {
	.dfbs .visible-print-inline {
		display: inline!important
	}
}

.dfbs .visible-print-inline-block {
	display: none!important
}

@media print {
	.dfbs .visible-print-inline-block {
		display: inline-block!important
	}
}

@media print {
	.dfbs .hidden-print {
		display: none!important
	}
}