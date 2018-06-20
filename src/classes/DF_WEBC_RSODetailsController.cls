public without sharing class DF_WEBC_RSODetailsController extends DF_WEBC_ControllerBase{

public User rso {get;set;}
public DF_Region__c region {get;set;}
public string regionName {get{if(region==null){return null;}return region.name;}}
public string email {get{if(region==null || rso==null){return null;}return rso.email;}}
public string phone {get{if(region==null || rso==null){return null;}return rso.phone;}}
public Integer friendsCount {get;set;}
public Boolean isChampion;

public DF_WEBC_RSODetailsController(){

String RT_CHAMPION = DF_Utils.getDfcRecordTypeId(DF_Utils.RT_CHAMPION);
String STATUS_CONVERTED = DF_Utils.STATUS_CONVERTED;

isChampion = DF_Utils.isChampion(currentDfc);

if(isChampion && currentDfc.DF_Region__c!=null){

    List<DF_Region__c> lisRegions = [select Id,RSO__c,name  from DF_Region__c where id =: currentDfc.DF_Region__c];
    if(lisRegions.size()>0)
    {
    List<User> lisrso = new List<User>();
    lisrso=[select Name,phone,Office_Location__c,CommunityNickname,firstName,LastName,email,FullPhotoUrl,SmallPhotoUrl from  User where id =: lisRegions[0].RSO__c];
    if(lisrso.size()>0){
    rso = lisrso[0];
}
    region = lisRegions[0];
    


    List<aggregateResult> RegionAgg= [SELECT DF_Region__c
                                            ,COUNT(id)
                                            ,SUM(Total_No_of_Friends_Created__c) TotFriends                                           
  	                                        FROM DF_Contact__c 
                                            WHERE RecordTypeId =: RT_CHAMPION 
                                            AND Status__c =: STATUS_CONVERTED 
                                            AND  DF_Region__c =: lisRegions[0].Id
                                            GROUP BY DF_Region__c];

        IF (RegionAgg.size()>0){
            
            FOR (AggregateResult argRec : RegionAgg){

                Double totalFriends =(Double)argRec.get('TotFriends');
                friendsCount = totalFriends.intValue();
              }

          }
        }
    }

 }

}