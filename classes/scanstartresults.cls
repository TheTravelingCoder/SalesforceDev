public class scanstartresults {
   public String success;
   @auraEnabled
   public String scan_id;
    
   public static Scanstartresults parse(String json) {
       return (Scanstartresults) System.JSON.deserialize(json, Scanstartresults.class);
   }
}