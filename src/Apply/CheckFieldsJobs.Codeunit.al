
namespace Wanamics.WanaCheck;

using Microsoft.Projects.Resources.Resource;
using Microsoft.Projects.Project.Posting;
using Microsoft.Projects.Resources.Journal;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Journal;

codeunit 87164 "Check Fields Jobs"
{
    [EventSubscriber(ObjectType::Table, Database::Resource, OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertResource(var Rec: Record Resource; RunTrigger: Boolean)
    var
        CheckFieldsRule: Record "Check Fields Rule";
    begin
        CheckFieldsRule.SetRange("Table No.", Database::Resource);
        CheckFieldsRule.SetRange(Enabled, true);
        if not CheckFieldsRule.IsEmpty then
            Rec.Blocked := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Resource, OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnResourceUnblock(var xRec: Record Resource; var Rec: Record Resource)
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        if not xRec.Blocked or Rec.Blocked then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::Job, OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertJob(var Rec: Record Job; RunTrigger: Boolean)
    var
        CheckFieldsRule: Record "Check Fields Rule";
    begin
        CheckFieldsRule.SetRange("Table No.", Database::Job);
        CheckFieldsRule.SetRange(Enabled, true);
        if not CheckFieldsRule.IsEmpty then
            Rec.Blocked := Rec.Blocked::All;
    end;

    [EventSubscriber(ObjectType::Table, database::Job, OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnJobUnblock(var xRec: Record Job; var Rec: Record Job)
    var
        Line: Record "Job Task";
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
        LineRef: RecordRef;
    begin
        if (xRec.Blocked = xRec.Blocked::" ") or (Rec.Blocked <> Rec.Blocked::" ") then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);

        Line.SetRange("Job No.", Rec."No.");
        LineRef.GetTable(Line);
        CheckFields.ApplyToSelection(LineRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Batch", OnBeforeJobJnlPostLine, '', false, false)]
    local procedure OnBeforeJobJnlPostLine(var JobJournalLine: Record "Job Journal Line")
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(JobJournalLine);
        CheckFields.ApplyToSelection(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Res. Jnl.-Post Batch", OnBeforeCode, '', false, false)]
    local procedure OnBeforeCode(var ResJnlLine: Record "Res. Journal Line")
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(ResJnlLine);
        CheckFields.ApplyToSelection(RecRef);
    end;
}
