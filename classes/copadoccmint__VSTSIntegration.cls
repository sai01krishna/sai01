/**
 * Created by copado on 05/06/2018.
 *
 * How to schedule the fetch process
 *
 * ScheduleUserStoryFetch Susf = new ScheduleUserStoryFetch (prpjectRecordId);
 * String str = Datetime.now().addSeconds(5).format('s m H d M ? yyyy');
 * String jobID = system.schedule('ScheduleUserStoryFetch - ' + DateTime.Now() + '.' + math.mod(DateTime.now().getTime(), 1000), str, Susf);
 *
 * */

public with sharing class VSTSIntegration extends VSTSIntegrationConstants implements IIntegration {
    //will be populated with related project/user Story record
    private String projectExtId;
    private String workspaceId;
    private String teamInfo;
    private String namedCredential;
    
    public VSTSIntegration(){}
    public VSTSIntegration(Id projectId){
        pId = projectId;
    }
    
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

    public Map<String, Map<String, String>> keyValuepairsByExternalId {
        get {
            if (null == keyValuepairsByExternalId) {
                keyValuepairsByExternalId = new Map<String, Map<String, String>>();
            }
            return keyValuepairsByExternalId;
        }
        private set;
    }

    private Map<String, Id> sprintIdByName {
        get {
            if (null == sprintIdByName) {
                sprintIdByName = new Map<String, Id>();
            }
            return sprintIdByName;
        }
        set;
    }

    //current copado__project__c record id
    private Id pId;

    //list to return serialized Json values to batch
    public List<Map<String, String>> userStoryList {
        get {
            if (null == userStoryList) {
                userStoryList = new List<Map<String, String>>();
            }
            return userStoryList;
        }
        set;
    }

    //VSTS work Items id set to use on the second callout
    public List<List<String>> wIIds {
        get {
            if (null == wIIds) {
                wIIds = new List<List<String>>{new List<String>()};
            }
            return wIIds;
        }
        set;
    }

    public String fieldsToFetch {
        get {
            if (String.isBlank(fieldsToFetch)) {
                Set<String> fields = new Set<String>(fieldMap.values());
                fields.add(ASSIGNED_TO);
                fields.add(PROJECT);
                fields.add(WORK_ITEM_TYPE);
                fields.add(ITERATION);
                String.join(new List<String>(fields), COMMA);
            }
            return fieldsToFetch;
        }
        set;
    }

    //Field mapping values between salesforce and third party platform fields under related project
    public Map<String, String> fieldMap {
        get {
            if (null == fieldMap) {
                fieldMap = CopadoCCMutilities.returnFieldMap(pId, DONT_EXCLUDE_FROM_THIRD_PARTY);
            }
            return fieldMap;
        }
        set;
    }

    //string comma seperated queries to us on sObject record query on updateRecord method
    public String queryFields {
        get {
            if (String.isBlank(queryFields)) {
                queryFields = String.join(new List<String>(fieldMap.keyset()), COMMA);
            }
            return queryFields;
        }
        set;
    }
    //INTEGRATION CORE METHODS - START
    /** updates single record based on the external id on VSTS
     *  this method will be triggered by the SendUpdatedValues2TP process on user story status change.
     *  You can clone the proces and change the firing conditions anytime
     */
    public void updateRecord(copado__User_story__c usItem) {
        pId = usItem.copado__Project__c;
        projectExtId = usItem.copado__Project__r.Project_External_Id__c;
        workspaceId = usItem.copado__Project__r.Workspace_Id__c;
        Id usId = usItem.id;
        Sobject cUserStory = Database.query('SELECT ' + queryFields + ',enable_logs__c FROM copado__user_story__c WHERE id=:usId');
        String finalJson = '[{';
        for (String fieldName : fieldMap.keyset()) {
            if (null != cUserStory.get(fieldName)) {
                String fieldKey = fieldMap.get(fieldName), fieldValue = String.escapeSingleQuotes(String.valueOf(cUserStory.get(fieldName)));
                if (fieldName == RECORD_TYPE_ID) {
                    String recordTypeId = fieldValue;
                    String recordTypeName = userStoryRecordTypeMap.get(recordTypeId);
                    fieldValue = recordTypeMap.get(recordTypeName);
                }

                finalJson += String.format(JsonTemplate, new List<String>{ fieldKey, fieldValue }) + '},{';
            }
        }

        //callout body to update VSTS record which is created from field mappings under related project and current field values
        finalJson = finalJson.substring(0, finalJson.length() - 2) + ']';
        namedCredential = usItem.copado__Project__r.Copado_Integration_Setting__r.Named_Credential__c;
        //callout for field update
        String responseText = CopadoCCMutilities.MakeCallout(
            namedCredential,
            workspacePath2Patch,
            authApiVersion,
            (String) cUserStory.get(EXTERNAL_ID),
            EMPTY_CHAR,
            new List<String>{ CONTENT_TYPE_PATCH_HEADER, CONNECTION_HEADER, OVERRIDE_POST_METHOD },
            Method.POST,
            finalJson,
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
        projectExtId = selectedProject.Project_External_Id__c;
        workspaceId = selectedProject.Workspace_Id__c;
        namedCredential = selectedProject.Copado_Integration_Setting__r.Named_Credential__c;
        teamInfo = null != selectedProject.Team_Info__c ? selectedProject.Team_Info__c : EMPTY_CHAR;

        getWorkItemIds(selectedProject, true, sprints);
        for (Integer idCounter = 0; idCounter < wIIds.size(); idCounter++) {
            //callout to have all fields for desired workItems
            String responseText = CopadoCCMutilities.MakeCallout(
                namedCredential,
                projectExtId,
                String.join(wIIds[idCounter], COMMA),
                workspacePath,
                '', //FIELD_QUERY_PATH + fieldsToFetch,
                new List<string>{ CONTENT_TYPE_HEADER, CONNECTION_HEADER },
                Method.GET,
                null,
                null,
                selectedProject
            );
            //Implemented to bypass lack of functionality to place 2 mock response on a flow with one execution point.
            //  --  check testMethodToFetchSprints_VSTS method in TestIntegration.cls
            if (Test.isRunningTest()) {
                responseText = returnMockResponseForSprints();
            }
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseText);
            //use below line if you experience parsing issues on above
            //Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(CopadoCCMUtilities.escapeInvalidChars(responseText));
            try {
                List<Object> values = (List<Object>) results.get(VALUE_KEYWORD);
                iterateThroughIssues(values);
            } catch (Exception ex) {
                System.debug('Conversion Error for ==> ' + results.get(VALUE_KEYWORD));
                System.debug('Error message ==> ' + ex.getMessage());
            }
        }
        CopadoCCMutilities.createLogRecords();
        //gets all unique values based on external id from keyValuepairsByExternalId
        return keyValuepairsByExternalId;
    }

    public List<Map<String, String>> fetchRecords(copado__Project__c selectedProject, Boolean isSprint) {
        pid = selectedProject.id;
        projectExtId = selectedProject.Project_External_Id__c;
        workspaceId = selectedProject.Workspace_Id__c;
        namedCredential = selectedProject.Copado_Integration_Setting__r.Named_Credential__c;
        teamInfo = null != selectedProject.Team_Info__c ? selectedProject.Team_Info__c : EMPTY_CHAR;

        getWorkItemIds(selectedProject, isSprint, null);

        for (Integer idCounter = 0; idCounter < wIIds.size(); idCounter++) {
            if(wIIds[idCounter].size() != 0){
                //callout to have all fields for desired workItems
                String responseText = CopadoCCMutilities.MakeCallout(
                    namedCredential,
                    projectExtId,
                    String.join(wIIds[idCounter], COMMA),
                    workspacePath,
                    '', //FIELD_QUERY_PATH + fieldsToFetch,
                    new List<string>{ CONTENT_TYPE_HEADER, CONNECTION_HEADER },
                    Method.GET,
                    null,
                    null,
                    selectedProject
                );
                //Implemented to bypass lack of functionality to place 2 mock response on a flow with one execution point.
                //  --  check testMethodToFetchSprints_VSTS method in TestIntegration.cls
                if (isSprint && Test.isRunningTest()) {
                    responseText = returnMockResponseForSprints();
                }
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseText);
                //use below line if you experience parsing issues on above
                //Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(CopadoCCMUtilities.escapeInvalidChars(responseText));
                try {
                    List<Object> values = (List<Object>) results.get(VALUE_KEYWORD);
                    iterateThroughIssues(values);
                } catch (Exception ex) {
                    System.debug('Conversion Error for ==> ' + results.get(VALUE_KEYWORD));
                    System.debug('Error message ==> ' + ex.getMessage());
                }
            }
        }
        CopadoCCMutilities.createLogRecords();
        //gets all unique values based on external id from keyValuepairsByExternalId
        userStoryList.addAll(keyValuepairsByExternalId.values());
        //returns list to executeUserStoryUpsert batch class
        return userStoryList;
    }
    //INTEGRATION CORE METHODS - END

    //INTEGRATION HELPER METHODS - START
    private void getWorkItemIds(copado__Project__c selectedProject, Boolean isSprint, List<copado__Sprint__c> sprints) {
        if (isSprint) {
            getSprintWorkItemIds(selectedProject, sprints);
            return;
        }
        Integer currentIndex = 0;
        //callout to find ids of the WorkItems exist on VSTS
        String responseText = CopadoCCMutilities.MakeCallout(
            namedCredential,
            projectExtId,
            workspaceId,
            authQueryPath,
            authApiVersion,
            new List<String>{ CONTENT_TYPE_HEADER },
            Method.GET,
            null,
            null,
            selectedProject
        );
        JSONParser parser = JSON.createParser(responseText);
        //wrapper class direct parse
        authWrapper authWrapperItem = (authWrapper) parser.readValueAs(authWrapper.class);
        if((currentIndex != 0 || (currentIndex == 0 && wIIds[0].size() != 0)) && authWrapperItem.workItems.size() > 0){
            currentIndex++;
            wIIds.add(new List<String>());
        }
        Integer counter4Ids = 0;
        for (workItemsWrapper wiw : authWrapperItem.workItems) {
            wIIds[currentIndex].add(String.valueOf(wiw.id));
            counter4Ids++;
            if (counter4Ids == vstsPaginationSize) {
                wIIds.add(new List<String>());
                counter4Ids = 0;
                currentIndex++;
            }
        }
    }

    private void getSprintWorkItemIds(copado__Project__c selectedProject, List<copado__Sprint__c> sprints) {
        if ((null == sprints) || (sprints.isEmpty())) {
            sprints = [
                SELECT Id, Name, External_Id__c
                FROM copado__Sprint__c
                WHERE copado__Project__c = :selectedProject.Id AND External_Id__c != NULL
                ORDER BY copado__Start_Date__c ASC
            ];
        }
        Integer currentIndex = 0;
        for (String team : teamInfo.split(COMMA)) {
            String encodedTeam = team.replaceAll(ONE_CHAR, SPACE_ENCODE);
            for (copado__Sprint__c sprint : sprints) {
                sprintIdByName.put(sprint.name, sprint.Id);
                String currentSprintEndpoint = WORK_ITEM_PER_ITERATION_ENDPOINT.replace(PROJECT_KEYWORD, projectExtId)
                    .replace(TEAM_KEYWORD, encodedTeam)
                    .replace(ITERATION_ID_KEYWORD, sprint.External_Id__c);
                //callout to find ids of the WorkItems exist on VSTS
                String responseText = CopadoCCMutilities.MakeCallout(
                    namedCredential,
                    currentSprintEndpoint,
                    EMPTY_CHAR,
                    EMPTY_CHAR,
                    EMPTY_CHAR,
                    new List<String>{ CONTENT_TYPE_HEADER },
                    Method.GET,
                    null,
                    null,
                    selectedProject
                );
                JSONParser parser = JSON.createParser(responseText);
                //wrapper class direct parse
                sprintWorkItemsWrapper sprintWrapperItem = (sprintWorkItemsWrapper) parser.readValueAs(sprintWorkItemsWrapper.class);
                if((currentIndex != 0 || (currentIndex == 0 && wIIds[0].size() != 0)) && sprintWrapperItem.workItemRelations.size() > 0){
                    currentIndex++;
                    wIIds.add(new List<String>());
                }
                Integer counter4Ids = 0;
                for (targetWrapper targetItem : sprintWrapperItem.workItemRelations) {
                    wIIds[currentIndex].add(String.valueOf(targetItem.target.id));
                    counter4Ids++;
                    if (counter4Ids == vstsPaginationSize) {
                        wIIds.add(new List<String>());
                        counter4Ids = 0;
                        currentIndex++;
                    }
                }
            }
        }
    }

    public Map<String, Map<String, String>> iterateThroughIssues(List<Object> values) {
        Map<String, String> keyValuepairTempMap;
        for (Object value : values) {
            Map<String, Object> currentValue = (Map<String, Object>) value;
            keyValuepairTempMap = new Map<String, String>();
            if (null != currentValue.get(FIELDS_STRING)) {
                Map<String, Object> fields = (Map<String, Object>) currentValue.get(FIELDS_STRING);
                //below four rows are in use for look up and external id purposes
                keyValuepairTempMap.put(ID_KEYWORD, String.valueOf(currentValue.get(ID_KEYWORD)));
                keyValuepairTempMap.put(URL_KEYWORD, String.valueOf(currentValue.get(URL_KEYWORD)));
                keyValuepairTempMap.put(REV_KEYWORD, String.valueOf(currentValue.get(REV_KEYWORD)));
                keyValuepairTempMap.put(PROJECT_ID, pid);
                keyValuepairsByExternalId.put(String.valueOf(currentValue.get(ID_KEYWORD)), iterateThroughFields(fields, keyValuepairTempMap));
            }
        }
        return keyValuepairsByExternalId;
    }

    private Map<String, String> iterateThroughFields(Map<String, Object> fields, Map<String, String> keyValuepairTempMap) {
        for (String sItem : fields.keyset()) {
            if (sItem == ITERATION && !sprintIdByName.isEmpty()) {
                String sprintName = ((String) fields.get(sItem));
                Integer lastIndex = sprintName.lastIndexOf('\\') + 1;
                sprintName = sprintName.substring(lastIndex);
                if (sprintIdByName.containsKey(sprintName)) {
                    keyValuepairTempMap.put(SPRINT_ID, sprintIdByName.get(sprintName));
                }
            } else if (sItem == ASSIGNED_TO) {
                String userEmail;
                if (String.valueOf(fields.get(sItem)).contains(OPENING_TAG)) {
                    //fills up user look up fields, if email address in use on Third Party Platform matches any of the email addresses on current salesforce org.
                    userEmail = String.valueOf(fields.get(sItem)).subStringAfter(OPENING_TAG).subsTringBefore(CLOSING_TAG);
                } else {
                    Map<String, Object> currentValue = (Map<String, Object>) fields.get(sItem);
                    if (currentValue.containsKey(UNIQUE_NAME)) {
                        userEmail = String.valueOf(currentValue.get(UNIQUE_NAME));
                    }
                }
                if(String.isNotBlank(userEmail)){
                    userEmail = userEmail.toLowerCase();
                }
                if (userMap.containsKey(userEmail)) {
                    keyValuepairTempMap.put(DEVELOPER_KEYWORD, userMap.get(userEmail));
                }
            } else if (
                fields.get(sItem) instanceof String ||
                fields.get(sItem) instanceof Integer ||
                fields.get(sItem) instanceof Decimal ||
                fields.get(sItem) instanceof Double ||
                fields.get(sItem) == null
            ) {
                //Prepares values from String
                keyValuepairTempMap.put(sItem.toLowerCase(), String.valueOf(fields.get(sItem)));
            } else if (fields.get(sItem) instanceof Map<String, Object>) {
                //Prepares values from Json Object
                Map<String, Object> tempObject = (Map<String, Object>) fields.get(sItem);
                if (null != tempObject.get(UNIQUE_NAME)) {
                    String cuEmail = String.valueOf(tempObject.get(UNIQUE_NAME)).toLowerCase();
                    if (userMap.containsKey(cuEmail)) {
                        keyValuepairTempMap.put(sItem.toLowerCase(), userMap.get(cuEmail));
                    }
                } else if (null != tempObject.get(DISPLAY_NAME)) {
                    keyValuepairTempMap.put(sItem.toLowerCase(), (String) tempObject.get(DISPLAY_NAME));
                }
            } else {
                keyValuepairTempMap.put(sItem.toLowerCase(), String.valueOf(fields.get(sItem)));
            }
        }
        return keyValuepairTempMap;
    }

    /**
     * gets planned sprints
     *
     * @param selectedProject
     *
     * @return sprint list response
     */
    private void getSprints(copado__Project__c selectedProject) {
        List<copado__Sprint__c> sprintsUpsert = new List<copado__Sprint__c>();
        List<String> teams = teamInfo.split(COMMA);
        for (String team : teams) {
            String encodedTeam = team.replaceAll(ONE_CHAR, SPACE_ENCODE);

            String responseText = CopadoCCMutilities.MakeCallout(
                namedCredential,
                ITERATION_ENDPOINT.replace(PROJECT_KEYWORD, projectExtId).replace(TEAM_KEYWORD, encodedTeam),
                EMPTY_CHAR,
                EMPTY_CHAR,
                EMPTY_CHAR,
                new List<String>{ CONTENT_TYPE_HEADER },
                Method.GET,
                null,
                null,
                selectedProject
            );

            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseText);
            sprintsUpsert.addAll(upsertSprints((List<Object>) results.get(VALUE_KEYWORD), selectedProject.Id));
        }
        upsert sprintsUpsert External_Id__c;
    }

    public void fetchSprints(copado__Project__c selectedProject) {
        namedCredential = selectedProject.Copado_Integration_Setting__r.Named_Credential__c;
        projectExtId = null != selectedProject.Project_External_Id__c ? selectedProject.Project_External_Id__c : EMPTY_CHAR;
        teamInfo = null != selectedProject.Team_Info__c ? selectedProject.Team_Info__c : EMPTY_CHAR;

        getSprints(selectedProject);
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
            Map<String, Object> attributes = (Map<String, Object>) tempMap.get(ATTRIBUTES_KEYWORD);
            sprintsUpsert.add(
                new copado__Sprint__c(
                    External_Id__c = String.valueOf(tempMap.get(ID_KEYWORD)),
                    Name = String.valueOf(tempMap.get(NAME_KEYWORD)),
                    copado__Start_Date__c = convertStringToDate(attributes.get(START_DATE)),
                    copado__End_Date__c = convertStringToDate(attributes.get(FINISH_DATE)),
                    copado__Project__c = projectId
                )
            );
        }
        return sprintsUpsert;
    }

    private Date convertStringToDate(Object dateValue) {
        return null != dateValue ? Date.valueOf(String.valueOf(dateValue).replace(T_CHAR, ONE_CHAR).replace(Z_CHAR, EMPTY_CHAR)) : null;
    }

    public String returnMockResponseForSprints() {
        return MOCK_WORK_ITEM_RESPONSE_FOR_SPRINT;
    }
    //INTEGRATION HELPER METHODS - START
}