namespace Wanamics.WanaCheck;

using System.Reflection;

codeunit 87160 "Check Fields"
{
    procedure ApplyTo(pRecordRef: RecordRef)
    var
        CheckFieldsRule: Record "Check Fields Rule";
        Message: Text;
        DoesntComplyLbl: Label '%1 %2 doesn''t comply with "%3" %4:\Conditions:%5\Checks:%6', Comment = '%1:TableCaption, %2:Record Primary Key, %3:Rule TableCaption, %4:"Rule No.", %5:Conditions, %6:Checks';
        ConfirmLbl: Label 'Do you want to continue?';
    begin
        CheckFieldsRule.SetRange("Table No.", pRecordRef.Number);
        CheckFieldsRule.SetRange(Enabled, true);
        CheckFieldsRule.SetAutoCalcFields("Table Caption");
        if CheckFieldsRule.FindSet() then
            repeat
                if CheckFieldsRule.IsWithinFilter(pRecordRef, false) then
                    if not CheckFieldsRule.IsWithinFilter(pRecordRef, true) then begin
                        Message := StrSubstNo(DoesntComplyLbl, CheckFieldsRule."Table Caption", GetPrimaryKey(pRecordRef, false), CheckFieldsRule.TableCaption, CheckFieldsRule."Rule No.", CheckFieldsRule.Filters(false), CheckFieldsRule.Filters(true));
                        if not CheckFieldsRule."Confirm Bypass" or not GuiAllowed then
                            Error(Message)
                        else
                            if not Confirm(Message + '\' + ConfirmLbl, false) then
                                Error('');
                    end;
            until CheckFieldsRule.Next() = 0;
    end;

    local procedure GetPrimaryKey(var pRecordRef: RecordRef; pHeaderOnly: Boolean) ReturnValue: Text;
    var
        kRef: KeyRef;
        fRef: FieldRef;
        FieldCount: Integer;
        i: Integer;
    begin
        kRef := pRecordRef.KeyIndex(1);
        if pHeaderOnly then
            FieldCount := kRef.FieldCount - 1
        else
            FieldCount := kRef.FieldCount;
        for i := 1 to FieldCount do begin
            fRef := kRef.FieldIndex(i);
            if i > 1 then
                ReturnValue += ', ';
            ReturnValue += Format(fRef.Value);
        end;
    end;

    procedure ApplyToSelection(pRecordRef: RecordRef)
    var
        CheckFieldsRule: Record "Check Fields Rule";
        Message: Text;
        DoesntComplyLbl: Label '%1 "%2" of %3 doesn''t comply with "%4" %5:\Conditions:%6\Checks:%7', Comment = '%1:Count, %2:TableCaption, %3:HeaderPrimaryKey, %4:RuleTableCaption, %5:"Rule No.", %6:Conditions, %7:Checks';
        ConfirmLbl: Label 'Do you want to continue?';
    begin
        CheckFieldsRule.SetRange("Table No.", pRecordRef.Number);
        CheckFieldsRule.SetRange(Enabled, true);
        CheckFieldsRule.SetAutoCalcFields("Table Caption");
        if CheckFieldsRule.FindSet() then
            repeat
                CheckFieldsRule.ApplyTo(pRecordRef, false);
                Mark(pRecordRef, true);
                pRecordRef.FilterGroup(2);
                CheckFieldsRule.ApplyTo(pRecordRef, true);
                Mark(pRecordRef, false);
                CheckFieldsRule.UnapplyTo(pRecordRef, true);
                pRecordRef.FilterGroup(0);
                pRecordRef.MarkedOnly(true);
                if not pRecordRef.IsEmpty then begin
                    Message := StrSubstNo(DoesntComplyLbl, pRecordRef.Count(), pRecordRef.Caption, GetPrimaryKey(pRecordRef, true), CheckFieldsRule.TableCaption, CheckFieldsRule."Rule No.", CheckFieldsRule.Filters(false), CheckFieldsRule.Filters(true));
                    if not CheckFieldsRule."Confirm Bypass" or not GuiAllowed then
                        Error(Message)
                    else
                        if not Confirm(Message + '\' + ConfirmLbl, false) then
                            Error('');
                end;
            until CheckFieldsRule.Next() = 0;
    end;

    local procedure Mark(var pRecordRef: RecordRef; pMark: Boolean)
    begin
        if pRecordRef.FindSet() then
            repeat
                pRecordRef.Mark(pMark);
            until pRecordRef.Next() = 0;
    end;
}
