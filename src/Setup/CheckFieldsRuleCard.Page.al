namespace WanaCheck.WanaCheck;

using Wanamics.WanaCheck;

page 87163 "Check Fields Rule Card"
{
    ApplicationArea = All;
    Caption = 'Check Fields Rule Card';
    PageType = Card;
    SourceTable = "Check Fields Rule";
    DataCaptionExpression = '';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Table No."; Rec."Table No.") { Editable = Rec."Table No." = 0; }
                field("Rule No."; Rec."Rule No.") { Editable = not Rec.Enabled; }
                field("Table Name"; Rec."Table Name") { }
                field("Table Caption"; Rec."Table Caption") { }
                field("Confirm Bypass"; Rec."Confirm Bypass") { Editable = not Rec.Enabled; }
                field(Enabled; Rec.Enabled) { }
            }
            part(Conditions; "Check Fields Rule Subpage")
            {
                Caption = 'Conditions';
                SubPageLink = "Table No." = field("Table No."), "Rule No." = field("Rule No.");
                SubPageView = where(Check = const(false));
                Editable = not Rec.Enabled;
            }
            part(Checks; "Check Fields Rule Subpage")
            {
                Caption = 'Checks';
                SubPageLink = "Table No." = field("Table No."), "Rule No." = field("Rule No.");
                SubPageView = where(Check = const(true));
                Editable = not Rec.Enabled;
            }
        }
    }
    trigger OnClosePage()
    var
        ConfirmLbl: Label 'Do you want to enable this rule now?';
    begin
        if not Rec.Enabled then
            if Confirm(ConfirmLbl, false) then begin
                Rec.Enabled := true;
                Rec.Modify();
            end;
    end;
}
