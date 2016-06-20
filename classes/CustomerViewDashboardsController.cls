public class CustomerViewDashboardsController
{
    public CustomerViewDashboardsController()
    {
        init();  
    }
    
    public static String AccountId { get; set; }
    public static String CurrentYear { get; set; }
    public static String CurrentQuarter { get; set; }
    
    private void init()
    {
        AccountId = Apexpages.currentpage().getParameters().get('acctId');
        CurrentYear = String.valueof(Date.today().year());
        Integer month = date.today().month();
        if(month < 4)
        {
            CurrentQuarter = '1';
        }
        else if(month >= 4 && month < 7)
        {
            CurrentQuarter = '2';
        }
        else if(month >= 7 && month < 10)
        {
            CurrentQuarter = '3';
        }
        else if(month >= 10 && month <= 12)
        {
            CurrentQuarter = '4';
        }
    }
    
}