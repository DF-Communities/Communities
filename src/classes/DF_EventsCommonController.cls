public class DF_EventsCommonController {
    
    public DF_Event__c[] dfEvents { get; set; }
    
    public Boolean isRequestedInfoSession { get;set; }
    public Boolean showListing { get; set {calculateNoRows();} }
    public String dfcId { get; set; }
    public String placeholderOrganiserId {get;set;}
    public Integer noEvents {get;set;}
    public Boolean isChamp {get;set;}
    
    public void calculateNoRows() {

        System.debug('//// ' + dfEvents);
        if (dfEvents != null){
            noEvents = dfEvents.size();
        } else {
            noEvents=0;
        }
    }
}