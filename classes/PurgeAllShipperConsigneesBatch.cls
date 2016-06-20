global class PurgeAllShipperConsigneesBatch implements Database.Batchable<sObject>  {

    global database.Querylocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([Select Id
        									From Shipper_Consignee__c]); 
    }
    
    global void execute(Database.BatchableContext context, List<Shipper_Consignee__c> shipperConsigneeList) {    	
    	delete shipperConsigneeList;
    }
    
    global void finish(Database.BatchableContext context) {
    }
    
  
}