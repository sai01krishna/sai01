/**
 * Test Class for CCM Integrations.
 *
 * @author Ümit Can Uçkan
 * @version 1.0
 * @since CCM Integrations 1.0
 */
@IsTest
private class TestIntegration {
    @testSetup
    static void fieldMappingsTest() {
        Copado_Integration_Setting__c cis1 = new Copado_Integration_Setting__c(
            name = 'JIRA',
            external_system__c = 'JIRA',
            Named_Credential__c = 'Test_JIRA'
        );
        Copado_Integration_Setting__c cis2 = new Copado_Integration_Setting__c(
            name = 'VSTS',
            external_system__c = 'Visual Studio Team Services',
            Named_Credential__c = 'Test_VSTS'
        );
        insert new List<Copado_Integration_Setting__c>{ cis1, cis2 };

        copado__Project__c pro1 = new copado__Project__c(
            name = 'MY JIRA Project',
            Project_External_Id__c = 'MTP',
            Copado_Integration_Setting__c = cis1.id,
            enable_logs__c = true
        );
        copado__Project__c pro2 = new copado__Project__c(
            name = 'MY VSTS Project',
            Project_External_Id__c = 'MyFirstProject',
            Copado_Integration_Setting__c = cis2.id,
            Workspace_Id__c = 'a404576b-7158-4661-9e93-19be9d8e3025',
            Team_Info__c = 'MyFirstProject Team'
        );
        insert new List<copado__Project__c>{ pro1, pro2 };

        Record_Type_Mapping__c rtm1 = new Record_Type_Mapping__c(
            Project__c = pro1.id,
            Salesforce_Record_Type_Name__c = 'Bug',
            Third_Party_Record_Type_Name__c = 'Bug'
        );

        Record_Type_Mapping__c rtm2 = new Record_Type_Mapping__c(
            Project__c = pro1.id,
            Salesforce_Record_Type_Name__c = 'User Story',
            Third_Party_Record_Type_Name__c = 'Sub-task'
        );

        Record_Type_Mapping__c rtm3 = new Record_Type_Mapping__c(
            Project__c = pro1.id,
            Salesforce_Record_Type_Name__c = 'User Story',
            Third_Party_Record_Type_Name__c = 'Story'
        );

        Record_Type_Mapping__c rtm4 = new Record_Type_Mapping__c(
            Project__c = pro1.id,
            Salesforce_Record_Type_Name__c = 'Investigation',
            Third_Party_Record_Type_Name__c = 'Bug'
        );
        insert new List<Record_Type_Mapping__c>{ rtm1, rtm2, rtm3, rtm4 };
        Field_Mapping__c fmJira1 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__Story_Points_SFDC__c',
            Third_Party_Field_Name__c = 'storypoints'
        );
        Field_Mapping__c fmJira2 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__Close_Date__c',
            Third_Party_Field_Name__c = 'closedate'
        );

        Field_Mapping__c fmJira3 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__Latest_Commit_Date__c',
            Third_Party_Field_Name__c = 'commitdate'
        );
        Field_Mapping__c fm1 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__User_Story_Title__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'summary'
        );
        Field_Mapping__c fm2 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__Status__c',
            Target_Field_Type__c = 'object',
            Third_Party_Field_Name__c = 'status'
        );
        Field_Mapping__c fm3 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__Functional_Specifications__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'description'
        );
        Field_Mapping__c fm4 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'RecordTypeId',
            Target_Field_Type__c = 'object',
            Third_Party_Field_Name__c = 'issuetype'
        );
        Field_Mapping__c fm5 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copadoccmint__External_Id__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'id'
        );
        Field_Mapping__c fm6 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copadoccmint__JIRA_Key__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'key'
        );
        Field_Mapping__c fm7 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__Developer__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'developer'
        );
        Field_Mapping__c fm8 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__Project__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'projectId'
        );

        Field_Mapping__c fm8_2 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro1.id,
            Salesforce_Field_Name__c = 'copado__Sprint__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'sprintId'
        );

        Field_Mapping__c fm9 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copadoccmint__External_Id__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'id'
        );
        Field_Mapping__c fm10 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copado__Project__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'projectId'
        );
        Field_Mapping__c fm11 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copado__Status__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'System.State'
        );
        Field_Mapping__c fm12 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = false,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copado__User_Story_Title__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'System.Title'
        );
        Field_Mapping__c fm13 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copado__Functional_Specifications__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'System.Reason'
        );
        Field_Mapping__c fm14 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'recordTypeId',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'recordTypeId'
        );
        Field_Mapping__c fm15 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copado__Priority__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'Microsoft.VSTS.Common.Priority'
        );
        Field_Mapping__c fm16 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copado__Developer__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'developer'
        );
        Field_Mapping__c fm17 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copado__Story_Points_SFDC__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'Microsoft.VSTS.Scheduling.StoryPoints'
        );
        Field_Mapping__c fm18 = new Field_Mapping__c(
            Exclude_from_su__c = false,
            Exclude_from_tpu__c = true,
            Project__c = pro2.id,
            Salesforce_Field_Name__c = 'copado__Sprint__c',
            Target_Field_Type__c = 'string',
            Third_Party_Field_Name__c = 'sprintId'
        );
        insert new List<Field_Mapping__c>{
            fm1,
            fm2,
            fm3,
            fm4,
            fm5,
            fm6,
            fm7,
            fm8,
            fm8_2,
            fm9,
            fm10,
            fm11,
            fm12,
            fm13,
            fm14,
            fm15,
            fm16,
            fm17,
            fm18,
            fmJira1,
            fmJira2,
            fmJira3
        };

        copado__User_Story__c us1 = new copado__User_Story__c(
            copado__project__c = pro1.id,
            external_id__c = '10003',
            jira_key__c = 'MTP-4',
            copado__status__c = 'Done',
            copado__userStory_Role__c = 'Bug',
            copado__User_Story_Title__c = 'Test title for user story!'
        );
        copado__User_Story__c us2 = new copado__User_Story__c(
            copado__project__c = pro2.id,
            external_id__c = '3',
            copado__status__c = 'Draft',
            copado__User_Story_Title__c = 'Test title for user story!',
            enable_logs__c = true
        );
        insert new List<copado__User_Story__c>{ us1, us2 };
    }

    @IsTest
    static void testMethod2FetchfromJIRA() {
        id proId = [SELECT id FROM copado__Project__c WHERE name = 'MY JIRA Project' LIMIT 1].id;
        Test.startTest();
        CopadoMockHttpResponseGenerator fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"expand":"schema,names","startAt":0,"maxResults":50,"total":4,"issues":[{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"10003","self":"https://ucuckan.atlassian.net/rest/api/2/issue/10003","key":"MTP-4","fields":{"issuetype":{"self":"https://ucuckan.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"Storiestrackfunctionalityorfeaturesexpressedasusergoals.","iconUrl":"https://ucuckan.atlassian.net/secure/viewavatar?size=xsmall&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"components":[],"timespent":null,"timeoriginalestimate":null,"project":{"self":"https://ucuckan.atlassian.net/rest/api/2/project/10000","id":"10000","key":"MTP","name":"MyTestProject","projectTypeKey":"software","avatarUrls":{"48x48":"https://ucuckan.atlassian.net/secure/projectavatar?avatarId=10324","24x24":"https://ucuckan.atlassian.net/secure/projectavatar?size=small&avatarId=10324","16x16":"https://ucuckan.atlassian.net/secure/projectavatar?size=xsmall&avatarId=10324","32x32":"https://ucuckan.atlassian.net/secure/projectavatar?size=medium&avatarId=10324"}},"description":null,"customfield_10010":null,"customfield_10011":null,"fixVersions":[],"aggregatetimespent":null,"customfield_10012":null,"resolution":null,"customfield_10015":null,"customfield_10006":null,"customfield_10007":null,"security":null,"customfield_10008":["com.atlassian.greenhopper.service.sprint.Sprint@39b1ed73[id=2,rapidViewId=1,state=FUTURE,name=MTPSprint2,goal=<null>,startDate=<null>,endDate=<null>,completeDate=<null>,sequence=2]"],"aggregatetimeestimate":null,"customfield_10009":"0|i0000b:","resolutiondate":null,"workratio":-1,"summary":"bltestissuealso","lastViewed":"2018-06-06T15:35:57.633+0200","watches":{"self":"https://ucuckan.atlassian.net/rest/api/2/issue/MTP-4/watchers","watchCount":1,"isWatching":true},"creator":{"self":"https://ucuckan.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"5b17b2f5d50d3d56fa78e586","emailAddress":"ucan+jira@copa.do","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"umitcanuckan","active":true,"timeZone":"Europe/Madrid"},"subtasks":[],"created":"2018-06-06T12:39:14.832+0200","reporter":{"self":"https://ucuckan.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"5b17b2f5d50d3d56fa78e586","emailAddress":"ucan+jira@copa.do","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"umitcanuckan","active":true,"timeZone":"Europe/Madrid"},"customfield_10000":"{}","aggregateprogress":{"progress":0,"total":0},"customfield_10001":null,"priority":{"self":"https://ucuckan.atlassian.net/rest/api/2/priority/3","iconUrl":"https://ucuckan.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"customfield_10002":null,"labels":[],"customfield_10016":"TestjirafieldvalueforjSon","environment":null,"aggregatetimeoriginalestimate":null,"timeestimate":null,"versions":[],"duedate":null,"progress":{"progress":0,"total":0},"issuelinks":[],"votes":{"self":"https://ucuckan.atlassian.net/rest/api/2/issue/MTP-4/votes","votes":0,"hasVoted":false},"assignee":null,"updated":"2018-06-06T15:36:01.910+0200","status":{"self":"https://ucuckan.atlassian.net/rest/api/2/status/10000","description":"","iconUrl":"https://ucuckan.atlassian.net/","name":"ToDo","id":"10000","statusCategory":{"self":"https://ucuckan.atlassian.net/rest/api/2/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"ToDo"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"10002","self":"https://ucuckan.atlassian.net/rest/api/2/issue/10002","key":"MTP-3","fields":{"issuetype":{"self":"https://ucuckan.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"Storiestrackfunctionalityorfeaturesexpressedasusergoals.","iconUrl":"https://ucuckan.atlassian.net/secure/viewavatar?size=xsmall&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"components":[],"timespent":null,"timeoriginalestimate":null,"description":null,"project":{"self":"https://ucuckan.atlassian.net/rest/api/2/project/10000","id":"10000","key":"MTP","name":"MyTestProject","projectTypeKey":"software","avatarUrls":{"48x48":"https://ucuckan.atlassian.net/secure/projectavatar?avatarId=10324","24x24":"https://ucuckan.atlassian.net/secure/projectavatar?size=small&avatarId=10324","16x16":"https://ucuckan.atlassian.net/secure/projectavatar?size=xsmall&avatarId=10324","32x32":"https://ucuckan.atlassian.net/secure/projectavatar?size=medium&avatarId=10324"}},"customfield_10010":null,"fixVersions":[],"customfield_10011":null,"customfield_10012":null,"aggregatetimespent":null,"resolution":null,"customfield_10015":null,"customfield_10006":null,"customfield_10007":null,"security":null,"customfield_10008":["com.atlassian.greenhopper.service.sprint.Sprint@39b1ed73[id=2,rapidViewId=1,state=FUTURE,name=MTPSprint2,goal=<null>,startDate=<null>,endDate=<null>,completeDate=<null>,sequence=2]"],"customfield_10009":"0|i0000f:","aggregatetimeestimate":null,"resolutiondate":null,"workratio":-1,"summary":"bltestissue","watches":{"self":"https://ucuckan.atlassian.net/rest/api/2/issue/MTP-3/watchers","watchCount":1,"isWatching":true},"lastViewed":"2018-06-06T15:36:19.216+0200","creator":{"self":"https://ucuckan.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"5b17b2f5d50d3d56fa78e586","emailAddress":"ucan+jira@copa.do","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"umitcanuckan","active":true,"timeZone":"Europe/Madrid"},"subtasks":[],"created":"2018-06-06T12:39:04.402+0200","reporter":{"self":"https://ucuckan.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"5b17b2f5d50d3d56fa78e586","emailAddress":"ucan+jira@copa.do","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"umitcanuckan","active":true,"timeZone":"Europe/Madrid"},"aggregateprogress":{"progress":0,"total":0},"customfield_10000":"{}","priority":{"self":"https://ucuckan.atlassian.net/rest/api/2/priority/3","iconUrl":"https://ucuckan.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"customfield_10001":null,"customfield_10002":null,"labels":[],"customfield_10016":"4JSON","environment":null,"aggregatetimeoriginalestimate":null,"timeestimate":null,"versions":[],"duedate":null,"progress":{"progress":0,"total":0},"issuelinks":[],"votes":{"self":"https://ucuckan.atlassian.net/rest/api/2/issue/MTP-3/votes","votes":0,"hasVoted":false},"assignee":null,"updated":"2018-06-06T15:36:19.169+0200","status":{"self":"https://ucuckan.atlassian.net/rest/api/2/status/10000","description":"","iconUrl":"https://ucuckan.atlassian.net/","name":"ToDo","id":"10000","statusCategory":{"self":"https://ucuckan.atlassian.net/rest/api/2/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"ToDo"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"10001","self":"https://ucuckan.atlassian.net/rest/api/2/issue/10001","key":"MTP-2","fields":{"issuetype":{"self":"https://ucuckan.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"Storiestrackfunctionalityorfeaturesexpressedasusergoals.","iconUrl":"https://ucuckan.atlassian.net/secure/viewavatar?size=xsmall&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"components":[],"timespent":null,"timeoriginalestimate":null,"description":null,"project":{"self":"https://ucuckan.atlassian.net/rest/api/2/project/10000","id":"10000","key":"MTP","name":"MyTestProject","projectTypeKey":"software","avatarUrls":{"48x48":"https://ucuckan.atlassian.net/secure/projectavatar?avatarId=10324","24x24":"https://ucuckan.atlassian.net/secure/projectavatar?size=small&avatarId=10324","16x16":"https://ucuckan.atlassian.net/secure/projectavatar?size=xsmall&avatarId=10324","32x32":"https://ucuckan.atlassian.net/secure/projectavatar?size=medium&avatarId=10324"}},"customfield_10010":null,"fixVersions":[],"customfield_10011":null,"aggregatetimespent":null,"customfield_10012":null,"resolution":null,"customfield_10015":null,"customfield_10006":null,"security":null,"customfield_10007":null,"customfield_10008":["com.atlassian.greenhopper.service.sprint.Sprint@61430419[id=1,rapidViewId=1,state=ACTIVE,name=MTPSprint1,goal=PatrickKluvert,startDate=2018-06-06T10:39:59.927Z,endDate=2018-06-20T10:39:00.000Z,completeDate=<null>,sequence=1]"],"customfield_10009":"0|i00007:","aggregatetimeestimate":null,"resolutiondate":null,"workratio":-1,"summary":"showmustgoon","lastViewed":null,"watches":{"self":"https://ucuckan.atlassian.net/rest/api/2/issue/MTP-2/watchers","watchCount":1,"isWatching":true},"creator":{"self":"https://ucuckan.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"5b17b2f5d50d3d56fa78e586","emailAddress":"ucan+jira@copa.do","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"umitcanuckan","active":true,"timeZone":"Europe/Madrid"},"subtasks":[],"created":"2018-06-06T12:38:41.444+0200","reporter":{"self":"https://ucuckan.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"5b17b2f5d50d3d56fa78e586","emailAddress":"ucan+jira@copa.do","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"umitcanuckan","active":true,"timeZone":"Europe/Madrid"},"customfield_10000":"{}","aggregateprogress":{"progress":0,"total":0},"priority":{"self":"https://ucuckan.atlassian.net/rest/api/2/priority/3","iconUrl":"https://ucuckan.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"customfield_10001":null,"customfield_10002":null,"labels":[],"customfield_10016":null,"environment":null,"timeestimate":null,"aggregatetimeoriginalestimate":null,"versions":[],"duedate":null,"progress":{"progress":0,"total":0},"votes":{"self":"https://ucuckan.atlassian.net/rest/api/2/issue/MTP-2/votes","votes":0,"hasVoted":false},"issuelinks":[],"assignee":null,"updated":"2018-06-06T12:38:41.444+0200","status":{"self":"https://ucuckan.atlassian.net/rest/api/2/status/10000","description":"","iconUrl":"https://ucuckan.atlassian.net/","name":"ToDo","id":"10000","statusCategory":{"self":"https://ucuckan.atlassian.net/rest/api/2/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"ToDo"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"10000","self":"https://ucuckan.atlassian.net/rest/api/2/issue/10000","key":"MTP-1","fields":{"issuetype":{"self":"https://ucuckan.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"Storiestrackfunctionalityorfeaturesexpressedasusergoals.","iconUrl":"https://ucuckan.atlassian.net/secure/viewavatar?size=xsmall&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"components":[],"timespent":null,"timeoriginalestimate":null,"project":{"self":"https://ucuckan.atlassian.net/rest/api/2/project/10000","id":"10000","key":"MTP","name":"MyTestProject","projectTypeKey":"software","avatarUrls":{"48x48":"https://ucuckan.atlassian.net/secure/projectavatar?avatarId=10324","24x24":"https://ucuckan.atlassian.net/secure/projectavatar?size=small&avatarId=10324","16x16":"https://ucuckan.atlassian.net/secure/projectavatar?size=xsmall&avatarId=10324","32x32":"https://ucuckan.atlassian.net/secure/projectavatar?size=medium&avatarId=10324"}},"description":null,"customfield_10010":null,"customfield_10011":null,"fixVersions":[],"aggregatetimespent":null,"customfield_10012":null,"resolution":null,"customfield_10015":null,"customfield_10006":null,"security":null,"customfield_10007":null,"customfield_10008":["com.atlassian.greenhopper.service.sprint.Sprint@61430419[id=1,rapidViewId=1,state=ACTIVE,name=MTPSprint1,goal=PatrickKluvert,startDate=2018-06-06T10:39:59.927Z,endDate=2018-06-20T10:39:00.000Z,completeDate=<null>,sequence=1]"],"customfield_10009":"0|hzzzzz:","aggregatetimeestimate":null,"resolutiondate":null,"workratio":-1,"summary":"testmustbedone","lastViewed":"2018-06-06T12:29:54.017+0200","watches":{"self":"https://ucuckan.atlassian.net/rest/api/2/issue/MTP-1/watchers","watchCount":1,"isWatching":true},"creator":{"self":"https://ucuckan.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"5b17b2f5d50d3d56fa78e586","emailAddress":"ucan+jira@copa.do","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"umitcanuckan","active":true,"timeZone":"Europe/Madrid"},"subtasks":[],"created":"2018-06-06T12:29:34.676+0200","reporter":{"self":"https://ucuckan.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"5b17b2f5d50d3d56fa78e586","emailAddress":"ucan+jira@copa.do","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/2421480cfe8dc6b91c361089c8321dd4?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F2421480cfe8dc6b91c361089c8321dd4%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"umitcanuckan","active":true,"timeZone":"Europe/Madrid"},"aggregateprogress":{"progress":0,"total":0},"customfield_10000":"{}","customfield_10001":null,"priority":{"self":"https://ucuckan.atlassian.net/rest/api/2/priority/3","iconUrl":"https://ucuckan.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"customfield_10002":null,"labels":[],"customfield_10016":null,"environment":null,"timeestimate":null,"aggregatetimeoriginalestimate":null,"versions":[],"duedate":null,"progress":{"progress":0,"total":0},"votes":{"self":"https://ucuckan.atlassian.net/rest/api/2/issue/MTP-1/votes","votes":0,"hasVoted":false},"issuelinks":[],"assignee":null,"updated":"2018-06-06T12:29:34.676+0200","status":{"self":"https://ucuckan.atlassian.net/rest/api/2/status/10000","description":"","iconUrl":"https://ucuckan.atlassian.net/","name":"ToDo","id":"10000","statusCategory":{"self":"https://ucuckan.atlassian.net/rest/api/2/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"ToDo"}}}}]}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        PageReference pageRef = Page.SyncUserStories;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid', proId);
        ApexPages.currentPage().getParameters().put('isSprint', 'false');
        new SyncUserStoriesController().ScheduleFetchOperationAndReturn2Project();
        System.assertEquals(2, [SELECT id FROM copado__User_Story__c].size());
        System.assertEquals(2, [SELECT id FROM Copado_Integration_Setting__c].size());
        System.assertEquals(2, [SELECT id FROM copado__Project__c].size());
        Test.stopTest();
    }

    @IsTest
    static void testMethod2FetchfromVSTS() {
        id proId = [SELECT id FROM copado__Project__c WHERE name = 'MY VSTS Project' LIMIT 1].id;
        Test.startTest();
        CopadoMockHttpResponseGenerator fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"count":3,"value":[{"id":1,"rev":3,"fields":{"System.AreaPath":"MyFirstProject","System.TeamProject":"MyFirstProject","System.IterationPath":"MyFirstProject","System.WorkItemType":"UserStory","System.State":"New","System.Reason":"New","System.CreatedDate":"2018-05-29T10:08:22.893Z","System.CreatedBy":"UmitUckan<umithuckan@hotmail.com>","System.ChangedDate":"2018-05-29T14:23:26.707Z","System.ChangedBy":"UmitUckan<umithuckan@hotmail.com>","System.Title":"test1","System.BoardColumn":"New","System.BoardColumnDone":false,"Microsoft.VSTS.Scheduling.StoryPoints":5.0,"Microsoft.VSTS.Common.StateChangeDate":"2018-05-29T10:08:22.893Z","Microsoft.VSTS.Common.Priority":1,"Microsoft.VSTS.Common.ValueArea":"Architectural","Microsoft.VSTS.Common.Risk":"2-Medium","WEF_F5A6319081AC47A6B7DA08F2435C6104_Kanban.Column":"New","WEF_F5A6319081AC47A6B7DA08F2435C6104_Kanban.Column.Done":false,"System.Description":"test","Microsoft.VSTS.Common.AcceptanceCriteria":"test1234","System.Tags":"test"},"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/1"},{"id":2,"rev":6,"fields":{"System.AreaPath":"MyFirstProject","System.TeamProject":"MyFirstProject","System.IterationPath":"MyFirstProject","System.WorkItemType":"UserStory","System.State":"Active","System.Reason":"Implementationstarted","System.AssignedTo":"UmitUckan<umithuckan@hotmail.com>","System.CreatedDate":"2018-05-29T10:08:49.097Z","System.CreatedBy":"UmitUckan<umithuckan@hotmail.com>","System.ChangedDate":"2018-05-29T13:37:35.327Z","System.ChangedBy":"UmitUckan<umithuckan@hotmail.com>","System.Title":"test2","System.BoardColumn":"Active","System.BoardColumnDone":false,"Microsoft.VSTS.Common.StateChangeDate":"2018-05-29T13:37:35.327Z","Microsoft.VSTS.Common.ActivatedDate":"2018-05-29T13:37:35.327Z","Microsoft.VSTS.Common.ActivatedBy":"UmitUckan<umithuckan@hotmail.com>","Microsoft.VSTS.Common.Priority":2,"Microsoft.VSTS.Common.ValueArea":"Business","WEF_F5A6319081AC47A6B7DA08F2435C6104_Kanban.Column":"Active","WEF_F5A6319081AC47A6B7DA08F2435C6104_Kanban.Column.Done":false},"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/2"},{"id":3,"rev":3,"fields":{"System.AreaPath":"MyFirstProject","System.TeamProject":"MyFirstProject","System.IterationPath":"MyFirstProject","System.WorkItemType":"UserStory","System.State":"Resolved","System.Reason":"Codecompleteandunittestspass","System.AssignedTo":"UmitUckan<umithuckan@hotmail.com>","System.CreatedDate":"2018-05-29T10:09:13.203Z","System.CreatedBy":"UmitUckan<umithuckan@hotmail.com>","System.ChangedDate":"2018-05-29T13:37:38.39Z","System.ChangedBy":"UmitUckan<umithuckan@hotmail.com>","System.Title":"test3","System.BoardColumn":"Resolved","System.BoardColumnDone":false,"Microsoft.VSTS.Common.StateChangeDate":"2018-05-29T13:37:38.39Z","Microsoft.VSTS.Common.ActivatedDate":"2018-05-29T13:37:38.39Z","Microsoft.VSTS.Common.ActivatedBy":"UmitUckan<umithuckan@hotmail.com>","Microsoft.VSTS.Common.ResolvedDate":"2018-05-29T13:37:38.39Z","Microsoft.VSTS.Common.ResolvedBy":"UmitUckan<umithuckan@hotmail.com>","Microsoft.VSTS.Common.Priority":2,"Microsoft.VSTS.Common.ValueArea":"Business","WEF_F5A6319081AC47A6B7DA08F2435C6104_Kanban.Column":"Resolved","WEF_F5A6319081AC47A6B7DA08F2435C6104_Kanban.Column.Done":false},"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/3"}],"workItems":[{"id":1,"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/_apis/wit/workItems/1"},{"id":2,"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/_apis/wit/workItems/2"},{"id":3,"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/_apis/wit/workItems/3"}]}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        ScheduleUserStoryFetch Susf = new ScheduleUserStoryFetch(proId, false);
        String str = Datetime.now().addSeconds(5).format('s m H d M ? yyyy');
        String jobID = system.schedule('ScheduleUserStoryFetch - ' + DateTime.Now() + '.' + math.mod(DateTime.now().getTime(), 1000), str, Susf);
        system.debug('jobId ==> ' + jobId);
        System.assertEquals(2, [SELECT id FROM copado__User_Story__c].size());
        System.assertEquals(2, [SELECT id FROM Copado_Integration_Setting__c].size());
        System.assertEquals(2, [SELECT id FROM copado__Project__c].size());
        Test.stopTest();
    }

    @IsTest
    static void testMethod2UpdateVSTS() {
        id proId = [SELECT id FROM copado__Project__c WHERE name = 'MY VSTS Project' LIMIT 1].id;
        copado__User_Story__c usItem = [
            SELECT id, copado__status__c
            FROM copado__User_Story__c
            WHERE copado__project__r.name = 'MY VSTS Project'
            LIMIT 1
        ];
        Test.startTest();
        CopadoMockHttpResponseGenerator fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"id":3,"rev":13,"fields":{"System.AreaPath":"MyFirstProject","System.TeamProject":"MyFirstProject","System.IterationPath":"MyFirstProject","System.WorkItemType":"User Story","System.State":"Ready for testing","System.Reason":"code complete and unit tests pass","System.AssignedTo":"Mert Yaltı <umithuckan@hotmail.com>","System.CreatedDate":"2018-05-29T10:09:13.203Z","System.CreatedBy":"Mert Yaltı <umithuckan@hotmail.com>","System.ChangedDate":"2018-06-12T13:48:49.87Z","System.ChangedBy":"Mert Yaltı <umithuckan@hotmail.com>","System.Title":"Fede VTST update is done!","Microsoft.VSTS.Common.StateChangeDate":"2018-06-12T13:48:49.87Z","Microsoft.VSTS.Common.ActivatedDate":"2018-05-29T13:37:38.39Z","Microsoft.VSTS.Common.ActivatedBy":"Mert Yaltı <umithuckan@hotmail.com>","Microsoft.VSTS.Common.ResolvedDate":"2018-05-29T13:37:38.39Z","Microsoft.VSTS.Common.ResolvedBy":"Mert Yaltı <umithuckan@hotmail.com>","Microsoft.VSTS.Common.Priority":3,"Microsoft.VSTS.Common.ValueArea":"Business","WEF_F5A6319081AC47A6B7DA08F2435C6104_Kanban.Column.Done":false},"_links":{"self":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/3"},"workItemUpdates":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/3/updates"},"workItemRevisions":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/3/revisions"},"workItemHistory":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/3/history"},"html":{"href":"https://copadointegrationspoc.visualstudio.com/web/wi.aspx?pcguid=1f826804-449f-44c5-b503-bdc1bee0db1a&id=3"},"workItemType":{"href":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/_apis/wit/workItemTypes/User%20Story"},"fields":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/wit/fields"}},"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/3"}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        usItem.copado__status__c = 'Resolved';
        update usItem;
        System.assertEquals('Resolved', usItem.copado__status__c);
        System.assertEquals(2, [SELECT id FROM copado__User_Story__c].size());
        System.assertEquals(2, [SELECT id FROM Copado_Integration_Setting__c].size());
        System.assertEquals(2, [SELECT id FROM copado__Project__c].size());
        Test.stopTest();
    }

    @IsTest
    static void testMethod2UpdateJIRA() {
        id proId = [SELECT id FROM copado__Project__c WHERE name = 'MY JIRA Project' LIMIT 1].id;
        copado__User_Story__c usItem = [
            SELECT id, copado__status__c
            FROM copado__User_Story__c
            WHERE copado__project__r.name = 'MY JIRA Project'
            LIMIT 1
        ];
        Test.startTest();
        CopadoMockHttpResponseGenerator fakeResponse = new CopadoMockHttpResponseGenerator(
            204,
            'No Content',
            '{"expand":"transitions","transitions":[{"id":"11","name":"To Do","to":{"self":"https://ucuckan.atlassian.net/rest/api/2/status/10000","description":"","iconUrl":"https://ucuckan.atlassian.net/","name":"To Do","id":"10000","statusCategory":{"self":"https://ucuckan.atlassian.net/rest/api/2/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"To Do"}},"hasScreen":false,"isGlobal":true,"isInitial":false,"isConditional":false},{"id":"21","name":"In Progress","to":{"self":"https://ucuckan.atlassian.net/rest/api/2/status/3","description":"This issue is being actively worked on at the moment by the assignee.","iconUrl":"https://ucuckan.atlassian.net/images/icons/statuses/inprogress.png","name":"In Progress","id":"3","statusCategory":{"self":"https://ucuckan.atlassian.net/rest/api/2/statuscategory/4","id":4,"key":"indeterminate","colorName":"yellow","name":"In Progress"}},"hasScreen":false,"isGlobal":true,"isInitial":false,"isConditional":false},{"id":"31","name":"Done","to":{"self":"https://ucuckan.atlassian.net/rest/api/2/status/10001","description":"","iconUrl":"https://ucuckan.atlassian.net/","name":"Done","id":"10001","statusCategory":{"self":"https://ucuckan.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}},"hasScreen":false,"isGlobal":true,"isInitial":false,"isConditional":false}]}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        usItem.copado__status__c = 'To Do';
        update usItem;
        System.assertEquals('To Do', usItem.copado__status__c);
        System.assertEquals(2, [SELECT id FROM copado__User_Story__c].size());
        System.assertEquals(2, [SELECT id FROM Copado_Integration_Setting__c].size());
        System.assertEquals(2, [SELECT id FROM copado__Project__c].size());
        Test.stopTest();
    }
    @IsTest
    static void testMethodToFetchSprints_JIRA() {
        copado__Project__c project = [
            SELECT
                Id,
                Name,
                Copado_Integration_Setting__r.External_System__c,
                Copado_Integration_Setting__r.Named_Credential__c,
                JQL_Extended_Filter__c,
                Enable_Logs__c,
                Project_External_Id__c,
                Workspace_Id__c
            FROM copado__Project__c
            WHERE name = 'MY JIRA Project'
            LIMIT 1
        ];

        Id proId = project.Id;
        System.assertEquals(0, [SELECT COUNT() FROM copado__sprint__c]);
        Test.startTest();
        CopadoMockHttpResponseGenerator fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"jodaTimeZoneId":"Etc/UTC","sprints":[{"id":9,"start":"19082020231134","end":"02092020231134","name":"Sample Sprint 1","closed":true,"editable":true,"projects":[{"key":"SSP","name":"Sample Scrum Project"}],"viewBoardsUrl":"https://copado.atlassian.net/secure/GHGoToBoard.jspa?sprintId=9"},{"id":8,"start":"03092020002134","end":"17092020004134","name":"Sample Sprint 2","closed":false,"editable":true,"projects":[{"key":"SSP","name":"Sample Scrum Project"}],"viewBoardsUrl":"https://copado.atlassian.net/secure/GHGoToBoard.jspa?sprintId=8"}]}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        new ScheduleUserStoryFetch(proId, true).prepareSprints();
        System.assertEquals(2, [SELECT COUNT() FROM copado__sprint__c]);

        fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"expand":"schema,names","startAt":0,"maxResults":50,"total":7,"issues":[{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13145","self":"https://copado.atlassian.net/rest/api/2/issue/13145","key":"SSP-23","fields":{"summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13144","self":"https://copado.atlassian.net/rest/api/2/issue/13144","key":"SSP-22","fields":{"summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13143","self":"https://copado.atlassian.net/rest/api/2/issue/13143","key":"SSP-21","fields":{"summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13142","self":"https://copado.atlassian.net/rest/api/2/issue/13142","key":"SSP-20","fields":{"summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13141","self":"https://copado.atlassian.net/rest/api/2/issue/13141","key":"SSP-19","fields":{"summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13140","self":"https://copado.atlassian.net/rest/api/2/issue/13140","key":"SSP-18","fields":{"summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13138","self":"https://copado.atlassian.net/rest/api/2/issue/13138","key":"SSP-16","fields":{"summary":"As a team, we can finish the sprint by clicking the cog icon next to the sprint name above the To Do column then selecting Complete Sprint >> Try closing this sprint now","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":null,"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}}]}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        delete [SELECT Id FROM copado__User_story__c];
        System.assertEquals(2, [SELECT COUNT() FROM copado__sprint__c]);
        Database.executeBatch(new ExecuteUserStoryUpsert(project, true), 200);
        Test.stopTest();

        System.assertEquals(7, [SELECT COUNT() FROM copado__User_story__c WHERE copado__Sprint__c != NULL]);
    }

    @IsTest
    static void testMethodToFetchSprints_VSTS() {
        copado__Project__c project = [
            SELECT
                Id,
                Name,
                Copado_Integration_Setting__r.External_System__c,
                Copado_Integration_Setting__r.Named_Credential__c,
                JQL_Extended_Filter__c,
                Enable_Logs__c,
                Project_External_Id__c,
                Team_Info__c,
                Workspace_Id__c
            FROM copado__Project__c
            WHERE name = 'MY VSTS Project'
            LIMIT 1
        ];

        Id proId = project.Id;
        System.assertEquals(0, [SELECT COUNT() FROM copado__sprint__c]);
        Test.startTest();
        CopadoMockHttpResponseGenerator fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"count":3,"value":[{"id":"52963986-9af6-4b04-8f54-a37e303ece6c","name":"Sprint Test 1","path":"MyFirstProject\\\\Sprint Test 1","attributes":{"startDate":"2020-09-09T00:00:00Z","finishDate":"2020-09-24T00:00:00Z","timeFrame":"current"},"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/52963986-9af6-4b04-8f54-a37e303ece6c"},{"id":"cdfb1dd5-5ac0-493b-8645-157bab6b72a9","name":"Iteration 2","path":"MyFirstProject\\\\Iteration 2","attributes":{"startDate":null,"finishDate":null,"timeFrame":"future"},"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/cdfb1dd5-5ac0-493b-8645-157bab6b72a9"},{"id":"d3a0d947-277a-4fc5-a0e4-0441319eaa8d","name":"Iteration 3","path":"MyFirstProject\\\\Iteration 3","attributes":{"startDate":null,"finishDate":null,"timeFrame":"future"},"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/d3a0d947-277a-4fc5-a0e4-0441319eaa8d"}]}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);

        new ScheduleUserStoryFetch(proId, true).prepareSprints();
        System.assertEquals(3, [SELECT COUNT() FROM copado__sprint__c]);

        fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"workItemRelations":[{"rel":null,"source":null,"target":{"id":10,"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/10"}},{"rel":null,"source":null,"target":{"id":9,"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/9"}}],"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/52963986-9af6-4b04-8f54-a37e303ece6c/workitems","_links":{"self":{"href":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/52963986-9af6-4b04-8f54-a37e303ece6c/workitems"},"project":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/projects/6755f40b-aacf-4234-8a07-a4b21da51a18"},"team":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/projects/6755f40b-aacf-4234-8a07-a4b21da51a18/teams/e4f76f04-0256-4477-852b-cb13734929cb"},"teamIteration":{"href":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/52963986-9af6-4b04-8f54-a37e303ece6c"}}}',
            null
        );
        delete [SELECT Id FROM copado__User_story__c];
        Test.setMock(HttpCalloutMock.class, fakeResponse);

        Database.executeBatch(new ExecuteUserStoryUpsert(project, true), 200);
        Test.stopTest();

        System.assertEquals(2, [SELECT COUNT() FROM copado__User_story__c WHERE copado__Sprint__c != NULL]);
    }
    @IsTest
    static void testMethodToFetchBulkSprints_JIRA() {
        copado__Project__c project = [
            SELECT
                Id,
                Name,
                Copado_Integration_Setting__r.External_System__c,
                Copado_Integration_Setting__r.Named_Credential__c,
                JQL_Extended_Filter__c,
                Enable_Logs__c,
                Project_External_Id__c,
                Workspace_Id__c,
                Sprint_Per_Batch_Chunk_Size__c
            FROM copado__Project__c
            WHERE name = 'MY JIRA Project'
            LIMIT 1
        ];
        System.assertEquals(50, project.Sprint_Per_Batch_Chunk_Size__c, 'Default Chunk size is not correct');
        Id proId = project.Id;
        System.assertEquals(0, [SELECT COUNT() FROM copado__sprint__c], 'Sprint Record count is incorrect');

        String respBody = '{"jodaTimeZoneId":"Etc/UTC","sprints":[';
        for (Integer i = 1; i < 51; i++) {
            String eachsprint =
                '{"id":' +
                i +
                ',"start":"19082020231134","end":"02092020231134","name":"Sample Sprint ' +
                i +
                '","closed":true,"editable":true,"projects":[{"key":"SSP","name":"Sample Scrum Project"}],"viewBoardsUrl":"https://copado.atlassian.net/secure/GHGoToBoard.jspa?sprintId=' +
                i +
                '"},';
            respBody += eachsprint;
        }
        respBody = respBody.subString(0, respBody.length() - 1);
        respBody += ']}';
        Test.startTest();
        CopadoMockHttpResponseGenerator fakeResponse = new CopadoMockHttpResponseGenerator(200, 'Complete', respBody, null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        ScheduleUserStoryFetch schObj = new ScheduleUserStoryFetch(proId, true);
        schObj.prepareSprints();
        System.assertEquals(50, [SELECT COUNT() FROM copado__sprint__c], 'Sprint count should be 50');

        fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"expand":"schema,names","startAt":0,"maxResults":50,"total":7,"issues":[{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13145","self":"https://copado.atlassian.net/rest/api/2/issue/13145","key":"SSP-23","fields":{"storypoints":3,"closedate":"2021-04-20","commitdate":"2021-04-20T03:00:00.000+0000","summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13144","self":"https://copado.atlassian.net/rest/api/2/issue/13144","key":"SSP-22","fields":{"storypoints":3,"closedate":"2021-04-20","commitdate":"2021-04-20T03:00:00.000+0000","summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13143","self":"https://copado.atlassian.net/rest/api/2/issue/13143","key":"SSP-21","fields":{"storypoints":3,"closedate":"2021-04-20","commitdate":"2021-04-20T03:00:00.000+0000","summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13142","self":"https://copado.atlassian.net/rest/api/2/issue/13142","key":"SSP-20","fields":{"storypoints":3,"closedate":"2021-04-20","commitdate":"2021-04-20T03:00:00.000+0000","summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13141","self":"https://copado.atlassian.net/rest/api/2/issue/13141","key":"SSP-19","fields":{"storypoints":3,"closedate":"2021-04-20","commitdate":"2021-04-20T03:00:00.000+0000","summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13140","self":"https://copado.atlassian.net/rest/api/2/issue/13140","key":"SSP-18","fields":{"storypoints":3,"closedate":"2021-04-20","commitdate":"2021-04-20T03:00:00.000+0000","summary":"As a user, Id like a historical story to show in reports","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":{"self":"https://copado.atlassian.net/rest/api/2/user?accountId=5bd1da5342830350dca4061d","accountId":"5bd1da5342830350dca4061d","avatarUrls":{"48x48":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","24x24":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","16x16":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png","32x32":"https://secure.gravatar.com/avatar/451b84aa83c5b885bebc0cf468fd68f3?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FCA-1.png"},"displayName":"Copado Jira account","active":true,"timeZone":"Europe/Madrid","accountType":"atlassian"},"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"13138","self":"https://copado.atlassian.net/rest/api/2/issue/13138","key":"SSP-16","fields":{"storypoints":3,"closedate":"2021-04-20","commitdate":"2021-04-20T03:00:00.000+0000","summary":"As a team, we can finish the sprint by clicking the cog icon next to the sprint name above the To Do column then selecting Complete Sprint >> Try closing this sprint now","issuetype":{"self":"https://copado.atlassian.net/rest/api/2/issuetype/10005","id":"10005","description":"Stories track functionality or features expressed as user goals.","iconUrl":"https://copado.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"description":null,"assignee":null,"status":{"self":"https://copado.atlassian.net/rest/api/2/status/10022","description":"","iconUrl":"https://copado.atlassian.net/","name":"Done","id":"10022","statusCategory":{"self":"https://copado.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}}]}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        delete [SELECT Id FROM copado__User_story__c];
        System.assertEquals(50, [SELECT COUNT() FROM copado__sprint__c], 'Sprint count should be 50');

        String sch = '0 0 23 * * ?';
        System.schedule('Test status Check', sch, schObj);
        Map<Id, copado__sprint__c> sprintMap = new Map<Id, copado__sprint__c>([SELECT Id, Name FROM copado__sprint__c]);

        Database.executeBatch(new ExecuteUserStoryFetch(project, new List<Id>(sprintMap.keySet())), 200);
        Test.stopTest();

        System.assertEquals(7, [SELECT COUNT() FROM copado__User_story__c WHERE copado__Sprint__c != NULL], 'User Story count should be 7');
        System.assertEquals(
            '{"Id":"123","Key":"&lt;b&gt;123&lt;/b&gt;"}',
            CopadoCCMutilities.escapeInvalidChars('{"Id":"123","Key":"<b>123</b>"}'),
            'String have some invalid characters'
        );
    }

    @IsTest
    static void testMethodToFetchBulkSprints_VSTS() {
        copado__Project__c project = [
            SELECT
                Id,
                Name,
                Copado_Integration_Setting__r.External_System__c,
                Copado_Integration_Setting__r.Named_Credential__c,
                JQL_Extended_Filter__c,
                Enable_Logs__c,
                Project_External_Id__c,
                Team_Info__c,
                Workspace_Id__c,
                Sprint_Per_Batch_Chunk_Size__c
            FROM copado__Project__c
            WHERE name = 'MY VSTS Project'
            LIMIT 1
        ];
        System.assertEquals(50, project.Sprint_Per_Batch_Chunk_Size__c, 'Default Chunk size is not correct');
        Id proId = project.Id;
        System.assertEquals(0, [SELECT COUNT() FROM copado__sprint__c], 'Sprint Record count is incorrect');

        String respBody = '{"count":50,"value":[';
        Integer urlCount = 52963849;
        for (Integer i = 1; i < 51; i++) {
            String eachsprint =
                '{"id":"' +
                urlCount +
                '-9af6-4b04-8f54-a37e303ece6c","name":"Sprint Test ' +
                i +
                '","path":"MyFirstProject\\\\Sprint Test ' +
                i +
                '","attributes":{"startDate":"2020-09-09T00:00:00Z","finishDate":"2020-09-24T00:00:00Z","timeFrame":"current"},"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/' +
                urlCount +
                '-9af6-4b04-8f54-a37e303ece6c"},';
            respBody += eachsprint;
            urlCount++;
        }
        respBody = respBody.subString(0, respBody.length() - 1);
        respBody += ']}';
        Test.startTest();
        CopadoMockHttpResponseGenerator fakeResponse = new CopadoMockHttpResponseGenerator(200, 'Complete', respBody, null);

        Test.setMock(HttpCalloutMock.class, fakeResponse);
        ScheduleUserStoryFetch schObj = new ScheduleUserStoryFetch(proId, true);
        schObj.prepareSprints();
        System.assertEquals(50, [SELECT COUNT() FROM copado__sprint__c], 'Sprint count should be 50');

        fakeResponse = new CopadoMockHttpResponseGenerator(
            200,
            'Complete',
            '{"workItemRelations":[{"rel":null,"source":null,"target":{"id":10,"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/10"}},{"rel":null,"source":null,"target":{"id":9,"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/9"}}],"url":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/52963986-9af6-4b04-8f54-a37e303ece6c/workitems","_links":{"self":{"href":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/52963986-9af6-4b04-8f54-a37e303ece6c/workitems"},"project":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/projects/6755f40b-aacf-4234-8a07-a4b21da51a18"},"team":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/projects/6755f40b-aacf-4234-8a07-a4b21da51a18/teams/e4f76f04-0256-4477-852b-cb13734929cb"},"teamIteration":{"href":"https://copadointegrationspoc.visualstudio.com/6755f40b-aacf-4234-8a07-a4b21da51a18/e4f76f04-0256-4477-852b-cb13734929cb/_apis/work/teamsettings/iterations/52963986-9af6-4b04-8f54-a37e303ece6c"}}}',
            null
        );
        delete [SELECT Id FROM copado__User_story__c];
        Test.setMock(HttpCalloutMock.class, fakeResponse);

        Database.executeBatch(new ExecuteUserStoryFetch(project, null), 200);
        Test.stopTest();

        System.assertEquals(2, [SELECT COUNT() FROM copado__User_story__c WHERE copado__Sprint__c != NULL], 'User Story count should be 2');
    }
}