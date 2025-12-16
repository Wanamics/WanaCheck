
namespace Wanamics.WanaCheck;

using Microsoft.Inventory.Item;
using Microsoft.Assembly.Document;
using Microsoft.Inventory.Transfer;

codeunit 87163 "Check Fields Master"
{
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
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(AssemblyHeader);
        CheckFields.ApplyTo(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", OnBeforeValidateEvent, 'Status', false, false)]
    local procedure OnBeforeReleaseTransfer(var xRec: Record "Transfer Header"; var Rec: Record "Transfer Header")
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        if (xRec.Status <> xRec.Status::Open) or (Rec.Status = Rec.Status::Open) then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
    end;
}
