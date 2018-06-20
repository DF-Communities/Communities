public with sharing class DF_WEBC_FootballTeamSelection_Controller {
	
	public DF_WEBC_FootballTeamSelection_Controller() {
		
	}

	public List<SelectOption> getFootballTeams()
	{
	  
	  List<SelectOption> options = new List<SelectOption>();
	        
	   Schema.DescribeFieldResult fieldResult = DF_Contact__c.Football_Team__c.getDescribe();
	   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	        
	   for( Schema.PicklistEntry f : ple)
	   {
	      options.add(new SelectOption(f.getLabel(), f.getValue()));
	   }       
	   
	   return options;
	}

}