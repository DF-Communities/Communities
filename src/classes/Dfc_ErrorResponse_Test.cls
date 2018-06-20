@isTest
private class Dfc_ErrorResponse_Test
{
    @isTest
    static void itShould()
    {
        
        Dfc_ErrorResponse error = (Dfc_ErrorResponse)Dfc_CommunityServiceController.inviteRepresentative('xxx', 'xxx', 'xxx');
        String s = error.getMessage();
        s = error.getType();
        s = error.getStackTrace();

    }
}