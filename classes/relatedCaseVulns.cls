public with sharing class relatedCaseVulns {
	public List<Case> cas {get; set;}

	
	public class AssignComment        // This class will be used to store the corresponding input from the user and the Case Comment
    {  
        public CaseComment comment {get; set;}        //This will store the case Comment
        public Boolean published {get; set;}          //This will store the input from the user
        public AssignComment(){}                      //Empty constructor
    }    
    public List<assignComment> Records {get; set;}    //This will store the list of case comments as well as the corresponding user inputs
    public relatedCaseVulns(ApexPages.StandardController controller)
    {
    	if(ApexPages.currentPage().getParameters().get('Id') != null)
    	{
        Records = new List<AssignComment>(); 
        if(controller !=null){         
	    Case Record = (Case) controller.getRecord();    //Get case from controller
        
      if(Schema.sObjectType.Case.isAccessible()) 
      {
          cas = [Select Id, Subject, Description, CaseNumber, SuppliedName, Priority, Status from Case where parentId = :Record.Id];
      }
            if (Schema.sObjectType.Case.isUpdateable()){
                //update cas;
            }
        
        
    	}
    	}      
    }
    
   
    
    @RemoteAction
	public static String closeVulns(String vuln_id)
	{	
        String return_id;
        if(Schema.sObjectType.Case.isAccessible()) 
        {
		Case cs = [Select Id, Status from Case where Id = :vuln_id];
		if(cs!=null){
		cs.Status = 'Closed';
		if (!Schema.sObjectType.Case.isUpdateable())
		{
			return 'failure';
		}
			update cs;
		}
			return_id = cs.Id;        
        }
		
		
		return return_id;
	}


}