public class Top5ShippersLostCtrl {
	public String ReportFIlter {get; set; }
   
     public class FilterDefinition {
    	public String column;
    	public String operator;
    	public String value;
    }
    
    
    @RemoteAction
    @ReadOnly
    public static List<ShipperInfo> getTop5ShippersLost(List<FilterDefinition> reportFilters, String shortOrLongTerm)
    {
        List<ShipperInfo> results = new List<ShipperInfo>();
        AggregateResult[] groupedResults;
        
        String fieldToTotal = '';
        if ( shortOrLongTerm == 'Short Term') {
        	fieldToTotal = 'Shipper__r.Change_Short_Term_Revenue__c';
        } else {
        	fieldToTotal = 'Shipper__r.Change_Long_Term_Revenue__c';
        }
       
        String queryString = 'Select Shipper__r.Name__c shipperName, Shipper__r.State__c state, SUM(' + fieldToTotal + ') totalRevenue From Probill__c  Where Shipper__r.Name__c != null';
 		       
 		// add report filters to the query string
       	for ( FilterDefinition filterDef : reportFilters ) {
       		//  the dashboard only allows for equals operator so no need 
       		//  to worry about the others ie, <, >, >= , etc
       		String columnName;
       		String filterValue;
       		if ( filterDef.column == 'ACCOUNT_ID' ) {
       			columnName = 'Account__c';
       			filterValue = '\'' + filterDef.value + '\'';
       		} else if ( filterDef.column == 'USERS.NAME') {
       			columnName = 'Account__r.Owner.Name';
       			filterValue = '\'' + filterDef.value + '\'';	 
       		} else if ( filterDef.column == 'Probill__c.Delivery_Start__c') {
       			columnName = filterDef.column;
       			filterValue = filterDef.value;
       		}
       		// for long term, ignore date filter
       		if ( columnName == 'Probill__c.Delivery_Start__c' && shortOrLongTerm == 'Short Term') {
	       		queryString += ' And ' + columnName + '=' + filterValue;   			
       		}
       	}
       	queryString += ' Group By Shipper__r.Name__c, Shipper__r.State__c ORDER BY SUM(Shipper__r.Change_Short_Term_Revenue__c) ASC LIMIT 5';
		groupedResults = Database.query( queryString  );
		//System.debug('***** long or short ' + shortOrLongTerm);
		//System.debug('***** query: ' + queryString);      
        //System.debug('***** result: ' + groupedResults);
        
        for(AggregateResult groupedResult : groupedResults)
        {
            ShipperInfo result = new ShipperInfo();
            result.shipperName = (String)groupedResult.get('shipperName');
            result.shipperState = (String)groupedResult.get('state');
            result.totalRevenue = (Decimal)groupedResult.get('totalRevenue');
            results.add(result);
        }
        return results;
    }
    
    public class ShipperInfo
    {
        public String shipperName { get; set; }
        public String shipperState { get; set; }
        public Decimal totalRevenue { get; set; }
    }   
}