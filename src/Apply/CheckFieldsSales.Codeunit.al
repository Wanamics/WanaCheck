namespace Wanamics.WanaCheck;

using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;

codeunit 87162 "Check Fields Sales"
{
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
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(SalesHeader);
        CheckFields.ApplyTo(RecRef);
    end;
}
