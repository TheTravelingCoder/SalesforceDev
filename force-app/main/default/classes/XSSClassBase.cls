public with sharing class XSSClassBase {
    public XSSClassBase() {
    }
    public string testXSS(string input)
        {
            if(input != '')
            {
                return input;
            }
            else
            {
                return '';
            }
        }
    
}
