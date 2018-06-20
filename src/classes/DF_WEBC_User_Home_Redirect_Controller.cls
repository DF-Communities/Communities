public without sharing class DF_WEBC_User_Home_Redirect_Controller {

    public DF_WEBC_User_Home_Redirect_Controller() {
        
    }

    public PageReference doAction() {


        //TODO!! get the specific user home based on the logged in user
        try {
            
            system.debug('Web User Home UserId ' + UserInfo.getUserId());
            system.debug('Web User Home User Type ' + UserInfo.getUserType());

            String url = Apexpages.currentPage().getUrl();
            String[] vUrl = url.split('\\?');     

            String sQuery = '';
            if ( vUrl.size()==2 ) { sQuery = '?' + vUrl[1]; }

            if ( UserInfo.getUserType() == 'Guest') { return new PageReference('DF_WEBC_HomePage' + sQuery); } 
            
            if ( WEBC_CommunityWrapper.isOrgAdmin() ) { return new PageReference('/DF_WEBC_AdminHome' + sQuery); }
            
            DF_Contact__c dfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());

            if ( DF_Utils.isChampion(dfc) ) { return new PageReference('/WebChampion' + sQuery) ;}
            if ( DF_Utils.isFriend(dfc) ) { return new PageReference('/WebFriend' + sQuery) ;}

            return new PageReference('/DF_WEBC_HomePage' + sQuery);

        } catch (Exception x) {

            system.debug('Get User Home : Cannot find user ' + x.getMessage() );

        }

        return new PageReference('/DF_WEBC_HomePage');


    }
    
    
}