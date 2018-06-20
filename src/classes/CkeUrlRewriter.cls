global class CkeUrlRewriter implements Site.UrlRewriter {
    
    global PageReference mapRequestUrl(PageReference shortUrl ) {

        try {
        
            String url = shortUrl.getUrl();
            system.debug('CkeUrlRewriter : ' + url);

            PageReference pr = handleDownload(url);
            if ( pr != null ) { return pr; }

            String[] vUrl = url.split('\\?');            
            String redirectUrl = getUrlMapping(vUrl[0]);

            if ( redirectUrl == null ) { return null; }

            if ( vUrl.size() == 1 ) { 
                return new PageReference(redirectUrl);
            }

            String slink = (redirectUrl.indexOf('?') == -1 ? '?' : '&');
            String sNewUrl = redirectUrl + slink + vUrl[1];
            system.debug('sNewUrl: ' + sNewUrl);
            
            return new PageReference(sNewUrl);

        } catch ( Exception x ) {

            system.debug('CkeUrlRewriter' + x.getMessage());
            return null;

        }

    }

    private PageReference handleDownload(String url) {

        if ( !url.startsWith('/download-') ) { return null; }

        String key = url.substring(10);
        String[] vKey = key.split('\\?');

        String[] params = null;
        if ( vKey.size() > 1 ) {
            params = vkey[1].split('\\&');
        }

        try {    

            PageReference pr = new PageReference('/Cke_Download');
            pr.getParameters().put('key', vKey[0]);

            if ( params != null ) {

                for (String nvp : params) {
                    String[] param = nvp.split('=');
                    if ( param.size() > 1) { 
                        pr.getParameters().put(param[0], param[1]);
                    }
                }

            }

            return pr;

        } catch (Exception x) {

            return null;

        }


    }

    private String getUrlMapping(String url){

        Map<String, String> mapUrls = new Map<String, String>();

        // Updates Post Live July 2016
        /*mapUrls.put('/home', '/Cke_Home_Holding');
        mapUrls.put('/request-a-pack', '/Cke_Home_Holding');
        mapUrls.put('/get-ready', '/Cke_Home_Holding');*/
        
        mapUrls.put('/request-a-pack-thank-you', '/Cke_ThankYou_Request');

        mapUrls.put('/pay-in', '/Cke_Payment');
        mapUrls.put('/pay-in-thank-you', '/Cke_ThankYou_Payin'); 

        mapUrls.put('/donate', '/Cke_Donate');
        mapUrls.put('/donate-thank-you', '/Cke_ThankYou_Donate');

        mapUrls.put('/about', '/Cke_About');

        mapUrls.put('/cupcake-catwalk', '/Cke_Gallery');
        
        mapUrls.put('/privacy-policy', '/Cke_PrivacyPolicy');
        mapUrls.put('/terms-and-conditions', '/Cke_TermsConditions');        
        mapUrls.put('/faqs', '/Cke_FAQs');

        mapUrls.put('/login', '/Cke_Error');
        
        mapUrls.put('/downloads', '/Cke_Downloads');
        mapUrls.put('/home', '/Cke_Home');
        
        mapUrls.put('/request-a-pack', '/Cke_Pack_Request');
        mapUrls.put('/request-a-pack-thank-you', '/Cke_ThankYou_Request');

        mapUrls.put('/pay-in', '/Cke_Payment');
        mapUrls.put('/pay-in-thank-you', '/Cke_ThankYou_Payin'); 

        mapUrls.put('/donate', '/Cke_Donate');
        mapUrls.put('/donate-thank-you', '/Cke_ThankYou_Donate');
        
        /* 
        //For use in sandboxes with previous year's cupcake site only
        mapUrls.put('/home2016', '/Cke2016_Home');
        mapUrls.put('/pay-in2016', '/Cke2016_Payment');
        mapUrls.put('/request-a-pack2016', '/Cke2016_Pack_Request');
        mapUrls.put('/payment2016', '/Cke2016_Payment');
        mapUrls.put('/resources2016', '/Cke2016_Resources');
        mapUrls.put('/donate2016', '/Cke_2016Donate');
        mapUrls.put('/donate-thank-you2016', '/Cke2016_ThankYou_Donate');
        mapUrls.put('/privacy-policy2016', '/Cke2016_PrivacyPolicy');
        mapUrls.put('/terms-and-conditions2016', '/Cke2016_TermsConditions');        
        mapUrls.put('/request-a-pack-thank-you2016', '/Cke_ThankYou_Request2016');
        mapUrls.put('/pay-in-thank-you2016', '/Cke_ThankYou_Payin2016');
        */

        String redirectUrl = mapUrls.get(url);
        System.debug('Redirect :' + redirectUrl);


        return redirectUrl;

    }    
    
    global List<PageReference> generateUrlFor(List<PageReference> yourSalesforceUrls) {
        
        return null;
    }
    
}