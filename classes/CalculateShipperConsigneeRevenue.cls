global class CalculateShipperConsigneeRevenue implements Database.Batchable<sObject>, Schedulable
{   
    
    // Definitions: 
    //   Delivery_Start__c = pickup date
    
    global database.Querylocator start(Database.BatchableContext context)
    {
        return Database.getQueryLocator([SELECT Id, Name FROM Shipper_Consignee__c ]); 
    }
    
    global void execute(Database.BatchableContext context, List<Shipper_Consignee__c> shipperConsigneeList)
    {
        //Set up date values we need
		Date todayDate = Date.today();
        Date lastYearDate = todayDate.addYears(-1);
        Date lastMonthDate = todayDate.addMonths(-1); 
        Integer currMonth = todayDate.month();
        Integer currYear = todayDate.year(); 
        Integer lastMonth = lastMonthDate.month();
        Integer lastMonthYear = lastMonthDate.year();
        Integer lastYear = lastYearDate.year();
        
        //Get the working days for current month, last month and last year
        Integer cmWD,pmWD,cmpyWD;
        //Get elapsed days
        for(Working_Day__c WD: [SELECT Month__c, Year__c, Elapsed_Days__c FROM Working_Day__c]){
            IF(WD.Month__c == currMonth && WD.Year__c == currYear){
                cmWD = integer.valueOf(WD.Elapsed_Days__c);
            }
            IF(WD.Month__c == currMonth && WD.Year__c == lastYear){
                cmpyWD = integer.valueOf(WD.Elapsed_Days__c);
            }
            IF(WD.Month__c == lastMonth && WD.Year__c == currYear){
                pmWD = integer.valueOf(WD.Elapsed_Days__c);
            }
        }
        
        // create a map of the shippers consignees we need to update
        Map<Id, Shipper_Consignee__c> shippersConsigneesToUpdate = new Map<Id, Shipper_Consignee__c>();
        for(Shipper_Consignee__c shipperConsignee : shipperConsigneeList) {
            shipperConsignee.CM_Working_Days__c = cmWD;
            shipperConsignee.PM_Working_Days__c = pmWD;
            shipperConsignee.PY_Working_Days__c = cmpyWD;
            shippersConsigneesToUpdate.put( shipperConsignee.Id, shipperConsignee );   
        }
        calculateCurrentMonthRevenue( shippersConsigneesToUpdate );
        calculatePreviousMonthRevenue( shippersConsigneesToUpdate );
        calculatePreviousYearRevenue( shippersConsigneesToUpdate );

        update shippersConsigneesToUpdate.values();
        
    }

	private void calculateCurrentMonthRevenue( Map<Id, Shipper_Consignee__c> shippersConsigneesToUpdate ) {
        //Calculate revenue for shipper 
     	AggregateResult[] queryResult = [SELECT shipper__c id, Sum(Rev_Curr_Total__c) ttl 
                                        FROM Probill__c 
                                        WHERE shipper__c in :shippersConsigneesToUpdate.keySet() 
                                            AND shipper__c != ''
                                            AND delivery_start__c = THIS_MONTH
                                        GROUP BY shipper__c];
                                        
        for (AggregateResult resultRow : queryResult ) {
            // get the shipper consignee id and find the corresponding item in the shipper consignee list so we can update Rev_Curr_Total
            String shipperConsigneeId = (String) resultRow.get('id'); 
            Shipper_Consignee__c shipperConsigneeToUpdate = (Shipper_Consignee__c) shippersConsigneesToUpdate.get( shipperConsigneeId );
            
            // update the amount
            shipperConsigneeToUpdate.Current_Month_Revenue__c = (Decimal) resultRow.get('ttl');
        }
     	
     	//Calculate revenue for Consignee
     	queryResult = [SELECT consignee__c id, Sum(Rev_Curr_Total__c) ttl 
                                        FROM Probill__c 
                                        WHERE consignee__c in :shippersConsigneesToUpdate.keySet() 
                                            AND consignee__c != ''
                                            AND delivery_start__c = THIS_MONTH
                                        GROUP BY consignee__c];
                                        
        for (AggregateResult resultRow : queryResult ) {
            // get the shipper consignee id and find the corresponding item in the shipper consignee list so we can update Rev_Curr_Total
            String shipperConsigneeId = (String) resultRow.get('id'); 
            Shipper_Consignee__c shipperConsigneeToUpdate = (Shipper_Consignee__c) shippersConsigneesToUpdate.get( shipperConsigneeId );
            
            // update the amount
            shipperConsigneeToUpdate.Current_Month_Revenue__c = (Decimal) resultRow.get('ttl');
        }     	
    }    
    
    
	private void calculatePreviousMonthRevenue( Map<Id, Shipper_Consignee__c> shippersConsigneesToUpdate ) {
		//Calculate revenue for Shipper
		AggregateResult[] queryResult = [SELECT shipper__c id, Sum(Rev_Curr_Total__c) ttl 
                                        FROM Probill__c 
                                        WHERE shipper__c in :shippersConsigneesToUpdate.keySet() 
                                            AND shipper__c != ''
                                            AND delivery_start__c = LAST_MONTH
                                        GROUP BY shipper__c];
                                        
        for (AggregateResult resultRow : queryResult ) {
            // get the shipper consignee id and find the corresponding item in the shipper consignee list so we can update Rev_Curr_Total
            String shipperConsigneeId = (String) resultRow.get('id'); 
            Shipper_Consignee__c shipperConsigneeToUpdate = (Shipper_Consignee__c) shippersConsigneesToUpdate.get( shipperConsigneeId );
            
            // update the amount
            shipperConsigneeToUpdate.PM_TL_Revenue__c = (Decimal) resultRow.get('ttl');
        }
    
		//Calculate revenue for Consignee
		queryResult = [SELECT consignee__c id, Sum(Rev_Curr_Total__c) ttl 
                                        FROM Probill__c 
                                        WHERE consignee__c in :shippersConsigneesToUpdate.keySet() 
                                            AND consignee__c != ''
                                            AND delivery_start__c = LAST_MONTH
                                        GROUP BY consignee__c];
                                        
        for (AggregateResult resultRow : queryResult ) {
            // get the shipper consignee id and find the corresponding item in the shipper consignee list so we can update Rev_Curr_Total
            String shipperConsigneeId = (String) resultRow.get('id'); 
            Shipper_Consignee__c shipperConsigneeToUpdate = (Shipper_Consignee__c) shippersConsigneesToUpdate.get( shipperConsigneeId );
            
            // update the amount
            shipperConsigneeToUpdate.PM_TL_Revenue__c = (Decimal) resultRow.get('ttl');
        }
    }

    
	private void calculatePreviousYearRevenue ( Map<Id, Shipper_Consignee__c> shippersConsigneesToUpdate ) {
         	//Calculate revenue for Shipper
        	AggregateResult[] queryResult = [SELECT shipper__c id, Sum(Rev_Curr_Total__c) ttl 
                                        FROM Probill__c 
                                        WHERE shipper__c in :shippersConsigneesToUpdate.keySet() 
                                            AND shipper__c != ''
                                        // updated Long Term Formula This month This Year vs This Month Last Year aka 12 months ago
                                        //       and delivery_start__c = LAST_YEAR
                                            AND delivery_start__c = N_MONTHS_AGO:12
                                        GROUP BY shipper__c];
                                        
        for (AggregateResult resultRow : queryResult ) {
            // get the shipper consignee id and find the corresponding item in the shipper consignee list so we can update Rev_Curr_Total
            String shipperConsigneeId = (String) resultRow.get('id'); 
            Shipper_Consignee__c shipperConsigneeToUpdate = (Shipper_Consignee__c) shippersConsigneesToUpdate.get( shipperConsigneeId );
            
            // update the amount
            shipperConsigneeToUpdate.PY_TL_Revenue__c = (Decimal) resultRow.get('ttl');
        }
        
         	//Calculate revenue for Consignee
        	queryResult = [SELECT consignee__c id, Sum(Rev_Curr_Total__c) ttl 
                                        FROM Probill__c 
                                        WHERE consignee__c in :shippersConsigneesToUpdate.keySet() 
                                            AND consignee__c != ''
                                            AND delivery_start__c = N_MONTHS_AGO:12
                                        GROUP BY consignee__c];
                                        
        for (AggregateResult resultRow : queryResult ) {
            // get the shipper consignee id and find the corresponding item in the shipper consignee list so we can update Rev_Curr_Total
            String shipperConsigneeId = (String) resultRow.get('id'); 
            Shipper_Consignee__c shipperConsigneeToUpdate = (Shipper_Consignee__c) shippersConsigneesToUpdate.get( shipperConsigneeId );
            
            // update the amount
            shipperConsigneeToUpdate.PY_TL_Revenue__c = (Decimal) resultRow.get('ttl');
        }
    }

    
    global void finish(Database.BatchableContext context)
    {
    }
    
    global void execute(SchedulableContext context)
    {
        CalculateShipperConsigneeRevenue task = new CalculateShipperConsigneeRevenue();
        Database.executeBatch(task);
    }
}