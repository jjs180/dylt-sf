public with sharing class NewTopShippersLost 
{
    public String ReportFIlter {get; set; }
    
     public class FilterDefinition {
    	public String column;
    	public String operator;
    	public String value;
    }
    
    
    @RemoteAction
    @ReadOnly
    public static List<ShipperInfo> getTop5ShippersLost(List<FilterDefinition> reportFilters)
    {
        List<ShipperInfo> results = new List<ShipperInfo>();
        AggregateResult[] groupedResults;
        
        String queryString = 'Select Shipper__r.Name__c shipperName, Shipper__r.State__c state, SUM(Shipper__r.Change_Short_Term_Revenue__c) totalRevenue From Probill__c  Where Shipper__r.Name__c != nulll';
 		       
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
       		} else {
       			columnName = filterDef.column;
       			filterValue = filterDef.value;
       		}
       		queryString += ' And ' + columnName + '=' + filterValue;
       	}
       	queryString += ' Group By Shipper__r.Name__c, Shipper_State__c ORDER BY SUM(Shipper__r.Change_Short_Term_Revenue__c) ASC LIMIT 5';
		groupedResults = Database.query( queryString  );
		       
 		 //System.debug('**** query ' + queryString);   
 		       
        /*
        if(theReportFilter != '')
        {
            if(theReportFilter.contains('001'))
            {//system.debug();
                accountIdFilter = theReportFilter.subString(theReportFilter.indexOf('001'), theReportFilter.indexOf('001') + 15);
            }
            if(theReportFilter.contains('THIS_MONTH'))
            {
                groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Rev_Curr_Total__c) sum from Probill__c where Shipper_Name__c != null and Delivery_Start__c = THIS_MONTH group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC limit 5];
            }
            else if(theReportFilter.contains('THIS_QUARTER'))
            {
                groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Rev_Curr_Total__c) sum from Probill__c where Shipper_Name__c != null and Delivery_Start__c = THIS_QUARTER group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC limit 5];
            }
            else if(theReportFilter.contains('THIS_YEAR'))
            {
                groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Rev_Curr_Total__c) sum from Probill__c where Shipper_Name__c != null and Delivery_Start__c = THIS_YEAR group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC limit 5];
            }
            if(accountIdFilter != null)
            {
                groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Rev_Curr_Total__c) sum from Probill__c where Shipper_Name__c != null and Account__c = :accountIdFilter group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC limit 5];
                if(theReportFilter.contains('THIS_MONTH'))
                {
                    groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Rev_Curr_Total__c) sum from Probill__c where Shipper_Name__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_MONTH group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC limit 5];
                }
                else if(theReportFilter.contains('THIS_QUARTER'))
                {
                    groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Rev_Curr_Total__c) sum from Probill__c where Shipper_Name__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_QUARTER group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC limit 5];
                }
                else if(theReportFilter.contains('THIS_YEAR'))
                {
                    groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Rev_Curr_Total__c) sum from Probill__c where Shipper_Name__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_YEAR group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Rev_Curr_Total__c) DESC limit 5];
                }
            }
        }
        
        */
        
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