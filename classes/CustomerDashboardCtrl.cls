public class CustomerDashboardCtrl {
    private String filterDate = ApexPages.currentPage().getparameters().get('date');
    private String acctId = ApexPages.currentPage().getparameters().get('account');
    private String acctOwner = ApexPages.currentPage().getparameters().get('owner');
    
    // added for Mark
    private String ma = ApexPages.currentPage().getparameters().get('ma');
    private String cat = ApexPages.currentPage().getparameters().get('cat');
    
    
    
    public String ReportFilter { get; set; }
    public String ReportFilter2 { get; set; }
    public String ReportFilter3 {get;set;}
    public String DateFilterOption { 
        get
        {
                if ( DateFilterOption == null ) {
                        DateFilterOption = 'This Month';
                }               
                return DateFilterOption;
        }
         set; 
    }
    
    public Contact filterContact { get; set; }
    public String TerritoryUser { get; set; }
    public String Manager {get;set;}
    public String Category {get;set;}
    
    public String baseUrl {
        get {
            if ( baseUrl == null ) {
                baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); 
            }
            return baseUrl;
        }
        set;
    }
    
    public CustomerDashboardCtrl(){
        
        // On page load we need to check to see if any URL parameters were sent
        // The possible parameters are:
        //  1.  date = populates the Time Period select list    
        //  2.  account = populates the Account lookup field
        //  3.  owner = populates the Territory (user) select list
        
        //  if filter date is not passes in URL then we need to default it to 'This Month'
        //  - otherwise set it to value in the URL
        if ( filterDate == null ) {
                filterDate = 'This Month';
        } else {
                DateFilterOption = filterDate;
        }
        
        
        filterContact = new Contact();

        if ( acctId != null ) {
            filterContact.AccountId = acctId;
        }
        
        
        // if url does not contain the Territory User filter then set to the currently
        //  logged in user
        //  -- otherwise set it to the user specified in the URL
        if ( acctOwner == null ) {
            TerritoryUser = UserInfo.getName();         
        } else {
            TerritoryUser = acctOwner;
        }
        
        
        if ( ma != null ) {
            Manager = ma;   
        }
        
        if ( cat != null ) {
            Category = cat;
        }
        
        
        
        initFilter();
        
        
               
        
    }
    
     public class FilterDefinition {
        public String column;
        public String operator;
        public String value;
    }
    
    
    
      @RemoteAction
    public static Object isReportDataReady( String reportInstanceId ) {
        Reports.ReportInstance ri = Reports.ReportManager.getReportInstance( reportInstanceId );
        
        Reports.ReportResults reportResults;
        List<Object> reportData = new List<Object>();

        // object to return to browser when we are done
        ReportResult reportResult = new ReportResult();

        Map<String, Reports.ReportFact> factMap;

        if ( ri.getStatus() == 'Success') {
            reportResults = ri.getReportResults();
            reportResult.reportResults = reportResults;

            // Get the report metadata
            //reportResult.metadata = reportResults.getReportMetadata();
        }

        reportResult.status = ri.getStatus();

        return reportResult;
        
    }
    
    

  @RemoteAction
    public static String runReportAsync(String reportName, String renderTo, List<FilterDefinition> filters) {
        // get the id of the report we want to run
        
        //System.debug('*** run report: ' + reportName);
        //System.debug('*** filters: '  + filters);
        List <Report> reportList = [SELECT Id,DeveloperName FROM Report where DeveloperName = :reportName];
        
        String reportId = (String)reportList.get(0).get('Id');
            
        // set report  filters
        Reports.ReportMetadata reportMetadata = Reports.ReportManager.describeReport( reportId ).getReportMetadata();
        
        // set standard date filter
        Reports.StandardDateFilter sdf = reportMetadata.getStandardDateFilter();
       
        //custom report fitlers
         //List<Reports.ReportFilter> reportFilters = reportMetadata.getReportFilters();
        
        List<Reports.ReportFilter> reportFilters = new List<Reports.ReportFilter>();
        
        
        
        // standard date filter
        // all reports have a date filter: Pickup_Day__c
        String dateFilter = null;
        
        
        if ( reportName == 'Top_5_Shippers_Lost_ST_Final'
        		|| reportName == 'Top_5_Shippers_Lost_LT') {
       		reportFilters.add( new Reports.ReportFilter('Shipper_Consignee__c.Type__c', 'equals', 'Shipper') );            	
        }
        
        if ( reportName == 'Top_5_Consignees_Lost_ST_Final'
        		|| reportName == 'Top_5_Consignees_LT_Final') {
       		reportFilters.add( new Reports.ReportFilter('Shipper_Consignee__c.Type__c', 'equals', 'Consignee') );            	
        }
        
       
        for ( FilterDefinition filterDef : filters ) {
            //  the dashboard only allows for equals operator so no need 
            //  to worry about the others ie, <, >, >= , etc
            if ( filterDef.column == 'ACCOUNT_ID' ) {
            	if ( reportName == 'Top_5_Shippers_Lost_ST_Final'
                			|| reportName == 'Top_5_Shippers_Lost_LT'
                			|| reportName == 'Top_5_Consignees_Lost_ST_Final'
                			|| reportName == 'Top_5_Consignees_LT_Final') {
                	System.debug('**** account filteR: ' + filterDef.value);
                	reportFilters.add( new Reports.ReportFilter('Shipper_Consignee__c.Account_ID__c', 'equals', filterDef.value) );
                		
            	} else {
            		reportFilters.add( new Reports.ReportFilter('ACCOUNT_ID', 'equals', filterDef.value) );     
            	} 
                
            } else if ( filterDef.column == 'USERS.NAME') { 
                if ( reportName == 'Top_5_Shippers_Lost_ST_Final'
                			|| reportName == 'Top_5_Shippers_Lost_LT'
                			|| reportName == 'Top_5_Consignees_Lost_ST_Final'
                			|| reportName == 'Top_5_Consignees_LT_Final') { 
                	// these report types behind these reports to not reference the Account object
                	//  so we have to ignore these Account Owner			
                } else {
                    reportFilters.add( new Reports.ReportFilter('USERS.NAME', 'equals', filterDef.value) );
                }             
            } else if ( filterDef.column == 'Probill__c.Delivery_Start__c'
        					|| filterDef.column == 'Probill__c.Pickup_Day__c') {
                dateFilter = filterDef.value;
            }
           
        }
                
        // ignore date filter for these reports:
        //	-- Top_5_Shippers_Lost_ST_Final
        
        if (dateFilter != null 
     			&& reportName != 'Top_5_Shippers_Lost_ST_Final'
                && reportName != 'Top_5_Shippers_Lost_LT'
                && reportName != 'Top_5_Consignees_Lost_ST_Final'
              	&& reportName != 'Top_5_Consignees_LT_Final'  ) {
            sdf.setDurationValue( dateFilter );
        } else {
            Reports.StandardDateFilter none = new Reports.StandardDateFilter();
            sdf = none;
        }
           
        // add filters to report
        reportMetadata.setReportFilters( reportFilters );
        
        String filterLogic='';
        
    	for ( Integer i = 0; i < reportFilters.size(); i++ ) {
    		filterLogic += String.valueOf(i+1);
        	if ( i < reportFilters.size()-1 ) {
        		filterLogic += ' AND ';
        	}
    	}	
        
        //System.debug('*** reportName: ' + reportName);	
        //System.debug('*** reportFilters' + reportFilters);	
       
        reportMetadata.setReportBooleanFilter( filterLogic );
               
        // Run a report
        Reports.ReportInstance ri;
        Boolean isTabular = false;
        if (reportMetadata.getReportFormat() == Reports.ReportFormat.TABULAR ){ 
        	isTabular = true;
        }
        ri = Reports.ReportManager.runAsyncReport(reportId, reportMetadata, isTabular);
        
        return ri.getId();
        
    }
        

    public class ReportResult {
        
        public String status;
       // public Object metadata;
        public Object reportResults;
    }
    

    
    public List<SelectOption> DateOptions{
        get{
            List<SelectOption> results = new List<SelectOption>();
            results.add(new SelectOption('This Month', 'This Month'));
            results.add(new SelectOption('This Quarter', 'This Quarter'));
            results.add(new SelectOption('This Year', 'This Year'));
            results.add(new SelectOption('Last Month', 'Last Month'));
            results.add(new SelectOption('Last Quarter', 'Last Quarter'));
            results.add(new SelectOption('Last Year', 'Last Year'));
            results.add(new SelectOption('Last 2 Years', 'Last 2 Years'));
            return results;
        }
        set;
    }
    
    public List<SelectOption> UserOptions{
        get{
            List<SelectOption> results = new List<SelectOption>();
            results.add(new SelectOption('', '--None--'));
            for(User u : [select Name from User where IsActive = true]){
                results.add(new SelectOption(u.Name, u.Name));
            }
            return results;
        }
        set;
    }
     public List<SelectOption> ManagerOptions{
        get{
            List<SelectOption> results = new List<SelectOption>();
            results.add(new SelectOption('', '--None--'));
            for(User u : [select Name from User where IsActive = true AND Profile.name = 'Sales Manager']){
                results.add(new SelectOption(u.Name, u.Name));
            }
            return results;
        }
        set;
    }
   
    public List<SelectOption> CategoryOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--None--'));           
            Schema.DescribeFieldResult fieldResult =  Probill_Accessorial__c.Category__c.getDescribe();
            
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
                   for( Schema.PicklistEntry f : ple){
                      options.add(new SelectOption(f.getLabel(), f.getValue()));
                   }       
                   return options;

        }
        set;
    }
    
    public PageReference setNewReportFilters(){
        ReportFilter = '[';
        ReportFilter2 = '[';
        ReportFilter3 = '[';
        String filterDateItem = '';
        String filterAcctIdItem = '';
        String filterAcctOwnerItem = '';
        String filterManagerItem = '';
        String filterCategoryItem = '';
        if(DateFilterOption != null && DateFilterOption != ''){
            
            if(DateFilterOption.toLowerCase() == 'this month'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"THIS_MONTH"},';
            }
            else if(DateFilterOption.toLowerCase() == 'this quarter'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"THIS_QUARTER"},';
            }
            else if(DateFilterOption.toLowerCase() == 'this year'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"THIS_YEAR"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last month'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"LAST_MONTH"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last quarter'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"LAST_QUARTER"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last YEAR'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"greaterOrEqual",';
                filterDateItem += 'value:"LAST_YEAR"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last 2 years'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"greaterOrEqual",';
                filterDateItem += 'value:"LAST_N_YEARS:2"},';
            }
            
        }
        if(filterContact.AccountId != null){
            filterAcctIdItem = '{column:"ACCOUNT_ID",operator:"equals",value:"' + filterContact.AccountId + '"},';
        }//USERS.NAME
        if(TerritoryUser != null && TerritoryUser != ''){
            filterAcctOwnerItem = '{column:"USERS.NAME",operator:"equals",value:"' + TerritoryUser + '"},';
        }
        
        ReportFilter += filterDateItem;
        ReportFilter += filterAcctIdItem;
        ReportFilter += filterAcctOwnerItem;              
        if(ReportFilter.contains(',')){
            ReportFilter = ReportFilter.substring(0, ReportFilter.length() - 1);
        }
        ReportFilter += ']';
        
        ReportFilter2 += filterAcctIdItem;
        ReportFilter2 += filterAcctOwnerItem;
        ReportFilter2 += filterManagerItem;       
        if(ReportFilter2.contains(',')){
            ReportFilter2 = ReportFilter2.substring(0, ReportFilter2.length() - 1);
        }
        ReportFilter2 += ']';
        
        if(Manager != null && Manager != '') {
             filterManagerItem = '{column:"Probill_Accessorial__c.Probill__c.Account__c.Owner.Manager.Name",operator:"equals",value:"' + Manager + '"},';
        }
        if(Category != null && Category != ''){
                filterCategoryItem = '{column:"Probill_Accessorial__c.Category__c", operator: "equals", value: "' + Category + ' "},';
        }
        
        ReportFilter3 += filterAcctIdItem;
        ReportFilter3 += filterManagerItem;
        ReportFilter3 += filterCategoryItem;
        
        if(ReportFilter3.contains(',')){
            ReportFilter3 = ReportFilter3.substring(0, ReportFilter3.length() - 1);
        }
        ReportFilter3 += ']';
        
        return null;
    }
    
    private void initFilter() {
    	
    	//System.debug('*** acctId in initFilter' + acctId);
    	
        ReportFilter = '[';
        ReportFilter2 = '[';
        ReportFilter3 = '[';
        String filterDateItem = '';
        String filterAcctIdItem = '';
        String filterAcctOwnerItem = '';
        String filterManagerItem = '';
        String filterCategoryItem = '';
        if(filterDate != null){          
            if(DateFilterOption.toLowerCase() == 'this month'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"THIS_MONTH"},';
            }
            else if(DateFilterOption.toLowerCase() == 'this quarter'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"THIS_QUARTER"},';
            }
            else if(DateFilterOption.toLowerCase() == 'this year'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"THIS_YEAR"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last month'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"LAST_MONTH"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last quarter'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"equals",';
                filterDateItem += 'value:"LAST_QUARTER"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last YEAR'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"greaterOrEqual",';
                filterDateItem += 'value:"LAST_YEAR"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last 2 years'){
                filterDateItem = '{column:"Probill__c.Pickup_Day__c", operator:"greaterOrEqual",';
                filterDateItem += 'value:"LAST_N_YEARS:2"},';
            }
        }
        //System.debug('*** here' + acctId);
        if(acctId != null){
            filterAcctIdItem = '{column:"ACCOUNT_ID",operator:"equals",value:"' + acctId + '"},';
        }
        
        
       // if(acctOwner != null && acctOwner != ''){
        if(TerritoryUser != null && TerritoryUser != ''){
            filterAcctOwnerItem = '{column:"USERS.NAME",operator:"equals",value:"' + TerritoryUser + '"},';
        }
        ReportFilter += filterDateItem;
        ReportFilter += filterAcctIdItem;
        ReportFilter += filterAcctOwnerItem;
        if(ReportFilter.contains(',')){
            ReportFilter = ReportFilter.substring(0, ReportFilter.length() - 1);
        }
        ReportFilter += ']';
        ReportFilter2 += filterAcctIdItem;
        ReportFilter2 += filterAcctOwnerItem;
        
        if(ReportFilter2.contains(',')){
            ReportFilter2 = ReportFilter2.substring(0, ReportFilter2.length() - 1);
        }
        ReportFilter2 += ']';
        
        if(Manager != null && Manager != '') {
            filterManagerItem = '{column:"Probill_Accessorial__c.Probill__c.Account__c.Owner.Manager.Name",operator:"equals",value:"' + Manager + '"},';
        }
        if(Category != null && Category != ''){
                filterCategoryItem = '{column:"Probill_Accessorial__c.Category__c",operator:"equals",value:"' + Category + '"},';
                
        }
        
        ReportFilter3 += filterAcctIdItem;
        ReportFilter3 += filterManagerItem;
        ReportFilter3 += filterCategoryItem;
        
        if(ReportFilter3.contains(',')){
            ReportFilter3 = ReportFilter3.substring(0, ReportFilter3.length() - 1);
        }
        ReportFilter3 += ']';
        
    
    }
        
  
}