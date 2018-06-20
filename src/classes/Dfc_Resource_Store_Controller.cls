/*  Get resource Files for various form states, Apply, Requested, Active */

public with sharing class Dfc_Resource_Store_Controller 
{
	@AuraEnabled
    public static Object getResourcesForState(String state)
    {
        try {
            return Dfc_Util.getResourcesForState(state);
        }
        catch (Exception e) {
            return new Dfc_ErrorResponse(e);
        }
    }
    
}