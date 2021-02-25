@isTest	
public with sharing class SecurityScanTest {
static testMethod void runTest()
{
	test.startTest();
	
	//System.debug('Beginning tests');
	User u1 = [SELECT Id FROM User WHERE Alias='WNazi'];
	System.runAs(u1){
		
	
	SecurityScan mcontroller = new SecurityScan();
	Test.setCurrentPage(Page.SecurityScan);
	PageReference pageRef = mcontroller.init();
	Case ScanCase = new Case();
 	ScanCase.Subject = 'Security Scan @ ';//format('MM/dd/yyyy HH:mm:ss');
 	ScanCase.Description = 'Security Scanner found XXX issues';
	ScanCase.Origin = 'Security Scan';
	ScanCase.SuppliedName = 'SecScanResults_oOlOo';
	insert ScanCase;
	String pageRef3 = SecurityScan.logVulns('','','','');
	pageRef = mcontroller.init();
	SecurityScan.apexcodeObject x = new SecurityScan.apexcodeObject();
	SecurityScan.apexcodeObjectblock u = new SecurityScan.apexcodeObjectblock();	
	SecurityScan.Vuln v = new SecurityScan.Vuln('rl', 'vari', 'ploit','ile', 
	' ine ','ype', 'ode', 'everity');
	SecurityScan.Caso c = new SecurityScan.Caso('Id','d', 'ubject', 'ighcount', 'ediumcount', 'owcount', 'ctivecount');
	SecurityScan.PkgNames p = new SecurityScan.PkgNames('test','test');
	SecurityScan.hearbeat();
	
	//pageRef = mcontroller.init();
	/*List<String> metaclasses = new List<String>{'classes/SecurityTesting.cls'};
	List<String> metapage = new List<String> {'pages/Security_Testing.page'};
	String asyncid = SecurityScan.jsretrieveMetadataClass(metaclasses);
	String asyncid1 = SecurityScan.jsretrieveMetadataPage(metapage);*/
	//String ftest = SecurityScan.jsretrieveSecuritySettings('test');
	
	//String filetext = SecurityScan.jscheckAsyncRequest('tes');
	//PageReference pageRef2 = mcontroller.checkAsyncRequest();
	String refer = mcontroller.getReferer(); 
	String tests = mcontroller.getFullname();
	String tests1 = mcontroller.getContent();
  	pageRef3 = SecurityScan.logVulns('[{"exploit":"Cross-site Scripting issue found @ https://digitsec.na11.visual.force.com/apex/Security_Testing via variable xsddsid","variable":"xsddsid","url":"https://digitsec.na11.visual.force.com/apex/Security_Testing?xsddsid=*/alert(\'519\'); /*","file":"NA","line":"NA","typed":"3","code":"NA","severity":"High"}]','','','');
	
	//String adsd=mcontroller.getContent();
	//PageReference pageRef3 = mcontroller.listMetadataItems();
	//PageReference pageRef4 =mcontroller.retrieveMetadataItem();
	//PageReference pageRef5 =mcontroller.createFuzzedObject();
	
	/*pageRef = mcontroller.receiveMetadataZipFile();*/
	
	
	/*String sample = SecurityScan.jsretrieveSecuritySettings('');
	//SecurityScan.logVulns('["exploit":"The current password complexity is set to ","variable":"NA","url":"NA","file":"NA","line":"NA","typed":"4", "code":"NA","severity":"Medium"]');
	List<String> files = new List<String>{'test', 'test'};
	sample = SecurityScan.jsretrieveMetadataPage(files);*/
	String sample = SecurityScan.deleteScan(ScanCase.Id);
	List<SObject> obls = mcontroller.fuzzObjects;
	String medf = mcontroller.MetadataFileName;
	medf = mcontroller.MetadataFileData;
	//String[] assdf = mcontroller.apexPageNames;
	//List<String> asddd = mcontroller.apexClassNames;
	//List<ApexClass> dsdedfs = mcontroller.apxcls;
	medf = mcontroller.status;
	medf = mcontroller.MetadataApexClass;
	}
	/*
	SecurityScan.hearbeat();
	String  Asyncid = SecurityScan.jscheckAsyncRequest('TESTS');
	List<String> files = new List<String>{'Cases','Accounts','Assets','Campaigns','CaseComments','CollaborationGroups','Contacts','Events','Ideas','Leads','Opportunitys','Pricebook2s','Product2s','Tasks'};
	Asyncid = SecurityScan.jsretrieveMetadataClass(files);
	Asyncid = SecurityScan.jsretrieveMetadataPage(files);
	String tst = 'test';
	tst = SecurityScan.jsretrieveSecuritySettings(tst);
	tst = SecurityScan.logVulns('test');
	tst = SecurityScan.logVulns(null);
	tst = SecurityScan.logVulns('');
	*/

	test.stopTest();
	
	
}

}