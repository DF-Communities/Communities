@isTest
private class WEBC_Recpatcha2Handler_Test
{

    static TestMethod void itShould()
    {    
        
        WEBC_Recaptcha2Handler re = new WEBC_Recaptcha2Handler('a','b');
        re.verify();
        
    }

}