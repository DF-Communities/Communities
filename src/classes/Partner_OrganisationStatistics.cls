Public Class Partner_OrganisationStatistics
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : Calculate and show the statistics for a Dementia Friend Partner Organisation
 *  Author  : Mike Tinson
 *  Date    : 31 March 2014
 *  Version : 1
 *
 *  Description: Read DF Contacts to calculate the number of champions and the number of friends that they have created.
 *                  
 *               
 *  Modification History
 *  Date            Who         Description 
 *  
 *  
 ******************************************************************************************/
{
Public Integer Total_No_of_Friends_Created {get;set;}
Public Integer Number_of_Champions_Identified {get;set;}


public Partner_OrganisationStatistics(ApexPages.StandardController controller) {
    this();
}
public Partner_OrganisationStatistics()
{
    if(ApexPages.currentPage().getParameters().get('id')!=null)
    {
    Id ID =  ApexPages.currentPage().getParameters().get('id');

    getStatistics(ID);
    
    }
}
public void getStatistics(ID pID){
    List<aggregateResult> PartnerOrganisationAgg =[SELECT partner_organisation_id__c
                                                           ,SUM(Total_No_of_Friends_Created__c)
                                                           ,COUNT(id) champ 
                                                   FROM DF_contact__c 
                                                   WHERE RecordType_Name__c = 'Dementia Friend Champion' 
                                                   AND  partner_organisation_id__c=:pID
                                                   GROUP BY partner_organisation_id__c];
    //retun count of champions and sum of friends, otherwise return zeros 
    IF (PartnerOrganisationAgg .size()>0){
        FOR (AggregateResult argRec : PartnerOrganisationAgg ){
            Double Total_No_of_Friends_CreatedDouble =(Double)argRec.get('expr0') ;
            Double Number_of_Champions_IdentifiedDouble= (Double)argRec.get('champ') ;
            
            //return zero, not null
            if (Total_No_of_Friends_CreatedDouble==null){
                Total_No_of_Friends_Created=0;
                }
            else {
                Total_No_of_Friends_Created = Total_No_of_Friends_CreatedDouble.IntValue();
            }
            
            if  (Number_of_Champions_IdentifiedDouble==null){
                Number_of_Champions_Identified=0;
                }
            else {
                Number_of_Champions_Identified= Number_of_Champions_IdentifiedDouble.IntValue();
            }
        }
    }
    else 
    {
       Total_No_of_Friends_Created = 0;
       Number_of_Champions_Identified  = 0; 
    }

}

}