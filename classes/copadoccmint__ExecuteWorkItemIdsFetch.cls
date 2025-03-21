global class ExecuteWorkItemIdsFetch extends VSTSIntegrationConstants implements Database.Batchable<List<String>>,Database.AllowsCallouts,Database.Stateful {
    private String pid;
    private String projectExtId;
    private String workspaceId;
    private String teamInfo;
    private String namedCredential;
    private copado__Project__c project;
    private Boolean isSprint;
    
    public List<Map<String, String>> userStoryList {
        get {
            if (null == userStoryList) {
                userStoryList = new List<Map<String, String>>();
            }
            return userStoryList;
        }
        set;
    }
    public List<List<String>> wIIds {
        get {
            if (null == wIIds) {
                wIIds = new List<List<String>>{new List<String>()};
            }
            return wIIds;
        }
        set;
    }
    global ExecuteWorkItemIdsFetch(copado__Project__c project, Boolean isSprint) {
        this.project = project;
        this.isSprint = isSprint;
        pid = project.id;
        projectExtId = project.Project_External_Id__c;
        workspaceId = project.Workspace_Id__c;
        namedCredential = project.Copado_Integration_Setting__r.Named_Credential__c;
        teamInfo = null != project.Team_Info__c ? project.Team_Info__c : EMPTY_CHAR;
    }
    global Iterable<List<String>> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
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
            project
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
        return wIIds;
    }

    global void execute(Database.BatchableContext BC, List<List<String>> scope) {
        List<List<String>> currentWiIds = scope;
        String ids = '';
        for(Integer i = 0; i < currentWiIds.size(); i++){
            ids += String.join(currentWiIds[i], COMMA) + COMMA;
        }
        ids = ids.subString(0, ids.length() - 1);
        if(currentWiIds.size() != 0){
            //callout to have all fields for desired workItems
            String responseText = CopadoCCMutilities.MakeCallout(
                namedCredential,
                projectExtId,
                ids,
                workspacePath,
                '', //FIELD_QUERY_PATH + fieldsToFetch,
                new List<string>{ CONTENT_TYPE_HEADER, CONNECTION_HEADER },
                Method.GET,
                null,
                null,
                project
            );
            //Implemented to bypass lack of functionality to place 2 mock response on a flow with one execution point.
            //  --  check testMethodToFetchSprints_VSTS method in TestIntegration.cls
            if (isSprint && Test.isRunningTest()) {
                responseText = new VSTSIntegration(pid).returnMockResponseForSprints();
            }
            Map<String, Object> results;
            try {
                results = (Map<String, Object>) JSON.deserializeUntyped(responseText);
                //use below line if you experience parsing issues on above
                //Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(CopadoCCMUtilities.escapeInvalidChars(responseText));
            
                List<Object> values = (List<Object>) results.get(VALUE_KEYWORD);
                List<Map<String, String>> userStories = new VSTSIntegration(pid).iterateThroughIssues(values).values();
                if(!userStories.isEmpty()){
                    this.userStoryList.addAll(userStories);
                }
            } catch (Exception ex) {
                if(null != results) {
                    System.debug('Conversion Error for ==> ' + results.get(VALUE_KEYWORD));
                }
                System.debug('Error message ==> ' + ex.getMessage());
            }
        }
        CopadoCCMutilities.createLogRecords();
        //gets all unique values based on external id from keyValuepairsByExternalId
        
    }

    global void finish(Database.BatchableContext BC) {
        database.executeBatch(new ExecuteUserStoryUpsert(project, userStoryList, false));
    }
}