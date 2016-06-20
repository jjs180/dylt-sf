@isTest
public class testBusinessbyLaneConsigneeController
{
    @isTest
    static void testController()
    {
        Account testAcct =  new Account(DYLT_Account__c=String.ValueOf(Math.Random()*100000000).right(10),Name='test1',BillingStreet='121 street',BillingCity='test city1',BillingState='California',BillingPostalCode='12356',Phone='1231121325',Fax='8485652512');
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
        Probill__c testProb1 = new Probill__c(Account__c = testAcct.Id, Name = 'test1', Shipper_Name__c = 'A', Consignee_State__c = 'A', Probill__c = '123sdg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart);
        Probill__c testProb2 = new Probill__c(Account__c = testAcct.Id, Name = 'test2', Shipper_Name__c = 'A', Consignee_State__c = 'B', Probill__c = '123srg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart.addMOnths(1));
        Probill__c testProb3 = new Probill__c(Account__c = testAcct.Id, Name = 'test3', Shipper_Name__c = 'B', Consignee_State__c = 'A', Probill__c = '123sjg', Paid_Amount__c = 1000, Delivery_Start__c = quoteStart.addMOnths(2));
        insert new List<Probill__c> {testProb1, testProb2, testProb3};
        
        BusinessbyLaneConsigneeController controller = new BusinessbyLaneConsigneeController();        
       	
       	// create filter criteria
       	List<BusinessbyLaneConsigneeController.FilterDefinition> filterCriteria = new List<BusinessbyLaneConsigneeController.FilterDefinition>();
        BusinessbyLaneConsigneeController.FilterDefinition filterDef = new BusinessbyLaneConsigneeController.FilterDefinition();
        filterDef.column = 'Probill__c.Delivery_Start__c';
        filterDef.value='THIS_YEAR';
        filterCriteria.add( filterDef );
        		
        BusinessbyLaneConsigneeController.getConsignees(filterCriteria);
    
    }
}