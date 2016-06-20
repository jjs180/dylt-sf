public class presentationController2 {
    //private String filterDate = ApexPages.currentPage().getparameters().get('pv0');
    //private String acctId = ApexPages.currentPage().getparameters().get('pv1');
    //private String acctOwner = ApexPages.currentPage().getparameters().get('pv2');
   //private String Manager = ApexPages.currentPage().getparameters().get('ma');
   //private String accCategory = ApexPages.currentPage().getparameters().get('cat');
	private String presentationId = ApexPages.currentPage().getparameters().get('pId');
    
    public presentationController2(){
        //initFilter();
        //filterContact = new COntact();
    }
    
    //public String ReportFilter { get; set; }
    //public String ReportFilter2 { get; set; }
    //public String ReportFilter3 {get;set;}
    //public String DateFilterOption { get; set; }
    //public CONTACT filterContact { get; set; }
    //public String TerritoryUser { get; set; }
    //public String Manager {get;set;}
    //public String Category {get;set;}
    
 	//get reports from presentation object
 	@RemoteAction
    public static List<String> getReports(String presId){
        List<String> reports = new List<String>();
         for (Presentation_Set_Two__c p: [SELECT Reports__c, Name, id FROM Presentation_Set_Two__c WHERE Presentation_Set_Two__c.Id =: presId])
            reports.add(p.Reports__c);        
        system.debug('----------------------------------------------------------------------------------------------------------------------reports' + reports);   
        return reports;		     
    }
      
    public List<String> getSelectedReports() {
        String presentationId = presentationId;
        
        system.debug('-----------------------------------------------------------------presentationID====' + presentationId);
               
        List<String> reportsToPresent = new List<String>();
        List<String> reports = new List<String>();
        
        for (Presentation_Set_Two__c p: [SELECT Reports__c, Name, id FROM Presentation_Set_Two__c WHERE Presentation_Set_Two__c.Id =: presentationId])
    		reports.add(p.Reports__c);
        system.debug('-------------------------------reports2' + reports);
        return reports;
    }
    /*    
    public List<SelectOption> DateOptions{
        get{
            List<SelectOption> results = new List<SelectOption>();
            results.add(new SelectOption('', '--None--'));
            results.add(new SelectOption('This Quarter', 'This Quarter'));
            results.add(new SelectOption('This Year', 'This Year'));
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
        
        if(ReportFilter2.contains(',')){
            ReportFilter2 = ReportFilter2.substring(0, ReportFilter2.length() - 1);
        }
        ReportFilter2 += ']';
        if(Manager != null && Manager != '') {
             filterManagerItem = '{column:"Probill_Accessorial__c.Probill__c.Account__c.Owner.Manager.Name",operator:"equals",value:"' + Manager + '"},';
        }
        if(accCategory != null && accCategory != ''){
        	filterCategoryItem = '{column:"Probill_Accessorial__c.Category__c",operator:"equals",value:"' + accCategory + '"},';
        	//filterCategoryItem = '{column:"PROBILL_ACCESSORIAL__C.CATEGORY__c", operator: "equals", value: "' + accCategory + ' "},';
        }
        
       // ReportFilter3 += filterAcctIdItem;
        ReportFilter3 += filterManagerItem;
        ReportFilter3 += filterCategoryItem;
        
        if(ReportFilter3.contains(',')){
            ReportFilter3 = ReportFilter3.substring(0, ReportFilter3.length() - 1);
        }
        ReportFilter3 += ']';
        return null;
    }
    
    private void initFilter(){//ACCOUNT.NAME
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
        if(accCategory != null && accCategory != ''){
       		filterCategoryItem = '{column:"Probill_Accessorial__c.Category__c",operator:"equals",value:"' + accCategory + '"},';
       		//filterCategoryItem = '{column:"Probill_Accessorial__c.Category__c",operator:"equals",value:"' + Category + '"},';
        	//filterCategoryItem = '{column:"Probill_Accessorial__c.CATEGORY__c",operator:"equals",value:"' + Manager + '"},';
        }
        
        //ReportFilter3 += filterAcctIdItem;
        ReportFilter3 += filterManagerItem;
        ReportFilter3 += filterCategoryItem;
        
        if(ReportFilter3.contains(',')){
            ReportFilter3 = ReportFilter3.substring(0, ReportFilter3.length() - 1);
        }
        ReportFilter3 += ']';
    }*/
}