namespace Wanamics.WanaCheck;

using System.Reflection;
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
                if "Field No." <> 0 then
                    if Field.Get("Table No.", "Field No.") then;
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
            Caption = 'Field Filter';
            ToolTip = 'Specifies the field filter value. By setting a value, you specify that only records with that value are included.';

            trigger OnLookup()
            var
                Field: Record Field;
            begin
                Field.Get("Table No.", "Field No.");
                if Field.RelationTableNo <> 0 then
                    LookupTableRelation(Field, Filter);
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
    local procedure LookupTableRelation(pField: Record Field; var pValue: Text)
    // Subset from Data Editor page 81002 "DET Edit Value" (credit to Drakonian)
    var
        SourceFieldInfo: Record Field;
        RecRef: RecordRef;
        FieldRefVar: FieldRef;
        VariantRecord: Variant;
        RelationFieldId: Integer;
    begin
        if pField.RelationTableNo = 0 then
            exit;
        RecRef.Open(pField.RelationTableNo);
        VariantRecord := RecRef;
        if not (Page.RunModal(0, VariantRecord) in [Action::LookupOK, Action::OK]) then
            exit;
        RecRef.GetTable(VariantRecord);
        if pField.RelationFieldNo = 0 then begin
            SourceFieldInfo.SetRange(TableNo, pField.RelationTableNo);
            SourceFieldInfo.SetRange(IsPartOfPrimaryKey, true);
            SourceFieldInfo.FindFirst();
            RelationFieldId := SourceFieldInfo."No.";
        end else
            RelationFieldId := pField.RelationFieldNo;

        FieldRefVar := RecRef.Field(RelationFieldId);
        if FieldRefVar.Class() = FieldClass::FlowField then
            FieldRefVar.CalcField();
        pValue := Format(FieldRefVar.Value);
    end;

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
}
