@isTest  
/******************************************************************************************
 *  Alzheimer's Society
 *  
 *  Purpose : APEX Test Class for WEBC_CryptoUtils 
 *  Author  : Lakshmi Rajendram
 *  Date    : 23-02-2015
 *  Version : 0.1 Unit Test
 *
 *               
 *  Modification History
 *  Date            Who         Description 
 *  dd-mm-yyyy      ??          ????                           
*******************************************************************************************/
public class WEBC_CryptoUtils_Test {
    
    
    static TestMethod void test_WEBC_CryptoUtils ()
    {        
        string password='test'; 
        WEBC_CryptoUtils wc=new WEBC_CryptoUtils();        
        password=WEBC_CryptoUtils.createCryptoKey();
        
        String decryptValue='decryptvalue';
        decryptValue= WEBC_CryptoUtils.decryptValue('encrypted value', 'xxxx');
        
        String en='encryptvalue';
        en=WEBC_CryptoUtils.encryptValue('v', 'yyyy');
    }
    
    
}