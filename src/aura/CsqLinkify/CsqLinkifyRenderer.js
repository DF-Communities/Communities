({
    afterRender: function(cmp, helper)
    {
        var elements = cmp.getElements();
        if (elements.length==0) return;
        if (elements.length>1) {
            console.log('CsqLinkify must enclose a single element that contains only text');
            return;
        }
        var e = elements[0];
        if (e.children.length) {
            console.log('CsqLinkify must enclose a single element that contains only text');
            return;
        }
        e.innerHTML = helper.format(e.innerHTML);
    }
})