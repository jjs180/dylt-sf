public class Top5ShippersController
{
    public String ReportFIlter {get; set; }
    
     public class FilterDefinition {
    	public String column;
    	public String operator;
    	public String value;
    }
    
    
    @RemoteAction
    @ReadOnly
    public static List<ShipperInfo> getTop5Shippers(List<FilterDefinition> reportFilters)
    {
        List<ShipperInfo> results = new List<ShipperInfo>();
        AggregateResult[] groupedResults;
        
        String queryString = 'Select Shipper_Name__c shipperName, Shipper_State__c state, SUM(Rev_Curr_Total__c) totalRevenue from Probill__c where Shipper_Name__c != null';
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
       			columnName = 'Probill__c.Pickup_Day__c';
       			filterValue = filterDef.value;
       		}
       		queryString += ' And ' + columnName + '=' + filterValue;
       	}
       	queryString += ' Group By Shipper_Name__c, Shipper_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC LIMIT 5';
		groupedResults = Database.query( queryString  );
		       		
       
        for(AggregateResult groupedResult : groupedResults)
        {
            ShipperInfo result = new ShipperInfo();
            result.ShipperName = (String)groupedResult.get('shipperName');
            result.ShiperState = (String)groupedResult.get('state');
            result.PaidAmount = (Decimal)groupedResult.get('totalRevenue');
            results.add(result);
        }
        return results;
    }
    
    public class ShipperInfo
    {
        public String ShipperName { get; set; }
        public String ShiperState { get; set; }
        public Decimal PaidAmount { get; set; }
    }
}