public with sharing class XSSClass {
    public string xinput {get; set;}
    public string xout {get; set;}

    public void XSSClass()
    {
        
    }

    public void doTest()
    {
        XSSClassBase cxc = new XSSClassBase();
        xout = cxc.testXSS(xinput);
        
    }

    @RemoteAction
    public static String doRemote(string sinput)
    {
        if(sinput != '')
        {
            List<Account> lstAccout = [SELECT Id, Name FROM Account WHERE Name = :sinput]; 
        }
        return sinput;
    }


}
