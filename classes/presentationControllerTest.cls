@isTest
public class presentationControllerTest {

    @isTest(seeAllData = true)
    static void testController(){
        Account testAcct =  [select Id from Account limit 1];
       
        Integer month = date.today().month();
        if(month < 4){
            month = 1;
        }
        else if(month >= 4 && month < 7){
            month = 4;
        }
        else if(month >= 7 && month < 10){
            month = 7;
        }
        else if(month >= 10 && month <= 12){
            month = 10;
        }
        Date quoteStart = date.newinstance(date.today().year(), month, 1);
        Probill__c testProb1 = new Probill__c(Account__c = testAcct.Id, Name = 'test1', Probill__c = '123sdg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart);
        Probill__c testProb2 = new Probill__c(Account__c = testAcct.Id, Name = 'test2', Probill__c = '123srg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart.addMOnths(1));
        Probill__c testProb3 = new Probill__c(Account__c = testAcct.Id, Name = 'test3', Probill__c = '123sjg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart.addMOnths(2));
        
        //insert testProb1;
        //insert testProb2;
        //insert testProb3;
        
        //List<String> testReports = new List<String>{'Average Days in Transit'};
        Presentation__c testPresentation = new Presentation__c(Account__c = testAcct.Id, Name = 'testPress', Reports__c = 'Business by Lane-Consignee');
        insert testPresentation;
        
        
        PageReference testPage = new PageReference('/apex/presentation?pId=' + testPresentation.Id  + 'pv0=' + testAcct.Id + '&pv1=this quarter&pv2=' + userinfo.getUsername());
        test.setCurrentPage(testPage);
        presentationController controller = new presentationController();
        system.assert(controller.DateOptions != null);
        system.assert(controller.UserOptions != null);
        String DateFilterOption = 'this quarter';
        String TerritoryUser = userinfo.getUsername();
        String ReportFilter = '[';
        String ReportFilter2 = '[]';
        Date filterDateItem = date.newinstance(date.today().year(), month,1);
        controller.setNewReportFilters();
        
       	List<SelectOption> dateOptions = controller.DateOptions;
        List<SelectOption> userOptions = controller.UserOptions;
    }

	@isTest (seeAllData = true)
	static void testGetSelectedReports(){
		presentationController testController = new presentationController();
		Account testAcct =  [select Id from Account limit 1];
		Presentation__c testPresentation = new Presentation__c(Account__c = testAcct.Id, Name = 'testPress', Reports__c = 'Business by Lane-Consignee');
        insert testPresentation;
        List<String> reportsToPresent = new List<String>();
        reportsToPresent.add('report1');
        List<String> reports = new List<String>();
        reports.add('report3');
        List<String> testReports = testController.getSelectedReports();
        //System.assertEquals('report1', testReports);
	}
	@isTest (seeAllData = true)	
	static void testGetReports(){
		presentationController testController = new presentationController();
		Account testAcct =  [select Id from Account limit 1];
		Presentation__c testPresentation = new Presentation__c(Account__c = testAcct.Id, Name = 'testPress', Reports__c = 'Business by Lane-Consignee');
        insert testPresentation;
        String testId = testPresentation.id;
        List<String> reportsToPresent = new List<String>();
        reportsToPresent.add('report1');
        List<String> reports = new List<String>();
        reports.add('report3');
        presentationController.getReports(testId);
	}
	
	
	public static List<String> getReports(String presId){
        List<String> reports = new List<String>();
         for (Presentation__c p: [SELECT Reports__c, Name, id FROM Presentation__c WHERE Presentation__c.Id =: presId])
            reports.add(p.Reports__c);        
        system.debug('----------------------------------------------------------------------------------------------------------------------reports' + reports);   
        return reports;		     
    }
	
	@isTest (seeAllData = true)
	static void testDateOptions(){
		presentationController testController = new presentationController();
		List<SelectOption> testResults = new List<SelectOption>();
		testResults.add(new SelectOption('', '--None--'));
        testResults.add(new SelectOption('This Quarter', 'This Quarter'));
        testResults.add(new SelectOption('This Year', 'This Year'));
       // List<SelectOption> testResults = testController.DateOptions();
		
	}
	
	
	
	
	
    





}