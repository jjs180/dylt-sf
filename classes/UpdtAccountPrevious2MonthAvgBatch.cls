global class UpdtAccountPrevious2MonthAvgBatch implements Database.Batchable<sObject>, Schedulable {   
    // Account.Previous_2_Months_Avg__c = (sum( probill.Rev_Curr_Total in Account.Date_Lost - 1 month ) +
	//						sum( probill.Rev_Curr_Total in Account.Date_Lost - 2 months ) ) / 2
	// Use probill.Quota_Date  
    
    global database.Querylocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([Select Id, 
        									Date_Lost__c,
        									Previous_2_Months_Avg__c 
        									From Account
        									Where Date_Lost__c != null ]); 
    }
    
    global void execute(Database.BatchableContext context, List<Account> accountList) {    	
    	
    	//System.debug('*** start	CPU Time: ' + Limits.getCpuTime());
    	//System.debug('*** start	CPU Limit CPU Time: ' + Limits.getLimitCpuTime() );
    
    	Map<Id, Account> accountMap = new Map<Id, Account>( accountList );
    	
    	// reset total to 0
    	for( Account accnt : accountMap.values() ) {
    		accnt.Previous_2_Months_Avg__c = 0;
    	}

    	// do the calculation

        for ( AggregateResult calcResult : [Select Account__c accountId,
    										Quota_Date__c quotaDt,
    										sum( Rev_Curr_Total__c ) ttl 
    									From Probill__c 
    									Where Account__c in :accountMap.values()
    									Group by Account__c, Quota_Date__c]) {
    										
    		Decimal ttl = (Decimal) calcResult.get('ttl');
			Date quotaDt = (Date) calcResult.get('quotaDt');
			String accountId = (String) calcResult.get('accountId');
			
			
			
			// get related account
			Account accnt = accountMap.get( accountId );
			Date startDate = accnt.Date_Lost__c.toStartOfMonth().addMonths(-3);
			Date endDate = accnt.Date_Lost__c.toStartOfMonth().addDays(-1);
			if ( quotaDt >= startDate && quotaDt <= endDate ) {
				accnt.Previous_2_Months_Avg__c += ttl;
			}
        }
        
		     	
    	// update the accountList with calculation results
    	/*
    	for ( Account accnt : accountList ) {
			Date startDate = accnt.Date_Lost__c.toStartOfMonth().addMonths(-3);
			Date endDate = accnt.Date_Lost__c.toStartOfMonth().addDays(-1);
    		for ( AggregateResult calcResult : calcResults) {
				Decimal ttl = (Decimal) calcResult.get('ttl');
				Date quotaDt = (Date) calcResult.get('quotaDt');
				String accountId = (String) calcResult.get('accountId');
				
				if ( accountId == accnt.id 
						&& quotaDt >= startDate 
						&& quotaDt <= endDate ) {
							
					accnt.Previous_2_Months_Avg__c += ttl;
				}
    		}
    		
    	}
    	*/
    	
    	
    	//  committ the changes to the database
    	update accountMap.values();
    	
    	//System.debug('*** end CPU Time: ' + Limits.getCpuTime());
    	//System.debug('*** end CPU Limit CPU Time: ' + Limits.getLimitCpuTime() );
    
    }
    
    /* Lucian Ciobanu - Commented out because it is not used and it affects code coverage
    private static void originalCalculation( List<Account> accountList ){
   		// report date range is previous 2 months
    	Date currentDate = Date.today();
    	Date startDate = currentDate.addMonths(-3);
    	Date endDate = currentDate.toStartOfMonth().addDays(-1);   
    	
    	// do the calculation
    	AggregateResult[] calcResults = [Select Account__c accountId,
    										sum( Rev_Curr_Total__c ) ttl 
    									From Probill__c 
    									Where Account__c in :accountList
    										and Delivery_Start_2__c >= :startDate
    										and Delivery_Start_2__c <= :endDate
    									Group by Account__c];
    
    	// update the accountList with calculation results
    	for ( Account accnt : accountList ) {
    		for ( AggregateResult calcResult : calcResults ) {
				String accountId = (String) calcResult.get('accountId');
    			if ( accnt.id == accountId ) {
    				Decimal ttl = (Decimal) calcResult.get('ttl');
    				accnt.Previous_2_Months_Avg__c = ttl;
    			}
    		}
    	}	
    } */
    
    global void finish(Database.BatchableContext context) {
    }
    
    global void execute(SchedulableContext context) {
        UpdtAccountPrevious2MonthAvgBatch task = new UpdtAccountPrevious2MonthAvgBatch();
        Database.executeBatch(task);
    }
}