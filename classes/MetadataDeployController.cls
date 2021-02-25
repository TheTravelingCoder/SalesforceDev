public with sharing class MetadataDeployController 
{
    public String ZipData { get; set; } 
    public String RemoteSiteError {get; set;}
    public String baseSFURL {get; set;} 
    public String rbaseSFURL {get; set;} 
    
    public MetadataService.AsyncResult AsyncResult {get; private set;}
    public PageReference init()
    {
    	baseSFURL = 'https://' + URL.getSalesforceBaseUrl().getHost();
		rbaseSFURL = 'https://' + URL.getSalesforceBaseUrl().toExternalForm();	
	//	baseSFURL = URL.getSalesforceBaseUrl().toExternalForm();
	//	List<String> parts = baseSFURL.split('\\.',10);
		
		//	if(parts[1].startsWith('na'))
			{
		//		baseSFURL ='https://' + parts[1]+ '.salesforce.com';
			}
    	RemoteSiteError = '0';
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));
		try
		{
        // Deploy zip file posted back from the page action function                
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = true;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = false;
        deployOptions.runAllTests = false;
        deployOptions.runTests = null;
        deployOptions.singlePackage = true; 
         if(Schema.sObjectType.StaticResource.isAccessible())
         {
             StaticResource sr = [select Id, Name, Body from StaticResource where Name ='digitsec1deployfolder'  LIMIT 1];
             ZipData = sr.Body.toString();
        	AsyncResult = service.deploy(ZipData, DeployOptions);
         }
        
        
        
        }catch(Exception e){
			RemoteSiteError = e.getMessage();
			}
				return null;	
		
    }
    
    public String getPackageXml()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' + 
            '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' + 
                '<types>' + 
                    '<members>SecurityFuzzer</members>' +
                    '<name>ApexPage</name>' + 
                '</types>' + 
                '<version>29.0</version>' + 
            '</Package>';       
    }
    
    public String getHelloWorldMetadata()
    {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
'<ApexPage xmlns="http://soap.sforce.com/2006/04/metadata">'+
    '<apiVersion>29.0</apiVersion>'+
    '<availableInTouch>false</availableInTouch>'+
    '<confirmationTokenRequired>false</confirmationTokenRequired>'+
    '<label>SecurityFuzzer</label>'+
'</ApexPage>';     
    }
    
    public String getHelloWorld()   
    {
        return '<apex:page>'+
            '<h1>Congratulations</h1><h2>Hello World</h2>  This is your new Page' +
            '</apex:page>';        
    }
    
    public PageReference deployZip()
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));

        // Deploy zip file posted back from the page action function                
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = true;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
        deployOptions.runAllTests = false;
        deployOptions.runTests = null;
        deployOptions.singlePackage = true;     
        
        AsyncResult = service.deploy(ZipData, DeployOptions);               
        return null;
    }   
    
    public PageReference checkAsyncRequest()
    {   
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(AsyncResult.Id, true);
        if(deployResult.done)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deployment complete'));

            // Deployment errors?
            if(deployResult.details!=null && deployResult.details.componentFailures!=null)
                for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
                    if(deployMessage.problem!=null)
                        ApexPages.addMessage(
                            new ApexPages.Message(ApexPages.Severity.Error, 
                                deployMessage.fileName + 
                                    ' (Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : ' + 
                                        deployMessage.problem));
            AsyncResult = null;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));
        }   
        return null;
    }
    
    private static MetadataService.MetadataPort createService(){ 
    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
    List<String> parts = baseURL.split('\\.',10);
    
   //   if(parts[1].startsWith('na'))
      {
        baseURL ='https://' + parts[1]+ '.salesforce.com';
      }
    service.endpoint_x = baseURL+'/services/Soap/m/29.0';
    
    service.SessionHeader = new MetadataService.SessionHeader_element();
    service.SessionHeader.sessionId = UserInfo.getSessionId();
    return service;    
  }       
}