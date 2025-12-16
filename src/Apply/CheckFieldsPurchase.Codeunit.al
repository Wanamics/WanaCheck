namespace Wanamics.WanaCheck;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;

codeunit 87161 "Check Fields Purchase"
{
    [EventSubscriber(ObjectType::table, database::Vendor, OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnCustomerUnblock(var xRec: Record Vendor; var Rec: Record Vendor)
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
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(PurchaseHeader);
        CheckFields.ApplyTo(RecRef);
    end;
}
