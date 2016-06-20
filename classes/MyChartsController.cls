public class MyChartsController
{
    private String filterDate = ApexPages.currentPage().getparameters().get('date');
    // value is case sensitive ie date=This Year
    
    private String acctId = ApexPages.currentPage().getparameters().get('account');
    private String acctOwner = ApexPages.currentPage().getparameters().get('owner');
    
    
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
    	 set; }
    public COntact filterContact { get; set; }
    public String TerritoryUser { get; set; }
    public String Manager {get;set;}
    public String Category {get;set;}
    
    
    public MyChartsController(){
		if ( filterDate == null ) {
			filterDate = 'This Month';
		} else {
			DateFilterOption = filterDate;
		}
		
        initFilter();
        filterContact = new COntact();
        
        
        
        if ( acctId != null ) {
        	filterContact.AccountId = acctId;
        }
        
        if ( acctOwner != null ) {
        	TerritoryUser = acctOwner;
        }
               
        
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
            filterDateItem = '{column:"Probill__c.Delivery_Start__c", operator:"equals",';
            if(DateFilterOption.toLowerCase() == 'this month'){
                filterDateItem += 'value:"THIS_MONTH"},';
            }
            else if(DateFilterOption.toLowerCase() == 'this quarter'){
                filterDateItem += 'value:"THIS_QUARTER"},';
            }
            else if(DateFilterOption.toLowerCase() == 'this year'){
                filterDateItem += 'value:"THIS_YEAR"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last month'){
                filterDateItem += 'value:"LAST_MONTH"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last quarter'){
                filterDateItem += 'value:"LAST_QUARTER"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last YEAR'){
                filterDateItem += 'value:"LAST_YEAR"},';
            }
            else if(DateFilterOption.toLowerCase() == 'last 2 years'){
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
        ReportFilter = '[';
        ReportFilter2 = '[';
        ReportFilter3 = '[';
        String filterDateItem = '';
        String filterAcctIdItem = '';
        String filterAcctOwnerItem = '';
        String filterManagerItem = '';
        String filterCategoryItem = '';
        if(filterDate != null){
            filterDateItem = '{column:"Probill__c.Delivery_Start__c", operator:"equals",';
            if(filterDate.toLowerCase() == 'this month'){
                filterDateItem += 'value:"THIS_MONTH"},';
            }
            else if(filterDate.toLowerCase() == 'this quarter'){
                filterDateItem += 'value:"THIS_QUARTER"},';
            }
            else if(filterDate.toLowerCase() == 'this year'){
                filterDateItem += 'value:"THIS_YEAR"},';
            }
            else if(filterDate.toLowerCase() == 'last month'){
                filterDateItem += 'value:"LAST_MONTH"},';
            }
            else if(filterDate.toLowerCase() == 'last quarter'){
                filterDateItem += 'value:"LAST_QUARTER"},';
            }
            else if(filterDate.toLowerCase() == 'last year'){
                filterDateItem += 'value:"LAST_YEAR"},';
            }
            else if(filterDate.toLowerCase() == 'last 2 years'){
                filterDateItem += 'value:"LAST_N_YEARS:2"},';
            }
        }
        if(acctId != null){
            filterAcctIdItem = '{column:"ACCOUNT_ID",operator:"equals",value:"' + acctId + '"},';
        }
        if(acctOwner != null && acctOwner != ''){
            filterAcctOwnerItem = '{column:"USERS.NAME",operator:"equals",value:"' + acctOwner + '"},';
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
        
        
        System.debug('*** reportFilter : ' + ReportFilter);
    	System.debug('*** reportFilter2 : ' + ReportFilter2);
        System.debug('*** reportFilter3 : ' + ReportFilter3);
        
        
    }
    
    

    
}