public with sharing class SecurityTesting 
{
    public String foor {get; set;}
    public String testing {get; set;}
    
  	public string myInput  {get;set;}
  	public string myoutput {get;set;}
  	public string myhrefoutput {get;set;}
  Public void MyMethode(){
   myoutput = myInput ;
   myhrefoutput = myInput;
  }
    public SecurityTesting()
    {
    	String testing = 'This is a test';
        if(apexpages.currentpage().getparameters().get('Id') !=null) 
        {
        String test = ApexPages.currentPage().getParameters().get('Id');
  	     relatedCaseVulns(test);
        taintedfunc(test, 'static');
        }
    	
    }
    
    public void relatedCaseVulns(String test)
    {
  		String newtest = '\'' + test  + '\''; 
        String gcase = 'Select Description from Case where ID=' + string.escapeSingleQuotes(newtest);
        List<Case> a = Database.Query(gcase);
        
  
    }
    
    public void taintedfunc (String v, 
    String f)
    
    {
        try
        {
        String gg = v;
        String gcase = 'Select Name, Description from Account where Name = \'John \' and ID=' + '\'' + string.escapeSingleQuotes(v) + '\'';
        List<Account> a = database.query (gcase);
        }catch (Exception e)
        {
        }
    }
    
    @RemoteAction
    public static string testing(ID testid)
    {
        if(Schema.sObjectType.Account.isAccessible()) 
        {
        List<Account> act = [Select ID, Name from Account LIMIT 1];
        if(testid == null){
            if (Schema.sObjectType.Account.isDeletable())
            {
                delete (act);
            }
            
        }
        
            
        }
        return testid;
       
    }
    
     @RemoteAction
    public static string testings(ID testid)
    {
        if(Account.sObjectType.getDescribe().isDeletable()){} 
        List<Account> act = [Select ID, Name from Account LIMIT 1];
        if(testid == null){delete (act);}
        return testid;
       
    }

}