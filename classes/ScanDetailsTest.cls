@isTest
public with sharing class ScanDetailsTest {
	static testMethod void runTest()
{
	test.startTest();
	ApexPages.StandardController controller;
	
	
	ScanDetails rcvsvulns = new ScanDetails(null);
	ScanDetails.AssignComment cssd = new ScanDetails.AssignComment();
	
	Case ScanCase = new Case();
 	ScanCase.Subject = 'Security Scan @ ';//format('MM/dd/yyyy HH:mm:ss');
 	ScanCase.Description = 'Security Scanner found XXX issues';
	ScanCase.Origin = 'Security Scan';
	ScanCase.SuppliedName = 'SecScanResults_oOlOo';
	insert ScanCase;
	CaseComment cmnt = new CaseComment(CommentBody = 'Test Account');
	cmnt.ParentId = ScanCase.Id;
	cssd.comment = cmnt;
	cssd.published = true;
		
	ScanDetails.closeVulns(ScanCase.Id);
	List<Case> cas  = [Select Id, Subject, Description, CaseNumber, SuppliedName, Priority, Status from Case];
	String idnet;
	Case csa;
	for(Case cs: cas)
		{
			idnet = cs.Id;
			csa = cs;
		}

		rcvsvulns = new ScanDetails(controller);
		ScanDetails.closeVulns(idnet);
	
	PageReference pageRef = Page.ScanDetails;
	      
	
        //In this case, the Visualforce page named 'jobpage' is the starting point of this test method.
        Test.setCurrentPage(pageRef);
        //Instantiate and construct the controller class. 
        ApexPages.currentPage().getParameters().put('Id',idnet);
       //ApexPages.StandardController thecontroller;       

Case acc = new Case(Description = 'Test Account');
        insert acc;
        ScanDetails thecontroller = new ScanDetails(new ApexPages.StandardController(acc));
        //thecontroller

        //rcvsvulns = new ScanDetails(thecontroller);
        
        List<Case> sds = rcvsvulns.cas;
        
 	ScanDetails.AssignComment sasdf = new ScanDetails.AssignComment();
 	
	
	test.stopTest();
	
	
}

}