public without sharing class ExchangeTopicsListController{

public  List<CollaborationGroupMember> collGroupMemberList {get;set;}
public string userId{get;set;}  
/*public List<String> options {get;set;}
public Map<String,String> mapGroups {get;set;}*/
public List<Topic> topics {get;set;}
public boolean userHasCommunityAccess{get;set;}
public static string permName = Community_Settings__c.getInstance('Exchange_Permission_Set').value__c;
public static string domainName{get;set;}
public static string NetworkId = DF_Utils.getNetworkId(Community_Settings__c.getInstance('Exchange_Site').value__c);

public ExchangeTopicsListController (){
 userId = UserInfo.getUserId();
 userHasCommunityAccess =DF_Utils.hasPermissionSetAccess(userId, DF_Utils.getPermissionSetId(permName));
 domainName=Community_Settings__c.getInstance('Exchange_Domain').value__c;
 try{
 
 topics = [SELECT Id, Name FROM Topic WHERE NetworkId =:NetworkId order by createddate desc limit 10];
 

 }catch(Exception ex){} 

}  




}