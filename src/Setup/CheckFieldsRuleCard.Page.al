namespace WanaCheck.WanaCheck;

using Wanamics.WanaCheck;

page 87163 "Check Fields Rule Card"
{
    ApplicationArea = All;
    Caption = 'Check Fields Rule Card';
    PageType = Card;
    SourceTable = "Check Fields Rule";
    DataCaptionExpression = '';//DataCaptionExpression();
    // DataCaptionFields = "Table Caption", "Rule No.";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Table No."; Rec."Table No.")
                {
                }
                field("Rule No."; Rec."Rule No.")
                {
                }
                field("Confirm Bypass"; Rec."Confirm Bypass")
                {
                }
                field("Table Name"; Rec."Table Name")
                {
                }
                field("Table Caption"; Rec."Table Caption")
                {
                }
            }
            part(Conditions; "Check Fields Rule Subpage")
            {
                Caption = 'Conditions';
                SubPageLink = "Table No." = field("Table No."), "Rule No." = field("Rule No.");
                SubPageView = where(Check = const(false));
            }
            part(Checks; "Check Fields Rule Subpage")
            {
                Caption = 'Checks';
                SubPageLink = "Table No." = field("Table No."), "Rule No." = field("Rule No.");
                SubPageView = where(Check = const(true));
            }
        }
    }
}
