/**
 * Fetch External User Stories into Copado w.r.t. Sprint(if available) linked
 *
 * @author Nishant Bansal
 * @version 1.0
 * @since CCM Integrations 1.4
 */

global class ExecuteUserStoryFetch extends CommonIntegrationConstants implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    private final String DONT_EXCLUDE_FROM_SALESFORCE = ' and Exclude_from_su__c = false';
    global copado__Project__c gProject;
    private Boolean isSprint;
    global Map<String, Map<String, String>> userStoryList;
    private final String queryTemplate = 'SELECT Id, Name, External_Id__c FROM copado__Sprint__c WHERE copado__Project__c = \'\'{0}\'\' {1} AND External_Id__c != NULL ORDER BY copado__Start_Date__c ASC';
    private String query;
    private List<Id> sprintIdList;

    //constructor to have the project via schedule class
    global ExecuteUserStoryFetch(copado__Project__c proParam) {
        this.userStoryList = new Map<String, Map<String, String>>();
        this.gProject = proParam;
        this.query = String.format(queryTemplate, new List<String>{ String.valueOf(gProject.Id), '' });
    }
    //constructor to have the project via anonymous - Can be used for only selected Sprint
    global ExecuteUserStoryFetch(copado__Project__c proParam, List<Id> sprintIdListParam) {
        this.userStoryList = new Map<String, Map<String, String>>();
        this.gProject = proParam;
        this.sprintIdList = sprintIdListParam;
        if (sprintIdList == null || sprintIdList.size() == 0) {
            this.query = String.format(queryTemplate, new List<String>{ String.valueOf(gProject.Id), '' });
        } else {
            this.query = String.format(queryTemplate, new List<String>{ String.valueOf(gProject.Id), 'AND Id IN:sprintIdList' });
        }
    }
    //Find Sprint records available in Salesforce system
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    //Finds related instance based on external system to use via factory pattern, fetches and parses the JSON and return to execute method
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<copado__Sprint__c> sprintList = (List<copado__Sprint__c>) scope;
        Map<String, Map<String, String>> tempUserStoryList = new Map<String, Map<String, String>>();
        tempUserStoryList = (IntegrationFactory.returnInstance(gProject.Copado_Integration_Setting__r.External_System__c)
            .fetchRecordsWithLimitedSprints(gProject, sprintList));
        if (null != tempUserStoryList && tempUserStoryList.size() > 0) {
            for (String eachUsExtId : tempUserStoryList.keySet()) {
                userStoryList.put(eachUsExtId, tempUserStoryList.get(eachUsExtId));
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        if (null != userStoryList && userStoryList.size() > 0) {
            Database.executeBatch(new ExecuteUserStoryUpsert(gProject, userStoryList.values()), 200);
        }
    }
}