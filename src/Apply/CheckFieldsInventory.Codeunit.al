
namespace Wanamics.WanaCheck;

using Microsoft.Inventory.Item;
using Microsoft.Assembly.Document;
using Microsoft.Inventory.Posting;
using Microsoft.Inventory.Transfer;
using Microsoft.Inventory.Journal;

codeunit 87163 "Check Fields Inventory"
{
    [EventSubscriber(ObjectType::Table, Database::Item, OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsert(var Rec: Record Item; RunTrigger: Boolean)
    var
        CheckFieldsRule: Record "Check Fields Rule";
    begin
        CheckFieldsRule.SetRange("Table No.", Database::Item);
        CheckFieldsRule.SetRange(Enabled, true);
        if not CheckFieldsRule.IsEmpty then
            Rec.Blocked := true;
    end;

    [EventSubscriber(ObjectType::table, database::Item, OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnItemUnblock(var xRec: Record Item; var Rec: Record Item)
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        if not xRec.Blocked or Rec.Blocked then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Assembly Document", OnBeforeReleaseAssemblyDoc, '', false, false)]
    local procedure OnBeforeReleaseAssemblyDoc(AssemblyHeader: Record "Assembly Header")
    var
        Line: Record "Assembly Line";
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
        LineRef: RecordRef;
    begin
        RecRef.GetTable(AssemblyHeader);
        CheckFields.ApplyTo(RecRef);
        Line.SetRange("Document Type", AssemblyHeader."Document Type");
        Line.SetRange("Document No.", AssemblyHeader."No.");
        LineRef.GetTable(Line);
        CheckFields.ApplyToSelection(LineRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", OnBeforeValidateEvent, 'Status', false, false)]
    local procedure OnBeforeReleaseTransfer(var xRec: Record "Transfer Header"; var Rec: Record "Transfer Header")
    var
        Line: Record "Transfer Line";
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
        LineRef: RecordRef;
    begin
        if (xRec.Status <> xRec.Status::Open) or (Rec.Status = Rec.Status::Open) then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
        Line.SetRange("Document No.", Rec."No.");
        LineRef.GetTable(Line);
        CheckFields.ApplyToSelection(LineRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", OnAfterCheckLines, '', false, false)]
    local procedure OnAfterCheckLines(var ItemJnlLine: Record "Item Journal Line")
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(ItemJnlLine);
        CheckFields.ApplyToSelection(RecRef);
    end;
}
