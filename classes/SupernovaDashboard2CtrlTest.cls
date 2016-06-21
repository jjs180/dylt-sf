/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for the SupernovaDashboard2Ctrl class
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Initial implementation
* @author         Lucian Ciobanu   <lucian.ciobanu@deutoria.com>
* @created        2016-06-21
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Changes
*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
*/
@isTest
public class SupernovaDashboard2CtrlTest {
    
    @isTest(SeeAllData=true)
    public static void testReports() {
    	
    	Test.startTest();
    	
    	String reportId = [SELECT Id,DeveloperName FROM Report where DeveloperName = 'AE_Commissions' Limit 1].Id;
        Reports.ReportInstance ri = Reports.ReportManager.runAsyncReport(reportId);
        SupernovaDashboard2Ctrl.isReportDataReady( ri.getId() );
        
        SupernovaDashboard2Ctrl.runReportAsync('AE_Commissions', 'DirectorSupernovaView', 'none', 'none');
    	
    	Test.stopTest();
    	
    }
    
    @isTest
    public static void testOther() {
    	
    	Test.startTest();
    	
    	SupernovaDashboard2Ctrl ctrl = new SupernovaDashboard2Ctrl();
    	
    	List<SelectOption> options = ctrl.ManagerOptions;
    	SupernovaDashboard2Ctrl.getAllUsers();
    	
    	Test.stopTest();
    	
    }
    
}