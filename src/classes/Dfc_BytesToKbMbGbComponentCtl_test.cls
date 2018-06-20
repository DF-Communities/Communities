@isTest
private class Dfc_BytesToKbMbGbComponentCtl_test
{
    @isTest
    static void itShould()
    {

        Dfc_BytesToKbMbGbComponentController ctl = new Dfc_BytesToKbMbGbComponentController();
        ctl.setFileSize('2048');
        ctl.setFileType('xxx.pdf');
        ctl.setFileName('xxx.pdf');

        String s = String.valueOf((1024 * 1024) + 1024);
        ctl.setFileSize(s);

        s = String.valueOf((1024*1024*1024) + 1024);
        ctl.setFileSize(s);

        String r = ctl.getFileSize();
        r = ctl.getFileType();
        r = ctl.getFileName();

    }
}