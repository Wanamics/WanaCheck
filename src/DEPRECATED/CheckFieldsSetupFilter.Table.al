#if FALSE
namespace Wanamics.WanaCheck;

using System.Reflection;
table 87162 "Check Fields Rule Filter"
{
    Caption = 'Check Fields Rule Filter';
    DataClassification = SystemMetadata;
    // LookupPageId = "Check Fields Rule Filters";
    // DrillDownPageId = "Check Fields Rule Filters";

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Rule No."; Integer)
        {
            Caption = 'Rule No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
            DataClassification = SystemMetadata;
            TableRelation = Field."No." where(TableNo = field("Table No."), Class = const(Normal), ObsoleteState = filter(<> Removed));
            NotBlank = true;
            BlankZero = true;
            trigger OnValidate()
            begin
                CalcFields("Field Name", "Field Caption");
            end;
        }
        field(8; "Filter"; Text[250])
        {
            Caption = 'Field Filter';
            ToolTip = 'Specifies the field filter value. By setting a value, you specify that only records with that value are included.';

            trigger OnValidate()
            var
                CheckFields: Codeunit "Check Fields";
            begin
                CheckFields.ValidateFieldFilter("Table No.", "Field No.", Filter);
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
        key(PK; "Table No.", "Rule No.", "Field No.")
        {
            Clustered = true;
        }
    }
    procedure IsWithinFilter(pCheckFieldsRule: Record "Check Fields Rule"; pRecordRef: RecordRef): Boolean
    begin
        pRecordRef.SetRecFilter();
        ApplyTo(pCheckFieldsRule, pRecordRef);
        exit(not IsEmpty())
    end;

    procedure ApplyTo(pCheckFieldsRule: Record "Check Fields Rule"; var pRecordRef: RecordRef)
    begin
        SetRange("Table No.", pCheckFieldsRule."Table No.");
        SetRange("Rule No.", pCheckFieldsRule."Rule No.");
        if FindSet() then
            repeat
                pRecordRef.Field("Field No.").SetFilter(Filter);
            until Next() = 0;
    end;
}
#endif

