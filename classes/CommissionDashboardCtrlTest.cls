@isTest( SeeAllData = true)
public class CommissionDashboardCtrlTest {
    
    
    static testMethod void testAll() {
        String dateFilter = 'none';
        String accountFilter = '';
        String accountExecFilter = 'none';
        
        CommissionDashboardCtrl ctrl = new CommissionDashboardCtrl();
        
        List<SelectOption> accountExecOptions = ctrl.accountExecOptions;
        
        CommissionDashboardCtrl.getDashboardSettings();
        
        CommissionDashboardCtrl.commissionReportData(dateFilter, accountFilter, accountExecFilter);
        
        
        String reportId = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'AE_Commissions' Limit 1].Id;
        Reports.ReportInstance ri = Reports.ReportManager.runAsyncReport(reportId);
        CommissionDashboardCtrl.isReportDataReady( ri.getId() );
        
    }

}