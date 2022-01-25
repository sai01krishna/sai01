/**
 * Implementation class for Jira. This class can be customized including extra logic, and cloned for supporting another provider.
 *
 * How to schedule the fetch process:
 * ScheduleUserStoryFetch Susf = new ScheduleUserStoryFetch (prpjectRecordId);
 * String str = Datetime.now().addSeconds(5).format('s m H d M ? yyyy');
 * String jobID = system.schedule('ScheduleUserStoryFetch - ' + DateTime.Now() + '.' + math.mod(DateTime.now().getTime(), 1000), str, Susf);
 * @author Ümit Can Uçkan
 * @version 1.11
 */

public with sharing class JiraIntegration extends JiraIntegrationConstants implements IIntegration {
    //NON-CONSTANTS
    //will be filled with related project/user Story record
    public String projectExtId;
    public String namedCredential;
    public Map<String, Id> userMap {
        get {
            if (null == userMap) {
                Boolean unableCommunityUser = [SELECT Id, Enable_Community_User__c FROM copado__Project__c WHERE Id = :pId].Enable_Community_User__c;
                userMap = CopadoCCMutilities.returnUsers(unableCommunityUser);
            }
            return userMap;
        }
        private set;
    }
    public Map<String, Map<String, String>> keyValuepairsByExternalId {
        get {
            if (null == keyValuepairsByExternalId) {
                keyValuepairsByExternalId = new Map<String, Map<String, String>>();
            }
            return keyValuepairsByExternalId;
        }
        private set;
    }
    public Map<String, copado__Release__c> releases {
        get {
            if (null == releases) {
                releases = new Map<String, copado__Release__c>();
            }
            return releases;
        }
        private set;
    }
    private copado__Sprint__c currentSprint;
    public String jqlExtFilter {
        get {
            if (String.isBlank(jqlExtFilter)) {
                jqlExtFilter = EMPTY_CHAR;
            }
            return jqlExtFilter;
        }
        private set;
    }

    //current copado__project__c record id
    public Id pId;

    //List of Map collector to be able to return records from json response to batch class
    public List<Map<String, String>> userStoryList {
        get {
            if (null == userStoryList) {
                userStoryList = new List<Map<String, String>>();
            }
            return userStoryList;
        }
        set;
    }

    public Map<String, String> recordTypeMap {
        get {
            if (null == recordTypeMap) {
                Boolean forThirdParty = true;
                recordTypeMap = CopadoCCMUtilities.returnRecordTypeMap(pId, forThirdParty);
            }
            return recordTypeMap;
        }
        private set;
    }

    public Map<String, String> userStoryRecordTypeMap {
        get {
            if (null == userStoryRecordTypeMap) {
                Boolean forThirdParty = true;
                userStoryRecordTypeMap = CopadoCCMUtilities.returnUserStoryRecordTypeMap(forThirdParty);
            }
            return userStoryRecordTypeMap;
        }
        private set;
    }

    //salesforce field api to third party field Mapping to use on third party record update operation
    public Map<String, String> fieldMap {
        get {
            if (null == fieldMap) {
                fieldMap = CopadoCCMutilities.returnFieldMap(pId, DONT_EXCLUDE_FROM_THIRD_PARTY);
            }
            return fieldMap;
        }
        set;
    }

    public String fieldsToFetch {
        get {
            if (String.isBlank(fieldsToFetch)) {
                Set<String> fields = new Set<String>(fieldMap.values());
                fields.add(ASSIGNEE);
                fields.add(ID_KEYWORD);
                fields.add(KEY_STRING);
                fields.add(PROJECT_ID);
                fields.add(RELEASE_REST_NAME);
                fields.add(ISSUE_TYPE);
                fieldsToFetch = String.join(new List<String>(fields), COMMA);
            }
            return fieldsToFetch;
        }
        set;
    }

    //salesforce field api to third party field type Mapping to use on third party record update operation
    //exps: copado__status__c => Object
    public Map<String, String> typeMap {
        get {
            if (null == typeMap) {
                typeMap = CopadoCCMutilities.returnTargetTypeMap(pId, DONT_EXCLUDE_FROM_THIRD_PARTY);
            }
            return typeMap;
        }
        set;
    }

    //String comma seperated queries to us on sObject record query on updateRecord method
    public String queryFields {
        get {
            if (String.isBlank(queryFields)) {
                queryFields = String.join(new List<String>(fieldMap.keyset()), COMMA);
                if (!queryFields.contains(EXTERNAL_ID)) {
                    queryFields += COMMA + EXTERNAL_ID;
                }
                if (!queryFields.contains(ENABLE_LOGS)) {
                    queryFields += COMMA + ENABLE_LOGS;
                }
            }
            return queryFields;
        }
        set;
    }

    //INTEGRATION CORE METHODS - START
    /**
     * Updates single record based on external Id on Jira.
     * This method will be triggered by the SendUpdatedValues2TP Process Builder Flow on User Story change criteria (customizable in the flow).
     *
     * @param usItem
     */
    public void updateRecord(copado__User_Story__c usItem) {
        pId = usItem.copado__Project__c;
        projectExtId = usItem.copado__Project__r.Project_External_Id__c;
        namedCredential = usItem.copado__Project__r.Copado_Integration_Setting__r.Named_Credential__c;
        Id usId = usItem.Id;
        sObject cUserStory = database.query('SELECT ' + queryFields + ' FROM copado__User_Story__c WHERE Id = : usId');

        String responseText = CopadoCCMutilities.MakeCallout(
            namedCredential,
            CALLOUT_API_VERSION,
            EMPTY_CHAR,
            String.format(updateParameter4TransitionString, new List<String>{ (String) cUserStory.get(EXTERNAL_ID) }),
            EMPTY_CHAR,
            new List<String>{ CONTENT_TYPE_HEADER },
            Method.GET,
            null,
            cUserStory,
            null
        );
        //Jira status update on a different method, since status is a state, not a field on Jira
        updateStatus(responseText, cUserStory);

        //callout for field update
        String responseTextFields = CopadoCCMutilities.MakeCallout(
            namedCredential,
            CALLOUT_API_VERSION,
            EMPTY_CHAR,
            String.format(updateParameterString, new List<String>{ (String) cUserStory.get(EXTERNAL_ID) }),
            EMPTY_CHAR,
            new List<String>{ CONTENT_TYPE_HEADER },
            Method.PUT,
            prepareFinalJSON(cUserStory),
            cUserStory,
            null
        );
        CopadoCCMutilities.createLogRecords();
    }

    /**
     * Fetches records Per Sprint from Jira in JSON format
     *
     * @param selectedProject
     *
     * @return List<Map<String,String>>
     */
    public Map<String, Map<String, String>> fetchRecordsWithLimitedSprints(copado__Project__c selectedProject, List<copado__Sprint__c> sprints) {
        pid = selectedProject.id;
        projectExtId = null != selectedProject.Project_External_Id__c ? selectedProject.Project_External_Id__c : EMPTY_CHAR;
        namedCredential = selectedProject.Copado_Integration_Setting__r.Named_Credential__c;

        for (copado__Sprint__c sprint : sprints) {
            this.currentSprint = sprint;
            jqlExtFilter = EMPTY_CHAR;
            String currentFilter = null != selectedProject.JQL_Extended_Filter__c ? selectedProject.JQL_Extended_Filter__c : EMPTY_CHAR;
            correctExtendedFilter(' AND Sprint=' + ESCAPED_SINGLE_QUOTE + sprint.Name + ESCAPED_SINGLE_QUOTE + (currentFilter != EMPTY_CHAR ? ' AND ' : EMPTY_CHAR) + currentFilter);
            iterateThroughCallouts(selectedProject);
        }

        CopadoCCMutilities.createLogRecords();
        Database.upsert(releases.values(), copado__Release__c.fields.External_Id__c);
        //gets all unique values based on external id from keyValuepairsByExternalId
        return keyValuepairsByExternalId;
    }

    /**
     * Fetches records from Jira in JSON format
     *
     * @param selectedProject
     *
     * @return List<Map<String,String>>
     */
    public List<Map<String, String>> fetchRecords(copado__Project__c selectedProject, Boolean isSprint) {
        pid = selectedProject.id;
        projectExtId = null != selectedProject.Project_External_Id__c ? selectedProject.Project_External_Id__c : EMPTY_CHAR;
        namedCredential = selectedProject.Copado_Integration_Setting__r.Named_Credential__c;

        List<copado__Sprint__c> sprints = [
            SELECT Id, Name, External_Id__c
            FROM copado__Sprint__c
            WHERE copado__Project__c = :pid AND External_Id__c != NULL
            ORDER BY copado__Start_Date__c ASC
        ];

        if (isSprint) {
            for (copado__Sprint__c sprint : sprints) {
                currentSprint = sprint;
                jqlExtFilter = EMPTY_CHAR;
                String currentFilter = null != selectedProject.JQL_Extended_Filter__c ? selectedProject.JQL_Extended_Filter__c : EMPTY_CHAR;
                correctExtendedFilter(' AND Sprint=' + ESCAPED_SINGLE_QUOTE + sprint.Name + ESCAPED_SINGLE_QUOTE + (currentFilter != EMPTY_CHAR ? ' AND ' : EMPTY_CHAR) + currentFilter);
                iterateThroughCallouts(selectedProject);
            }
        } else {
            correctExtendedFilter(selectedProject.JQL_Extended_Filter__c);
            iterateThroughCallouts(selectedProject);
        }
        CopadoCCMutilities.createLogRecords();
        Database.upsert(releases.values(), copado__Release__c.fields.External_Id__c);
        //gets all unique values based on external id from keyValuepairsByExternalId
        userStoryList.addAll(keyValuepairsByExternalId.values());
        //Returns list to executeUserStoryUpsert batch class
        return userStoryList;
    }
    //INTEGRATION CORE METHODS - END

    //INTEGRATION HELPER METHODS - START
    private void iterateThroughCallouts(copado__Project__c selectedProject) {
        Integer startIndex = 0;
        Boolean shouldContinue = true;
        Integer total;
        //Gets issues via JQR
        while (shouldContinue) {
            String responseText = CopadoCCMutilities.MakeCallout(
                namedCredential,
                CALLOUT_API_VERSION,
                projectExtId + jqlExtFilter,
                AUTH_QUERY_PATH,
                START_AT_URI +
                startIndex +
                FIELD_QUERY_PATH +
                fieldsToFetch,
                new List<String>{ CONTENT_TYPE_HEADER },
                Method.GET,
                null,
                null,
                selectedProject
            );
            if (responseText.contains(ERROR_MESSAGES_JSON)) {
                return;
            }
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseText);
            //Pagination variables, Jira fetch is limited to 50 records by default
            total = Integer.valueOf(results.get(TOTAL_STRING));
            startIndex = Integer.valueOf(results.get(START_AT));
            List<Object> issues = (List<Object>) results.get(ISSUES_STRING);

            if (null != issues) {
                iterateThroughIssues(issues);

                if (total - startIndex < PAGINATION_SIZE) {
                    shouldContinue = false;
                } else {
                    startIndex = startIndex + PAGINATION_SIZE;
                }
            }
        }
    }

    private void iterateThroughIssues(List<Object> issues) {
        Map<String, String> keyValuepairs;
        for (Object issue : issues) {
            keyValuepairs = new Map<String, String>();
            Map<String, Object> currentIssue = (Map<String, Object>) issue;
            //Below three rows are in use for look up and external id purpose
            keyValuepairs.put(KEY_STRING, (String) currentIssue.get(KEY_STRING));
            keyValuepairs.put(ID_KEYWORD, (String) currentIssue.get(ID_KEYWORD));
            keyValuepairs.put(PROJECT_ID, pid);
            if (null != currentSprint) {
                keyValuepairs.put(SPRINT_ID, currentSprint.Id);
            }
            if (null != currentIssue.get(FIELDS_STRING)) {
                Map<String, Object> fields = (Map<String, Object>) currentIssue.get(FIELDS_STRING);
                keyValuepairsByExternalId.put((String) currentIssue.get(ID_KEYWORD), iterateThroughFields(fields, keyValuepairs));
            }
        }
    }

    private Map<String, String> iterateThroughFields(Map<String, Object> fields, Map<String, String> keyValuepairs) {
        for (String cf : fields.keySet()) {
            //Prepares values from String
            if (
                fields.get(cf) instanceof String ||
                fields.get(cf) instanceof Integer ||
                fields.get(cf) instanceof Decimal ||
                fields.get(cf) instanceof Double ||
                fields.get(cf) == null
            ) {
                keyValuepairs.put(cf, String.valueOf(fields.get(cf)));
            } else if (fields.get(cf) instanceof Map<String, Object>) {
                //Prepares values from Json Object
                Map<String, Object> tempObject = (Map<String, Object>) fields.get(cf);
                if (null != tempObject.get(EMAIL_ADDRESS)) {
                    //Fills up user look up fields, if email address in use on Third Party Platform matches any of the email addresses on current salesforce org.
                    String cuEmail = ((String) tempObject.get(EMAIL_ADDRESS)).toLowerCase();
                    if (userMap.containsKey(cuEmail)) {
                        String mapKey = (cf == ASSIGNEE ? DEVELOPER_KEYWORD : cf);
                        keyValuepairs.put(mapKey, userMap.get(cuEmail));
                    } else {
                        keyValuepairs.put(cf, (String) tempObject.get(EMAIL_ADDRESS));
                    }
                } else if (null != tempObject.get(NAME_KEYWORD)) {
                    keyValuepairs.put(cf, (String) tempObject.get(NAME_KEYWORD));
                } else if (null != tempObject.get(VALUE_KEYWORD)) {
                    keyValuepairs.put(cf, (String) tempObject.get(VALUE_KEYWORD));
                }
            } else if (fields.get(cf) instanceof List<Object> && cf == RELEASE_REST_NAME) {
                List<Object> tempObject = (List<Object>) fields.get(cf);
                if (tempObject.isEmpty()) {
                    continue;
                }
                Map<String, Object> result = (Map<String, Object>) tempObject[0];
                String extId = (String) result.get(ID_KEYWORD);
                String extName = (String) result.get(NAME_KEYWORD);
                copado__Release__c upsertRelease = new copado__Release__c(External_Id__c = extId, Name = extName, copado__Project__c = pId);
                keyValuepairs.put(cf.toLowerCase(), extId);
                releases.put(extId, upsertRelease);
            } else if (fields.get(cf) instanceof List<Object>) {
                List<Object> tempObject = (List<Object>) fields.get(cf);
                String cf_value = '';
                for (Object eachObject : tempObject) {
                    if (eachObject instanceof Map<String, Object>) {
                        Map<String, Object> result = (Map<String, Object>) eachObject;
                        if (null != result.get(EMAIL_ADDRESS)) {
                            if (String.isBlank(cf_value)) {
                                cf_value = (String) result.get(EMAIL_ADDRESS);
                            } else {
                                cf_value += '; ' + (String) result.get(EMAIL_ADDRESS);
                            }
                        } else if (null != result.get(NAME_KEYWORD)) {
                            if (String.isBlank(cf_value)) {
                                cf_value = (String) result.get(NAME_KEYWORD);
                            } else {
                                cf_value += '; ' + (String) result.get(NAME_KEYWORD);
                            }
                        } else if (null != result.get(VALUE_KEYWORD)) {
                            if (String.isBlank(cf_value)) {
                                cf_value = (String) result.get(VALUE_KEYWORD);
                            } else {
                                cf_value += '; ' + (String) result.get(VALUE_KEYWORD);
                            }
                        }
                    } else {
                        if (String.isBlank(cf_value)) {
                            cf_value = (String) eachObject;
                        } else {
                            cf_value += '; ' + (String) eachObject;
                        }
                    }
                }
                keyValuepairs.put(cf, cf_value);
            }
        }
        return keyValuepairs;
    }

    /**
     * prepares callout body from field Mappings
     */
    private String prepareFinalJSON(SObject cUserStory) {
        String finalJson = JSON_TEMPLATE_OUTER;
        for (String fieldName : fieldMap.keyset()) {
            if (null != cUserStory.get(fieldName) && fieldMap.get(fieldName) != STATUS) {
                String fieldKey = fieldMap.get(fieldName), fieldValue = String.valueOf(cUserStory.get(fieldName));
                if (fieldName == RECORD_TYPE_ID) {
                    String recordTypeId = fieldValue;
                    String recordTypeName = userStoryRecordTypeMap.get(recordTypeId);
                    fieldValue = recordTypeMap.get(recordTypeName);
                }

                finalJson +=
                    String.format(
                        (typeMap.get(fieldName) == OBJECT_STRING
                            ? JSON_TEMPLATE_INNER_OBJECT
                            : (typeMap.get(fieldName) == INTEGER_STRING ? JSON_TEMPLATE_INNER_INTEGER : JSON_TEMPLATE_INNER_STRING)),
                        new List<String>{ fieldKey, CopadoCCMUtilities.escapeDoubleQuotes(fieldValue) }
                    ) + COMMA;
            }
        }
        //callout body to update Jira record which is created from field mappings under related project and current field values
        finalJson = CopadoCCMutilities.replaceFromCurly(finalJson.substring(0, finalJson.length() - 1) + JSON_TEMPLATE_OUTER_CLOSURE);
        return finalJson;
    }

    /**
     * Updates Jira workItem status
     *
     * @param responseText
     * @param cUserStory
     */
    public void updateStatus(String responseText, sObject cUserStory) {
        String statusfinalJson = EMPTY_CHAR;
        JSONParser parser = JSON.createParser(responseText);
        //Wrapper class direct parse
        TransitionWrapper transitionWrapperItem = (TransitionWrapper) parser.readValueAs(TransitionWrapper.class);
        String currentStatusValue = (String) cUserStory.get(COPADO_STATUS);
        Boolean calloutFlag = false;
        for (Transitions tw : transitionWrapperItem.Transitions) {
            //Checks if the current status is available on Jira workflow, if not, does not do the callout
            if (tw.name.toLowerCase().equals(currentStatusValue.toLowerCase())) {
                statusfinalJson = CopadoCCMutilities.replaceFromCurly(String.format(transitionTemplate, new List<String>{ tw.id }));
                calloutFlag = true;
                break;
            }
        }

        if (calloutFlag) {
            CopadoCCMutilities.MakeCallout(
                namedCredential,
                CALLOUT_API_VERSION,
                EMPTY_CHAR,
                String.format(updateParameter4TransitionString, new List<String>{ (String) cUserStory.get(EXTERNAL_ID) }),
                EMPTY_CHAR,
                new List<String>{ CONTENT_TYPE_HEADER },
                Method.POST,
                statusfinalJson,
                cUserStory,
                null
            );
        }
    }

    /**
     * gets planned sprints
     *
     * @param selectedProject
     *
     * @return sprint list response
     */
    private List<copado__Sprint__c> getSprints(copado__Project__c selectedProject) {
        String responseText = CopadoCCMutilities.MakeCallout(
            namedCredential,
            SPRINT_QUERY_PATH,
            EMPTY_CHAR,
            projectExtId,
            EMPTY_CHAR,
            new List<String>{ CONTENT_TYPE_HEADER },
            Method.GET,
            null,
            null,
            selectedProject
        );

        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseText);
        return upsertSprints((List<Object>) results.get(SPRINTS_STRING), selectedProject.Id);
    }

    /**
     * fetches planned sprints
     *
     * @param selectedProject
     *
     */
    public void fetchSprints(copado__Project__c selectedProject) {
        namedCredential = selectedProject.Copado_Integration_Setting__r.Named_Credential__c;
        projectExtId = null != selectedProject.Project_External_Id__c ? selectedProject.Project_External_Id__c : EMPTY_CHAR;
        List<copado__Sprint__c> sprints = getSprints(selectedProject);
    }

    /**
     * Upserts returned sprints based on extennal Id
     *
     * @param List<Object> sprints
     * @param Id copado Project Id
     *
     * @return copado sprint list
     */
    private List<copado__Sprint__c> upsertSprints(List<Object> sprints, Id projectId) {
        List<copado__Sprint__c> sprintsUpsert = new List<copado__Sprint__c>();
        for (Object obj : sprints) {
            Map<String, Object> tempMap = (Map<String, Object>) obj;
            String startDate = String.valueOf(tempMap.get(START_AT_JSON));
            String endDate = String.valueOf(tempMap.get(END_AT_JSON));
            sprintsUpsert.add(
                new copado__Sprint__c(
                    External_Id__c = String.valueOf(tempMap.get(ID_KEYWORD)),
                    Name = String.valueOf(tempMap.get(NAME_KEYWORD)),
                    copado__Start_Date__c = CopadoCCMUtilities.convertLongDateToDate(startDate),
                    copado__End_Date__c = CopadoCCMUtilities.convertLongDateToDate(endDate),
                    copado__Project__c = projectId
                )
            );
        }
        upsert sprintsUpsert External_Id__c;
        return sprintsUpsert;
    }

    private void correctExtendedFilter(String jqlFilter) {
        if (String.isNotBlank(jqlFilter)) {
            if (jqlFilter.length() >= 3) {
                if (jqlFilter.toLowercase().replace(ONE_CHAR, EMPTY_CHAR).substring(0, 3) != 'and') {
                    jqlExtFilter = projectExtId.length() > 0 ? ' AND ' : EMPTY_CHAR;
                }
                jqlExtFilter += jqlFilter;
                jqlExtFilter = EncodingUtil.urlEncode(jqlExtFilter, ENCODING_TYPE);
            }
        }
    }
    //INTEGRATION HELPER METHODS - END

    /**
     * Wrapper classes for direct casting of Transition Callout response
     */
    public class TransitionWrapper {
        public List<Transitions> Transitions;
    }
    public class Transitions {
        public String id;
        public String name;
    }
}