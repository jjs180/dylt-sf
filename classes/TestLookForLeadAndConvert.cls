@isTest
public class TestLookForLeadAndConvert
{
    @isTest
    public static void testLeadConvert()
    {
    	Lead l = new Lead();
    	l.LastName = 'Lucian352863';
    	l.TruckMate_Id__c = 'Lucian1259';
    	l.Company = 'Lucian992370';
    	l.Lead_Stage__c = '1 - Identification';
    	insert l;
        
        Account acc = new Account(DYLT_Account__c = 'Lucian1259', Name = 'Lucian232865');
        insert acc;
    }
}