public with sharing class Dfc_AssessmentStoreController 
{
    @AuraEnabled
    public static Object getAssessmentForCommunityAndYear(String Id, Integer yearEnding) 
    {
      try {

        return Dfc_Util.getAssessmentForCommunityAndYear(Id, Integer.valueOf(yearEnding)); 
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
    
    @AuraEnabled
    public static Object updateAssessment(String assessmentId, String status, DFC_Assessment_Answer__c[] answers) 
    { 
      try {
        return Dfc_Util.updateAssessment(assessmentId, status, answers);
      }
       catch(Exception e) {
         return new Dfc_ErrorResponse(e);
      }
    }
}