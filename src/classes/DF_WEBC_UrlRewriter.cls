global class DF_WEBC_UrlRewriter implements Site.UrlRewriter {
    
    global PageReference mapRequestUrl(PageReference shortUrl ) {

        try {
        
            String url = shortUrl.getUrl();
            system.debug('DF_WEBC_UrlRewriter : ' + url);


            String[] vUrl = url.split('\\?');            
            String redirectUrl = getUrlMapping(vUrl[0]);
            
            if ( redirectUrl == null ) { return null; }

            if ( vUrl.size() == 1 ) { 
                return new PageReference(redirectUrl);
            }

            String slink = (redirectUrl.indexOf('?') == -1 ? '?' : '&');
            String sNewUrl = redirectUrl + slink + vUrl[1];
            system.debug(sNewUrl);
            
            return new PageReference(sNewUrl);

        } catch ( Exception x ) {

            system.debug('DF_WEBC_UrlRewriter' + x.getMessage());
            return null;

        }

    }


    private String getUrlMapping(String url){

        Map<String, String> mapUrls = new Map<String, String>();
        mapUrls.put('/subscribe', '/DF_WEBC_RegisterNewsletter');
        mapUrls.put('/register', '/DF_WEBC_RegisterIntro');
        mapUrls.put('/register-digital-friend', '/DF_WEBC_RegisterDigitalFriend');
        mapUrls.put('/register-friend', '/DF_WEBC_RegisterFriend');
        mapUrls.put('/register-champion', '/DF_WEBC_RegisterChampion');
        //mapUrls.put('/register-admin', '/DF_WEBC_RegisterAdmin');
        mapUrls.put('/register-partner-admin', '/DF_WEBC_RegisterOrgAdmin');
        mapUrls.put('/register-intro', '/DF_WEBC_RegisterIntro');
        mapUrls.put('/register-community-admin', '/DF_WEBC_RegisterCommunityAdmin');
        mapUrls.put('/register-community-representative', '/DF_WEBC_RegisterCommunityAdmin');
        mapUrls.put('/manage-partner-admins', '/DF_WEBC_ManagePartnerAdmins');
        mapUrls.put('/partner-actions','/DF_WEBC_PartnerActions');
        mapUrls.put('/partner-resources','/DF_WEBC_PartnerResources');
        mapUrls.put('/register-partner','/DF_WEBC_RegisterPartner');
     //   mapUrls.put('/register-community', '/dfc_apply');

        mapUrls.put('/home', '/DF_WEBC_HomePage');
        mapUrls.put('/user-home', getUserHome());
        mapUrls.put('/forgot-password', '/DF_WEBC_ForgotPassword');
        mapUrls.put('/errorPage', '/WebErrorPage');
        mapUrls.put('/login', '/DF_WEBC_Login');
        mapUrls.put('/edit-details', '/DF_WEBC_EditDetails');
        mapUrls.put('/view-details', '/DF_WEBC_ViewDetails');        
        mapUrls.put('/change-password', '/DF_WEBC_ChangePassword');
        mapUrls.put('/partner-home', '/DF_WEBC_PartnerHome');
        
        
        // These are pages from the old Portal site
        mapUrls.put('/WEBRegisterFriend', '/DF_WEBC_RegisterFriend');
        mapUrls.put('/WEBRegisterChampion', '/DF_WEBC_RegisterChampion');
        mapUrls.put('/WEBLogin', '/DF_WEBC_Login');
        mapUrls.put('/WEBNewsLetterSignup', '/DF_WEBC_RegisterNewsletter');
        mapUrls.put('/WEBNewsletterArchives', '/DF_WEBC_NewsletterArchives');
        mapUrls.put('/WEBCreateActions', '/DF_WEBC_CreateActions');
        
        // These are old PHE pages 
        mapUrls.put('/partners', '/WEBArticle?page=about-partner-organisations');
        mapUrls.put('/customers', '/WEBArticle?page=about-partner-organisations');

        mapUrls.put('/verify', '/DF_WEBC_VerifyRegistration');
        mapUrls.put('/verify-admin', '/DF_WEBC_VerifyAdmin');
        mapUrls.put('/reset-password', '/DF_WEBC_ResetPassword');
       
        String redirectUrl = mapUrls.get(url);
        return redirectUrl;

    }    

 
    private String getUserHome() {
        
        return '/DF_WEBC_UserHome';
        
    }

    
    global List<PageReference> generateUrlFor(List<PageReference> yourSalesforceUrls) {
        
        return null;
    }
    
}