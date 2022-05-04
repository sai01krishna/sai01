global class BatchCreateOpportunity implements Database.batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT id from Account limit 1';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        List<Opportunity> oppList = new  List<Opportunity>();
         for(Account acc : scope )
     { 

         for(integer i=0;i<5;i++){
             Opportunity opp = new Opportunity();
             opp.accountId = acc.id;
             opp.name = 'version'+i;
             opp.CloseDate = system.today()+10;
             opp.StageName = 'prospecting';
              oppList.add(opp);
         } 
    }   
    insert oppList;
}
 global void finish(Database.BatchableContext BC)
    {
    }
}