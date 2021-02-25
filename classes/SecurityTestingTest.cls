@isTest
public with sharing class SecurityTestingTest {
	static testMethod void runTest()
{
	test.startTest();
	PageReference pageRef = Page.Security_Testing;
        //In this case, the Visualforce page named 'jobpage' is the starting point of this test method.
        Test.setCurrentPage(pageRef);
        //Instantiate and construct the controller class. 
        ApexPages.currentPage().getParameters().put('Id','5000f00001G6EY2AAN');
	SecurityTesting sds = new SecurityTesting();
	sds.foor ='test';
	sds.testing ='test';
	sds.myInput ='test';
	sds.myoutput = 'test';
	sds.myhrefoutput = 'test';
	sds.MyMethode();
	sds.taintedfunc('5000f00001G6EY2AAN', 'test');
	sds.relatedCaseVulns('5000f00001G6EY2AAN');
	String gg = SecurityTesting.testing('5000f00001G6EY2AAN');
	test.stopTest();
}
}