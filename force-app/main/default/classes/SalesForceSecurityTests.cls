@isTest
public with sharing class SalesForceSecurityTests {


static testMethod void runTest()
{
	test.startTest();
	
	//System.debug('Beginning tests');
	User u1 = [SELECT Id FROM User WHERE Alias='WNazi'];
	System.runAs(u1){
	MetadataRetrieveController mcontroller = new MetadataRetrieveController();
	Test.setCurrentPage(Page.metadataretrieve);
	PageReference pageRef = mcontroller.init();
	MetadataRetrieveController.apexcodeObject x = new MetadataRetrieveController.apexcodeObject();
	MetadataRetrieveController.apexcodeObjectblock u = new MetadataRetrieveController.apexcodeObjectblock();	
	MetadataRetrieveController.Vuln v = new MetadataRetrieveController.Vuln('rl', 'vari', 
	'ploit','ile', 'ine',
	'ype', 'ode', 
	'everity');
	MetadataRetrieveController.Caso c = new MetadataRetrieveController.Caso('Id','d', 
	'ubject', 'ighcount', 'ediumcount', 'owcount', 'ctivecount');
	MetadataRetrieveController.hearbeat();
	
	//pageRef = mcontroller.init();
	/*List<String> metaclasses = new List<String>{'classes/SecurityTesting.cls'};
	List<String> metapage = new List<String> {'pages/Security_Testing.page'};
	String asyncid = MetadataRetrieveController.jsretrieveMetadataClass(metaclasses);
	String asyncid1 = MetadataRetrieveController.jsretrieveMetadataPage(metapage);*/
	//String ftest = MetadataRetrieveController.jsretrieveSecuritySettings('test');
	
	//String filetext = MetadataRetrieveController.jscheckAsyncRequest('tes');
	//PageReference pageRef2 = mcontroller.checkAsyncRequest();
	String refer = mcontroller.getReferer(); 
	String tests = mcontroller.getFullname();
	String tests1 = mcontroller.getContent();
  	String pageRef3 = MetadataRetrieveController.logVulns('[{"exploit":"Cross-site Scripting issue found @ https://digitsec.na11.visual.force.com/apex/Security_Testing via variable xsddsid","variable":"xsddsid","url":"https://digitsec.na11.visual.force.com/apex/Security_Testing?xsddsid=*/alert(\'519\'); /*","file":"NA","line":"NA","typed":"3","code":"NA","severity":"High"}]');
	
	//String adsd=mcontroller.getContent();
	//PageReference pageRef3 = mcontroller.listMetadataItems();
	//PageReference pageRef4 =mcontroller.retrieveMetadataItem();
	//PageReference pageRef5 =mcontroller.createFuzzedObject();
	
	/*pageRef = mcontroller.receiveMetadataZipFile();
	pageRef = mcontroller.retrieveMetadataItem();
	pageRef = mcontroller.checkAsyncRequest();*/
	//String sample = MetadataRetrieveController.jsretrieveSecuritySettings('');
	//MetadataRetrieveController.logVulns('["exploit":"The current password complexity is set to ","variable":"NA","url":"NA","file":"NA","line":"NA","typed":"4", "code":"NA","severity":"Medium"]');
	//List<String> files = new List<String>{'test', 'test'};
	//sample = mcontroller.jsretrieveMetadataPage(files);
	}
	/*
	MetadataRetrieveController.hearbeat();
	String  Asyncid = MetadataRetrieveController.jscheckAsyncRequest('TESTS');
	List<String> files = new List<String>{'Cases','Accounts','Assets','Campaigns','CaseComments','CollaborationGroups','Contacts','Events','Ideas','Leads','Opportunitys','Pricebook2s','Product2s','Tasks'};
	Asyncid = MetadataRetrieveController.jsretrieveMetadataClass(files);
	Asyncid = MetadataRetrieveController.jsretrieveMetadataPage(files);
	String tst = 'test';
	tst = MetadataRetrieveController.jsretrieveSecuritySettings(tst);
	tst = MetadataRetrieveController.logVulns('test');
	tst = MetadataRetrieveController.logVulns(null);
	tst = MetadataRetrieveController.logVulns('');
	*/

	test.stopTest();
	
	
}
}