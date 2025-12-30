namespace Wanamics.WanaCheck;

using System.Reflection;
table 87160 "Check Fields Rule"
{
    Caption = 'Check Fields Rule';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
            ToolTip = 'Spécified the Table No.';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table), "Object ID" = filter('<2000000000'));
            NotBlank = true;
            BlankZero = true;
            Width = 8;
        }
        field(2; "Rule No."; Integer)
        {
            Caption = 'Rule No.';
            ToolTip = 'Specifies the rule No.';
            BlankZero = true;
            Width = 4;
        }
        field(3; Enabled; Boolean)
        {
            Caption = 'Enabled';
            ToolTip = 'Specifies if the rule is active';
            Width = 4;
        }
        field(4; "Confirm Bypass"; Boolean)
        {
            Caption = 'Confirm Bypass';
            ToolTip = 'Specifies if the rule can be by passed after confirmation.';
        }
        field(100; "Table Name"; Text[250])
        {
            Caption = 'Table Name';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table No.")));
            Editable = false;
            Width = 20;
        }
        field(101; "Table Caption"; Text[250])
        {
            Caption = 'Table Caption';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table), "Object ID" = field("Table No.")));
            Editable = false;
            Width = 20;
        }
    }

    keys
    {
        key(PK; "Table No.", "Rule No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        Rec2: Record "Check Fields Rule Field";
    begin
        if "Rule No." <> 0 then
            exit;
        Rec2.SetRange("Table No.", "Table No.");
        if Rec2.FindLast() then;
        "Rule No." := Rec2."Rule No." + 1;
    end;

    trigger OnDelete()
    var
        CheckFieldsRuleField: Record "Check Fields Rule Field";
    begin
        CheckFieldsRuleField.SetRange("Table No.", "Table No.");
        CheckFieldsRuleField.SetRange("Rule No.", "Rule No.");
        CheckFieldsRuleField.DeleteAll(true);
    end;

    // procedure Filters(pCheck: Boolean): Text
    // var
    //     RecRef: RecordRef;
    // begin
    //     if "Table No." = 0 then
    //         exit;
    //     RecRef.Open("Table No.");
    //     ApplyTo(RecRef, pCheck);
    //     exit(RecRef.GetFilters());
    // end;

    procedure IsWithinFilter(pRecordRef: RecordRef; pCheck: Boolean): Boolean
    begin
        pRecordRef.SetRecFilter();
        ApplyTo(pRecordRef, pCheck);
        exit(not pRecordRef.IsEmpty())
    end;

    procedure Filters(pCheck: Boolean): Text
    var
        Dummy: Text;
    begin
        exit(Filters(pCheck, Dummy));
    end;

    procedure Filters(pCheck: Boolean; var pStyleExpr: Text): Text
    var
        RecRef: RecordRef;
    begin
        if "Table No." = 0 then
            exit;
        RecRef.Open("Table No.");
        if not TryApplyTo(RecRef, pCheck) then begin
            pStyleExpr := format(PageStyle::Attention);
            exit(GetLastErrorText());
        end;
        pStyleExpr := '';
        exit(RecRef.GetFilters());
    end;

    [TryFunction]
    local procedure TryApplyTo(pRecordRef: RecordRef; pCheck: Boolean)
    begin
        ApplyTo(pRecordRef, pCheck);
    end;

    procedure ApplyTo(var pRecordRef: RecordRef; pCheck: boolean)
    var
        CheckFieldsRuleFilter: Record "Check Fields Rule Field";
    begin
        CheckFieldsRuleFilter.SetRange("Table No.", "Table No.");
        CheckFieldsRuleFilter.SetRange("Rule No.", "Rule No.");
        CheckFieldsRuleFilter.SetRange(Check, pCheck);
        if CheckFieldsRuleFilter.FindSet() then
            repeat
                pRecordRef.Field(CheckFieldsRuleFilter."Field No.").SetFilter(CheckFieldsRuleFilter.Filter);
            until CheckFieldsRuleFilter.Next() = 0;
    end;

    procedure UnapplyTo(var pRecordRef: RecordRef; pCheck: boolean)
    var
        CheckFieldsRuleFilter: Record "Check Fields Rule Field";
    begin
        CheckFieldsRuleFilter.SetRange("Table No.", "Table No.");
        CheckFieldsRuleFilter.SetRange("Rule No.", "Rule No.");
        CheckFieldsRuleFilter.SetRange(Check, pCheck);
        if CheckFieldsRuleFilter.FindSet() then
            repeat
                pRecordRef.Field(CheckFieldsRuleFilter."Field No.").SetRange();
            until CheckFieldsRuleFilter.Next() = 0;
    end;
}
