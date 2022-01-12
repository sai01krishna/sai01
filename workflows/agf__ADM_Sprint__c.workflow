<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>agf__Calculate_Release_Burndown</fullName>
        <field>agf__Release_Burndown_Calc__c</field>
        <literalValue>1</literalValue>
        <name>Calculate Release Burndown Chart Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>agf__Calculate_Release_Burndown_After_Sprint_Ends</fullName>
        <field>agf__Release_Burndown_Calc__c</field>
        <literalValue>1</literalValue>
        <name>Calculate Release Burndown Chart Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>agf__Update Release Burndown</fullName>
        <active>true</active>
        <criteriaItems>
            <field>agf__ADM_Sprint__c.agf__Release_Burndown_Calc__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>2 days after the sprint is completed, we want to update the release burndown information. Setting the Release Burndown Calculated field to true fires sprint trigger which does this.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
