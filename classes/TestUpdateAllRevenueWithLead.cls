@isTest
public class TestUpdateAllRevenueWithLead
{
    @isTest
    public static void testUpdate()
    {
    	Account a = new Account();
	 	a.Name = 'Lucian384722';
	 	a.DYLT_Account__c = 'Lucian1998';
	 	insert a;
	 	
	 	Lead l = new Lead();
	 	l.LastName = 'Lucian175284';
	 	l.Company = 'Lucian110934';
	 	l.TruckMate_Id__c = 'Lucian1998';
	 	l.Lead_Stage__c = '1 - Identification';
	 	insert l;
	 	
	 	Test.startTest();
	 	
	 	Probill__c probill = new Probill__c(Name = 'Test', Probill__c = '0p9olmkjn', Account__c = a.Id, Rev_Cont_Total__c = 123.21, Rev_Curr_Total__c = 21);
        insert probill;
	 	
	 	Test.stopTest();
	 	
	 	l = [SELECT All_Revenue__c FROM Lead WHERE Id = :l.Id];
	 	System.assertEquals(21, l.All_Revenue__c);
    }
}