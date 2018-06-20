/******************************************************************************************
 *  Alzheimers
 *  
 *  Purpose : APEX Handler for JSON data Champion Registration
 *  Author  : Gary Grant
 *  Date    : 17/11/2015
 *  Version : 1.0
 *
 *  Description:    Handler for DF Champion Registration. 
                    registration process
 *               
 *  Modification History
 *  Date            Who         Description 
 *            
*******************************************************************************************/
global without sharing class DF_WEBC_RegisterChampion_Handler extends DF_WEBC_RegisterBase_Handler {

  public DF_WEBC_RegisterChampion_Handler(String sJson) {        
        
       init(sJson);

  }

  protected override boolean isExtendedRegistrationDataOK() {

    return isBirthDateOK(192);

  }

  /* Extend these Methods for different classes of Friend */


  // Don't include the Community Prefix in the name  
  protected override String getEmailTemplateName() {

    return 'Verification_Request';

  }

   protected override  String getRecordTypeName() { 

    return DF_Utils.RT_CHAMPION;

  }

  protected override String getCreatedAsValue() {

    return 'Champion';

  } 
  
  protected override String getStartUrl() {
    //google tracking QP-6
       string var ='?df_champion_verified=true';
       return WEBC_CommunityWrapper.COMMUNITY_USER_HOME + var ;

  }

  protected override void populateExtendedData() {

     dfc.BirthDate__c = getDate(data.birthDate); 
     dfc.Champion_newsletters__c = data.champnewsletter;
     dfc.Why_do_you_want_to_become_a_Champion__c = data.whychampion;

  }
  
 


}