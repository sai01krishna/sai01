/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RunTestsAction implements copado.JobExecutionCallback {
    global RunTestsAction() {

    }
    global void execute(copado__JobExecution__c execution, String status) {

    }
    @InvocableMethod(label='Run a List of Copado Tests' description='Extracts and Runs a list of Copado Tests of a specific type')
    global static List<copado.RunTestsAction.Response> execute(List<copado.RunTestsAction.Request> requests) {
        return null;
    }
global class Request {
    @InvocableVariable(label='Action Callback' description='Apex Callback Class that implements JobExecutionCallback' required=false)
    global String actionCallback;
    @InvocableVariable(label='Context Ids' description='List of Salesforce Record Ids that contain Tests. It might be multiple test records, user stories, features or applications' required=false)
    global List<Id> contextIds;
    @InvocableVariable(label='Environment Id' description='The Identifier (Salesforce Record Id, URL, URI, ApiName, Git branch, etc) of the “Environment” to run the tests in.' required=false)
    global String environmentId;
    @InvocableVariable(label='Properties Override' description='JSON String overriding properties with different values. For instance, allows Quality Gates to use stricter values e.g. Code Coverage on Unit Test runs.' required=false)
    global String propertiesOverride;
    @InvocableVariable(label='Test Type' description='Master label of the Test Type custom metadata type record that applies to all Tests contained in contextIds' required=false)
    global String type;
    global Request() {

    }
    global copado.RunTestsAction.Request actionCallback(String className) {
        return null;
    }
    global copado.RunTestsAction.Request context(List<Id> ids) {
        return null;
    }
    global copado.RunTestsAction.Request environment(String id) {
        return null;
    }
    global copado.RunTestsAction.Request propertiesOverride(String json) {
        return null;
    }
    global copado.RunTestsAction.Request type(String testType) {
        return null;
    }
}
global class Response {
    @InvocableVariable(label='Job Execution' description='Job Execution record for the Run Test Action' required=false)
    global copado__JobExecution__c jobExecution;
}
}
