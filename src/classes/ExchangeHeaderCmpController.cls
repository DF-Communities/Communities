public without sharing class ExchangeHeaderCmpController{
   
    @AuraEnabled
    public static String Stub_Url(){
        
        return WEBC_CommunityWrapper.getCustomSetting('Stub_Url', 'DF');
       
    }
    
    
    @AuraEnabled
     public static String totalFriendCount() {
                


            /* June 2016. Change from Custom Setting to Editable Item */

            String sDate = '2015-4-18 00:00:00';
            String sBaseLine = '1000000';
            
            List<Edt_Item__c> items = [select Id, Text1__c, Text2__c from Edt_Item__c where Group__c = 'df-generic' and Key__c = 'total-friend-count' limit 1];
            if ( items.size() > 0 ) {
                 sBaseLine = items[0].Text1__c;
                 sDate = items[0].Text2__c;
            }

             Date dt = Date.valueOf(sDate);
             AggregateResult[] res = [select count(id) dc from DF_Contact__c 
                        where Digital_Friend_Signup_Time__c !=null AND Digital_Friend_Signup_Time__c>:dt
                        AND Created_As_Type__c ='Digital Friend'];
             
             Integer iDDF = (Integer)res[0].get('dc');

       

             Integer iBaseline = Integer.valueOf(sBaseLine);
         system.debug('count'+(iBaseline + iDDF).format());
             return (iBaseline + iDDF).format();

    }
    @AuraEnabled
    public static String getCurrentUser() {
      string toReturn;  
        if(UserInfo.getUserType()!='Guest'){
      toReturn =UserInfo.getUserId();
        system.debug('returned user'+toReturn);
        }
      return toReturn.substring(0, 15);
   }
  
}