public class MontlyRevenueController
{
    private static Map<Integer, String> monthMap = new Map<Integer, String>();
    
    private static void initMonthMap()
    {
        monthMap.put(1, 'Jan');
        monthMap.put(2, 'Feb');
        monthMap.put(3, 'Mar');
        monthMap.put(4, 'Apr');
        monthMap.put(5, 'May');
        monthMap.put(6, 'Jun');
        monthMap.put(7, 'Jul');
        monthMap.put(8, 'Aug');
        monthMap.put(9, 'Sep');
        monthMap.put(10, 'Oct');
        monthMap.put(11, 'Nov');
        monthMap.put(12, 'Dec');
    }
    
    public static String AccountId { get; set; }
    public static String CurrentYear { get; set; }
    public static String CurrentQuarter { get; set; }
    
    @RemoteAction
    public static List<MontlyRevenueInfo> getQuarterRevenues(String theAccountId, String theYear, String theQuarter)
    {
        initMonthMap();
        List<MontlyRevenueInfo> results = new List<MontlyRevenueInfo>();
        Date currentMonthFirstDay = null;
        Integer year = integer.valueof(theYear);
        integer month = null;
        if(theQuarter == '1')
        {
            month = 3;
        }
        else if(theQuarter == '2')
        {
            month = 6;
        }
        else if(theQuarter == '3')
        {
            month = 9;
        }
        else if(theQuarter == '4')
        {
            month = 12;
        }
         integer day = 1;
        currentMonthFirstDay = date.newinstance(year, month, day);
        //Date currentMonthFirstDay = Date.today().toStartOfMonth();
        Date lastMonthFirstDay = CurrentMonthFirstDay.addMonths(-1);
        Date lastLastMonthFirstday = CurrentMonthFirstDay.addMonths(-2);       
        //gets last last month
        MontlyRevenueInfo lastLastMonthItem = new MontlyRevenueInfo();
        lastLastMonthItem.MonthName = monthMap.get((currentMonthFirstDay.addMonths(-2)).month());
        AggregateResult[] groupedResults1 = [select Sum(Rev_Curr_Total__c)sum from Probill__c where Delivery_Start__c >= :lastLastMonthFirstday and Delivery_Start__c < :lastMonthFirstDay and Account__c = :theAccountId];
        lastLastMonthItem.MonthlyPaidAmount = (Decimal)groupedResults1[0].get('sum');
        if(lastLastMonthItem.MonthlyPaidAmount == null)
        {
            lastLastMonthItem.MonthlyPaidAmount = 0;
        }
        results.add(lastLastMonthItem);
        //gets last month
        MontlyRevenueInfo lastMonthItem = new MontlyRevenueInfo();
        lastMonthItem.MonthName = monthMap.get(lastMonthFirstDay.month());
        AggregateResult[] groupedResults2 = [select Sum(Rev_Curr_Total__c)sum from Probill__c where Delivery_Start__c >= :lastMonthFirstDay and Delivery_Start__c < :currentMonthFirstDay and Account__c = :theAccountId];
        lastMonthItem.MonthlyPaidAmount = (Decimal)groupedResults2[0].get('sum');
        if(lastMonthItem.MonthlyPaidAmount == null)
        {
            lastMonthItem.MonthlyPaidAmount = 0;
        }
        results.add(lastMonthItem);
        //gets quarter last month
        MontlyRevenueInfo quarterLastMonthItem = new MontlyRevenueInfo();
        quarterLastMonthItem.MonthName = monthMap.get(currentMonthFirstDay.month());
        AggregateResult[] groupedResults3 = [select Sum(Rev_Curr_Total__c)sum from Probill__c where Delivery_Start__c >= :currentMonthFirstDay and Delivery_Start__c < :currentMonthFirstDay.addMonths(1) and Account__c = :theAccountId];
        quarterLastMonthItem.MonthlyPaidAmount = (Decimal)groupedResults3[0].get('sum');
        if(quarterLastMonthItem.MonthlyPaidAmount == null)
        {
            quarterLastMonthItem.MonthlyPaidAmount = 0;
        }
        results.add(quarterLastMonthItem);
        return results;
    }
    
    public class MontlyRevenueInfo
    {
        public MontlyRevenueInfo()
        {
        }
        
        public String MonthName { get; set; }
        public Decimal MonthlyPaidAmount { get; set; }
    } 
}