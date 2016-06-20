@isTest
private class CustomerDashboardCtrlTest {

    @isTest
    static void testController()
    {
        Account testAcct = new Account();
        testAcct.Name = 'Lucian239786';
        testAcct.DYLT_Account__c = 'Lucian2511';
        insert testAcct;
        
        Integer month = date.today().month();
        if(month < 4)
        {
            month = 1;
        }
        else if(month >= 4 && month < 7)
        {
            month = 4;
        }
        else if(month >= 7 && month < 10)
        {
            month = 7;
        }
        else if(month >= 10 && month <= 12)
        {
            month = 10;
        }
        Date quoteStart = date.newinstance(date.today().year(), month, 1);
        Probill__c testProb1 = new Probill__c(Account__c = testAcct.Id, Name = 'test1', Probill__c = '123sdg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart);
        Probill__c testProb2 = new Probill__c(Account__c = testAcct.Id, Name = 'test2', Probill__c = '123srg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart.addMOnths(1));
        Probill__c testProb3 = new Probill__c(Account__c = testAcct.Id, Name = 'test3', Probill__c = '123sjg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart.addMOnths(2));
        insert new List<Probill__c> {testProb1, testProb2, testProb3};
        PageReference testPage = new PageReference('/apex/CustomerDashboard?pv0=' + testAcct.Id + '&pv1=this quarter&pv2=' + userinfo.getUsername());
        test.setCurrentPage(testPage);
        ApexPages.currentPage().getparameters().put('date', 'this quarter');
        CustomerDashboardCtrl controller = new CustomerDashboardCtrl();
        ApexPages.currentPage().getparameters().put('date', 'this month');
        controller = new CustomerDashboardCtrl();
        ApexPages.currentPage().getparameters().put('date', 'this year');
        controller = new CustomerDashboardCtrl();
        ApexPages.currentPage().getparameters().put('date', 'last 2 years');
        controller = new CustomerDashboardCtrl();
        ApexPages.currentPage().getparameters().put('date', 'last quarter');
        controller = new CustomerDashboardCtrl();
        ApexPages.currentPage().getparameters().put('date', 'last YEAR');
        controller = new CustomerDashboardCtrl();
        ApexPages.currentPage().getparameters().put('date', 'last month');
        controller = new CustomerDashboardCtrl();
        system.assert(controller.DateOptions != null);
        system.assert(controller.UserOptions != null);
        controller.TerritoryUser = userinfo.getUsername();
        controller.DateFilterOption = 'this quarter';
        controller.setNewReportFilters();
        controller.DateFilterOption = 'this month';
        controller.setNewReportFilters();
        controller.DateFilterOption = 'this year';
        controller.setNewReportFilters();
        controller.DateFilterOption = 'last month';
        controller.setNewReportFilters();
        controller.DateFilterOption = 'last quarter';
        controller.setNewReportFilters();
        controller.DateFilterOption = 'last YEAR';
        controller.setNewReportFilters();
        controller.DateFilterOption = 'last 2 years';
        controller.setNewReportFilters();
        string baseUrl = controller.baseUrl;
        List<SelectOption> options = controller.ManagerOptions;
        options = controller.CategoryOptions;

    }
    
    @isTest(SeeAllData = true)
    static void testReports()
    {
    	List<CustomerDashboardCtrl.FilterDefinition> filterList = new List<CustomerDashboardCtrl.FilterDefinition>();
    	CustomerDashboardCtrl.FilterDefinition filter = new CustomerDashboardCtrl.FilterDefinition();
    	filter.column = 'USERS.NAME';
    	filter.operator = '=';
    	filter.value = UserInfo.getUserName();
    	filterList.add(filter);
    	CustomerDashboardCtrl.runReportAsync('Top_5_Shippers_Lost_ST_Final', '', filterList);
    }
    
}