global class schduleBatchCreateOpportunity implements Schedulable {

   global void execute(SchedulableContext ctx) {
      BatchCreateOpportunity p = new BatchCreateOpportunity();
        database.executeBatch(p);
   }   
}