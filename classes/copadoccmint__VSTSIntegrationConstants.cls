public virtual with sharing class VSTSIntegrationConstants extends CommonIntegrationConstants {
    //callout pagination per records
    protected final Integer vstsPaginationSize {
        get {
            if (null == vstsPaginationSize) {
                vstsPaginationSize = 100;
            }
            return vstsPaginationSize;
        }
        set;
    }
    //strings
    protected final String SPACE_ENCODE = '%20';
    protected final String T_CHAR = 'T';
    protected final String Z_CHAR = 'Z';
    protected final String SLASH = '/';
    protected final String START_DATE = 'startDate';
    protected final String FINISH_DATE = 'finishDate';
    protected final String PROJECT_KEYWORD = '{project}';
    protected final String TEAM_KEYWORD = '{team}';
    protected final String ITERATION_ID_KEYWORD = '{iterationId}';
    protected final String ATTRIBUTES_KEYWORD = 'attributes';
    protected final String URL_KEYWORD = 'url';
    protected final String REV_KEYWORD = 'rev';
    protected final String OPENING_TAG = '<';
    protected final String CLOSING_TAG = '>';
    protected final String VALUE_KEYWORD = 'value';
    //tpu field names
    protected final String ASSIGNED_TO = 'System.AssignedTo';
    protected final String PROJECT = 'System.TeamProject';
    protected final String WORK_ITEM_TYPE = 'System.WorkItemType';
    protected final String ITERATION = 'System.IterationPath';
    protected final String UNIQUE_NAME = 'uniqueName';
    protected final String DISPLAY_NAME = 'displayName';

    //endpoint path to reach work items ids
    protected final String authQueryPath = '/_apis/wit/wiql/';
    //endpoint path to reach sprint  info
    protected final String ITERATION_PATH = '/_apis/work/teamsettings/iterations';
    //endpoint api versions
    protected final String authApiVersion = '?api-version=4.1';
    protected final String AUTH_API_VERSION_SIX = '?api-version=6.0-preview.1';
    //endpoint path to reach work items returned from query callout
    protected final String workspacePath = '/_apis/wit/workitems?ids=';
    //endpoint path to use on patch operation
    protected final String workspacePath2Patch = '_apis/wit/workitems/';
    //endpoint path workItem folder to use on sprint fetch
    protected final String WORK_ITEMS = '/workitems';

    //endpoint path to fetch sprints
    protected final String ITERATION_ENDPOINT = PROJECT_KEYWORD + SLASH + TEAM_KEYWORD + ITERATION_PATH;
    protected final String WORK_ITEM_PER_ITERATION_ENDPOINT =
        PROJECT_KEYWORD +
        SLASH +
        TEAM_KEYWORD +
        ITERATION_PATH +
        SLASH +
        ITERATION_ID_KEYWORD +
        WORK_ITEMS +
        AUTH_API_VERSION_SIX;

    //headers for callout
    protected final String CONTENT_TYPE_PATCH_HEADER = 'Content-Type:application/json-patch+json';
    protected final String CONNECTION_HEADER = 'Connection:keep-alive';
    protected final String OVERRIDE_POST_METHOD = 'X-HTTP-Method-Override:PATCH';

    //Json template to use on string.format function
    protected final String JsonTemplate = '"op": "add","path": "/fields/{0}","value": "{1}"';

    //Implemented to bypass lack of functionality to place 2 mock response on a flow with one execution point.
    //  --  check testMethodToFetchSprints_VSTS method in TestIntegration.cls
    protected final String MOCK_WORK_ITEM_RESPONSE_FOR_SPRINT = '{"count":2,"value":[{"id":9,"rev":2,"fields":{"System.TeamProject":"MyFirstProject","System.IterationPath":"MyFirstProject\\\\Sprint Test 1","System.WorkItemType":"User Story","System.State":"New","System.Reason":"New","System.Title":"Test Sprint Us1","Microsoft.VSTS.Common.Priority":2},"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/9"},{"id":10,"rev":4,"fields":{"System.TeamProject":"MyFirstProject","System.IterationPath":"MyFirstProject\\\\Sprint Test 1","System.WorkItemType":"User Story","System.State":"New","System.Reason":"New","System.AssignedTo":{"displayName":"Mert Yaltı","url":"https://spsprodweu1.vssps.visualstudio.com/Adbb5dbbd-c945-4f70-8c19-049005f7e80a/_apis/Identities/989c055f-77c9-4f21-bfd8-8b8d1590232e","_links":{"avatar":{"href":"https://copadointegrationspoc.visualstudio.com/_apis/GraphProfile/MemberAvatars/msa.NDBkZDlkY2YtOWVmMC03NjA4LTllZWUtOWIxNDI4YzAyNmM3"}},"id":"989c055f-77c9-4f21-bfd8-8b8d1590232e","uniqueName":"mertyalti@hotmail.com","imageUrl":"https://copadointegrationspoc.visualstudio.com/_apis/GraphProfile/MemberAvatars/msa.NDBkZDlkY2YtOWVmMC03NjA4LTllZWUtOWIxNDI4YzAyNmM3","descriptor":"msa.NDBkZDlkY2YtOWVmMC03NjA4LTllZWUtOWIxNDI4YzAyNmM3"},"System.Title":"Test Sprint Us2","Microsoft.VSTS.Common.Priority":2},"url":"https://copadointegrationspoc.visualstudio.com/_apis/wit/workItems/10"}]}';

    //nested wrapper classes to use on direct Json casting on authentication callout step
    public class sprintWorkItemsWrapper {
        public List<targetWrapper> workItemRelations;
    }
    public class targetWrapper {
        public workItemsWrapper target;
    }

    public class authWrapper {
        public String queryType;
        public String queryResultType;
        public String asOf;
        public List<columnsWrapper> columns;
        public List<sortColumnsWrapper> sortColumns;
        public List<workItemsWrapper> workItems;
    }
    public class columnsWrapper {
        public String referenceName;
        public String name;
        public String url;
    }
    public class sortColumnsWrapper {
        public sortColumnsfieldWrapper field;
        public Boolean descending;
    }
    public class workItemsWrapper {
        public Integer id;
        public String url;
    }
    public class sortColumnsfieldWrapper {
        public String referenceName;
        public String name;
        public String url;
    }
}