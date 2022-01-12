<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Bug</label>
    <protected>false</protected>
    <values>
        <field>agf__Fields__c</field>
        <value xsi:type="xsd:string">[
    {&quot;Name&quot;: &quot;agf__Subject__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;subjectField&quot;,&quot;WrapperClass&quot;: &quot;slds-size_1-of-1&quot;,&quot;FieldClass&quot;: &quot;slds-form-element_1-col&quot;,&quot;Required&quot;: &quot;Required&quot; },
    {&quot;Name&quot;: &quot;agf__Details_and_Steps_to_Reproduce__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;WrapperClass&quot;: &quot;slds-size_1-of-1&quot;,&quot;FieldClass&quot;: &quot;slds-form-element_1-col&quot;,&quot;Id&quot;: &quot;dstrField&quot; },
    {&quot;Name&quot;: &quot;agf__Product_Tag__c&quot;,&quot;Element&quot;: &quot;custom&quot;,&quot;Id&quot;: &quot;productTagField&quot;,&quot;Required&quot;: &quot;Required&quot; },
    {&quot;Name&quot;: &quot;agf__Status__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;statusField&quot; },
    {&quot;Name&quot;: &quot;agf__Priority_Rank__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;priorityRankField&quot; },
    {&quot;Name&quot;: &quot;agf__Sprint__c&quot;,&quot;Element&quot;: &quot;custom&quot;,&quot;Id&quot;: &quot;sprintField&quot; },
    {&quot;Name&quot;: &quot;agf__Found_in_Build__c&quot;,&quot;Id&quot;: &quot;foundInBuildField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Required&quot;: &quot;Required&quot; },
    {&quot;Name&quot;: &quot;agf__Scheduled_Build__c&quot;,&quot;Id&quot;: &quot;scheduledBuildField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__Impact__c&quot;,&quot;Element&quot;: &quot;custom&quot;,&quot;Required&quot;: &quot;Required&quot; },
    {&quot;Name&quot;: &quot;agf__Frequency__c&quot;,&quot;Element&quot;: &quot;custom&quot;,&quot;Required&quot;: &quot;Required&quot; },
    {&quot;Name&quot;: &quot;agf__Priority__c&quot;,&quot;Element&quot;: &quot;custom&quot;,&quot;Id&quot;: &quot;priorityField&quot; },
    {&quot;Name&quot;: &quot;agf__Story_Points__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;storyPointsField&quot; },
    {&quot;Name&quot;: &quot;agf__Epic__c&quot;,&quot;Id&quot;: &quot;epicField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__Root_Cause_Analysis_2__c&quot;,&quot;Id&quot;: &quot;rootCauseAnalysisField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__Perforce_Status__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__Test_Failure_Status__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;testFailureStatusField&quot; },
    {&quot;Name&quot;: &quot;agf__Resolution__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;testResolutionField&quot; },
    {&quot;Name&quot;: &quot;agf__Help_Status__c&quot;,&quot;Id&quot;: &quot;helpStatusField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__Customer__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;customerField&quot; },
    {&quot;Name&quot;: &quot;agf__Type__c&quot;,&quot;Id&quot;: &quot;typeField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__ftest__c&quot;,&quot;WrapperClass&quot;: &quot;slds-size_1-of-1&quot;,&quot;FieldClass&quot;: &quot;slds-form-element_1-col&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;ftestField&quot;,&quot;HasTriggerValidation&quot;: true,&quot;Required&quot;: &quot;Conditional&quot; },
    {&quot;Name&quot;: &quot;agf__Readme_Notes__c&quot;,&quot;WrapperClass&quot;: &quot;slds-size_1-of-1&quot;,&quot;FieldClass&quot;: &quot;slds-form-element_1-col&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;readMeNotesField&quot; },
    {&quot;Name&quot;: &quot;agf__Assignee__c&quot;,&quot;Id&quot;: &quot;assigneeField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__QA_Engineer__c&quot;,&quot;Id&quot;: &quot;qaField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__Product_Owner__c&quot;,&quot;Id&quot;: &quot;poField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__System_Test_Engineer__c&quot;,&quot;Id&quot;: &quot;perfField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__UE_Engineer__c&quot;,&quot;Id&quot;: &quot;ueField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__Tech_Writer__c&quot;,&quot;Id&quot;: &quot;twField&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot; },
    {&quot;Name&quot;: &quot;agf__Due_Date__c&quot;,&quot;Element&quot;: &quot;lightning:inputField&quot;,&quot;Id&quot;: &quot;dueDateField&quot; },
    {&quot;Name&quot;: &quot;agf__FileUpload&quot;,&quot;Element&quot;: &quot;lightning:fileUpload&quot;,&quot;Label&quot;: &quot;Attach File&quot; },
    {&quot;Name&quot;: &quot;agf__Theme__c&quot;,&quot;Element&quot;: &quot;custom&quot;,&quot;Id&quot;: &quot;themeComponentId&quot; }
]</value>
    </values>
</CustomMetadata>
