namespace Wanamics.WanaCheck;
using WanaCheck.WanaCheck;

page 87160 "Check Fields Rules"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Check Fields Rule";
    Caption = 'Check Fields Rules';
    CardPageId = "Check Fields Rule Card";
    Editable = false;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table No."; Rec."Table No.") { }
                field("Table Name"; Rec."Table Name") { }
                field("Table Caption"; Rec."Table Caption") { }
                field("Rule No."; Rec."Rule No.") { }
                field(Enabled; Rec.Enabled) { }
                field(Conditions; Conditions)
                {
                    Caption = 'Conditions';
                    ToolTip = 'List of fields filters';
                    StyleExpr = ConditionsStyleExpr;
                }
                field(Checks; Checks)
                {
                    Caption = 'Checks';
                    ToolTip = 'List of fields check';
                    StyleExpr = ChecksStyleExpr;
                }
                field("Confirm Bypass"; Rec."Confirm Bypass") { }
            }
        }
        area(FactBoxes)
        {
            part(ConditionsFactbox; "Check Fields Factbox")
            {
                Caption = 'Conditions';
                SubPageLink = "Table No." = field("Table No."), "Rule No." = field("Rule No.");
                SubPageView = where(Check = const(false));
            }
            part(ChecksFactbox; "Check Fields Factbox")
            {
                Caption = 'Checks';
                SubPageLink = "Table No." = field("Table No."), "Rule No." = field("Rule No.");
                SubPageView = where(Check = const(true));
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Enable)
            {
                Caption = 'Enable';
                ToolTip = 'Enable selection';
                Image = Approve;
                trigger OnAction()
                var
                    Selection: Record "Check Fields Rule";
                begin
                    CurrPage.SetSelectionFilter(Selection);
                    Selection.ModifyAll(Enabled, true);
                    CurrPage.Update(true);
                end;
            }
            action(Disable)
            {
                Caption = 'Disable';
                ToolTip = 'Disable selection';
                Image = Cancel;
                trigger OnAction()
                var
                    Selection: Record "Check Fields Rule";
                begin
                    CurrPage.SetSelectionFilter(Selection);
                    Selection.ModifyAll(Enabled, false);
                    CurrPage.Update(true);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Enable_Promoted; Enable) { }
            actionref(Disable_Promoted; Disable) { }
        }
    }
    var
        Conditions: Text;
        ConditionsStyleExpr: Text;
        Checks: Text;
        ChecksStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        Conditions := Rec.Filters(false, ConditionsStyleExpr);
        Checks := Rec.Filters(true, ChecksStyleExpr);
    end;
}