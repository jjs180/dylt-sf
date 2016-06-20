public class Top5ShippersLostController
{
    public String ReportFIlter {get; set; }
    
    @RemoteAction
    public static List<ShipperInfo> getTop5Shippers(String theReportFilter)
    {
        List<ShipperInfo> results = new List<ShipperInfo>();
        theReportFilter = theReportFilter.replace('[', '').replace(']', '');
        Map<String, String> reportDateFilterMap = null;
        Map<String, String> reportAccountIdFilterMap = null;
        Map<String, String> reportAccountOwnerFilterMap = null;
        String accountIdFilter = null;
        String acountOwnerFilter  = null;
        String dateFilter = null;
        AggregateResult[] groupedResults;
        //[select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Paid_Amount__c) sum from Probill__c where Shipper_Name__c != null and Account__r.Date_Lost__c != null group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
        if(theReportFilter != '')
        {
            if(theReportFilter.contains('001'))
            {//system.debug();
                accountIdFilter = theReportFilter.subString(theReportFilter.indexOf('001'), theReportFilter.indexOf('001') + 15);
            }
            if(theReportFilter.contains('THIS_MONTH'))
            {
                groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Paid_Amount__c) sum from Probill__c where Shipper_Name__c != null and Account__r.Date_Lost__c != null and Delivery_Start__c = THIS_MONTH group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
            }
            else if(theReportFilter.contains('THIS_QUARTER'))
            {
                groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Paid_Amount__c) sum from Probill__c where Shipper_Name__c != null and Account__r.Date_Lost__c != null and Delivery_Start__c = THIS_QUARTER group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
            }
            else if(theReportFilter.contains('THIS_YEAR'))
            {
                groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Paid_Amount__c) sum from Probill__c where Shipper_Name__c != null and Account__r.Date_Lost__c != null and Delivery_Start__c = THIS_YEAR group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
            }
            if(accountIdFilter != null)
            {
                groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Paid_Amount__c) sum from Probill__c where Shipper_Name__c != null and Account__r.Date_Lost__c != null and Account__c = :accountIdFilter group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
                if(theReportFilter.contains('THIS_MONTH'))
                {
                    groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Paid_Amount__c) sum from Probill__c where Shipper_Name__c != null and Account__r.Date_Lost__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_MONTH group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
                }
                else if(theReportFilter.contains('THIS_QUARTER'))
                {
                    groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Paid_Amount__c) sum from Probill__c where Shipper_Name__c != null and Account__r.Date_Lost__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_QUARTER group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
                }
                else if(theReportFilter.contains('THIS_YEAR'))
                {
                    groupedResults = [select Shipper_Name__c shippername, Shipper_State__c shippingstate, SUM(Paid_Amount__c) sum from Probill__c where Shipper_Name__c != null and Account__r.Date_Lost__c != null and Account__c = :accountIdFilter and Delivery_Start__c = THIS_YEAR group by Shipper_Name__c, Shipper_State__c ORDER BY Sum(Paid_Amount__c) DESC limit 5];
                }
            }
        }
        for(AggregateResult groupedResult : groupedResults)
        {
            ShipperInfo result = new ShipperInfo();
            result.ShipperName = (String)groupedResult.get('shippername');
            result.ShiperState = (String)groupedResult.get('shippingstate');
            result.PaidAmount = (Decimal)groupedResult.get('sum');
            results.add(result);
        }
        return results;
    }
    
    public class ShipperInfo
    {
        public String ShipperName { get; set; }
        public String ShiperState { get; set; }
        public Decimal PaidAmount { get; set; }
    }
}