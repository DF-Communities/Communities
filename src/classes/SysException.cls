global class SysException extends Exception
{
    global SysException(String msg, HttpResponse resp)
    {
    	msg += '['+resp.getStatusCode()+resp.getStatus();
        if (resp.getBody()!=null) msg += ' '+resp.getBody();
        msg += ']';
		setMessage(msg);     
    }
}