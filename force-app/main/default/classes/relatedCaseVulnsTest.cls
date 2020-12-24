@isTest
public with sharing class relatedCaseVulnsTest {
	static testMethod void runTest()
{
	test.startTest();
	ApexPages.StandardController controller;
	
	
	relatedCaseVulns rcvsvulns = new relatedCaseVulns(null);
	relatedCaseVulns.AssignComment cssd = new relatedCaseVulns.AssignComment();
	
	Case ScanCase = new Case();
 	ScanCase.Subject = 'Security Scan @ ';//format('MM/dd/yyyy HH:mm:ss');
 	ScanCase.Description = 'Security Scanner found XXX issues';
	ScanCase.Origin = 'Security Scan';
	ScanCase.SuppliedName = 'SecScanResults_oOlOo';
	insert ScanCase;
		
	relatedCaseVulns.closeVulns(ScanCase.Id);
	List<Case> cas  = [Select Id, Subject, Description, CaseNumber, SuppliedName, Priority, Status from Case];
	String idnet;
	Case csa;
	for(Case cs: cas)
		{
			idnet = cs.Id;
			csa = cs;
		}
		rcvsvulns = new relatedCaseVulns(controller);
		relatedCaseVulns.closeVulns(idnet);
	
	PageReference pageRef = Page.ScanDetails;
        //In this case, the Visualforce page named 'jobpage' is the starting point of this test method.
        Test.setCurrentPage(pageRef);
        //Instantiate and construct the controller class. 
        ApexPages.currentPage().getParameters().put('Id',idnet);
       ApexPages.StandardController thecontroller;       
       
        rcvsvulns = new relatedCaseVulns(thecontroller);
        
        
	
	test.stopTest();
}
}