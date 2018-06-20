/* The 'without sharing' keywords in the class declaration 
   to ensure that the sharing rules for the current user are not enforced.

    Public Listing of Dementia Friendly Communities

    https://dfdev-dfdev.cs18.force.com/WebArticle?page=dfc-public-listing#.VwecehMrLdS

   ****/

public without sharing class Dfc_CommunityPublicListing {

    Public String daa { get;set; }
    Public String country { get;set; }
    Public String county { get;set; } 
    Public String region { get;set; } 

    public Dfc_CommunityPublicListing() {
        region = '';
        List<DFC_Community__c> c = communities;     
    }

    /*
     *   Returns a list of Regions to select from - with the Active Community Count per region
     */
    public List<SelectOption> regions { 

        get {

            Map<String, Integer> mapCount = new Map<String, Integer>();

            
            // Get the Active Community Count for each Region in the selected Country
            AggregateResult[] lisCount = 
                                [SELECT Region__c r, count(Id) c FROM DFC_Community__c 
                                 WHERE ( Status__c = 'Active' and Country__c =: country ) 
                                 GROUP BY Region__c ];

            for ( AggregateResult agr : lisCount ) {

                mapCount.put((String)agr.get('r'), (Integer)agr.get('c'));

            }

            regions = new List<SelectOption>();
            List<DFC_DAA_Region__c> lisRegions = [ select Id, Name from DFC_DAA_Region__c order by Name];
            for ( DFC_DAA_Region__c region : lisRegions ) {

                Integer iCount = (Integer)mapCount.get(region.Name);
                if ( iCount != null ) { 
                    String sLabel = region.Name + ' (' + iCount + ')';
                    regions.add(new SelectOption(region.Name, sLabel));
                }

            }

            return regions;
        }

        private set;

    }

    public List<SelectOption> daas { 

        get {

            List<DFC_Alliance__c> lis;


            daas = new List<SelectOption>();

            if (country=='Wales') return daas;

            if ( region == null || region == '' ) { 

                daa = ''; 
                lis = [ select Id, Name from DFC_Alliance__c order by Name ];

            } else { 

                lis = [ select Id, Name from DFC_Alliance__c where Region__c =:region order by Name];
            }


            Map<String, Integer> mapCount = new Map<String, Integer>();
            AggregateResult[] lisCount = [select DA_Alliance__c r, count(id) c from DFC_Community__c where Status__c = 'Active' group by DA_Alliance__c ];
            for ( AggregateResult agr : lisCount ) {

                mapCount.put((String)agr.get('r'), (Integer)agr.get('c'));

            }

            for ( DFC_Alliance__c daa : lis ) {

                Integer iCount = (Integer)mapCount.get(daa.id);
                if ( iCount != null ) { 
                    String sLabel = daa.Name + ' (' + iCount + ')';
                    daas.add(new SelectOption(daa.id, sLabel));
                }
            }

            return daas;
        }

        private set;

    }

    /*
     *   Returns the list of Active communities that match the selected 
     *   Country, Region and DAA filters -  if any - otherwise retuns all Active Communities
     */
    public List<DFC_Community__c> communities {

        get {
                 String status = 'Active';

                 String soql = 
                 'SELECT   Id, Name, Name__c, Central_Location__c, Status__c, Country__c, Region__c, '+
                         ' County__r.Name, Location__c, Location_Type__c, Population__c, Date_Approved__c, '+
                         ' DA_Alliance__r.Url__c, DA_Alliance__r.Name' + 
                 ' FROM DFC_Community__c ' +
                 ' WHERE Status__c =: status' ; 

                 // Add 'AND'  clauses to qualify the WHERE if there are filters selected
                 if ( country != null && country != '' ) {
                    soql = soql + ' and Country__c =: country ';
                 }

                 if ( region != null && region != '' ) {
                    soql = soql + ' and Region__c =: region ';
                 }

                 if ( daa != null && daa != '' ) {
                    soql = soql + ' and DA_Alliance__c =: daa ';
                 }

                 soql = soql + ' order by Name__c';

                 communities = Database.query(soql);

                return communities;

        }
        private set;
    }



}