namespace Wanamics.WanaCheck;

using System.Reflection;
using Microsoft.Utilities;
table 87161 "Check Fields Rule Field"
{
    Caption = 'Check Fields Rule Field';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            ToolTip = 'Specified the Table No.';
        }
        field(2; "Rule No."; Integer)
        {
            Caption = 'Rule No.';
            ToolTip = 'Specifies the Rule No.';
        }
        field(3; Check; Boolean)
        {
            Caption = 'Check';
            ToolTip = 'Specifies a where field (default) or a check field.';
        }
        field(4; "Field No."; Integer)
        {
            Caption = 'Field No.';
            ToolTip = 'Specifies the field No. (lookup to select one or more).';
            TableRelation = Field."No." where(TableNo = field("Table No."), Class = const(Normal), "No." = filter('<2000000000'), ObsoleteState = filter(<> Removed));
            NotBlank = true;
            BlankZero = true;
            trigger OnLookup()
            var
                Field: Record Field;
                FieldSelection: Codeunit "Field Selection";
            begin
                Field.SetRange(TableNo, "Table No.");
                Field.SetRange(Class, Field.Class::Normal);
                Field.SetFilter("No.", '<%1', 2000000000); // avoid system fields
                // if "Field No." <> 0 then
                //     if Field.Get("Table No.", "Field No.") then;
                if FieldSelection.Open(Field) then
                    "Field No." := Field."No.";
            end;

            trigger OnValidate()
            begin
                CalcFields("Field Name", "Field Caption");
            end;
        }
        field(8; "Filter"; Text[250])
        {
            Caption = 'Filter';
            ToolTip = 'Specifies the field filter value. By setting a value, you specify that only records with that value are included.';

            trigger OnLookup()
            var
                Field: Record Field;
            begin
                Field.Get("Table No.", "Field No.");
                if Field.RelationTableNo <> 0 then
                    LookupTableRelation(Field, Filter);
                if Field.Type = Field.Type::Option then
                    LookupOptionValue(Field, Filter);
            end;

            trigger OnValidate()
            var
                RecRef: RecordRef;
                FieldRef: FieldRef;
            begin
                if Filter = '' then
                    exit;
                RecRef.Open("Table No.");
                FieldRef := RecRef.Field("Field No.");
                FieldRef.SetFilter(Filter);
            end;
        }
        field(100; "Field Name"; Text[30])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."), "No." = field("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the name of the field.';
        }
        field(101; "Field Caption"; Text[250])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."), "No." = field("Field No.")));
            Caption = 'Field Caption';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the field caption of the field.';
        }
    }

    keys
    {
        key(PK; "Table No.", "Rule No.", Check, "Field No.")
        {
            Clustered = true;
        }
    }
    procedure AddFields()
    var
        Field: Record Field;
        FieldSelection: Codeunit "Field Selection";
    begin
        Field.SetRange(TableNo, "Table No.");
        Field.SetRange(Class, Field.Class::Normal);
        Field.SetFilter("No.", '<%1', 2000000000); // avoid system fields
        if FieldSelection.Open(Field) then
            if Field.FindSet() then
                repeat
                    Init();
                    "Field No." := Field."No.";
                    if Insert(true) then;
                until Field.Next() = 0;
    end;

    local procedure LookupOptionValue(pField: Record Field; var pValue: Text)
    var
        Select: Integer;
        RecRef: RecordRef;
    begin
        RecRef.Open(pField.TableNo);
        if Evaluate(Select, pValue) then
            Select := Select + 1;
        Select := StrMenu(RecRef.Field(pField."No.").OptionCaption, Select);
        if Select <> 0 then
            pValue := Format(Select - 1);
    end;

    local procedure LookupTableRelation(pField: Record Field; var pValue: Text)
    var
        KeyField: Record Field;
        RecordRef: RecordRef;
        // FieldRef: FieldRef;
        Rec: Variant;
    // RelationFieldId: Integer;
    begin
        if pField.RelationTableNo = 0 then
            exit;
        RecordRef.Open(pField.RelationTableNo);
        FetchPrimaryKey(RecordRef, pValue);
        Rec := RecordRef;
        if not (Page.RunModal(0, Rec) in [Action::LookupOK, Action::OK]) then
            exit;
        RecordRef.GetTable(Rec);
        if pField.RelationFieldNo = 0 then begin
            KeyField.SetRange(TableNo, pField.RelationTableNo);
            KeyField.SetRange(IsPartOfPrimaryKey, true);
            KeyField.FindFirst();
            pField.RelationFieldNo := KeyField."No.";
        end;

        // FieldRef := RecordRef.Field(pField.RelationFieldNo);
        // if FieldRef.Class() = FieldClass::FlowField then
        //     FieldRef.CalcField();
        pValue := Format(RecordRef.Field(pField.RelationFieldNo).Value);
    end;

    local procedure FetchPrimaryKey(var pRecordRef: RecordRef; pValue: Code[20])
    var
        KeyRef: KeyRef;
        FieldRef: FieldRef;
    begin
        KeyRef := pRecordRef.KeyIndex(1);
        FieldRef := KeyRef.FieldIndex(1);
        FieldRef.SetRange(pValue);
        if pRecordRef.FindFirst() then;
        FieldRef.SetRange();
    end;
}
