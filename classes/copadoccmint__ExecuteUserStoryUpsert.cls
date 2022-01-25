/**
 * Upserts an External User Story into Copado's User Story.
 *
 * @author Ümit Can Uçkan
 * @version 2.0
 * @since CCM Integrations 1.0
 */

global class ExecuteUserStoryUpsert extends CommonIntegrationConstants implements Database.Batchable<Object>, Database.AllowsCallouts {
    private final String DONT_EXCLUDE_FROM_SALESFORCE = ' and Exclude_from_su__c = false';
    global copado__Project__c gProject;
    private Boolean isSprint;
    List<copado__User_Story__c> userStories2Upsert;
    private List<Map<String, String>> userStoryList;
    //Field mapping values between salesforce and third party platform fields under related project
    global Map<String, String> fieldMap {
        get {
            if (null == fieldMap) {
                fieldMap = CopadoCCMutilities.returnFieldMap(gProject.Id, DONT_EXCLUDE_FROM_SALESFORCE);
            }
            return fieldMap;
        }
        set;
    }
    //Record Type mapping values between salesforce and third party platform Work Items under related project
    global Map<String, String> recordTypeMap {
        get {
            if (null == recordTypeMap) {
                recordTypeMap = CopadoCCMutilities.returnRecordTypeMap(gProject.Id, false);
            }
            return recordTypeMap;
        }
        set;
    }

    //User Story object record Type name=>Id Map
    global Map<String, String> UserStoryRecordTypeMap {
        get {
            if (null == UserStoryRecordTypeMap) {
                Boolean forJIRA = false;
                UserStoryRecordTypeMap = CopadoCCMutilities.returnUserStoryRecordTypeMap(forJIRA);
            }
            return UserStoryRecordTypeMap;
        }
        set;
    }

    //constructor to have the project via schedule class
    global ExecuteUserStoryUpsert(copado__Project__c proParam, Boolean isSprint) {
        gProject = proParam;
        this.isSprint = isSprint;
        userStoryList = new List<Map<String, String>>();
    }
    //constructor to have the project via schedule class with User Story records
    global ExecuteUserStoryUpsert(copado__Project__c proParam, List<Map<String, String>> userStoryListParam) {
        gProject = proParam;
        this.isSprint = true;
        userStoryList = userStoryListParam;
    }
    global ExecuteUserStoryUpsert(copado__Project__c proParam, List<Map<String, String>> userStoryListParam, Boolean isSprint) {
        gProject = proParam;
        this.isSprint = isSprint;
        userStoryList = userStoryListParam;
    }
    //Finds related instance based on external system to use via factory pattern, fetches and parses the JSON and return to execute method
    global Iterable<Object> start(Database.BatchableContext BC) {
        if (null != userStoryList && !userStoryList.isEmpty()) {
            return new CallIterable(userStoryList);
        } else {
            return new CallIterable(
                IntegrationFactory.returnInstance(gProject.Copado_Integration_Setting__r.External_System__c).fetchRecords(gProject, isSprint)
            );
        }
    }

    global void execute(Database.BatchableContext BC, List<Object> scope) {
        userStories2Upsert = new List<copado__User_Story__c>();
        //loops among user story Items Map
        for (Object usItem : scope) {
            Map<String, String> tempMap = (Map<String, String>) usItem;
            sObject sobj = new copado__User_Story__c();
            //loops among field Mapping items under related project
            for (String fieldName : fieldMap.keyset()) {
                fieldName = fieldName.toLowerCase();
                //puts the value on sf Object if the current user story item value Map stores current field Map keyset
                if (tempMap.containsKey(fieldMap.get(fieldName))) {
                    if (
                        fieldName == COPADO_RELEASE &&
                        CopadoCCMutilities.returnCastedValue(tempMap.get(fieldMap.get(fieldName)), fieldName) != null
                    ) {
                        Sobject releaseObj = Schema.getGlobalDescribe().get(fieldName).newSObject();
                        releaseObj.put(EXTERNAL_ID, CopadoCCMutilities.returnCastedValue(tempMap.get(fieldMap.get(fieldName)), fieldName));
                        sobj.putsObject(copado__User_Story__c.copado__Release__c.getDescribe().getSObjectField(), releaseObj);
                    } else if (fieldName == RECORD_TYPE_ID && !recordTypeMap.isEmpty()) {
                        String jiraType = tempMap.get(fieldMap.get(fieldName));
                        String sfType = recordTypeMap.get(jiraType);
                        if (null != sfType) {
                            Id sfTypeId = UserStoryRecordTypeMap.get(sfType);
                            sobj.put(fieldName, sfTypeId);
                        }
                    } else {
                        sobj.put(fieldName, CopadoCCMutilities.returnCastedValue(tempMap.get(fieldMap.get(fieldName)), fieldName));
                    }
                }
            }
            userStories2Upsert.add((copado__User_Story__c) sobj);
        }
        try {
            //performs upsert based on third party id
            upsert userStories2Upsert External_Id__c;
        } catch (DmlException ex) {
            System.debug('ExecuteUserStoryUpsert dml exception==> ' + ex.getMessage());
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}