public class S4Parse {
      
    @auraEnabled
    public Boolean auth;
    @auraEnabled
    public String company;
    @auraEnabled
    public String token;

    public static S4Parse parse(String json) {
        return (S4Parse) System.JSON.deserialize(json, S4Parse.class);
    }
}