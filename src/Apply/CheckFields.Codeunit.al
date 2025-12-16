namespace Wanamics.WanaCheck;

using System.Reflection;

codeunit 87160 "Check Fields"
{
    procedure ApplyTo(pRecordRef: RecordRef)
    var
        CheckFieldsRule: Record "Check Fields Rule";
        Message: Text;
        DoesntComplyLbl: Label '%1 %2 doesn''t comply with "%3" %4:\Conditions:%5\Checks:%6', Comment = '%1:TableCaption, %2:Record Primary Key, %3:Rule TableCaption, %4:"Rule No.", %5:When, %6:Check Fields';
        ConfirmLbl: Label 'Do you want to continue?';
    begin
        CheckFieldsRule.SetRange("Table No.", pRecordRef.Number);
        if CheckFieldsRule.FindSet() then
            repeat
                if CheckFieldsRule.IsWithinFilter(pRecordRef, false) then
                    if not CheckFieldsRule.IsWithinFilter(pRecordRef, true) then begin
                        Message := StrSubstNo(DoesntComplyLbl, CheckFieldsRule."Table Caption", GetPrimaryKey(pRecordRef), CheckFieldsRule.TableCaption, CheckFieldsRule."Rule No.", CheckFieldsRule.Filters(false), CheckFieldsRule.Filters(true));
                        if not CheckFieldsRule."Confirm Bypass" then
                            error(Message)
                        else
                            if not Confirm(Message + '\' + ConfirmLbl, false) then
                                Error('');
                    end;
            until CheckFieldsRule.Next() = 0;
    end;

    local procedure GetPrimaryKey(var pRecordRef: RecordRef) ReturnValue: Text;
    var
        kRef: KeyRef;
        fRef: FieldRef;
        i: Integer;
    begin
        kRef := pRecordRef.KeyIndex(1);
        for i := 1 to kRef.FieldCount do begin
            fRef := kRef.FieldIndex(i);
            if i > 1 then
                ReturnValue += ', ';
            ReturnValue += Format(fRef.Value);
        end;
    end;
}
