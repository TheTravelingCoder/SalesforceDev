public with sharing class MapHolder {
    public Map<String, Boolean> it { get; private set; }
    
    public MapHolder(Map<String, Boolean> it) {
    	this.it = it;
    }
}