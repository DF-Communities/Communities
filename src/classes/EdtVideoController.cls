public class EdtVideoController extends EdtComponentController
{
    public String getOptionString()
    {
        String vars = itemValue2==null ? '' : itemValue2;
        vars = vars.replaceAll('(^|,)([^:]+):', '$1"$2":');
        vars = vars.replaceAll('\'', '"');
        
        String opt = '{';
	    opt += '"videoId":"'+itemValue1+'"';
        if (vars.length()>0) opt += ',"playerVars":{'+vars+'}';
        opt += '}';
        return opt; 
    }
	
   public String getCoverImageUrl()
   {
       return itemValue3==null ? '//img.youtube.com/vi/'+itemValue1+'/hqdefault.jpg' : itemValue3;
   }
}