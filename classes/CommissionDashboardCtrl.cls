public class CommissionDashboardCtrl {
    public Account accountProxy {get; set;}
   
   
    @RemoteAction
    public static Object getDashboardSettings( ) {
        DashboardSettings dbs = new DashboardSettings();
       
        Map<String, Commission_Dashboard_Drilldown_Settings__c> mcs = Commission_Dashboard_Drilldown_Settings__c.getAll();
        dbs.CommissionDashboardDrilldownSettings = mcs;
        dbs.AllCommissionsDrilldownReportId = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'All_Commission_Drill_Down' Limit 1].Id;
        dbs.MissedCommissionDrilldownReportId = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'Missed_Commission_Drill_Down' Limit 1].Id;

        return dbs;
    }
   
    
    @RemoteAction
    public static Object isReportDataReady( String reportInstanceId ) {
        Reports.ReportInstance ri = Reports.ReportManager.getReportInstance( reportInstanceId );
        
        Reports.ReportResults reportResults;
        List<Object> reportData = new List<Object>();

        if ( ri.getStatus() == 'Success') {
            reportResults = ri.getReportResults();
            // Get the report metadata
            Reports.ReportMetadata rm = reportResults.getReportMetadata();
    
            Map<String,Reports.ReportFact> factMap = reportResults.getFactMap();
            

            List<Reports.GroupingValue> groupingVals = reportResults.getGroupingsAcross().getGroupings();
            
            for( Reports.GroupingValue grp: groupingVals) {
                
                List<Reports.SummaryValue> aggregates = factMap.get( 'T!' + grp.getKey() ).getAggregates();

                Decimal drawCurrent = (Decimal)aggregates[0].getValue();
                Decimal commissionAmount = (Decimal)aggregates[1].getValue();
                Decimal missedCommission = (Decimal)aggregates[2].getValue();
                Decimal commissionGowthAmount = (Decimal)aggregates[3].getValue();

                // data valudation
                // 1.  if pickup date is null then skip
                
                if( grp.getLabel() != null ) {  // grp.getLabel() is the pickup date
                    reportData.add( new List<Object>{ grp.getLabel(), drawCurrent, commissionAmount, missedCommission, commissionGowthAmount  } );
                }
            }
                
        } else {
            // not ready
        }
         
        List<Object> result = new List<Object>();
        result.add( ri.getStatus());
        result.add( reportData );
        
        return result;
        
    }

    @RemoteAction
    public static String commissionReportData(String dateFilter, String accountFilter, String accountExecFilter) {
        // get the id of the report we want to run
        String reportId = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'AE_Commissions' Limit 1].Id;

        // set report  filters
        Reports.ReportMetadata reportMetadata = Reports.ReportManager.describeReport( reportId ).getReportMetadata();

        // set standard date filter
        Reports.StandardDateFilter sdf = reportMetadata.getStandardDateFilter();
        if( dateFilter == 'none') {
            Reports.StandardDateFilter none = new Reports.StandardDateFilter();
            sdf = none;
        } else {
            sdf.setDurationValue( dateFilter );
            
        }
        
        // Set custom report fitlers
        LIST<Reports.ReportFilter> reportFilters = new List<Reports.ReportFilter>();
    
        // set account executive filter
        if ( accountExecFilter != 'none') {
            reportFilters.add( new Reports.ReportFilter('Commission__c.Owner.Name', 'equals', accountExecFilter) );
        }
        
        // set account filter
        if ( accountFilter != '') {
           reportFilters.add( new Reports.ReportFilter('Commission__c.Rate_To_Account__c.Name', 'equals', accountFilter) );
           //reportFilters.add( new Reports.ReportFilter('Probill__c.Account__c.Name', 'equals', accountFilter) );
           
        }
        
        // add filters to report
        reportMetadata.setReportFilters( reportFilters );
        
        
        // Run a reports
        Reports.ReportInstance ri = Reports.ReportManager.runAsyncReport(reportId, reportMetadata);
        
        return ri.getId();
    }

    /*
    @RemoteAction
    public static List<Object> commissionReportData2(String dateFilter, String accountFilter, String accountExecFilter) {
        
        // get the id of the report we want to run
        List <Report> reportList = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'AE_Commissions'];
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
        LIST<Reports.ReportFilter> reportFilters = new List<Reports.ReportFilter>();
    
        // set account executive filter
        if ( accountExecFilter != 'none') {
            // TODO: why contains
            reportFilters.add( new Reports.ReportFilter('Commission__c.Owner.Name', 'contains', accountExecFilter) );
        }
        
        // set account filter
        if ( accountFilter != '') {
            reportFilters.add( new Reports.ReportFilter('Probill__c.Account__c.Name', 'contains', accountFilter) );
        }
        
        // add filters to report
        reportMetadata.setReportFilters( reportFilters );


        // Run a reportss
        
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, reportMetadata);

        // Get the report metadata
        Reports.ReportMetadata rm = results.getReportMetadata();
    
        MAP<String,Reports.ReportFact> factMap = results.getFactMap();
        System.debug('******* fact map:  ' + factMap);
        

        
        // ---------------------------------------------------
        
        //List<CommissionReportData> reportData = new List<CommissionReportData>();
        List<Object> reportData = new List<Object>();
        List<Reports.GroupingValue> groupingVals = results.getGroupingsDown().getGroupings();

        for( Reports.GroupingValue grp: groupingVals) {
            
            // get aggregate totals for this row
            List<Reports.SummaryValue> aggregates = factMap.get( grp.getKey() + '!T').getAggregates();
            Decimal drawCurrent = (Decimal)aggregates[0].getValue();
            Decimal commissionAmount = (Decimal)aggregates[1].getValue();
            Decimal missedCommission = (Decimal)aggregates[2].getValue();
            Decimal commissionGowthAmount = (Decimal)aggregates[3].getValue();
            
            // data valudation
            // 1.  if pickup date is null then skip
            
            if( grp.getLabel() != null ) {  // grp.getLabel() is the pickup date
                reportData.add( new List<Object>{ grp.getLabel(), drawCurrent, commissionAmount, missedCommission, commissionGowthAmount  } );
               
            }
        }
        return reportData;
        
    }
    */
    
     private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        // recursively get all sub roles
        Set<ID> currentRoleIds = new Set<ID>();
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null]) {
            currentRoleIds.add(userRole.Id);
        }
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0)  {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }
    
    public List<SelectOption> accountExecOptions {
        get
        {
            // only show users below the Sales role
            // get the Sales Role
            UserRole salesRole = [Select id, name
                                    From UserRole
                                    Where DeveloperName = 'Sales' Limit 1 ];
                      
            Set<Id> roles = new Set<Id> ();
            roles.add( salesRole.Id );
            Set<Id> subRoleIds = getAllSubRoleIds( roles );
            

            
            List<SelectOption> results = new List<SelectOption>();
            for(User u : [select Name from User where IsActive = true and userRoleId in :subRoleIds])
            {
                results.add(new SelectOption(u.Name, u.Name));
            }
            results.sort();
            results.add(0, new SelectOption('none', '--None--'));

            return results;
        }
        set;
    }
    
    public class DashboardSettings {
        public String AllCommissionsDrilldownReportId;
        public String MissedCommissionDrilldownReportId;
        public Object CommissionDashboardDrilldownSettings;
    }
    
    
}