({
	format : function(text) {
		
     var settings = {
      tagName: "a",
      newLine: "\n",
      target: "_blank",
      linkClass: null,
      linkClasses: [],
      linkAttributes: null
    };
  
    var linkMatch = new RegExp([ "(", '\\s|[^a-zA-Z0-9.\\+_\\/"\\>\\-]|^', ")(?:", "(", "[a-zA-Z0-9\\+_\\-]+", "(?:", "\\.[a-zA-Z0-9\\+_\\-]+", ")*@", ")?(", "http:\\/\\/|https:\\/\\/|ftp:\\/\\/", ")?(", "(?:(?:[a-z0-9][a-z0-9_%\\-_+]*\\.)+)", ")(", "(?:com|ca|co|edu|gov|net|org|dev|biz|cat|int|pro|tel|mil|aero|asia|coop|info|jobs|mobi|museum|name|post|travel|local|[a-z]{2})", ")(", "(?::\\d{1,5})", ")?(", "(?:", "[\\/|\\?]", "(?:", "[\\-a-zA-Z0-9_%#*&+=~!?,;:.\\/]*", ")*", ")", "[\\-\\/a-zA-Z0-9_%#*&+=~]", "|", "\\/?", ")?", ")(", '[^a-zA-Z0-9\\+_\\/"\\<\\-]|$', ")" ].join(""), "g"); 
  
     var attr, linkClasses, linkReplace = [];
    linkClasses = settings.linkClass ? settings.linkClass.split(/\s+/) : [], linkClasses.push.apply(linkClasses, settings.linkClasses), 
    text = text.replace(/</g, "&lt;").replace(/(\s)/g, "$1$1"), linkReplace.push("$1<" + settings.tagName, 'href="http://$2$4$5$6$7"'), 
    linkReplace.push('class="linkified' + (linkClasses.length > 0 ? " " + linkClasses.join(" ") : "") + '"'), 
    settings.target && linkReplace.push('target="' + settings.target + '"');
    for (attr in settings.linkAttributes) linkReplace.push([ attr, '="', settings.linkAttributes[attr].replace(new RegExp('\\"',"g"), "&quot;").replace(/\$/g, "&#36;"), '"' ].join(""));
    return linkReplace.push(">$2$3$4$5$6$7</" + settings.tagName + ">$8"), text = text.replace(linkMatch, linkReplace.join(" ")), 
    text = text.replace(/(\s){2}/g, "$1"), text = text.replace(/\n/g, settings.newLine); 
  }
    
})