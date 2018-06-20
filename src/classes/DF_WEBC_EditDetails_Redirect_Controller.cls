public without sharing class DF_WEBC_EditDetails_Redirect_Controller extends WEBC_ControllerBase {


    public PageReference doAction() {


        //TODO!! get the specific user home based on the logged in user
        try {
            
            system.debug('Web User Details UserId ' + UserInfo.getUserId());
            system.debug('Web User Home User Type ' + UserInfo.getUserType());

            if ( UserInfo.getUserType() == 'Guest') { return handleGuest(); } 
            
            if ( WEBC_CommunityWrapper.isOrgAdmin() ) { return handleOrgAdmin(); }

            DF_Contact__c dfc = DF_Utils.getDFContactForUser(UserInfo.getUserId());            
            return handleDfc(dfc);

        } catch (Exception x) {

            system.debug('Get User Home : Cannot find user ' + x.getMessage() );

        }

        return new PageReference('/DF_WEBC_HomePage');


    }

    @TestVisible
    private PageReference handleOrgAdmin()
    {

        return new PageReference('/DF_WEBC_EditMyDetailsAdmin');
    }

    @TestVisible
    private PageReference handleGuest()
    {
        return new PageReference('/DF_WEBC_HomePage'); 
    }


    @TestVisible
    private PageReference handleDfc(DF_Contact__c dfc)
    {

        if ( DF_Utils.isChampion(dfc) ) { return new PageReference('/WebChampionEditMyDetails') ;}
        if ( DF_Utils.isFriend(dfc) ) { return new PageReference('/WebFriendEditMyDetails') ;}

        return new PageReference('/DF_WEBC_HomePage');

    }


}