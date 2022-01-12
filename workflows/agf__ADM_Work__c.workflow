<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>agf__Check_Returned_To_Support_Check_Box</fullName>
        <field>agf__Was_Ever_Returned_to_Support__c</field>
        <literalValue>1</literalValue>
        <name>Check Returned To Support Check Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>agf__P4_status</fullName>
        <field>agf__Perforce_Status__c</field>
        <name>P4 status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>agf__Clear P4 Status</fullName>
        <actions>
            <name>agf__P4_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>agf__ADM_Work__c.agf__Resolved__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>Clear P4 status when the work record resolved value becomes 1</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
