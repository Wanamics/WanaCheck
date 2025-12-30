namespace Wanamics.WanaCheck;

using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 87165 "Check Fields General Ledger"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Account", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsert(var Rec: Record "G/L Account"; RunTrigger: Boolean)
    var
        CheckFieldsRule: Record "Check Fields Rule";
    begin
        CheckFieldsRule.SetRange("Table No.", Database::"G/L Account");
        CheckFieldsRule.SetRange(Enabled, true);
        if not CheckFieldsRule.IsEmpty then
            Rec.Blocked := true;
    end;

    [EventSubscriber(ObjectType::table, database::"G/L Account", OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnGLAccountUnblock(var xRec: Record "G/L Account"; var Rec: Record "G/L Account")
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        if not xRec.Blocked or Rec.Blocked then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeProcessLines, '', false, false)]
    local procedure OnBeforeProcessLines(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(GenJournalLine);
        CheckFields.ApplyToSelection(RecRef);
    end;
}
