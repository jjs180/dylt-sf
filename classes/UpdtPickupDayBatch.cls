global class UpdtPickupDayBatch implements Database.Batchable<sObject> {
    global database.Querylocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([Select Id, 
        									Delivery_Start__c,
        									Pickup_Day__c 
        									From Probill__c
        									Where Delivery_Start__c != null ]); 
    }
    
    global void execute(Database.BatchableContext context, List<Probill__c> probillList) {    	
    	// set Pickup_Day__c to the Date portion of the Delivery_Start__c date/time field
    	for ( Probill__c probill : probillList ) {
    		probill.Pickup_Day__c = Date.valueOf(probill.Delivery_Start__c);
    	}
    	update probillList;
    }
    

    global void finish(Database.BatchableContext context) {
    }
    
   
    
}