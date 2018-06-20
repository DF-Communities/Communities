/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX DFC Community Context Class
 *  Author  : Conseq
 *  Date    : 26/11/2015
 *  Version : 0.1 Unit Test
 *  
 *               
 *  Modification History
 *  Date            Who         Description 
 *  31/03/2016      Conseq      Added regions to support Wales
 *
*******************************************************************************************/
public class Dfc_CommunityContext 
{
  @AuraEnabled
    public User currentUser {get; set;}

  @AuraEnabled
    public DF_Contact__c currentContact {get; set;}

  @AuraEnabled
    public DFC_Community__c community {get; set;} 

  @AuraEnabled
    public DFC_DAA_Region__c[] regions {get; set;} 

  @AuraEnabled
    public DFC_Alliance__c[] alliances {get; set;} 
    
  @AuraEnabled
    public DFC_Action_Area__c[] actionAreas {get; set;} 
    
  @AuraEnabled
    public DFC_Activity__c[] activities {get; set;} 
    
  @AuraEnabled
    public DFC_County__c[] counties {get; set;} 
    
  @AuraEnabled
  public UserRecordAccess[] access {get; set;} 
    
    
}