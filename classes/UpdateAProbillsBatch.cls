global class UpdateAProbillsBatch implements Database.Batchable<sObject>, Schedulable
{   
    global database.Querylocator start(Database.BatchableContext context)
    {
        return Database.getQueryLocator([select Id, Quota_Date__c, Working_Day__c, Working_Day_Name__c, 
                                         Shipper__c, Shipper_Address__c, Shipper_City__c, Shipper_Country__c, 
                                         Shipper_ID__c, Shipper_Name__c, Shipper_State__c, Shipper_Zip__c, 
                                         Consignee__c, Consignee_Address__c, Consignee_City__c, Consignee_Country__c, 
                                         Consignee_ID__c, Consignee_Name__c, Consignee_State__c, Consignee_Zip__c, 
                                         Commission_Summary__c, Commission_Name__c, Delivery_Month__c, 
                                         Supernova_Performance__c, Supernova_Name__c, AE_Rate_To__c, Delivery_Start__c, 
                                         Account__c, Account__r.Name, ShipperAccountID__c, ConsigneeAccountID__c 
                                         FROM Probill__c 
                                         WHERE AE_Rate_To__c != NULL AND Delivery_Start__c != NULL AND
                                         (Working_Day__c = NULL OR Shipper__c = NULL OR Consignee__c = NULL
                                          OR Commission_Summary__c = NULL OR Supernova_Performance__c = NULL)
                                        AND Shipper_ID__c != NULL AND Consignee_ID__c != NULL] );   
    }									//Last line ignores probills that are missing the Shipper or Consignee ID
    
    global void execute(Database.BatchableContext context, List<Probill__c> probills)
    {
        Set<String> commissionNames = new Set<String>();
        Set<String> workingDayNames = new Set<String>();
        Set<String> supernovaNames = new Set<String>();
        //Set<String> ShipperIDs = new Set<String>();
        //Set<String> ConsigneeIDs = new Set<String>();
        Set<String> ShipperAcctIds = new Set<String>();
        Set<String> ConsigneeAcctIds = new Set<String>();
        
        for(Probill__c probill : probills)
        {
            //Probill__c probill = (Probill__c)obj;
				           
            if(probill.Commission_Summary__c == null && probill.Commission_Name__c != null){
                commissionNames.add(probill.Commission_Name__c);
            }
            if(probill.Working_Day__c == null && probill.Working_Day_Name__c != null){
                workingDayNames.add(probill.Working_Day_Name__c);
            }
            if(probill.Supernova_Performance__c == null && probill.Supernova_Name__c != null){
                supernovaNames.add(probill.Supernova_Name__c);
            }
            if(probill.ShipperAccountID__c != null && !ShipperAcctIds.contains(probill.ShipperAccountID__c)){
                ShipperAcctIds.add(probill.ShipperAccountID__c);
            }
            if(probill.ConsigneeAccountID__c != null && !ConsigneeAcctIds.contains(probill.ConsigneeAccountID__c) ){
                ConsigneeAcctIds.add(probill.ConsigneeAccountID__c);
            }            

        } //end loop
        
        Map<String,Id> commissionMap = new Map<String,Id>();
        for(Commission__c comm: [SELECT Id, Name FROM Commission__c WHERE Name in:commissionNames]){
        	commissionMap.put(comm.Name,comm.Id);
        }
        Map<String,Id> workingDayMap = new Map<String,Id>();
        for(Working_Day__c wd: [SELECT Id, Name FROM Working_Day__c WHERE Name in:workingDayNames]){
        	workingDayMap.put(wd.Name,wd.Id);
        }
        Map<String,Id> supernovaMap = new Map<String,Id>();
        for(Supernova__c sup: [SELECT Id, Name FROM Supernova__c WHERE Name in:supernovaNames]){
        	supernovaMap.put(sup.Name,sup.Id);
        }
        Map<String,Shipper_Consignee__c> shipperMap = new Map<String,Shipper_Consignee__c>();
        for(Shipper_Consignee__c shipCon: [SELECT Id, Name, Type__c, Account__c, ShipConAccountID__c FROM Shipper_Consignee__c WHERE ShipConAccountID__c in:ShipperAcctIds AND Type__c='Shipper']){
        	shipperMap.put(shipCon.ShipConAccountID__c, shipCon);
        }
        Map<String,Shipper_Consignee__c> consigneeMap = new Map<String,Shipper_Consignee__c>();
        for(Shipper_Consignee__c shipCon: [SELECT Id, Name, Type__c, Account__c, ShipConAccountID__c FROM Shipper_Consignee__c WHERE ShipConAccountID__c in:ConsigneeAcctIds AND Type__c='Consignee']){
        	consigneeMap.put(shipCon.ShipConAccountID__c, shipCon);
        }        
        //Find out which records need Shipper/Consignees inserted
        List<Shipper_Consignee__c> shipConstoInsert = new List<Shipper_Consignee__c>();
		Set<String> newShipperIDSet = new Set<String>();
        Set<String> newConsigneeIDSet = new Set<String>();
        
        for(Probill__c probill : probills)
        {
            if( !shipperMap.containsKey(probill.ShipperAccountID__c) && !newShipperIDSet.contains(probill.ShipperAccountID__c) ){ 
                //create new Shipper-Account combo record
            	shipConstoInsert.add(new Shipper_Consignee__c(Name = probill.Shipper_ID__c, Type__c = 'Shipper', Address__c = probill.Shipper_Address__c, City__c = probill.Shipper_City__c, Country__c = probill.Shipper_Country__c, Name__c = probill.Shipper_Name__c, State__c = probill.Shipper_State__c, Zip__c = probill.Shipper_Zip__c, Account__c = probill.account__r.id));
            	newShipperIDSet.add(probill.ShipperAccountID__c);
            }
            if( !consigneeMap.containsKey(probill.ConsigneeAccountID__c) && !newConsigneeIDSet.contains(probill.ConsigneeAccountID__c) ){
                //create Consignee-Account combo record
                shipConstoInsert.add(new Shipper_Consignee__c(Name = probill.Consignee_ID__c, Type__c = 'Consignee', Address__c = probill.Consignee_Address__c, City__c = probill.Consignee_City__c, Country__c = probill.Consignee_Country__c, Name__c = probill.Consignee_Name__c, State__c = probill.Consignee_State__c, Zip__c = probill.Consignee_Zip__c, account__c = probill.account__r.id) );
            	newConsigneeIDSet.add(probill.ConsigneeAccountID__c);
            }
        }//end for loop
        
        if(shipConstoInsert.size() > 0){
        	try{
            	insert(shipConstoInsert);
        	}
        	catch(Exception e){
            	system.debug('Insert Shipper/Consignee exception ' + e.getMessage());
        	}
            //Requery to include inserted Shipper/Consignees and add to map
        	shipperMap = new Map<String,Shipper_Consignee__c>();
        	for(Shipper_Consignee__c shipCon: [SELECT Id, Name, Type__c, Account__c, ShipConAccountID__c FROM Shipper_Consignee__c WHERE ShipConAccountID__c in:ShipperAcctIds AND Type__c='Shipper']){
        		shipperMap.put(shipCon.ShipConAccountID__c, shipCon);
        	}
        	consigneeMap = new Map<String,Shipper_Consignee__c>();
        	for(Shipper_Consignee__c shipCon: [SELECT Id, Name, Type__c, Account__c, ShipConAccountID__c FROM Shipper_Consignee__c WHERE ShipConAccountID__c in:ConsigneeAcctIds AND Type__c='Consignee']){
        		consigneeMap.put(shipCon.ShipConAccountID__c, shipCon);
        	}               
        }
        
        //Loop through a final time and add all proper values
        for(Probill__c probill: probills){
            if(probill.Commission_Summary__c == null && commissionMap.get(probill.Commission_Name__c) != null){
                probill.Commission_Summary__c = commissionMap.get(probill.Commission_Name__c);
            }
            if(probill.Working_Day__c == null && workingDayMap.get(probill.Working_Day_Name__c) != null){
                probill.Working_Day__c = workingDayMap.get(probill.Working_Day_Name__c);
            }
            if(probill.Supernova_Performance__c == null && supernovaMap.get(probill.Supernova_Name__c) != null){
                probill.Supernova_Performance__c = supernovaMap.get(probill.Supernova_Name__c);
            }
            if(probill.Shipper__c == null && shipperMap.get(probill.ShipperAccountID__c) != null  && shipperMap.get(probill.ShipperAccountID__c).Type__c =='Shipper' ){
                probill.Shipper__c = shipperMap.get(probill.ShipperAccountID__c).Id;
            }
            if(probill.Consignee__c == null && consigneeMap.get(probill.ConsigneeAccountID__c) != null  && consigneeMap.get(probill.ConsigneeAccountID__c).Type__c =='Consignee' ){
                probill.Consignee__c = consigneeMap.get(probill.ConsigneeAccountID__c).Id;
            }
        }//end for loop
        try{
            update probills;
        }
        catch(Exception e){
            system.debug('Update probills Exception: ' + e.getMessage());
        }
        
    }
    
    global void finish(Database.BatchableContext context)
    {
    }
    
    global void execute(SchedulableContext context)
    {
         UpdateAProbillsBatch task = new UpdateAProbillsBatch();
         Database.executeBatch(task, 500);
    }
}