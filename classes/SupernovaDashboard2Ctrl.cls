public class SupernovaDashboard2Ctrl {
    public String defaultTimePeriod {
    	get {
    		return 'THIS_MONTH';
    	}
    	set;
    }
    
    public List<SelectOption> managerOptions {
    	get {
    		List<SelectOption> managerOptions = new List<SelectOption>();    			 
    		managerOptions.add( new SelectOption( 'none', '--None--' ));
    		managerOptions.add( new SelectOption( 'DWIEDERMAN', 'David Wiederman' ));
    		managerOptions.add( new SelectOption( 'DMOLLARD', 'David Mollard' ));
    		managerOptions.add( new SelectOption( 'JCHRISTMAN', 'Josh Christman' ));
    		managerOptions.add( new SelectOption( 'JMCCABE', 'John McCabe' ));
    		managerOptions.add( new SelectOption( 'WCHRISTENSEN', 'Bill Christensen' ));
            
            						
    		return managerOptions;
    	}
    	set;
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
    public static String runReportAsync(String reportName, String viewName, String dateFilter, String managerFilter) {
        // get the id of the report we want to run
        List <Report> reportList = [SELECT Id,DeveloperName FROM Report where DeveloperName = :reportName];
        String reportId = (String)reportList.get(0).get('Id');
        
        // set report  filters
        Reports.ReportMetadata reportMetadata = Reports.ReportManager.describeReport( reportId ).getReportMetadata();

        // set standard date filter
        Reports.StandardDateFilter sdf = reportMetadata.getStandardDateFilter();
        if( dateFilter == 'none') {
            // dateFilter = '';
            Reports.StandardDateFilter none = new Reports.StandardDateFilter();
            sdf = none;
        } else {
            sdf.setDurationValue( dateFilter );
        }
               
       
        // Set custom report fitlers
        List<Reports.ReportFilter> reportFilters = new List<Reports.ReportFilter>();
    	
    	if ( viewName == 'DirectorSupernovaView' || 
    			viewName == 'DirectorTeamSupernovaView' ||
    			viewName == 'DirectorHypernovaView' ) {
	    	
	    	// set manager filter
	        if ( managerFilter != 'none') {
	        	// the filter string is case sensitive
	           reportFilters.add( new Reports.ReportFilter('Supernova__c.AE_Manager_ID__c', 'equals', managerFilter) );
	        }
    	}
         
        // add filters to report
        reportMetadata.setReportFilters( reportFilters );
       
        // Run a report
        Reports.ReportInstance ri = Reports.ReportManager.runAsyncReport(reportId, reportMetadata);
        return ri.getId();
        
    }
        

    @RemoteAction
    public static List<User> getAllUsers() {
            List<User> userList = [Select Id, Name, SmallPhotoUrl
                                                            From User];                                      
            return userList;    
        }
        
        
    
    public static void setStandardDateFilter( ) {
       /* Reports.StandardDateFilter sdf = reportMetadata.getStandardDateFilter();
        if( dateFilter == 'none') {
            // dateFilter = '';
            Reports.StandardDateFilter none = new Reports.StandardDateFilter();
            sdf = none;
        } else {
            sdf.setDurationValue( dateFilter );
        }
        */
    }
    
    public class ReportResult {
        
        public String status;
       // public Object metadata;
        public Object reportResults;
    }
    
 
    
    
}