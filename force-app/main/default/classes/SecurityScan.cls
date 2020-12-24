public with sharing class SecurityScan {
    
 
    public Transient String MetadataFileName {get; set;}
    public Transient String MetadataFileData {get; set;}
    public MetadataService.AsyncResult AsyncResult {get; private set;}
    public Transient String MetaDataRetrieveZip { get; private set; }
    public List<MetaDataService.MetadataWithContent> MetadataFiles { get; set; }
    public String fullName {get; set;}
    public String content {get; set;}   
    public List<Case> cas {get; set;}
    public List<Caso> casos {get; set;}
    public Transient String status {get; set;}
    public String MetadataApexClass {get; set;}
    public List<String> customfields  = new List<String> {'Typeid__c', 'Objectid__c'};//,'Payload__c','URL__c'}; 
    public String custObjName = 'Security_Scan_oOlOo_v6';
    public String scannerSettings = 'Security_Scan_Settings_oOlOo_v5';
    public Transient String FuzzedObjsnames {get; set;}
    public String RemoteSiteError {get; set;}
    
    //
        private Transient Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		public Transient List <SelectOption> objectNames{public get; private set;}
		public Transient String selectedObject {get; set;}
//
        

    public Boolean found = false;  
    public List<sObject> fuzzObjects {get; set;} // new List<sObject> {Case, Account, Asset, Campaign, CaseComment, CollaborationGroup, Contact, Event, Lead, Opportunity, Pricebook2, Product2, Task};
    private Transient List<String> objectstoFuzz  = new List<String> {'Cases','Accounts','Assets','Campaigns','CaseComments','CollaborationGroups','Contacts','Events','Leads','Opportunitys','Pricebook2s','Product2s','Tasks'};
    private Transient List<String> payloads = new List<String> {'\'\';alert(\'oOlOo1\')','\';alert(\'oOlOo2\');//',';alert(\'oOlOo3\');//','*/\';alert(\'oOlOo4\'); /*','*/alert(\'oOlOo5\'); /*','%0A%0D\';alert(\'oOlOo6\');','" onload="alert(\'oOlOo7\')"><!--;','<img src="" onerror="alert(\'oOlOo8\');" /><!--','<script>alert(\'oOlOo9\');</script><!--','"><script>alert(\'oOlOo10\');</script><!--','"></textarea><script>alert(\'oOlOo11\');</script><!--','<img src="javascript:alert(\'oOlOo12\');">','<<SCRIPT>alert(\'oOlOo13\');//<</SCRIPT>','\\";alert(\'oOlOo14\');//','\\\';alert(\'oOlOo15\');//',' BACKGROUND="javascript:alert(\'oOlOo16\')"','<BASE HREF="javascript:alert(\'oOlOo17\');//">','"";alert(\'oOlOo18\')','";alert(\'oOlOo19\')//','";alert(\'oOlOo20\');//','*/";alert(\'oOlOo21\'); /*','*/alert(\'oOlOo22\'); /*','%0A%0D";alert(\'oOlOo23\');',' onload="alert(\'oOlOo24\')"><!--;','<img src="" onerror="alert(\'oOlOo25\');" /><!--','<script>alert(\'oOlOo26\');</script><!--','><script>alert(\'oOlOo27\');</script><!--','></textarea><script>alert(\'oOlOo28\');</script><!--','<img src="javascript:alert(\'oOlOo29\');">','<<SCRIPT>alert(\'oOlOo30\');//<</SCRIPT>','\\\';alert(\'oOlOo31\');//','\\";alert(\'oOlOo32\');//',' BACKGROUND="javascript:alert(\'oOlOo33\')"','<BASE HREF="javascript:alert(\'oOlOo34\');//">'};
    private Transient List<Case> fizzCases= new List<Case>();
    private Transient List<Account> fizzAccounts= new List<Account>();
    private Transient List<Asset> fizzAssets= new List<Asset>();
    private Transient List<Campaign> fizzCampaigns= new List<Campaign>();
    private Transient List<CaseComment> fizzCaseComments= new List<CaseComment>();
    private Transient List<Contact> fizzContacts= new List<Contact>();
    private Transient List<Event> fizzEvents= new List<Event>(); 
    private Transient List<Lead> fizzLeads= new List<Lead>();
    private Transient List<Opportunity> fizzOpportunitys= new List<Opportunity>();
    private Transient List<Pricebook2> fizzPricebook2s= new List<Pricebook2>();
    private Transient List<Product2> fizzProduct2s= new List<Product2>();
    private Transient List<Task> fizzTasks= new List<Task>();
    public String scanCaseName = 'SecScanResults_oOlOo';
    public String baseSFURL {get; set;} 
    public String baseSFHost {get; set;} 
    
    public String dotPrefix {get; set;} 
    public String isDemo {get; set;}
    public String isSetup {get; set;}
    public String AuditURL {get;set;}
	public String settingsURL {get;set;}
	public String expired {get;set;}
    
    
    
    public PageReference init()
    {	
		//if(DateTime.now() < DateTime.parse('07/01/2018 11:46 AM')){
		isDemo = '0';
		expired = '0';        	
		if(Schema.sObjectType.Organization.isaccessible() && Schema.sObjectType.Organization.fields.NamespacePrefix.isAccessible())
    	{
         Organization orx = [SELECT NamespacePrefix FROM Organization] ;// SecurityScan.class.getName().substringBefore('SecurityScan');
            
         if(!(String.isBlank(orx.NamespacePrefix)))
         {dotPrefix = orx.NamespacePrefix+'.';}
    	}
    	baseSFHost = URL.getSalesforceBaseUrl().getHost();
        baseSFURL = URL.getSalesforceBaseUrl().toExternalForm();
        
         if(Schema.sObjectType.Organization.isaccessible() && Schema.sObjectType.Organization.fields.Instancename.isAccessible())
    	{
	         Organization orx = [SELECT Instancename FROM Organization] ;  
	       //  if(!(String.isBlank(orx.Instancename)))
	      //   {baseSFURL ='https://'+orx.Instancename.toLowerCase()+'.salesforce.com';}
    	 }
        
        RemoteSiteError = '0';
        
        if(Schema.sObjectType.Case.isaccessible() && Schema.sObjectType.Case.fields.Subject.isAccessible() && Schema.sObjectType.Case.fields.Id.isAccessible() && Schema.sObjectType.Case.fields.Description.isAccessible()&& Schema.sObjectType.Case.fields.Status.isAccessible() && Schema.sObjectType.Case.fields.Priority.isAccessible() && Schema.sObjectType.Case.fields.CaseNumber.isAccessible())
        {
        cas = [ Select Id, Subject, Description, CaseNumber, Status, Priority from Case where 
        SuppliedName = :scanCaseName AND status <> 'Closed' ORDER BY LastModifiedDate DESC];
        /*if(cas.size() >= 1){isDemo = '1';return null;}*/
        }
        else
        {
            //Security Error
        }
        List<Caso> casost = new List<Caso>();
        for(Case cs: cas){
        Integer hcount = 0;
        Integer mcount = 0; 
        Integer lcount = 0;
        Integer acount = 0;
        List<Case> relatedCases = new List<Case>();
        if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.fields.Subject.isAccessible() && Schema.sObjectType.Case.fields.Id.isAccessible() && Schema.sObjectType.Case.fields.Description.isAccessible()&& Schema.sObjectType.Case.fields.Status.isAccessible() && Schema.sObjectType.Case.fields.Priority.isAccessible()){
            relatedCases = [Select Id, Subject, Description, CaseNumber, Status, Priority from Case where ParentId = :cs.Id];
            }
            for(Case rcs: relatedCases)
            {
                if (rcs.Priority == 'High'){
                    hcount++;}
                if(rcs.Priority == 'Medium'){
                    mcount++;}
                if(rcs.Priority == 'Low'){
                    lcount++;}
                if(rcs.Status == 'Active'){
                    acount++;}
            }
           PageReference pr1 = Page.ScanDetails;
        String scanfileURL = pr1.getUrl();
            Caso crcs = new Caso(cs.Id, URL.getSalesforceBaseUrl().toExternalForm() + scanfileURL+'?id='+cs.Id, integer.valueof(cs.CaseNumber) + ' - ' + cs.Subject, String.valueOf(hcount),String.valueOf(mcount), String.valueOf(lcount), String.valueOf(acount));
            casost.add(crcs);
        }   
        casos = casost;
        if (Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.fields.Id.isAccessible() && Schema.sObjectType.Attachment.fields.Description.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible()){
        List<Attachment> checkCase = [Select Id,Description,Body from Attachment where Description = 'Security_Scan_oOlOo_v6' LIMIT 1];     
        if(checkCase.isEmpty()){
        	isSetup = '1';
        }   
        else
        {
        	isSetup = '0';
        }
        }
        isSetup = '0';
		/*}else{
			RemoteSiteError = '0';
			expired = '1';
		}*/
        
        return null;    
    }
    
    private static Boolean checkHeapSize()
    {
    	if(Limits.getHeapSize() < 3000000){
    	return true;
    	}
    	return false;
    }
    
    @RemoteAction
    public static String saveSettings(String settings)
    {
    	try
    	{
    	Transient String result;
    	Transient String scannerSettings = 'Security_Scan_Settings_oOlOo_v4'; 
    	if (Schema.sObjectType.Attachment.isDeletable())
    	{	
    		List<Attachment> settingsAttachment = [Select Id,Description,Body from Attachment where Description = :scannerSettings];
    		delete settingsAttachment;	
    	}
    	Case SecurityScanCase;
    	if(Schema.sObjectType.Case.isAccessible())
    	{
    		Transient String custObjName = 'Security_Scan_oOlOo_v6';
    		SecurityScanCase = [Select Id from Case where SuppliedName = :custObjName LIMIT 1];
    	}
    	if (Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.Attachment.fields.Description.isCreateable() && Schema.sObjectType.Attachment.fields.Body.isCreateable())
    	{
		    Attachment settingsAttachment = new Attachment();
		   	settingsAttachment.Body = Blob.valueOf(settings);
		    settingsAttachment.Description = scannerSettings;
		    settingsAttachment.Name = 'Security Scanner Settings';
		    settingsAttachment.ParentId = SecurityScanCase.Id;
		    if(Schema.sObjectType.Attachment.isCreateable())
		    {
		    insert settingsAttachment;
		    result ='success';
		    }
    	}
    	else
    	{
    		result = 'failure';
    	}
    	return result;
    	}
    	catch(Exception ex)
    	{
    		return ex.getMessage();
    	}
    }
    
    @RemoteAction
    public static String getSettings(String settings)
    {
    	Transient String scannerSettings = 'Security_Scan_Settings_oOlOo_v4'; 
    	if (Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.fields.Id.isAccessible() && Schema.sObjectType.Attachment.fields.Description.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible()){
    		Attachment lstatt = [Select Id,Description,Body from Attachment where Description = :scannerSettings LIMIT 1];
    		return EncodingUtil.base64Encode(lstatt.Body);
    	}
    	return null;
    }
    
    @RemoteAction
    public static String xcreateFuzzedSObjects()
	{
	Transient String FuzzedObjsnames = '[{"name":"SecurityFuzzer","id":"oOlOo"}]';
    Transient String custObjName = 'Security_Scan_oOlOo_v6';
    
    Case SecurityScanCase = new Case();
    SecurityScanCase.SuppliedName = custObjName;
    SecurityScanCase.Subject = 'Security Fuzzed Objects';
    if(Schema.sObjectType.Case.isCreateable())
    {
    insert SecurityScanCase;
    } 
    Attachment SecurityAttachment = new Attachment();
   	SecurityAttachment.Body = Blob.valueOf(FuzzedObjsnames);
    SecurityAttachment.Description = custObjName;
    SecurityAttachment.Name = 'Security Fuzzed Objects';
    SecurityAttachment.ParentId = SecurityScanCase.Id;
    if(Schema.sObjectType.Attachment.isCreateable())
    {
    insert SecurityAttachment;
    }
    return '0';
	}    
         
    @RemoteAction
    public static String createFuzzedSObjects()
    {
		    
		    
		    List<String> objectstoFuzz  = new List<String> {'Cases','Accounts','Assets','Campaigns','CaseComments','CollaborationGroups','Contacts','Events','Leads','Opportunitys','Pricebook2s','Product2s','Tasks'};
		    List<String> payloads = new List<String> {'\'\';alert(\'oOlOo1\')','\';alert(\'oOlOo2\');//',';alert(\'oOlOo3\');//','*/\';alert(\'oOlOo4\'); /*','*/alert(\'oOlOo5\'); /*','%0A%0D\';alert(\'oOlOo6\');','" onload="alert(\'oOlOo7\')"><!--;','<img src="" onerror="alert(\'oOlOo8\');" /><!--','<script>alert(\'oOlOo9\');</script><!--','"><script>alert(\'oOlOo10\');</script><!--','"></textarea><script>alert(\'oOlOo11\');</script><!--','<img src="javascript:alert(\'oOlOo12\');">','<<SCRIPT>alert(\'oOlOo13\');//<</SCRIPT>','\\";alert(\'oOlOo14\');//','\\\';alert(\'oOlOo15\');//',' BACKGROUND="javascript:alert(\'oOlOo16\')"','<BASE HREF="javascript:alert(\'oOlOo17\');//">','"";alert(\'oOlOo18\')','";alert(\'oOlOo19\')//','";alert(\'oOlOo20\');//','*/";alert(\'oOlOo21\'); /*','*/alert(\'oOlOo22\'); /*','%0A%0D";alert(\'oOlOo23\');',' onload="alert(\'oOlOo24\')"><!--;','<img src="" onerror="alert(\'oOlOo25\');" /><!--','<script>alert(\'oOlOo26\');</script><!--','><script>alert(\'oOlOo27\');</script><!--','></textarea><script>alert(\'oOlOo28\');</script><!--','<img src="javascript:alert(\'oOlOo29\');">','<<SCRIPT>alert(\'oOlOo30\');//<</SCRIPT>','\\\';alert(\'oOlOo31\');//','\\";alert(\'oOlOo32\');//',' BACKGROUND="javascript:alert(\'oOlOo33\')"','<BASE HREF="javascript:alert(\'oOlOo34\');//">'};
		    List<Case> fizzCases= new List<Case>();
		    List<Account> fizzAccounts= new List<Account>();
		    List<Asset> fizzAssets= new List<Asset>();
		    List<Campaign> fizzCampaigns= new List<Campaign>();
		    List<CaseComment> fizzCaseComments= new List<CaseComment>();
		    List<Contact> fizzContacts= new List<Contact>();
		    List<Event> fizzEvents= new List<Event>(); 
		    List<Lead> fizzLeads= new List<Lead>();
		    List<Opportunity> fizzOpportunitys= new List<Opportunity>();
		    List<Pricebook2> fizzPricebook2s= new List<Pricebook2>();
		    List<Product2> fizzProduct2s= new List<Product2>();
		    List<Task> fizzTasks= new List<Task>();
		    List<String> customfields  = new List<String> {'Typeid__c', 'Objectid__c'};//,'Payload__c','URL__c'}; 
		    String custObjName = 'Security_Scan_oOlOo_v6';
		    Transient String FuzzedObjsnames ='';
		    Transient String fuzzedObjects ='';
		    List<Attachment> checkCase;
		    
		    return 'success';
		    
		    if (Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.fields.Id.isAccessible() && Schema.sObjectType.Attachment.fields.Description.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible())
    		{
		checkCase = [Select Id,Description,Body from Attachment where Description = 'Security_Scan_oOlOo_v6' LIMIT 1];     
	if(checkCase.size() <1 ){
 	
		        }   
		        else
		        {
		        	if(checkHeapSize()){
		        		FuzzedObjsnames =  checkCase[0].Body.toString().replace(']', ',');
		        	}
		        }
    		}
	
        try
        {
    		    Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Account TempFuzzAccount = new Account();
                TempFuzzAccount.Description = 'SecurityTesting';
                TempFuzzAccount.ShippingStreet= 'SecurityTesting';
                TempFuzzAccount.Name= 'SecurityTesting';
        if(Schema.sObjectType.Account.isCreateable()
                &&  Schema.sObjectType.Account.fields.Description.isCreateable()
                &&  Schema.sObjectType.Account.fields.BillingCountry.isCreateable()
                &&  Schema.sObjectType.Account.fields.BillingState.isCreateable()
                &&  Schema.sObjectType.Account.fields.ShippingStreet.isCreateable()
                &&  Schema.sObjectType.Account.fields.ShippingState.isCreateable()
                &&  Schema.sObjectType.Account.fields.ShippingCountry.isCreateable()
                &&  Schema.sObjectType.Account.fields.Name.isCreateable()
          ){
          	//Database.SaveResult result = Database.Insert(TempFuzzAccount, false);
            insert TempFuzzAccount;
          }
        	
        	
                
                Case TempFuzzcase = new Case();
                TempFuzzcase.Subject = 'SecurityTesting';
                TempFuzzcase.Description = 'SecurityTesting';
                TempFuzzcase.SuppliedName = 'SecurityTesting';
                if('SecurityTesting'.length() < 40)
                {
                TempFuzzcase.Origin = 'SecurityTesting';
                TempFuzzcase.Reason = 'SecurityTesting';
                
                TempFuzzcase.SuppliedPhone = 'SecurityTesting';
                TempFuzzcase.SuppliedCompany = 'SecurityTesting';
                }
                
                if(Schema.sObjectType.Case.isCreateable() && Schema.sObjectType.Case.fields.Subject.isCreateable() &&
                 Schema.sObjectType.Case.fields.Description.isCreateable()
                 && Schema.sObjectType.Case.fields.SuppliedName.isCreateable()
                 && Schema.sObjectType.Case.fields.Origin.isCreateable()
                 && Schema.sObjectType.Case.fields.Reason.isCreateable()
                 && Schema.sObjectType.Case.fields.SuppliedPhone.isCreateable()
                 && Schema.sObjectType.Case.fields.SuppliedCompany.isCreateable())
                {
                    insert TempFuzzcase;
                }
        
        try{
        FuzzedObjsnames = '[';
    for(String payl: payloads)
    {
    	
    			
                //Case Creation
                Case Fuzzcase = new Case();
                Fuzzcase.Subject = payl;
                Fuzzcase.Description = payl;
                Fuzzcase.SuppliedName = payl;
                if(payl.length() < 40)
                {
                Fuzzcase.Origin = payl;
                Fuzzcase.Reason = payl;
                
                Fuzzcase.SuppliedPhone = payl;
                Fuzzcase.SuppliedCompany = payl;
                }
                
                fizzCases.add(Fuzzcase);
                
                
        
                //Account Creation
        
                Account FuzzAccount = new Account();
                FuzzAccount.Description = payl;
              //  FuzzAccount.BillingCountry = 'US';
              //  FuzzAccount.BillingState= 'WA';
                FuzzAccount.ShippingStreet= payl;
              //  FuzzAccount.ShippingState= 'WA';
              //  FuzzAccount.ShippingCountry= 'US';
                FuzzAccount.Name= payl;
                
                if(payl.length() < 40)
                {
                FuzzAccount.AccountNumber = payl;
                FuzzAccount.BillingCity = 'Seattle';
                FuzzAccount.BillingStreet = payl;
                FuzzAccount.Fax = payl;
                FuzzAccount.Phone = payl;
                FuzzAccount.ShippingCity = payl;
                }
                fizzAccounts.add(FuzzAccount);      
                
                //Asset Creation
                Asset FuzzAsset = new Asset();
                FuzzAsset.Description = payl;
                FuzzAsset.Name = payl;
                FuzzAsset.AccountId = TempFuzzAccount.Id;
                
                if(payl.length() < 40)
                {
                FuzzAsset.SerialNumber = payl;
                }
                fizzAssets.add(FuzzAsset);
                
                //Campaign Creation
                Campaign FuzzCampaign = new Campaign();
                FuzzCampaign.Description = payl;
                FuzzCampaign.Name = payl;
                if(payl.length() < 40)
                {
                }
                fizzCampaigns.add(FuzzCampaign);
                    
                // CaseComment Creation
                CaseComment FuzzCaseComment = new CaseComment();
                FuzzCaseComment.CommentBody = payl;
                FuzzCaseComment.ParentId = TempFuzzcase.Id;
                if(payl.length() < 40)
                {
                }
                fizzCaseComments.add(FuzzCaseComment);
                
                
                
                
                //Contact Creation
                Contact FuzzContact = new Contact();
                
                FuzzContact.Description = payl;
                FuzzContact.Department = payl;
                FuzzContact.LastName= payl;
                FuzzContact.MailingStreet= payl;
                FuzzContact.OtherStreet= payl;
                FuzzContact.Title= payl;
                
                if(payl.length() < 40)
                {
                    FuzzContact.FirstName = payl;
                    FuzzContact.AssistantName = payl;
                }
                fizzContacts.add(FuzzContact);          
                
                
                //Event Creation
                Event FuzzEvent = new Event();
                FuzzEvent.Description = payl;
                FuzzEvent.Location = payl;
                FuzzEvent.Subject = payl;
                FuzzEvent.DurationInMinutes = 23;
                FuzzEvent.ActivityDate = Date.today();
                FuzzEvent.ActivityDateTime = DateTime.now();
                if(payl.length() < 40)
                {
                }
                fizzEvents.add(FuzzEvent);
                
                //Lead Creation
                Lead FuzzLead = new Lead();
                FuzzLead.Company = payl;
                FuzzLead.Country = payl;
                FuzzLead.Description = payl;
                FuzzLead.LastName= payl;
                FuzzLead.Street= payl;
                FuzzLead.Title= payl;
                
                if(payl.length() < 40)
                {
                FuzzLead.FirstName= payl;
                FuzzLead.City = payl;
                }
                fizzLeads.add(FuzzLead);
                
                
                //Opportunity Creation
                Opportunity FuzzOpportunity = new Opportunity();
                FuzzOpportunity.Description = payl;
                FuzzOpportunity.Name = payl;
                FuzzOpportunity.NextStep = payl;
                FuzzOpportunity.StageName = 'Introducted';
                FuzzOpportunity.CloseDate = Date.today();
                
                if(payl.length() < 40)
                {
                }
                fizzOpportunitys.add(FuzzOpportunity);
                
                //Pricebook2 Creation
                
                Pricebook2 FuzzPricebook2 = new Pricebook2();
                FuzzPricebook2.Name = payl;
                FuzzPricebook2.Description = payl;
                
                if(payl.length() < 40)
                {
                }
                fizzPricebook2s.add(FuzzPricebook2);
                //Product2 Creation
                
                Product2 FuzzProduct2 = new Product2();
                FuzzProduct2.Name = payl;
                FuzzProduct2.Description = payl;
                
                if(payl.length() < 40)
                {
                }
                fizzProduct2s.add(FuzzProduct2);
                
                //Task Creation
                Task FuzzTask = new Task();
                FuzzTask.CallDisposition = payl;
                FuzzTask.Description = payl;
                FuzzTask.CallObject = payl;
                FuzzTask.Subject =payl;
                FuzzTask.Priority = 'High';
                FuzzTask.Status = 'Closed';
                if(payl.length() < 40)
                {
                }
                fizzTasks.add(FuzzTask);
                
        
    }
    
    }catch(Exception ex){ /*return ex.getMessage();*/}

	try{
    //do the inserts and create the JSON object
    if(Schema.sObjectType.Case.isCreateable()
    && Schema.sObjectType.Case.fields.Subject.isCreateable() 
    && Schema.sObjectType.Case.fields.Description.isCreateable()
    && Schema.sObjectType.Case.fields.SuppliedName.isCreateable()
    && Schema.sObjectType.Case.fields.Origin.isCreateable()
    && Schema.sObjectType.Case.fields.Reason.isCreateable()
    && Schema.sObjectType.Case.fields.SuppliedPhone.isCreateable()
    && Schema.sObjectType.Case.fields.SuppliedCompany.isCreateable())
    {
        insert fizzCases;
        for(Case fCase: fizzCases)
        {
            FuzzedObjsnames = FuzzedObjsnames + '{"name":"Case","id":"'+ EncodingUtil.urlEncode(fCase.Id, 'UTF-8')  +'"},';
        }
    }
    }catch(Exception ex){}
    try{
    if(Schema.sObjectType.Account.isCreateable()
    &&  Schema.sObjectType.Account.fields.Description.isCreateable()
    &&  Schema.sObjectType.Account.fields.BillingCountry.isCreateable()
    &&  Schema.sObjectType.Account.fields.BillingState.isCreateable()
    &&  Schema.sObjectType.Account.fields.ShippingStreet.isCreateable()
    &&  Schema.sObjectType.Account.fields.ShippingState.isCreateable()
    &&  Schema.sObjectType.Account.fields.ShippingCountry.isCreateable()
    &&  Schema.sObjectType.Account.fields.Name.isCreateable()
    &&  Schema.sObjectType.Account.fields.AccountNumber.isCreateable()
    &&  Schema.sObjectType.Account.fields.BillingCity.isCreateable()
    &&  Schema.sObjectType.Account.fields.BillingStreet.isCreateable()
    &&  Schema.sObjectType.Account.fields.Fax.isCreateable()
    &&  Schema.sObjectType.Account.fields.Phone.isCreateable()
    &&  Schema.sObjectType.Account.fields.ShippingCity.isCreateable())
    {
            insert fizzAccounts;
            for(Account fAccount: fizzAccounts)
            {
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"Account","id":"'+ EncodingUtil.urlEncode(fAccount.Id, 'UTF-8')  +'"},';
            }
    }
    }catch(Exception ex){}
    try
    {
    if(Schema.sObjectType.Asset.isCreateable() 
    &&Schema.sObjectType.Asset.fields.Description.isCreateable() 
    &&Schema.sObjectType.Asset.fields.Name.isCreateable() 
    &&Schema.sObjectType.Asset.fields.AccountId.isCreateable() 
    &&Schema.sObjectType.Asset.fields.SerialNumber.isCreateable())
    {
                insert fizzAssets;
                for(Asset fAsset: fizzAssets)
                {
                    FuzzedObjsnames = FuzzedObjsnames + '{"name":"Asset","id":"'+ EncodingUtil.urlEncode(fAsset.Id, 'UTF-8')  +'"},';
                }
                
    }
    }catch(Exception ex){}
    try
    {
    if(Schema.sObjectType.Campaign.isCreateable()
    && Schema.sObjectType.Campaign.fields.Description.isCreateable() 
    && Schema.sObjectType.Campaign.fields.Name.isCreateable())
    {
                insert fizzCampaigns;
                for(Campaign fCampaign: fizzCampaigns)
                {
                    FuzzedObjsnames = FuzzedObjsnames + '{"name":"Campaign","id":"'+ EncodingUtil.urlEncode(fCampaign.Id, 'UTF-8')  +'"},';
                }
                
    }
    }catch(Exception ex){}
    try
    {
    if(Schema.sObjectType.CaseComment.isCreateable()
    && Schema.sObjectType.CaseComment.fields.CommentBody.isCreateable() 
    && Schema.sObjectType.CaseComment.fields.ParentId.isCreateable())
    {
                insert fizzCaseComments;
                for(CaseComment fCaseComment: fizzCaseComments)
                {
                    FuzzedObjsnames = FuzzedObjsnames + '{"name":"CaseComment","id":"'+ EncodingUtil.urlEncode(fCaseComment.Id, 'UTF-8')  +'"},';
                }
    }
    }catch(Exception ex){}
    try
    {   
    if(Schema.sObjectType.Contact.isCreateable()
    &&Schema.sObjectType.Contact.fields.Description.isCreateable() 
    &&Schema.sObjectType.Contact.fields.Department.isCreateable() 
    &&Schema.sObjectType.Contact.fields.LastName.isCreateable() 
    &&Schema.sObjectType.Contact.fields.MailingStreet.isCreateable() 
    &&Schema.sObjectType.Contact.fields.OtherStreet.isCreateable() 
    &&Schema.sObjectType.Contact.fields.Title.isCreateable() 
    &&Schema.sObjectType.Contact.fields.FirstName.isCreateable() 
    &&Schema.sObjectType.Contact.fields.AssistantName.isCreateable())
    {
                insert fizzContacts;
                for(Contact fContact: fizzContacts)
                {           
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"Contact","id":"'+ EncodingUtil.urlEncode(fContact.Id, 'UTF-8')  +'"},';
                }
    }
    }catch(Exception ex){/*return ex.getMessage();*/}
    
    try
    {
    if(Schema.sObjectType.Event.isCreateable()
    &&Schema.sObjectType.Event.fields.Description.isCreateable() 
    &&Schema.sObjectType.Event.fields.Location.isCreateable() 
    &&Schema.sObjectType.Event.fields.Subject.isCreateable() 
    &&Schema.sObjectType.Event.fields.DurationInMinutes.isCreateable() 
    &&Schema.sObjectType.Event.fields.ActivityDate.isCreateable()
    &&Schema.sObjectType.Event.fields.ActivityDateTime.isCreateable())
    {
                insert fizzEvents;
                for(Event fEvent: fizzEvents)
                {
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"Event","id":"'+ EncodingUtil.urlEncode(fEvent.Id, 'UTF-8')  +'"},';
                }
    }
       }catch(Exception ex){/*return ex.getMessage();*/}
       try
       {         
    if(Schema.sObjectType.Lead.isCreateable()
    &&Schema.sObjectType.Lead.fields.Company.isCreateable() 
    &&Schema.sObjectType.Lead.fields.Country.isCreateable() 
    &&Schema.sObjectType.Lead.fields.Description.isCreateable() 
    &&Schema.sObjectType.Lead.fields.LastName.isCreateable() 
    &&Schema.sObjectType.Lead.fields.Street.isCreateable() 
    &&Schema.sObjectType.Lead.fields.Title.isCreateable() 
    &&Schema.sObjectType.Lead.fields.FirstName.isCreateable() 
    &&Schema.sObjectType.Lead.fields.City.isCreateable())
    {
                insert fizzLeads;
                for(Lead fLead: fizzLeads)
                {
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"Lead","id":"'+ EncodingUtil.urlEncode(fLead.Id, 'UTF-8')  +'"},';
                }
    }
    }catch(Exception ex){/*return ex.getMessage();*/}
    
    try
    {
    if(Schema.sObjectType.Opportunity.isCreateable()
    &&Schema.sObjectType.Opportunity.fields.Description.isCreateable() 
    &&Schema.sObjectType.Opportunity.fields.Name.isCreateable() 
    &&Schema.sObjectType.Opportunity.fields.NextStep.isCreateable() 
    &&Schema.sObjectType.Opportunity.fields.StageName.isCreateable() 
    &&Schema.sObjectType.Opportunity.fields.CloseDate.isCreateable())
    {
                insert fizzOpportunitys;
                for(Opportunity fOpportunity: fizzOpportunitys)
                {
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"Opportunity","id":"'+ EncodingUtil.urlEncode(fOpportunity.Id, 'UTF-8')  +'"},';
                }
    }
    }catch(Exception ex){/*return ex.getMessage();*/}
    try
    {
    if(Schema.sObjectType.Pricebook2.isCreateable()
    &&Schema.sObjectType.Pricebook2.fields.Name.isCreateable() 
    &&Schema.sObjectType.Pricebook2.fields.Description.isCreateable())
    {
                insert fizzPricebook2s;
                for(Pricebook2 fPricebook2: fizzPricebook2s)
                {
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"Pricebook2","id":"'+ EncodingUtil.urlEncode(fPricebook2.Id, 'UTF-8')  +'"},';
                }
    }
    }catch(Exception ex){/*return ex.getMessage();*/}
    
    try
    {
    if(Schema.sObjectType.Product2.isCreateable()
    &&Schema.sObjectType.Product2.fields.Name.isCreateable()
    &&Schema.sObjectType.Product2.fields.Description.isCreateable())
    {
                insert fizzProduct2s;
                for(Product2 fProduct2: fizzProduct2s)
                {
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"Product2","id":"'+ EncodingUtil.urlEncode(fProduct2.Id, 'UTF-8')  +'"},';
                }
    }
    }catch(Exception ex){/*return ex.getMessage();*/}
    try
    {
    if(Schema.sObjectType.Task.isCreateable()
    &&Schema.sObjectType.Task.fields.CallDisposition.isCreateable() 
    &&Schema.sObjectType.Task.fields.Description.isCreateable() 
    &&Schema.sObjectType.Task.fields.CallObject.isCreateable() 
    &&Schema.sObjectType.Task.fields.Subject.isCreateable() 
    &&Schema.sObjectType.Task.fields.Priority.isCreateable() 
    &&Schema.sObjectType.Task.fields.Status.isCreateable())
    {
                
                insert fizzTasks;
                for(Task fTask: fizzTasks){
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"Task","id":"'+ EncodingUtil.urlEncode(fTask.Id, 'UTF-8')  +'"},';
                }
    }
//
}catch(Exception ex){/*return ex.getMessage();*/}

    
    FuzzedObjsnames = FuzzedObjsnames.replace(']', ',') +'{"name":"SecurityFuzzer","id":"oOlOo"}]';
    
    Case SecurityScanCase = new Case();
    SecurityScanCase.SuppliedName = custObjName;
    SecurityScanCase.Subject = 'Security Fuzzed Objects';
    if(Schema.sObjectType.Case.isCreateable())
    {
    insert SecurityScanCase;
    
    }
    
    
    checkCase[0].Body = Blob.valueOf(FuzzedObjsnames.replace(']', ',') + '{"name":"SecurityFuzzer","id":"oOlOo4"}]');
    if(Schema.sObjectType.Attachment.isUpdateable())
    {
    update checkCase;
    }
    	

       
    }catch(Exception ex){
    	
    	//	throw ex;
           // RemoteSiteError = ex.getMessage();
            FuzzedObjsnames = '[{"name":"SecurityFuzzer","id":"oOlOo"}]';
    
    
    Case SecurityScanCase = new Case();
    SecurityScanCase.SuppliedName = custObjName;
    SecurityScanCase.Subject = 'Security Fuzzed Objects';
    if(Schema.sObjectType.Case.isCreateable())
    {
    insert SecurityScanCase;
    } 
    Attachment SecurityAttachment = new Attachment();
   	SecurityAttachment.Body = Blob.valueOf(FuzzedObjsnames);
    SecurityAttachment.Description = custObjName;
    SecurityAttachment.Name = 'Security Fuzzed Objects';
    SecurityAttachment.ParentId = SecurityScanCase.Id;
    if(Schema.sObjectType.Attachment.isCreateable())
    {
    insert SecurityAttachment;
    }
    return ex.getMessage();
        }
    return 'success';
    }

@RemoteAction
public static Integer generatecustomFuzzObjects(Integer offset, Integer cnt)
{

    //offset = 0;
    //cnt = 20; 
    //
    Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    List<String> entities = new List<String>(schemaMap.keySet());
    entities.sort();
	
	return 0;
    Integer current = offset;
    String custObjName = 'Security_Scan_oOlOo_v6';
    Integer result = 0;
    Transient List<String> payloads = new List<String> {'\'\';alert(\'oOlOo1\')','\';alert(\'oOlOo2\');//',';alert(\'oOlOo3\');//','*/\';alert(\'oOlOo4\'); /*','*/alert(\'oOlOo5\'); /*','%0A%0D\';alert(\'oOlOo6\');','" onload="alert(\'oOlOo7\')"><!--;','<img src="" onerror="alert(\'oOlOo8\');" /><!--','<script>alert(\'oOlOo9\');</script><!--','"><script>alert(\'oOlOo10\');</script><!--','"></textarea><script>alert(\'oOlOo11\');</script><!--','<img src="javascript:alert(\'oOlOo12\');">','<<SCRIPT>alert(\'oOlOo13\');//<</SCRIPT>','\\";alert(\'oOlOo14\');//','\\\';alert(\'oOlOo15\');//',' BACKGROUND="javascript:alert(\'oOlOo16\')"','<BASE HREF="javascript:alert(\'oOlOo17\');//">','"";alert(\'oOlOo18\')','";alert(\'oOlOo19\')//','";alert(\'oOlOo20\');//','*/";alert(\'oOlOo21\'); /*','*/alert(\'oOlOo22\'); /*','%0A%0D";alert(\'oOlOo23\');',' onload="alert(\'oOlOo24\')"><!--;','<img src="" onerror="alert(\'oOlOo25\');" /><!--','<script>alert(\'oOlOo26\');</script><!--','><script>alert(\'oOlOo27\');</script><!--','></textarea><script>alert(\'oOlOo28\');</script><!--','<img src="javascript:alert(\'oOlOo29\');">','<<SCRIPT>alert(\'oOlOo30\');//<</SCRIPT>','\\\';alert(\'oOlOo31\');//','\\";alert(\'oOlOo32\');//',' BACKGROUND="javascript:alert(\'oOlOo33\')"','<BASE HREF="javascript:alert(\'oOlOo34\');//">'};
    Transient String FuzzedObjsnames = '[';
    
    if (Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.fields.Id.isAccessible() && Schema.sObjectType.Attachment.fields.Description.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible())
            {
    List<Attachment> checkCase = [Select Id,Description,Body from Attachment where Description = 'Security_Scan_oOlOo_v6' LIMIT 1];     
    if(checkCase.size() <1 ){
    
                }   
                else
                {
                    if(checkHeapSize()){
                        FuzzedObjsnames =  checkCase[0].Body.toString().replace(']', ',');
                    }
                }
    try
    {


for(Integer a = offset;a < cnt; a++){
current = a;
if(a < entities.size())
{
String name = entities[a];
if(name.contains('__c'))
{

List<Schema.SObjectfield> fieldnames = new List<Schema.SObjectfield>();
List<sObject> lts = new List<sObject>();
Integer containsStrings = 0;
Map <String, Schema.SObjectField> fieldMap = schemaMap.get(name).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
        schema.describefieldresult dfield = sfield.getDescribe();
            if(dfield.getType() == Schema.DisplayType.STRING && dfield.getLength() > 50 && dfield.isCreateable() )
            {
                containsStrings =1;
                fieldnames.add(dfield.getSobjectField());
                }
        
        }
        if(containsStrings==1){
        for(String payl: payloads)
        {
        sObject xsa = schemaMap.get(name).newSObject();
        for(Schema.SObjectfield fname: fieldnames)
        {
            xsa.put(fname, payl);
        }
        lts.add(xsa);
        }
        }
        Schema.DescribeSObjectResult sr = schemaMap.get(name).getDescribe();
        if(sr.isCreateable())
        {
            
            insert lts;
            for(sObject nm: lts)
            {
                FuzzedObjsnames = FuzzedObjsnames + '{"name":"'+name+'","id":"'+ EncodingUtil.urlEncode(nm.Id, 'UTF-8')  +'"},';
            }
        
        }
}
}
}
if(current >= entities.size())
    {
    result = 0;
    }
    else
    {
    result = current+1;
    }
    }
     catch(Exception ex)
    {
    if(current >= entities.size())
    {
    result = 0;
    }
    else
    {
    result = current+1;
    }
    FuzzedObjsnames = FuzzedObjsnames.replace(']', ',') +'{"name":"SecurityFuzzer","id":"oOlOo6"}]';
    
if(checkCase.size() < 1)
    {
    Case SecurityScanCase = new Case();
    SecurityScanCase.SuppliedName = custObjName;
    SecurityScanCase.Subject = 'Security Fuzzed Objects';
    if(Schema.sObjectType.Case.isCreateable())
    {
    insert SecurityScanCase;
    
    }
    
    Attachment SecurityAttachment = new Attachment();
    SecurityAttachment.Body = Blob.valueOf('[{"name":"SecurityFuzzer","id":"oOlOo5"}]');
    SecurityAttachment.Description = custObjName;
    SecurityAttachment.Name = 'Security Fuzzed Objects';
    SecurityAttachment.ParentId = SecurityScanCase.Id;
    if(Schema.sObjectType.Attachment.isCreateable())
    {
    insert SecurityAttachment;
    
    }
    }
    else
    {
        
    checkCase[0].Body = Blob.valueOf(FuzzedObjsnames.replace(']', ',') + '{"name":"SecurityFuzzer","id":"oOlOo4"}]');  
    if(Schema.sObjectType.Attachment.isUpdateable())
    {
    update checkCase;
    }
    }       
    }
    if(result == 0){
    FuzzedObjsnames = FuzzedObjsnames.replace(']', ',') +'{"name":"SecurityFuzzer","id":"oOlOo3"}]';
    }
    if(checkCase.size() < 1)
    {
        Case SecurityScanCase = new Case();
    SecurityScanCase.SuppliedName = custObjName;
    SecurityScanCase.Subject = 'Security Fuzzed Objects';
    if(Schema.sObjectType.Case.isCreateable())
    {
    insert SecurityScanCase;
    }
    
    Attachment SecurityAttachment = new Attachment();
    SecurityAttachment.Body = Blob.valueOf('[{"name":"SecurityFuzzer","id":"oOlOo2"}]');
    SecurityAttachment.Description = custObjName;
    SecurityAttachment.Name = 'Security Fuzzed Objects';
    SecurityAttachment.ParentId = SecurityScanCase.Id;
    if(Schema.sObjectType.Attachment.isCreateable())
    {
    insert SecurityAttachment;
    }
    }
    else
    {
    checkCase[0].Body = Blob.valueOf(FuzzedObjsnames.replace(']', ',') +'{"name":"SecurityFuzzer","id":"oOlOo1"}]');
    }
    if(Schema.sObjectType.Attachment.isUpdateable())
    {
    update checkCase;
    }
   }
   return result;
}
    
    @RemoteAction
    public static String deleteScan(ID scanID)
    {
    	if(Schema.sObjectType.Case.isDeletable() && Schema.sObjectType.Case.isAccessible()){
        Case casedel = [Select Id,Description from Case where ID = :scanID];
        List<Case> vulnsdel = [Select Id,Description from Case where parentId = :scanID];
            delete vulnsdel;
            delete casedel; 
            return scanID;
        }
        else{
            return 'failure';
        }
    }
    @RemoteAction
    public static List<AuraDefinition> getAuraBundles()
    {
    /*	try
    	{
    		if(Schema.sObjectType.AuraDefinition.isAccessible())
    		{
    			return [SELECT AuraDefinitionBundleId, Id, Source, DefType FROM AuraDefinition LIMIT 20];
    		}
    	}
    	catch(Exception ex)
    	{
    		return null;
    	}*/
    	return null;
    }
    @RemoteAction
    public static List<AuraDefinitionBundle> getAuraComponents(String off, String xlim)
    {
    /*	try
    	{	Integer offset = Integer.valueOf(off);
    		Integer xlimit = Integer.valueOf(xlim);
    		if(Schema.sObjectType.AuraDefinitionBundle.isAccessible())
    		{
    		//return [SELECT Id,MasterLabel,NamespacePrefix FROM AuraDefinitionBundle LIMIT :xlimit OFFSET :offset];
    		return [SELECT Id,MasterLabel,NamespacePrefix FROM AuraDefinitionBundle LIMIT 20];
    		

    		}
    	}
    		catch(Exception ex)
    		{
    			return null;
    		}*/
    		return null;
    }
    		
    
    @RemoteAction
    public static String logVulns(String vulns, String caseId, String done, String offset) {
        try
        {
        	        	
        String returnurl = '';
       
    String[] remediationguidance = new String[] {'nothing','We recommend the following to prevent or mitigate the effects of SOQL injection: \n\t1. Do not use dynamic SOQL queries with Database.query() function.\n\t 2. Use prepared statements like [Select Id from Account where id = :accountid];\n\t3. If you must use dynamic SOQL, use the escapeSingleQuotes method to sanitize user-supplied input.\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_security_tips_soql_injection.htm \n\t',
    'We recommend the following to prevent against authorization bypass:\n\t1. Implement access control checks such as isAccessible() prior to Select, isCreateable() prior to insert, isUpdateable() prior to update, isDeleteable() prior to delete as shown below: \n\t\t if(Schema.sObjectType.Case.isCreateable())\n\t\t{\n\t\tinsert SecurityScanCase;\n\t\t}\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_security_tips_data_access_control.htm \n\t',
    'We recommend the following to prevent against cross-site scripting:\n\t1. Implement calls to appropriate encoding function prior to rending any user controlled input, such as:\n\t\t {!HTMLENCODE($Request.title)} or JSENCODE() or JSINHTMLENCODE() or URLENCODE()\n\t2. Set escape="true" for all apex: output tags\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_security_tips_xss.htm \n\t ',
    'We recommend the following to address weak passwords:\n\t1. Go to Security Controls > Password Policies and set the password to require a mix alpha, numeric, and special characters.\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against persistent or stored cross-site scripting:\n\t1. Implement calls to appropriate encoding function prior to rending any user controlled input, such as:\n\t\t {!HTMLENCODE($Request.title)} or JSENCODE() or JSINHTMLENCODE() or URLENCODE()\n\t2. Set escape="true" for all apex: output tags\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_security_tips_xss.htm \n\t ',
    'We recommend the following to address weak passwords:\n\t1. Go to Security Controls > Password Policies and set the password expiration to sixty days\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to address weak passwords:\n\t1. Go to Security Controls > Password Policies and set the password history to remember last 3 or more passwords\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against brute force attacks:\n\t1. Go to Security Controls > Password Policies and set the account lockout time to 15 minutes (FifteenMinutes) due to failed login attempts\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against brute force attacks:\n\t1. Go to Security Controls > Password Policies and set the maximum invalid login attempts to 10 attempts (TenAttempts) or less\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against brute force attacks:\n\t1. Go to Security Controls > Password Policies and set the minimum password length to 10 characters\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against weak authentication:\n\t1. Go to Security Controls > Password Policies and set the Password question requirement to Cannot contain password\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against cross site request forgery(CSRF) attacks:\n\t1. Go to Security Controls > Session Settings and select Enable CSRF protection on GET requests on non-setup pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against cross site request forgery(CSRF) attacks:\n\t1. Go to Security Controls > Session Settings and select Enable CSRF protection on POST requests on non-setup pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against click jacking attacks:\n\t1. Go to Security Controls > Session Settings and select Enable clickjack protection for setup pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against click jacking attacks:\n\t1. Go to Security Controls > Session Settings and select Enable clickjack protection for non-setup Salesforce pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against click jacking attacks:\n\t1. Go to Security Controls > Session Settings and select Enable clickjack protection for non-setup customer Visualforce pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent an inactive session from being misused:\n\t1. Go to Security Controls > Session Settings and select 2 hours or less from the drop down\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent caching of sensitive data:\n\t1. Go to Security Controls > Session Settings and de-select(uncheck) Enable caching and password autocomplete on login page\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against the use of instanceof :\n\t1. Use built in JavaScript or Lightning components utility functions.\n\n\t For example:\n\t Array.isArray(foo) or $A.util.isPlainObject(foo) \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/cli_rules_no_instanceof.htm',
	'We recommend the following to prevent against use of Aura API:\n\t1. Remove all instance that use Aura API directly and use $A instead. \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/cli_rules_aura_api.htm',
	'We recommend the following to prevent against insecure usage of document object:\n\t1. Use the Aura secure-documents object methods only\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/cli_rules_secure_document.htm',
	'We recommend the following to prevent against insecure usage of window object:\n\t1. Use the Aura secure-window object methods only\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/cli_rules_secure_window.htm',
	'We recommend the following to prevent against insecure API usage :\n\t1. Enable protocol security to ensure that HTTPS data is not shared with HTTP data and vice versa.\n\t2. Go to Setup > Security Controls > Remote Site Settings and select the vulnerable site and uncheck "Disable Protocol Security" \n\t\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_remotesitesetting.htm',
	'We recommend the following to prevent against using insecure HTTP APIs:\n\t1. Go to Setup > Security Controls > Remote Site Settings and change all HTTP API urls to HTTPS. \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_remotesitesetting.htm',
	'We recommend the following to prevent against using insecure HTTP CSPs:\n\t1. Go to Setup > Security Controls > CSP Trusted Sites and change all HTTP URLs urls to HTTPS. \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_csptrustedsite.htm',
	'We recommend the following to prevent against using insecure HTTP CORS:\n\t1. Go to Setup > Security Controls > CORS and change all HTTP URLs urls to HTTPS. \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_corswhitelistorigin.htm',
	'We recommend the following to prevent against data leakage:\n\t1. Review each of the APIs, URLs, and end points above to ensure that these are authorized vendors who need access to your environment. If you do not understand the type of data they access, then review these connections and the need to grant them access to your environment. Document these end points as external entities whose security should be reviewed as part of vendor assessments. \n\t\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_remotesitesetting.htm'

    };
    
    String[] impact = new String[] {'nothing','We recommend the following to prevent or mitigate the effects of SOQL injection: \n\t1. Do not use dynamic SOQL queries with Database.query() function.\n\t 2. Use prepared statements like [Select Id from Account where id = :accountid];\n\t3. If you must use dynamic SOQL, use the escapeSingleQuotes method to sanitize user-supplied input.\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_security_tips_soql_injection.htm \n\t',
    'We recommend the following to prevent against authorization bypass:\n\t1. Implement access control checks such as isAccessible() prior to Select, isCreateable() prior to insert, isUpdateable() prior to update, isDeleteable() prior to delete as shown below: \n\t\t if(Schema.sObjectType.Case.isCreateable())\n\t\t{\n\t\tinsert SecurityScanCase;\n\t\t}\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_security_tips_data_access_control.htm \n\t',
    'We recommend the following to prevent against cross-site scripting:\n\t1. Implement calls to appropriate encoding function prior to rending any user controlled input, such as:\n\t\t {!HTMLENCODE($Request.title)} or JSENCODE() or JSINHTMLENCODE() or URLENCODE()\n\t2. Set escape="true" for all apex: output tags\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_security_tips_xss.htm \n\t ',
    'We recommend the following to address weak passwords:\n\t1. Go to Security Controls > Password Policies and set the password to require a mix alpha, numeric, and special characters.\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against persistent or stored cross-site scripting:\n\t1. Implement calls to appropriate encoding function prior to rending any user controlled input, such as:\n\t\t {!HTMLENCODE($Request.title)} or JSENCODE() or JSINHTMLENCODE() or URLENCODE()\n\t2. Set escape="true" for all apex: output tags\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_security_tips_xss.htm \n\t ',
    'We recommend the following to address weak passwords:\n\t1. Go to Security Controls > Password Policies and set the password expiration to sixty days\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to address weak passwords:\n\t1. Go to Security Controls > Password Policies and set the password history to remember last 3 or more passwords\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against brute force attacks:\n\t1. Go to Security Controls > Password Policies and set the account lockout time to 15 minutes (FifteenMinutes) due to failed login attempts\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against brute force attacks:\n\t1. Go to Security Controls > Password Policies and set the maximum invalid login attempts to 10 attempts (TenAttempts) or less\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against brute force attacks:\n\t1. Go to Security Controls > Password Policies and set the minimum password length to 10 characters\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against weak authentication:\n\t1. Go to Security Controls > Password Policies and set the Password question requirement to Cannot contain password\n\t\n\n\t+Additional Resources: \n\thttps://help.salesforce.com/htviewhelpdoc?id=admin_password.htm&siteLang=en_US',
    'We recommend the following to prevent against cross site request forgery(CSRF) attacks:\n\t1. Go to Security Controls > Session Settings and select Enable CSRF protection on GET requests on non-setup pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against cross site request forgery(CSRF) attacks:\n\t1. Go to Security Controls > Session Settings and select Enable CSRF protection on POST requests on non-setup pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against click jacking attacks:\n\t1. Go to Security Controls > Session Settings and select Enable clickjack protection for setup pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against click jacking attacks:\n\t1. Go to Security Controls > Session Settings and select Enable clickjack protection for non-setup Salesforce pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against click jacking attacks:\n\t1. Go to Security Controls > Session Settings and select Enable clickjack protection for non-setup customer Visualforce pages\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent an inactive session from being misused:\n\t1. Go to Security Controls > Session Settings and select 2 hours or less from the drop down\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent caching of sensitive data:\n\t1. Go to Security Controls > Session Settings and de-select(uncheck) Enable caching and password autocomplete on login page\n\t\n\n\t+Additional Resources: \n\thttp://www.salesforce.com/us/developer/docs/securityImplGuide/Content/admin_sessions.htm',
    'We recommend the following to prevent against the use of instanceof :\n\t1. Use built in JavaScript or Lightning components utility functions.\n\n\t For example:\n\t Array.isArray(foo) or $A.util.isPlainObject(foo) \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/cli_rules_no_instanceof.htm',
	'We recommend the following to prevent against use of Aura API:\n\t1. Remove all instance that use Aura API directly and use $A instead. \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/cli_rules_aura_api.htm',
	'We recommend the following to prevent against insecure usage of document object:\n\t1. Use the Aura secure-documents object methods only\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/cli_rules_secure_document.htm',
	'We recommend the following to prevent against insecure usage of window object:\n\t1. Use the Aura secure-window object methods only\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/cli_rules_secure_window.htm',
	'We recommend the following to prevent against insecure API usage :\n\t1. Enable protocol security to ensure that HTTPS data is not shared with HTTP data and vice versa.\n\t2. Go to Setup > Security Controls > Remote Site Settings and select the vulnerable site and uncheck "Disable Protocol Security" \n\t\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_remotesitesetting.htm',
	'We recommend the following to prevent against using insecure HTTP APIs:\n\t1. Go to Setup > Security Controls > Remote Site Settings and change all HTTP API urls to HTTPS. \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_remotesitesetting.htm',
	'We recommend the following to prevent against using insecure HTTP CSPs:\n\t1. Go to Setup > Security Controls > CSP Trusted Sites and change all HTTP URLs urls to HTTPS. \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_csptrustedsite.htm',
	'We recommend the following to prevent against using insecure HTTP CORS:\n\t1. Go to Setup > Security Controls > CORS and change all HTTP URLs urls to HTTPS. \n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_corswhitelistorigin.htm',
	'We recommend the following to prevent against data leakage:\n\t1. Review each of the APIs, URLs, and end points above to ensure that these are authorized vendors who need access to your environment. If you do not understand the type of data they access, then review these connections and the need to grant them access to your environment. Document these end points as external entities whose security should be reviewed as part of vendor assessments. \n\t\n\n\t+Additional Resources: \n\thttps://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_remotesitesetting.htm'

    };
    if(caseId == '0')
    {
    DateTime d = datetime.now();
    String monthName= d.format('MMMMM');
    Integer cdate = Date.Today().Day();
    Integer year = Date.Today().Year();
    String formattedDt = d.format('hh:mm:ss');
    Case ScanCase = new Case();
        ScanCase.Subject = 'Security Scan on ' + monthName + ' ' + cdate + ' ' + year + ' @ ' + formattedDt; 
        ScanCase.Description = 'Security Scanner found issues';
        ScanCase.Origin = 'Security Scan';
        ScanCase.SuppliedName = 'SecScanResults_oOlOo';
        if(Schema.sObjectType.Case.isCreateable()
    && Schema.sObjectType.Case.fields.Subject.isCreateable() 
    && Schema.sObjectType.Case.fields.Description.isCreateable()
    && Schema.sObjectType.Case.fields.SuppliedName.isCreateable()
    && Schema.sObjectType.Case.fields.Origin.isCreateable()
    && Schema.sObjectType.Case.fields.Status.isCreateable()
    && Schema.sObjectType.Case.fields.Priority.isCreateable()
    && Schema.sObjectType.Case.fields.SuppliedCompany.isCreateable()){
        insert ScanCase; caseId =ScanCase.Id;}
    }
        String Title;
        String Vulnexploit;
        String JSONvulns = '{"vulnerabilities":'+vulns+'}';
        
        JSONParser parser = JSON.createParser(JSONvulns);
        List<Case> relatedVulns = new List<Case>();
        while (parser.nextToken() != null) {
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
        while (parser.nextToken() != null) {
        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
        Case cvulns = new Case();
        Vuln inv = (Vuln)parser.readValueAs(Vuln.class);
        cvulns.ParentId = caseId;
        cvulns.Subject = inv.exploit.abbreviate(252);
                    if(inv.url == 'NA'){
                        Title = '' + EncodingUtil.base64Decode(inv.code).toString() + '';
                    
                    }else{
                        Title = '' + EncodingUtil.base64Decode(inv.url).toString() + '';
                    
                    }
                    cvulns.Status = 'Active';
                    cvulns.Priority = inv.severity;
                    cvulns.SuppliedName =  inv.typed ;
                    cvulns.Description = Title; 
                    //cvulns.Type = inv.file;
                    cvulns.Origin = 'Security Scan';
                    relatedVulns.Add(cvulns);
                   
                    String s = JSON.serialize(inv);
                    Vulnexploit = Vulnexploit + s;
                    parser.skipChildren();
                }
            }
        }
    }
    if(Schema.sObjectType.Case.isCreateable()
    && Schema.sObjectType.Case.fields.Subject.isCreateable() 
    && Schema.sObjectType.Case.fields.Description.isCreateable()
    && Schema.sObjectType.Case.fields.SuppliedName.isCreateable()
    && Schema.sObjectType.Case.fields.Origin.isCreateable()
    && Schema.sObjectType.Case.fields.Priority.isCreateable()
    && Schema.sObjectType.Case.fields.Status.isCreateable()
    && Schema.sObjectType.Case.fields.SuppliedCompany.isCreateable())
    {
    insert relatedVulns;
    }
    List<CaseComment> lstvulncomment = new List<CaseComment>();
    List<CaseComment> lstvulnbackground  = new List<CaseComment>();
    for(Case cvs: relatedVulns)
    {
         CaseComment vulncomment = new CaseComment();
         vulncomment.ParentId = cvs.Id;
         vulncomment.CommentBody = remediationguidance[integer.valueof(cvs.SuppliedName)];
         lstvulncomment.Add(vulncomment);   
         
         CaseComment vulnimpact = new CaseComment();
         vulnimpact.ParentId = cvs.Id;
         vulnimpact.CommentBody = impact[integer.valueof(cvs.SuppliedName)];
         lstvulnbackground.Add(vulnimpact);  
             
        
    }
    if(Schema.sObjectType.CaseComment.isCreateable()){insert lstvulncomment; /*insert lstvulnbackground;*/}
    if(done == '1')
    {
    PageReference pr1 = Page.ScanDetails;
    String scanfileURL = pr1.getUrl();
    String userName = UserInfo.getUserName();
    if(Schema.sObjectType.User.isAccessible()){
            
        
    User activeUser = [Select Email From User where Username = :userName limit 1];
    String userEmail = activeUser.Email;
    String[] userEmails = new String[] {userEmail};                 
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('S4: Salesforce Security Scan Complete');
        email.setToAddresses(userEmails);
        email.setPlainTextBody('Review results here: ' + URL.getSalesforceBaseUrl().toExternalForm() + scanfileURL +'?id='+EncodingUtil.urlEncode(caseId, 'UTF-8'));
        email.setHtmlBody('<html><head></head><body style=""><div style="background-color: #CADBE4; margin-top: 5px; padding:10px; font-size: 22px; color: #666666;"  width="100%" height="40px;"> .SaaS Security Scanner for Salesforce (S4)</div><div style="background-color:#f0f0f0;" width="100%"><div style="font-family:  Helvetica; font-size: 14px; color: #333;text-align: center; height:130px;"><br><br> .Salesforce Security Scan Completed <br><span style="color:  #5a7b93;"><a href="' + URL.getSalesforceBaseUrl().toExternalForm() + scanfileURL +'?id='+EncodingUtil.urlEncode(caseId, 'UTF-8') +' "> View Results </a> <br><br>' +  URL.getSalesforceBaseUrl().toExternalForm() + scanfileURL +'?id='+EncodingUtil.urlEncode(caseId, 'UTF-8') +'</span><br><br><br></div></div><div align="center" width="100%"  style="font-family: Helvetica; font-size:11px; background-color: #CADBE4; padding:10px;"><a href="https://www.digitsec.com"  tabindex="0" style="text-decoration:none;">© DigitSec</a> </div><div style="font-family: Helvetica; margin-top: 5px; font-size: 11px; color:  #666666;" align="center">This email was generated by your Salesforce sandbox to notify you about the completion of a security scan.</div></div></body></html>');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        returnurl = URL.getSalesforceBaseUrl().toExternalForm() + scanfileURL +'?id='+EncodingUtil.urlEncode(caseId, 'UTF-8');
    }
    }
        return '{"caseId":"'+EncodingUtil.urlEncode(caseId, 'UTF-8')+'","offset":"'+EncodingUtil.urlEncode(offset, 'UTF-8')+'","returnurl":"'+returnurl+'"}';
        
        }
        catch(Exception ex)
        {
            return '! Failure : ' + ex.getMessage();
        } 
    }
    
    public String getReferer(){
    return ApexPages.currentPage().getHeaders().get('referer');
    }
    
    @RemoteAction
    public static String getFuzzedObjects()
    {
        try{
        	
			String fuzzedObjects = EncodingUtil.base64Encode(Blob.valueOf('[]'));
    		if (Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.fields.Id.isAccessible() && Schema.sObjectType.Attachment.fields.Description.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible())
    		{
		        List<Attachment> checkCase = [Select Id,Description,Body from Attachment where Description = 'Security_Scan_oOlOo_v6' LIMIT 1];     
		        if(checkCase.isEmpty()){
		        	
		        }   
		        else
		        {
		        	if(checkHeapSize()){
		        		fuzzedObjects = EncodingUtil.base64Encode(checkCase[0].Body);
		        	}
		        }
    		}
    		return fuzzedObjects;
        	
        }catch(Exception ex)
        {
        	return 'Failure ... ' + ex.getMessage();
        }
    }
    
    
    @RemoteAction
    public static List<ApexClass> listMetadataClasses()
    {
   
    		List<ApexClass> temp = new List<ApexClass>();
            Integer managedclass = 0;
            
            if(Schema.sObjectType.ApexClass.isAccessible() && Schema.sObjectType.Organization.isAccessible())
            {
                 if(checkHeapSize()){
                     Organization orx = [SELECT NamespacePrefix FROM Organization];
                return  [Select Id, Name from ApexClass Where Status = 'Active' and NamespacePrefix = :orx.NamespacePrefix LIMIT 10000];
                
                 }
            }

          return null;
    }

	@RemoteAction
    public static MetadataService.FileProperties[]  listMetadataVFPages()
    {
    	
    		
		String MetaDataFolder;
        // List Metadata items for the selected Metadata Type
        List<SelectOption> MetaDataItems = new List<SelectOption>();       
        MetadataService.MetadataPort service = createService();             
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
        MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
        queryLayout.folder = MetaDataFolder;
        queryLayout.type_x = 'ApexPage';
        queries.add(queryLayout);       
        return service.listMetadata(queries, 25);
    	
    	
        return null;
    }
    
    @RemoteAction
    public static String listMetadataItems()
    {
        try{
		String MetaDataFilenames = EncodingUtil.base64Encode(Blob.valueOf('[{}]'));
		String MetaDataFolder;
        // List Metadata items for the selected Metadata Type
        List<SelectOption> MetaDataItems = new List<SelectOption>();       
        MetadataService.MetadataPort service = createService();             
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
        MetadataService.ListMetadataQuery queryLayout = new MetadataService.ListMetadataQuery();
        queryLayout.folder = MetaDataFolder;
        queryLayout.type_x = 'ApexPage';
        queries.add(queryLayout);       
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        // Sort
        List<String> fullNames = new List<String>();
        if(fileProperties!=null)
        {
            MetaDataFilenames = '[';
            Integer i = 0;
            for(MetadataService.FileProperties fileProperty : fileProperties){
                i++;
                if(fileProperty.fullName != 'metadataretrieve')
                if(fileProperty.fullName != 'SecurityScan')
                if(fileProperty.fullName != 'SecurityScanDebug')
                if(fileProperty.fullName != 'ScanDetails')
				if(fileProperty.fullName != 'DownloadReport')                
                if(fileProperty.fullName != 'SecurityFuzzer')
                 if (!(fileProperty.fullName.endsWith('Test'))){
                fullNames.add(fileProperty.fullName);
                if(checkHeapSize()){
                MetaDataFilenames = MetaDataFilenames + '{"id":"' + EncodingUtil.urlEncode(fileProperty.fullName, 'UTF-8') + '", "file":"'+ 'pages/'+EncodingUtil.urlEncode(fileProperty.fullName, 'UTF-8')+'.page' + '",' + '"fileid":"' + EncodingUtil.urlEncode(fileProperty.id, 'UTF-8') +'","isApexPage": "1"  , "apexControllers": [], "initaction":""}';
                }
                if(i>0 && i<=fileProperties.size()){
                    MetaDataFilenames = MetaDataFilenames + ',';
                }
                
                }
            }
        }
            fullNames.sort();
            List<String> axlNames = new List<String>();
            Integer i = 0;
            for(ApexClass apxcl : [Select Id, Name from ApexClass Where Status = 'Active' LIMIT 10000]){
                i++;
                if(apxcl.Name != 'MetadataService')
                if(apxcl.Name != 'SecurityScan')
                if(apxcl.Name != 'ScanDetails')
                if(apxcl.Name != 'ReportDownload')
                if(apxcl.Name != 'MetadataRetrieveController')  
                if(!(apxcl.Name.endsWith('Test'))){
                    axlNames.add(apxcl.Name);
                    if(checkHeapSize()){
                MetaDataFilenames = MetaDataFilenames + '{"id":"' + EncodingUtil.urlEncode(apxcl.Name, 'UTF-8') + '","file":"'+ 'classes/'+EncodingUtil.urlEncode(apxcl.Name, 'UTF-8')+'.cls' + '",' + '"fileid":"' + EncodingUtil.urlEncode(apxcl.id, 'UTF-8') +'","isApexPage": "0" , "apexControllers": [],  "initaction":""}';
                    }
                if(i>0)
                {
                    MetaDataFilenames = MetaDataFilenames + ',';
                }
                }
                
            }
            
            if(MetaDataFilenames.endsWith(',')) {
                MetaDataFilenames = MetaDataFilenames.substring(0, MetaDataFilenames.length()-1);
            }
            MetaDataFilenames = MetaDataFilenames + ']';
            MetaDataFilenames = EncodingUtil.base64Encode(Blob.valueOf(MetaDataFilenames));
          	return MetaDataFilenames;
            }catch(Exception e){
            return '0';
            }
 			return '0';     
            }
        private static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        if(Schema.sObjectType.Organization.isaccessible() && Schema.sObjectType.Organization.fields.Instancename.isAccessible())
    	{
	         Organization orx = [SELECT Instancename FROM Organization] ;  
	         if(!(String.isBlank(orx.Instancename)))
	         {baseURL ='https://'+orx.Instancename.toLowerCase()+'.salesforce.com';}
    	 }
        service.endpoint_x = baseURL+'/services/Soap/m/29.0';
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }   
    
        public String getFullname(){
            return fullName;}
        
        public String getContent(){
            return content;}
    
    public class Vuln
{
    public String url;
    public String variable;
    public String exploit;
    public String file;
    public String line;
    public String typed;
    public String code;
    public String severity;
    
    public Vuln(String rl, String vari, String ploit, String ile, String ine, String ype, String ode, String everity)
    {
        url = rl;
        variable = vari;
        exploit=ploit;
        file = ile;
        line = ine;
        typed = ype;
        code = ode;
        severity = everity;
        
    }
}



public class PkgNames
{
    public String packagetype;
    public String filename;
    
    public PkgNames(String ptype, String fname)
    {
        packagetype = ptype;
        filename = fname;
        
    }
}

public class apexcodeObject
{
    public String apxclassname {get; set;}
    public String linecount{get; set;}
    public String methodcount{get; set;}
    public List<apexcodeObjectblock> methodnames{get; set;}
}

public class apexcodeObjectblock
{
    public String methodname{get; set;}
    public Integer startline{get; set;}
    public Integer endline{get; set;}
}
public  class Caso
{
    public String Id{get; set;}
    public String Subject {get; set;}
    public String highcount{get; set;} 
    public String mediumcount{get; set;}
    public String lowcount{get; set;}
    public String activecount{get; set;}
    public String cId{get; set;}

    public Caso(String Id, String d, String ubject, String ighcount, String ediumcount, String owcount, String ctivecount)
    {
        this.cId = Id;
        this.Id = d;
        this.Subject = ubject;
        this.highcount = ighcount;
        this.mediumcount=ediumcount;
        this.lowcount=owcount;
        this.activecount=ctivecount;
    }
}

@RemoteAction
public static String jsretrieveMetadataClass(List<String> files)
    {       
        if(files.size() > 0)
        {
        MetadataService.MetadataPort service = createService();             
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = 25;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType2 = new MetadataService.PackageTypeMembers();
        packageType2.name = 'ApexClass'; 
        packageType2.members = files;
        retrieveRequest.unpackaged.types.add(packageType2);
        MetadataService.AsyncResult AsyncResult = service.retrieve_x(retrieveRequest);
        return AsyncResult.id;  
        }
        else {return '0';}  
    }
    

    
@RemoteAction
public static String jsretrieveCORSettings(String test)
    {
            
        // Construct unmanaged package with list of desired components to retrieve in zip
        MetadataService.MetadataPort service = createService();             
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = 32;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType3 = new MetadataService.PackageTypeMembers();
        packageType3.name = 'CorsWhitelistOrigin'; 
        List<String> tempSettings = new List<String>();
        tempSettings.add('*');
        packageType3.members = tempSettings;
        retrieveRequest.unpackaged.types.add(packageType3);
        MetadataService.AsyncResult AsyncResult = service.retrieve_x(retrieveRequest);
        return AsyncResult.id;  
        
    }
    
    
    @RemoteAction
public static String jsretrieveCSPSettings(String test)
    {
            
        // Construct unmanaged package with list of desired components to retrieve in zip
        MetadataService.MetadataPort service = createService();             
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = 39;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType3 = new MetadataService.PackageTypeMembers();
        packageType3.name = 'CspTrustedSite'; 
        List<String> tempSettings = new List<String>();
        tempSettings.add('*');
        packageType3.members = tempSettings;
        retrieveRequest.unpackaged.types.add(packageType3);
        MetadataService.AsyncResult AsyncResult = service.retrieve_x(retrieveRequest);
        return AsyncResult.id;  
        
    }
    
    @RemoteAction
public static String jsretrieveRemoteSettings(String test)
    {
            
        // Construct unmanaged package with list of desired components to retrieve in zip
        MetadataService.MetadataPort service = createService();             
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = 25;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType3 = new MetadataService.PackageTypeMembers();
        packageType3.name = 'RemoteSiteSetting'; 
        List<String> tempSettings = new List<String>();
        tempSettings.add('*');
        packageType3.members = tempSettings;
        retrieveRequest.unpackaged.types.add(packageType3);
        MetadataService.AsyncResult AsyncResult = service.retrieve_x(retrieveRequest);
        return AsyncResult.id;  
        
    }
    

@RemoteAction
public static String jsretrieveSecuritySettings(String test)
    {
            
        // Construct unmanaged package with list of desired components to retrieve in zip
        MetadataService.MetadataPort service = createService();             
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = 25;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType3 = new MetadataService.PackageTypeMembers();
        packageType3.name = 'Settings'; 
        List<String> tempSettings = new List<String>();
        tempSettings.add('Security');
        packageType3.members = tempSettings;
        retrieveRequest.unpackaged.types.add(packageType3);
        MetadataService.AsyncResult AsyncResult = service.retrieve_x(retrieveRequest);
        return AsyncResult.id;  
        
    }
    
    @RemoteAction
public static void hearbeat()
{
    return;
}

@RemoteAction
public static String jsretrieveMetadataPage(List<String> files)
    {       

        
        if(files.size() > 0)
        {
        

        MetadataService.MetadataPort service = createService();             
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = 25;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers();
        packageType.name = 'ApexPage'; 
        packageType.members = files;
        retrieveRequest.unpackaged.types.add(packageType);
        MetadataService.AsyncResult AsyncResult = service.retrieve_x(retrieveRequest);
                                
        return AsyncResult.id;
        }
        else {return '0';}  
    }
    
    
@RemoteAction
public static String jscheckAsyncRequest(String Asyncid)
    {
        String MetaDataRetrieveZips;
        MetadataService.MetadataPort service = createService();
        MetadataService.AsyncResult[] aysncResults = service.checkStatus(new String[] { Asyncid });

        if(aysncResults[0].done)
        {
            if(aysncResults[0].state == 'Error')
            {
                
                MetaDataRetrieveZips ='0';
            }
            else
            {
           		try
                {
                MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus(Asyncid);
                MetaDataRetrieveZips = retrieveResult.zipFile;
                }
                catch(Exception ex)
                {
                 MetaDataRetrieveZips = 'UEsDBBQACAgIAIuO+0gAAAAAAAAAAAAAAAAUAAAAcGFnZXMvR3JlZXRpbmdzLnBhZ2WzSSxIrbAqSExPVbDjUlCwUdTVVXBKTc/MU3BJTUsszSlRcM7PK0nNK1EIcvX1D3NVCPHwDFbQ1QUrzjC0A8qmFyWWlOYklmTm5xXb6APFwFJGdh6pOTn5CuH5RTkpQGEjkHBIRmaxAhBV5pcWKeSllisEAC2GWeual0LQUht9uHvtAFBLBwgUaOSYgwAAALsAAABQSwMEFAAICAgAi477SAAAAAAAAAAAAAAAAB0AAABwYWdlcy9HcmVldGluZ3MucGFnZS1tZXRhLnhtbE2NsQrCMBQA93xFyG5eLCIqSYqLrg7q/kyfbSFNQhOkn2+gCN54HJxul8nzD815jMGIrVSCU3CxG0NvxON+2RxEa5k+J1pu2BOvechGDKWkE0COmGR+x9mRdHGCRqk9qB1MVLDDgsIyXtGYxuf6sM1RKg1/Yi08vsjb60xU6jprWAXT8Ftb9gVQSwcIeAqpgYgAAACtAAAAUEsDBBQACAgIAIuO+0gAAAAAAAAAAAAAAAALAAAAcGFja2FnZS54bWxNjs0KwjAQhO95ipC72VhURNIUL3rtQR8gpmstmh+aIPXtDf1B97TfMMyMrAb7om/sY+ddydZcMIrO+KZzbcmul9NqzypFZK3NU7dIs9vFkj1SCgeA6HXg8e57g9x4C4UQOxAbsJh0o5NmitB8Mn0Cxukf2aK95Up17hFTbooSFulnctqiOgYc6lwsYcQpDv7y5LxdFVsuJCxEJMyTFfkCUEsHCH4lG0qgAAAA5AAAAFBLAQIUABQACAgIAIuO+0gUaOSYgwAAALsAAAAUAAAAAAAAAAAAAAAAAAAAAABwYWdlcy9HcmVldGluZ3MucGFnZVBLAQIUABQACAgIAIuO+0h4CqmBiAAAAK0AAAAdAAAAAAAAAAAAAAAAAMUAAABwYWdlcy9HcmVldGluZ3MucGFnZS1tZXRhLnhtbFBLAQIUABQACAgIAIuO+0h+JRtKoAAAAOQAAAALAAAAAAAAAAAAAAAAAJgBAABwYWNrYWdlLnhtbFBLBQYAAAAAAwADAMYAAABxAgAAAAA=';  
                }
                
            }
        }
        else
        {
            
            MetaDataRetrieveZips = '0';
        }   
        return MetaDataRetrieveZips;
    }

}