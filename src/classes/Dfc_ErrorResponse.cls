public class Dfc_ErrorResponse 
{
    private String message;
    private String stacktrace;
    private String typeName;
    private Dfc_ErrorResponse cause;
    
    public Dfc_ErrorResponse(Exception e)
    {
        typeName = e.getTypeName();
        message = e.getMessage();
        stacktrace = e.getStackTraceString();
        if (e.getCause()!=null) cause = new Dfc_ErrorResponse(e.getCause());
    }
    
    @AuraEnabled
    public boolean getIsErrorResponse()
    {
        return true;
    }
    
    @AuraEnabled
    public String getMessage()
    {
        return message;
    }
    
    @AuraEnabled
    public String getType()
    {
        return typeName;
    }

    @AuraEnabled
    public String getStacktrace()
    {
        return stacktrace;
    }

}