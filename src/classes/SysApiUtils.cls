global class SysApiUtils 
{
   global static String NO_CACHE = 'max-age=0, no-cache';
   global static String SHORT_CACHE = 'max-age=36000';
   global static String LONG_CACHE = 'max-age=604800';
	
   global static void setCache(String cache)
   {
      RestResponse resp = RestContext.response;
      resp.headers.put('Expires', null);
      resp.headers.put('Cache-Control', cache);
    }

   global static void setNoCache()
   {
      setCache(NO_CACHE);
   }

   global static void setShortCache()
   {
      setCache(SHORT_CACHE);
   }

   global static void setLongCache()
   {
      setCache(LONG_CACHE);
   }

   global static void sendJson(Object content)
   {
       sendJson(content, 200);
   }

   global static void sendJson(Object content, Integer status)
   {
      RestResponse resp = RestContext.response;
      resp.statusCode = status;
      resp.headers.put('Content-Type', 'application/json;charset=UTF-8');
      resp.responseBody = Blob.valueOf(JSON.serialize(content));       
    }

   global static void sendText(String text)
   {
       sendText(text, 200);
   }

   global static void sendText(String text, Integer status)
   {
      RestResponse resp = RestContext.response;
      resp.statusCode = status;
      resp.headers.put('Content-Type', 'text/plain;charset=UTF-8');
      resp.responseBody = Blob.valueOf(text);       
   }

   global static void sendError(Exception e)
   {
      sendJson(new SysRestError(e), 500);
   }

}