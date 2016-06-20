public class Top5ConsigneesLostController
{
    public String ReportFIlter {get; set; }
    
    @RemoteAction
    public static List<ConsigneeInfo> getTop5Consignees(String theReportFilter)
    {
        List<ConsigneeInfo> results = new List<ConsigneeInfo>();
        theReportFilter = theReportFilter.replace('[', '').replace(']', '');
        Map<String, String> reportDateFilterMap = null;
        Map<String, String> reportAccountIdFilterMap = null;
        Map<String, String> reportAccountOwnerFilterMap = null;
        String accountIdFilter = null;
        String acountOwnerFilter  = null;
        String dateFilter = null;
        AggregateResult[] groupedResults; 
        
        //= [select Consignee_Name__c consigneeName, Consignee_State__c consigneeState, SUM(Paid_Amount__c) sum from Probill__c where Consignee_Name__c != null and Account__r.Date_Lost__c != null group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
        if(theReportFilter != '')
        {
            if(theReportFilter.contains('001'))
            {//system.debug();
                accountIdFilter = theReportFilter.subString(theReportFilter.indexOf('001'), theReportFilter.indexOf('001') + 15);
            }
            if(theReportFilter.contains('THIS_MONTH'))
            {
                groupedResults = [select Consignee_Name__c consigneeName, Consignee_State__c consigneeState, SUM(Paid_Amount__c) sum from Probill__c where Delivery_Start__c = THIS_MONTH and Consignee_Name__c != null and Account__r.Date_Lost__c != null group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
            }
            else if(theReportFilter.contains('THIS_QUARTER'))
            {
                groupedResults = [select Consignee_Name__c consigneeName, Consignee_State__c consigneeState, SUM(Paid_Amount__c) sum from Probill__c where Delivery_Start__c = THIS_QUARTER and Consignee_Name__c != null and Account__r.Date_Lost__c != null group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
            }
            else if(theReportFilter.contains('THIS_YEAR'))
            {
                groupedResults = [select Consignee_Name__c consigneeName, Consignee_State__c consigneeState, SUM(Paid_Amount__c) sum from Probill__c where Delivery_Start__c = THIS_YEAR and Consignee_Name__c != null and Account__r.Date_Lost__c != null group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
            }
            if(accountIdFilter != null)
            {
                groupedResults = [select Consignee_Name__c consigneeName, Consignee_State__c consigneeState, SUM(Paid_Amount__c) sum from Probill__c where Account__c = :accountIdFilter and Consignee_Name__c != null and Account__r.Date_Lost__c != null group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
                if(theReportFilter.contains('THIS_MONTH'))
                {
                    groupedResults = [select Consignee_Name__c consigneeName, Consignee_State__c consigneeState, SUM(Paid_Amount__c) sum from Probill__c where Account__c = :accountIdFilter and Delivery_Start__c = THIS_MONTH and Consignee_Name__c != null and Account__r.Date_Lost__c != null group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
                }
                else if(theReportFilter.contains('THIS_QUARTER'))
                {
                    groupedResults = [select Consignee_Name__c consigneeName, Consignee_State__c consigneeState, SUM(Paid_Amount__c) sum from Probill__c where Account__c = :accountIdFilter and Delivery_Start__c = THIS_QUARTER and Consignee_Name__c != null and Account__r.Date_Lost__c != null group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
                }
                else if(theReportFilter.contains('THIS_YEAR'))
                {
                    groupedResults = [select Consignee_Name__c consigneeName, Consignee_State__c consigneeState, SUM(Paid_Amount__c) sum from Probill__c where Account__c = :accountIdFilter and Delivery_Start__c = THIS_YEAR and Consignee_Name__c != null and Account__r.Date_Lost__c != null group by Consignee_Name__c,Consignee_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
                }
            }
        }
        for(AggregateResult groupedResult : groupedResults)
        {
            ConsigneeInfo result = new ConsigneeInfo();
            result.ConsigneeName = (String)groupedResult.get('consigneeName');
            result.ConsigneeState = (String)groupedResult.get('consigneeState');
            result.PaidAmount = (Decimal)groupedResult.get('sum');
            results.add(result);
        }
        return results;
    }
    
    public class ConsigneeInfo
    {
        public String ConsigneeName { get; set; }
        public String ConsigneeState { get; set; }
        public Decimal PaidAmount { get; set; }
    }
}