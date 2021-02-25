public class scaninitresults {

    public class Scanresults {
        public String status {get;set;} 
        public Boolean autoscan {get;set;} 
        public Boolean Findings_new {get;set;} 
        @auraEnabled
        public String x_id {get;set;} // in json: _id
        @auraEnabled
        public String Org_Id {get;set;} 
        public String Created_date {get;set;} 
        public String Initiated_Scan_date {get;set;} 

        public Scanresults(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'autoscan') {
                            autoscan = parser.getBooleanValue();
                        } else if (text == 'Findings_new') {
                            Findings_new = parser.getBooleanValue();
                        } else if (text == '_id') {
                            x_id = parser.getText();
                        } else if (text == 'Org_Id') {
                            Org_Id = parser.getText();
                        } else if (text == 'Created_date') {
                            Created_date = parser.getText();
                        } else if (text == 'Initiated_Scan_date') {
                            Initiated_Scan_date = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Scanresults consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static Scanresults parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new Scanresults(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    




}