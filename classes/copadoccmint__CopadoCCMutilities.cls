/**
 * Utilities class for CCM Integrations.
 *
 * @author Ümit Can Uçkan
 * @version 1.0
 * @since CCM Integrations 1.0
 */
public with sharing class CopadoCCMutilities {
    //callout log list to be inserted as a final action
    public static List<Callout_Log__c> callOutLogList2Insert {
        get {
            if (callOutLogList2Insert == null) {
                callOutLogList2Insert = new List<Callout_Log__c>();
            }
            return callOutLogList2Insert;
        }
        set;
    }

    /**
     * HTTP method based on a named credential and current parameters
     * Project and UserStory are required parameters for log creation
     *
     * @param namedCredential
     * @param firstParam
     * @param secondParam
     * @param firstUrlpart
     * @param secondUrlpart
     * @param additionalHeader
     * @param methodType
     * @param bodyParam
     * @param userStory
     * @param project
     *
     * @return
     */
    public static String MakeCallout(
        String namedCredential,
        String firstParam,
        String secondParam,
        String firstUrlpart,
        String secondUrlpart,
        List<String> additionalHeader,
        Method methodType,
        String bodyParam,
        sObject userStory,
        sObject project
    ) {
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        //exp: callout: endpoint + projectExternalId + '/_apis/wit/wiql/' + workspaceId +'?api-version=4.1';
        System.debug('endpoint===> ' + 'callout:' + namedCredential + '/' + firstParam + firstUrlpart + secondParam + secondUrlpart);
        req.setEndpoint('callout:' + namedCredential + '/' + firstParam + firstUrlpart + secondParam + secondUrlpart);
        for (String ahItem : additionalHeader) {
            req.setHeader(ahItem.split(':')[0], ahItem.split(':')[1]);
        }
        req.setMethod(String.valueOf(methodType));
        if (String.isNotBlank(bodyParam)) {
            req.setBody(bodyParam);
        }
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if (userStory != null && (Boolean) userStory.get('Enable_Logs__c')) {
            callOutLogList2Insert.add(
                new Callout_Log__c(
                    Response_Body__c = res.getBody(),
                    Status__c = res.getStatus(),
                    Status_Code__c = String.valueOf(res.getStatusCode()),
                    User_Story__c = (String) userStory.get('id')
                )
            );
        } else if (null != project && (Boolean) project.get('ENABLE_Logs__c')) {
            callOutLogList2Insert.add(
                new Callout_Log__c(
                    Response_Body__c = res.getBody(),
                    Status__c = res.getStatus(),
                    Status_Code__c = String.valueOf(res.getStatusCode()),
                    project__c = (String) project.get('id')
                )
            );
        }
        System.debug('res.getBody()==> ' + res.getBody());
        return res.getBody();
    }
    //Map to use on dynamic cast logic
    private static Map<String, Schema.SObjectField> userStoryFieldsMap;
    static {
        userStoryFieldsMap = Schema.SObjectType.copado__User_Story__c.fields.getMap();
    }
    //casts value based on the current sObject field
    public static Object returnCastedValue(Object param, String fname) {
        if (null != param) {
            Schema.SObjectField field = userStoryFieldsMap.get(fname);
            String FldType = String.valueOf(field.getDescribe().getType()).toLowerCase();
            if (FldType == 'textarea' || FldType == 'picklist' || fldType == 'reference' || FldType == 'multipicklist') {
                FldType = 'string';
            }
            if (FldType == 'boolean') {
                return Boolean.valueOf(param);
            } else if (FldType == 'string') {
                return String.valueOf(param);
            } else if (FldType == 'blob') {
                return (Blob) param;
            } else if (FldType == 'date') {
                return Date.valueOf(applySalesforceDateFormatString(param));
            } else if (FldType == 'datetime') {
                return Datetime.valueOf(applySalesforceDateTimeFormatString(param));
            } else if (FldType == 'time') {
                return (Time) param;
            } else if (FldType == 'integer') {
                return Integer.valueOf(param);
            } else if (FldType == 'long') {
                return (Long) param;
            } else if (FldType == 'decimal') {
                return (Decimal) param;
            } else if (FldType == 'double') {
                return Double.valueOf(param);
            }
        }
        return null;
    }
    private static String applySalesforceDateFormatString(Object param) {
        return String.valueOf(param).replace('Z', '+0000');
    }
    private static String applySalesforceDateTimeFormatString(Object param) {
        return String.valueOf(param).replace('T', ' ');
    }

    public static Map<String, Id> returnUsers(Boolean enableCommunityUsers) {
        //usermap to match lookup values via third party users' mail addresses
        Map<String, Id> userMap = new Map<String, id>();
        List<User> users;
        try {
            users = Database.query(
                'SELECT Id, Email FROM User WHERE IsActive = TRUE AND Email != NULL' + (enableCommunityUsers ? '' : ' AND IsPortalEnabled = FALSE ')
            );
        } catch (QueryException exp) {
            //portal or community is not enabled for the org, hence IsPortalEnabled is not available for the environment yet
            //no need to handle this
            users = [SELECT Id, Email FROM User WHERE IsActive = TRUE AND Email != NULL];
        }
        for (User u : users) {
            userMap.put(u.Email.toLowercase(), u.Id);
        }
        return userMap;
    }

    //Field mapping values between salesforce and third party platform fields under related project
    public static Map<String, String> returnFieldMap(id pid, String additionalWhereClause) {
        Map<String, String> fieldMap;
        if (null == fieldMap) {
            fieldMap = new Map<String, String>();
            for (
                Field_Mapping__c fm : database.query(
                    'SELECT Salesforce_Field_Name__c, Third_Party_Field_Name__c FROM Field_Mapping__c WHERE project__c =: pid ' +
                    additionalWhereClause
                )
            ) {
                fieldMap.put(fm.Salesforce_Field_Name__c.toLowerCase(), fm.Third_Party_Field_Name__c.toLowerCase());
            }
        }
        return fieldMap;
    }

    //returns Name/DeveloperName to Id map of User Story object's recordTypes
    public static Map<String, String> returnUserStoryRecordTypeMap(Boolean forJIRA) {
        Map<String, String> userStoryRecordTypes = new Map<String, String>();
        for (RecordType recordType : [
            SELECT Id, Name, DeveloperName
            FROM RecordType
            WHERE IsActive = TRUE AND SobjectType = 'copado__User_Story__c'
        ]) {
            if (!forJIRA) {
                userStoryRecordTypes.put(recordType.DeveloperName, recordType.Id);
                userStoryRecordTypes.put(recordType.Name, recordType.Id);
            } else {
                userStoryRecordTypes.put(recordType.Id, recordType.Name);
            }
        }
        return userStoryRecordTypes;
    }

    //Record Type mapping values between salesforce and third party platform work Items under related project
    public static Map<String, String> returnRecordTypeMap(Id pid, Boolean forThirdParty) {
        Map<String, String> recordTypeMap;
        if (null == recordTypeMap) {
            recordTypeMap = new Map<String, String>();
            for (
                Record_Type_Mapping__c recordType : database.query(
                    'SELECT Salesforce_Record_Type_Name__c, Third_Party_Record_Type_Name__c FROM Record_Type_Mapping__c WHERE project__c =: pid '
                )
            ) {
                if (!forThirdParty) {
                    recordTypeMap.put(recordType.Third_Party_Record_Type_Name__c, recordType.Salesforce_Record_Type_Name__c);
                } else {
                    recordTypeMap.put(recordType.Salesforce_Record_Type_Name__c, recordType.Third_Party_Record_Type_Name__c);
                }
            }
        }
        return recordTypeMap;
    }
    //returns a map with sf field api name to target field type, (if the target field on the third party program expect String or a json Object as a value **** defined by "target field type" field on the field mapping Object ****)
    public static Map<String, String> returnTargetTypeMap(Id pid, String additionalWhereClause) {
        Map<String, String> fieldMap;
        if (null == fieldMap) {
            fieldMap = new Map<String, String>();
            for (
                Field_Mapping__c fm : database.query(
                    'SELECT Salesforce_Field_Name__c, Third_Party_Field_Name__c, Target_Field_Type__c FROM Field_Mapping__c WHERE project__c =: pid ' +
                    additionalWhereClause
                )
            ) {
                fieldMap.put(
                    fm.Salesforce_Field_Name__c.toLowerCase(),
                    (String.isBlank(fm.Target_Field_Type__c) ? '' : fm.Target_Field_Type__c.toLowerCase())
                );
            }
        }
        return fieldMap;
    }
    //Escapes undesired characters in the returned JSON
    public static String escapeInvalidChars(String responseText) {
        responseText = String.escapeSingleQuotes(responseText);
        responseText = responseText.escapeHTML4();
        responseText = responseText.replace('{&quot;', '{"');
        responseText = responseText.replace('&quot;:&quot;', '":"');
        responseText = responseText.replace('&quot;,&quot;', '","');
        responseText = responseText.replace('&quot;:', '":');
        responseText = responseText.replace(',&quot;', ',"');
        responseText = responseText.replace('&quot;}', '"}');
        responseText = responseText.replace('&amp;', '&');
        responseText = responseText.replace('\b', '\\b');
        responseText = responseText.replace('\n', '\\n');
        responseText = responseText.replace('\t', '\\t');
        responseText = responseText.replace('\r', '\\r');
        responseText = responseText.replace('\\', '\\\\');
        return responseText;
    }
    public static String replaceFromCurly(String strwcurly) {
        return strwcurly.replace('lcurly', '{').replace('rcurly', '}');
    }
    public static String escapeDoubleQuotes(String value) {
        return value.replace('"', '\\"');
    }
    public static Date convertLongDateToDate(String longDate) {
        return Date.newInstance(
            Integer.valueOf(longDate.substring(4, 8)),
            Integer.valueOf(longDate.substring(2, 4)),
            Integer.valueOf(longDate.substring(0, 2))
        );
    }
    //method to create logs under related user story or project record based on the step of the integration after all callouts are done
    public static void createLogRecords() {
        if (callOutLogList2Insert.size() > 0) {
            database.insert(callOutLogList2Insert, false);
        }
    }
}