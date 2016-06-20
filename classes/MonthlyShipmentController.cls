global class MonthlyShipmentController
{
    public static String AccountId { get; set; }
    public static String CurrentYear { get; set; }
    public static String CurrentQuarter { get; set; }
    
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
    
    @RemoteAction
    public static List<ChartData> getMonthlyShipment(String theAccountId, String theYear, String theQuarter)
    {
        initMonthMap();
        List<ChartData> results = new List<ChartData>();
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
        ChartData lastLastMonthItem = new ChartData();
        lastLastMonthItem.Month = monthMap.get((currentMonthFirstDay.addMonths(-2)).month());
        AggregateResult[] groupedResults1 = [select count(Id) sum from Probill__c where Delivery_Start__c >= :lastLastMonthFirstday and Delivery_Start__c < :lastMonthFirstDay and Account__c = :theAccountId];
        lastLastMonthItem.count = (Integer)groupedResults1[0].get('sum');
        results.add(lastLastMonthItem);
        
        //gets last month
        ChartData lastMonthItem = new ChartData();
        lastMonthItem.Month = monthMap.get(lastMonthFirstDay.month());
        AggregateResult[] groupedResults2 = [select count(Id)sum from Probill__c where Delivery_Start__c >= :lastMonthFirstDay and Delivery_Start__c < :currentMonthFirstDay and Account__c = :theAccountId];
        lastMonthItem.count = (Integer)groupedResults2[0].get('sum');
        results.add(lastMonthItem);
        //gets quarter last month
        ChartData quarterLastMonthItem = new ChartData();
        quarterLastMonthItem.Month = monthMap.get(currentMonthFirstDay.month());
        AggregateResult[] groupedResults3 = [select count(Id)sum from Probill__c where Delivery_Start__c >= :currentMonthFirstDay and Delivery_Start__c < :currentMonthFirstDay.addMonths(1) and Account__c = :theAccountId];
        quarterLastMonthItem.count = (Integer)groupedResults3[0].get('sum');
        results.add(quarterLastMonthItem);
        return results;
    }
    
    public class ChartData
    {
        public String month {get; set;}
        public Integer count {get; set;}
        public ChartData()
        {
        }
    }
}