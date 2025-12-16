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

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table No."; Rec."Table No.")
                {
                    // trigger OnValidate()
                    // begin
                    //     Rec.CalcFields("Table Caption");
                    // end;
                }
                field("Table Name"; Rec."Table Name") { }
                field("Table Caption"; Rec."Table Caption") { }
                field("Rule No."; Rec."Rule No.")
                {
                    Width = 4;
                }
                field(Conditions; Rec.Filters(false))
                {
                    Caption = 'Conditions';
                    ToolTip = 'List of fields filters';
                    // trigger OnDrillDown()
                    // begin
                    //     Rec.DrillDown(false);
                    //     CurrPage.Update(false);
                    // end;
                }
                field(Checks; Rec.Filters(true))
                {
                    Caption = 'Checks';
                    ToolTip = 'List of fields check';
                    // trigger OnDrillDown()
                    // begin
                    //     Rec.DrillDown(true);
                    //     CurrPage.Update(false);
                    // end;
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
}