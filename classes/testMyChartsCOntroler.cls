@isTest
public class testMyChartsCOntroler
{
    @isTest(seeAllData = true)
    static void testController()
    {
        Account testAcct =  [select Id from Account limit 1];
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
        PageReference testPage = new PageReference('/apex/mycharts2?pv0=' + testAcct.Id + '&pv1=this quarter&pv2=' + userinfo.getUsername());
        test.setCurrentPage(testPage);
        MyChartsController controller = new MyChartsController();
        system.assert(controller.DateOptions != null);
        system.assert(controller.UserOptions != null);
        controller.DateFilterOption = 'this quarter';
        controller.TerritoryUser = userinfo.getUsername();
        controller.setNewReportFilters();
    }
}