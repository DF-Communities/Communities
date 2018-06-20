public with sharing class CsqUserStoreController 
{
    @AuraEnabled
  public static Map<String, Object> getCurentUserInfo()
    {
        Map<String, Object> userData = new Map<String, Object>();
        userData.put('Id', UserInfo.getUserId());
        userData.put('Name', UserInfo.getName());
        userData.put('FirstName', UserInfo.getFirstName());
        userData.put('LastName', UserInfo.getLastName());
        userData.put('Email', UserInfo.getUserEmail());
        userData.put('UserType', UserInfo.getUserType());
        userData.put('ProfileId', UserInfo.getProfileId());
        Profile[] p = [ select Name from Profile where id = :UserInfo.getProfileId() ];
        if (p.size()>0) userData.put('ProfileName', p[0].Name);
        userData.put('RoleId', UserInfo.getUserRoleId());
        UserRole[] r = [ select Name from UserRole where id = :UserInfo.getUserRoleId() ];
        if (r.size()>0) userData.put('RoleName', r[0].Name);
        
        Map<String, Object> data = new Map<String, Object>();
        data.put('info', userData);
        data.put('sessionId', UserInfo.getSessionId());
        
        return data;
    }
    
}