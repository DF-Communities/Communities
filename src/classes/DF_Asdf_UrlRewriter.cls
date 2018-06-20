global without sharing class DF_Asdf_UrlRewriter implements Site.UrlRewriter {

	global PageReference mapRequestUrl(PageReference oUrl ) {

        try {
        
            String url = oUrl.getUrl();
            url = url.right(url.length()-1);
            System.debug('Rewriter ' + url);

            String newUrl = '/DF_WEBC_SiteDownMessage?qs=' + url;
            return new PageReference(newUrl);


        } catch ( Exception x ) {

            system.debug('DF_WEBC_UrlRewriter' + x.getMessage());
            return null;

        }

    }
    
    global List<PageReference> generateUrlFor(List<PageReference> yourSalesforceUrls) {
        
        return null;
    }
}