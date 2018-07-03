/**
 * Created by gary on 18/06/2018.
 */

trigger IndividualTrigger on Individual (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    List<String> vFields = GDPR.getFieldList();
    
    /* If doing an update from an external source, be sure to include f_Source values in the data */
    
    if ( Trigger.isBefore ) {
        
        if ( Trigger.isInsert || Trigger.isUpdate ) {

            for ( Individual indvNew : Trigger.new ) {

               Individual indvOld;
               if ( Trigger.isUpdate ) { indvOld = Trigger.oldMap.get(indvNew.id); }

                /* Set the external Id for DF Contact. This is required for the bulk update
                  used in the progress process. It's a duplication of data but apparently required
               */
                if ( indvNew.DF_Contact__c == null ) { indvNew.DF_ContactExternalId__c = null; } else {

                    if (indvNew.DF_Contact__c != indvNew.DF_ContactExternalId__c) {
                        indvnew.DF_ContactExternalId__c = indvNew.DF_Contact__c;
                    }

                }

                for ( String f : vFields ) {
                    
                   String sFieldName = f + '__c';
                   String sDateFieldName = f + '_Date__c';
                   String sSourceFieldName = f + '_Source__c';

                   /* CAUTION : For all Salesforce processes, ensure old dates are cleared or reset
                                before making the call to update
                   */
                   if ( Trigger.isInsert || (Trigger.isUpdate && (indvNew.get(sFieldName) != indvOld.get(sFieldName))) )  {

                       // Insert Now as a default if no time is specified
                       if ( indvNew.get(sDateFieldName) == null ) {
                            indvNew.put(sDateFieldName, system.Now());                        
                       }

                       //Insert a default value if none is specified
                       if ( indvNew.get(sSourceFieldName) == null ) {
                            indvNew.put(sSourceFieldName, 'DEMFRND_DB');
                       }
                   
                   }
                }
            }
               
        }

    }


}