public virtual with sharing class JiraIntegrationConstants extends CommonIntegrationConstants {
    //CONSTANTS
    //string
    protected final String ESCAPED_SINGLE_QUOTE = '\'';
    protected final String STATUS = 'status';
    protected final String ASSIGNEE = 'assignee';
    protected final String KEY_STRING = 'key';
    protected final String INTEGER_STRING = 'integer';
    protected final String OBJECT_STRING = 'object';
    protected final String TOTAL_STRING = 'total';
    protected final String START_AT = 'startAt';
    protected final String START_AT_URI = '&startAt=';
    protected final String START_AT_JSON = 'start';
    protected final String END_AT_JSON = 'end';
    protected final String ISSUES_STRING = 'issues';
    protected final String ISSUE_TYPE = 'issuetype';
    protected final String SPRINTS_STRING = 'sprints';
    protected final String EMAIL_ADDRESS = 'emailAddress';
    protected final String VALUE_KEYWORD = 'value';
    protected final String ERROR_MESSAGES_JSON = '"errorMessages"';
    protected final String ENCODING_TYPE = 'UTF-8';

    //integer
    protected final Integer PAGINATION_SIZE = 50;
    //field apis
    protected final String COPADO_STATUS = 'copado__Status__c';
    protected final String ENABLE_LOGS = 'Enable_Logs__c';

    //endpoint path to fetch records from Jira
    protected final String AUTH_QUERY_PATH = 'search?jql=project=';
    protected final String SPRINT_QUERY_PATH = 'greenhopper/latest/integration/teamcalendars/sprint/list?jql=project=';
    protected final String CALLOUT_API_VERSION = 'api/2/';
    protected final String RELEASE_REST_NAME = 'fixVersions';

    //headers for callout
    protected final String CONNECTION_HEADER = 'Connection:keep-alive';

    //Json template to use on String.format function for Object types
    protected final String JSON_TEMPLATE_INNER_OBJECT = '"{0}" :lcurly"name" : "{1}"rcurly';
    //Json template to use on String.format function for String types
    protected final String JSON_TEMPLATE_INNER_STRING = '"{0}" :"{1}"';
    //Json template to use on String.format function for Integer types
    protected final String JSON_TEMPLATE_INNER_INTEGER = '"{0}" :{1}';
    protected final String JSON_TEMPLATE_OUTER = '{"fields" : {';
    protected final String JSON_TEMPLATE_OUTER_CLOSURE = '}}';

    //template to be able to change the status via transition
    //in use on updateStatus method
    protected final String transitionTemplate = 'lcurly"transition":lcurly"id":"{0}"rcurlyrcurly';

    //endpoint path to reach to specified issue
    protected final String updateParameterString = 'issue/{0}';
    //endpoint path to fetch available statuses on related issue
    protected final String updateParameter4TransitionString = updateParameterString + '/transitions?Expand=transitions.fields';
}