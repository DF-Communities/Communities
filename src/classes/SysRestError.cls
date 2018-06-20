global class SysRestError 
{
   Boolean isErrorResponse = true;
   Integer status;
   String message;
   Datetime timestamp;
   String diagnosticMessage;
   String exceptionType;
   
   public SysRestError(Exception e)
   {
       this(e, 500);
   }
    
   public SysRestError(Exception e, Integer status)
   {
      this.status = status;
      this.message = e.getMessage();
      this.timestamp = Datetime.now();
      this.diagnosticMessage = e.getStackTraceString();
      this.exceptionType = String.valueOf(e);
   }
    
}