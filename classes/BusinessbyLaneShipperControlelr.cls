public class BusinessbyLaneShipperControlelr
{
    public String ReportFIlter {get; set; }
    
    public class FilterDefinition {
    	public String column;
    	public String operator;
    	public String value;
    }
    
    @readOnly @RemoteAction
    public static List<ShipperInfo> getShippers(List<FilterDefinition> reportFilters){
        List<ShipperInfo> results = new List<ShipperInfo>();
        AggregateResult[] groupedResults; 
       
       	// build a query string
       	String queryString = 'Select Shipper_State__c state, SUM(Rev_Curr_Total__c) totalRevenue';
       	queryString += ' From Probill__c Where Shipper_State__c != null ';
       	
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
       	queryString += ' Group By Shipper_State__c Order By Sum(Rev_Curr_Total__c) DESC';
		groupedResults = Database.query( queryString  );
		
		System.debug('**** query: ' + queryString );
		
       	// format the report data to return to javascript
        for(AggregateResult groupedResult : groupedResults)
        {
            ShipperInfo result = new ShipperInfo();
            result.ShipperState = (String)groupedResult.get('state');
            result.ShipperStateCode = StateCodeLookup(result.ShipperState);
            result.PaidAmount = (Decimal)groupedResult.get('totalRevenue');
            results.add(result);
        }
        return results;
    }
    
    public class ShipperInfo
    {
        public String ShipperState { get; set; }
        public String ShipperStateCode { get; set; }
        public Decimal PaidAmount { get; set; }
    }
    
    public static String StateCodeLookup(String state)
    {
    	Map<String,String> stateToCodeMap = new Map<String,String>
    	{
	    	'Alabama' => 'AL', 
			'Alaska' => 'AK', 
			'Arizona' => 'AZ', 
			'Arkansas' => 'AR', 
			'California' => 'CA', 
			'Colorado' => 'CO', 
			'Connecticut' => 'CT', 
			'District Of Columbia' => 'DC',			
			'Delaware' => 'DE', 
			'Florida' => 'FL', 
			'Georgia' => 'GA', 
			'Hawaii' => 'HI', 
			'Idaho' => 'ID', 
			'Illinois' => 'IL', 
			'Indiana' => 'IN', 
			'Iowa' => 'IA', 
			'Kansas' => 'KS', 
			'Kentucky' => 'KY', 
			'Louisiana' => 'LA', 
			'Maine' => 'ME', 
			'Maryland' => 'MD', 
			'Massachusetts' => 'MA', 
			'Michigan' => 'MI', 
			'Minnesota' => 'MN', 
			'Mississippi' => 'MS', 
			'Missouri' => 'MO', 
			'Montana' => 'MT', 
			'Nebraska' => 'NE', 
			'Nevada' => 'NV', 
			'New Hampshire' => 'NH', 
			'New Jersey' => 'NJ', 
			'New Mexico' => 'NM', 
			'New York' => 'NY', 
			'North Carolina' => 'NC', 
			'North Dakota' => 'ND', 
			'Ohio' => 'OH', 
			'Oklahoma' => 'OK', 
			'Oregon' => 'OR', 
			'Pennsylvania' => 'PA', 
			'Rhode Island' => 'RI', 
			'South Carolina' => 'SC', 
			'South Dakota' => 'SD', 
			'Tennessee' => 'TN', 
			'Texas' => 'TX', 
			'Utah' => 'UT', 
			'Vermont' => 'VT', 
			'Virginia' => 'VA', 
			'Washington' => 'WA', 
			'West Virginia' => 'WV', 
			'Wisconsin' => 'WI', 
			'Wyoming' => 'WY', 
			'Ontario' => 'ON', 
			'Quebec' => 'QC', 
			'QuéBec' => 'QC', 
			'British Columbia' => 'BC', 
			'Alberta' => 'AB', 
			'Manitoba' => 'MB', 
			'Saskatchewan' => 'SK', 
			'Nova Scotia' => 'NS', 
			'New Brunswick' => 'NB', 
			'Newfoundland And Labrador' => 'NL', 
			'Prince Edward Island' => 'PE', 
			'Northwest Territories' => 'NT', 
			'Yukon' => 'YT', 
			'Nunavut' => 'NU'
    	};
    	
    	return stateToCodeMap.get(state);
    }
}