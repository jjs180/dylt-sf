public class Top5ConsigneesController
{
    public String ReportFIlter {get; set; }
    
     public class FilterDefinition {
    	public String column;
    	public String operator;
    	public String value;
    }
    
    
    @RemoteAction
    @ReadOnly
    public static List<ConsigneeInfo> getTop5Consignees(List<FilterDefinition> reportFilters) {
        List<ConsigneeInfo> results = new List<ConsigneeInfo>();
        AggregateResult[] groupedResults;   
        
        String queryString = 'Select Consignee_Name__c consigneeName, Consignee_State__c state, SUM(Rev_Curr_Total__C) totalRevenue From Probill__c where Consignee_Name__c != null ';
        
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
        queryString += ' Group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Rev_Curr_Total__C) DESC LIMIT 5';
        
        groupedResults = Database.query( queryString  );
                
        
        for(AggregateResult groupedResult : groupedResults)
        {
            ConsigneeInfo result = new ConsigneeInfo();
            result.ConsigneeName = (String)groupedResult.get('consigneeName');
            result.ConsigneeState = (String)groupedResult.get('state');
            result.PaidAmount = (Decimal)groupedResult.get('totalRevenue');
            results.add(result);
        }
        return results;
    }
    
    public class ConsigneeInfo
    {
        public String ConsigneeName { get; set; }
        public String ConsigneeState { get; set; }
        public Decimal PaidAmount { get; set; }
    }
}