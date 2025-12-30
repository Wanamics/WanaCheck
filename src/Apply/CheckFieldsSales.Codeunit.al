namespace Wanamics.WanaCheck;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;

codeunit 87162 "Check Fields Sales"
{
    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsert(var Rec: Record Customer; RunTrigger: Boolean)
    var
        CheckFieldsRule: Record "Check Fields Rule";
    begin
        CheckFieldsRule.SetRange("Table No.", Database::Customer);
        CheckFieldsRule.SetRange(Enabled, true);
        if not CheckFieldsRule.IsEmpty then
            Rec.Blocked := Rec.Blocked::All;
    end;

    [EventSubscriber(ObjectType::table, database::Customer, OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnCustomerUnblock(var xRec: Record Customer; var Rec: Record Customer)
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        if (xRec.Blocked = xRec.Blocked::" ") or (Rec.Blocked <> Rec.Blocked::" ") then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforePerformManualRelease, '', false, false)]
    local procedure OnBeforePerformManualRelease(SalesHeader: Record "Sales Header")
    var
        Line: Record "Sales Line";
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
        LineRef: RecordRef;
    begin
        RecRef.GetTable(SalesHeader);
        CheckFields.ApplyTo(RecRef);

        Line.SetRange("Document Type", SalesHeader."Document Type");
        Line.SetRange("Document No.", SalesHeader."No.");
        LineRef.GetTable(Line);
        CheckFields.ApplyToSelection(LineRef);
    end;
}
