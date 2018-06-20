public class Dfc_BytesToKbMbGbComponentController {
   

    public String fileSize;
    public String fileType;
    public String fileName;
   
    public void setFileSize(String s) {
        fileSize = s.toUpperCase();
        Long longValue = Long.valueOf(s);
       
        if (longValue < 1024)
            fileSize =  string.valueOf(longValue) + ' Bytes';
        else
            if (longValue >= 1024 && longValue < (1024*1024))
        {
            //KB
            Decimal kb = Decimal.valueOf(longValue);
            kb = kb.divide(1024,0);
            fileSize = string.valueOf(kb) + ' KB';
        }
        else
            if (longValue >= (1024*1024) && longValue < (1024*1024*1024))
        {
            //MB
            Decimal mb = Decimal.valueOf(longValue);
            mb = mb.divide((1024*1024),1);
            fileSize = string.valueOf(mb) + ' MB';
        }
        else
        {
            //GB
            Decimal gb = Decimal.valueOf(longValue);
            gb = gb.divide((1024*1024*1024),2);
           
            fileSize = string.valueOf(gb) + ' GB';
        }   
       
    }

    public void setFileType(String s) {
        if (s.contains('pdf')) {
            fileType = '<i class="fa fa-file-pdf-o"></i>';
        }
    }

    public void setFileName(String s) {
    }
   
    public String getFileSize() {
        return fileSize;
    }

     public String getFileType() {
        return fileType;
    }

    public String getFileName() {
        return fileName;
    }
}