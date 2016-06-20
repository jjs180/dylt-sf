//Consignee_State__c
public class BusinessbyLaneConsigneeController
{
    public String ReportFilter {get; set; }
    
     public class FilterDefinition {
    	public String column;
    	public String operator;
    	public String value;
    }
    
    
    @readOnly @RemoteAction
    public static List<ConsigneeInfo> getConsignees(List<FilterDefinition>  reportFilters)
    {
        List<ConsigneeInfo> results = new List<ConsigneeInfo>();
        AggregateResult[] groupedResults; 
        
        String queryString = 'Select Consignee_State__c state, SUM(Rev_Curr_Total__c) totalRevenue From Probill__c';
        queryString += ' Where Consignee_State__c != null';
        
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
       	queryString += ' Group By Consignee_State__c Order By Sum(Rev_Curr_Total__c) DESC';
		groupedResults = Database.query( queryString  );
        
        
        /*
        if(theReportFilter != '')
        {
            if(theReportFilter.contains('001'))
            {//system.debug();
                accountIdFilter = theReportFilter.subString(theReportFilter.indexOf('001'), theReportFilter.indexOf('001') + 15);
            }
            if(theReportFilter.contains('THIS_MONTH'))
            {
                groupedResults = [select Consignee_State__c consigneestate, SUM(Rev_Curr_Total__c) sum from Probill__c where Consignee_State__c != null and Delivery_Start__c = THIS_MONTH group by Consignee_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC];
            }
            else if(theReportFilter.contains('THIS_QUARTER'))
            {
                groupedResults = [select Consignee_State__c consigneestate, SUM(Rev_Curr_Total__c) sum from Probill__c where Consignee_State__c != null and Delivery_Start__c = THIS_QUARTER group by Consignee_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC];
            }
            else if(theReportFilter.contains('THIS_YEAR'))
            {
                groupedResults = [select Consignee_State__c consigneestate, SUM(Rev_Curr_Total__c) sum from Probill__c where Consignee_State__c != null and Delivery_Start__c = THIS_YEAR group by Consignee_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC];
            }
            if(accountIdFilter != null)
            {
                groupedResults = [select Consignee_State__c consigneestate, SUM(Rev_Curr_Total__c) sum from Probill__c where Consignee_State__c != null and Account__c = :accountIdFilter group by Consignee_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC];
                if(theReportFilter.contains('THIS_MONTH'))
                {
                    groupedResults = [select Consignee_State__c consigneestate, SUM(Rev_Curr_Total__c) sum from Probill__c where Consignee_State__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_MONTH group by Consignee_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC];
                }
                else if(theReportFilter.contains('THIS_QUARTER'))
                {
                    groupedResults = [select Consignee_State__c consigneestate, SUM(Rev_Curr_Total__c) sum from Probill__c where Consignee_State__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_QUARTER group by Consignee_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC];
                }
                else if(theReportFilter.contains('THIS_YEAR'))
                {
                    groupedResults = [select Consignee_State__c consigneestate, SUM(Rev_Curr_Total__c) sum from Probill__c where Consignee_State__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_YEAR group by Consignee_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC];
                }
            }
        }
        
        */
        
        for(AggregateResult groupedResult : groupedResults)
        {
            ConsigneeInfo result = new ConsigneeInfo();
            result.ConsigneeState = (String)groupedResult.get('state');
            result.ConsigneeStateCode = BusinessbyLaneShipperControlelr.StateCodeLookup(result.ConsigneeState);            
            result.PaidAmount = (Decimal)groupedResult.get('totalRevenue');
            
            results.add(result);
        }
        return results;
    }
    
    public class ConsigneeInfo
    {
        public String ConsigneeState { get; set; }
        public String ConsigneeStateCode { get; set; }
        public Decimal PaidAmount { get; set; }
    }
}