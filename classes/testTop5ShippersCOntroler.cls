@isTest
public class testTop5ShippersCOntroler
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
        Probill__c testProb1 = new Probill__c(Account__c = testAcct.Id, Name = 'test1', Shipper_Name__c = 'A', Probill__c = '123sdg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart);
        Probill__c testProb2 = new Probill__c(Account__c = testAcct.Id, Name = 'test2', Shipper_Name__c = 'A', Probill__c = '123srg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart.addMOnths(1));
        Probill__c testProb3 = new Probill__c(Account__c = testAcct.Id, Name = 'test3', Shipper_Name__c = 'B', Probill__c = '123sjg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart.addMOnths(2));
        insert new List<Probill__c> {testProb1, testProb2, testProb3};
        
        Test.startTest();
            Top5ShippersController controller = new Top5ShippersController();
           
           
           // create filter criteria
	       	List<Top5ShippersController.FilterDefinition> filterCriteria = new List<Top5ShippersController.FilterDefinition>();
	        Top5ShippersController.FilterDefinition filterDef = new Top5ShippersController.FilterDefinition();
	        filterDef.column = 'Probill__c.Delivery_Start__c';
	        filterDef.value='THIS_YEAR';
	        filterCriteria.add( filterDef );
           
           
            Top5ShippersController.getTop5Shippers(filterCriteria);
        Test.stopTest();
        
        
        
        
        

    }
}