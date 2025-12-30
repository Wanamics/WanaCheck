namespace Wanamics.WanaCheck;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;

codeunit 87161 "Check Fields Purchase"
{
    [EventSubscriber(ObjectType::Table, Database::Vendor, OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsert(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        CheckFieldsRule: Record "Check Fields Rule";
    begin
        CheckFieldsRule.SetRange("Table No.", Database::Vendor);
        CheckFieldsRule.SetRange(Enabled, true);
        if not CheckFieldsRule.IsEmpty then
            Rec.Blocked := Rec.Blocked::All;
    end;

    [EventSubscriber(ObjectType::table, database::Vendor, OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnVendorUnblock(var xRec: Record Vendor; var Rec: Record Vendor)
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        if (xRec.Blocked = xRec.Blocked::" ") or (Rec.Blocked <> Rec.Blocked::" ") then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnBeforePerformManualRelease, '', false, false)]
    local procedure OnBeforePerformManualRelease(PurchaseHeader: Record "Purchase Header")
    var
        Line: Record "Purchase Line";
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
        LineRef: RecordRef;
    begin
        RecRef.GetTable(PurchaseHeader);
        CheckFields.ApplyTo(RecRef);

        Line.SetRange("Document Type", PurchaseHeader."Document Type");
        Line.SetRange("Document No.", PurchaseHeader."No.");
        LineRef.GetTable(Line);
        CheckFields.ApplyToSelection(LineRef);
    end;
}
