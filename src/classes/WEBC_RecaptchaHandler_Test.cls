@isTest 
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for WEBC_RecaptchaHandler
 *  Author  : Lakshmi Rajendram
 *  Date    : 23-02-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
public class WEBC_RecaptchaHandler_Test {
    
    
    static TestMethod void test_WEBC_RecaptchaHandler()
    {    
        
        
        WEBC_RecaptchaHandler re = new WEBC_RecaptchaHandler('a','b','c');
        string href = re.baseUrl;
        re.challenge = re.response = 'foo';
        string publick = re.publicKey; 
        string host = re.remoteHost; 
        String privateK=re.privateKey;
        re.verify();
        
        
        
    }
    public static  testmethod void test_2() {
        
        WEBC_RecaptchaHandler re2 = new WEBC_RecaptchaHandler('a','b','c');
        re2.verify();
        
    }
    
    
    
}