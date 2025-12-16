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
            part(When; "Check Fields Rule Subpage")
            {
                Caption = 'Conditions';
                SubPageLink = "Table No." = field("Table No."), "Rule No." = field("Rule No.");
                SubPageView = where(Check = const(false));
            }
            part(Then; "Check Fields Rule Subpage")
            {
                Caption = 'Checks';
                SubPageLink = "Table No." = field("Table No."), "Rule No." = field("Rule No.");
                SubPageView = where(Check = const(true));
            }
        }
    }
    // local procedure DataCaptionExpression(): Text
    // begin
    //     exit(StrSubstNo('%1 - %2', Rec."Table Caption", Rec."Rule No."));
    // end;
    /*
    actions
    {
        area(Processing)
        {
            action(AddConditionFields)
            {
                Caption = 'Add Condition Fields';
                trigger OnAction()
                begin
                    AddFields(false);
                end;
            }
            action(AddCheckFields)
            {
                Caption = 'Add Check Fields';
                trigger OnAction()
                begin
                    AddFields(true);
                end;
            }
        }
        area(Promoted)
        {
            actionref(AddConditionFields_Promoted; AddConditionFields) { }
            actionref(AddCheckFields_Promoted; AddCheckFields) { }
        }
    }
    local procedure AddFields(pCheck: Boolean)
    begin
        // if not FieldSelection.Open(Field) then
        //     exit;
        // "Field No." := Field."No.";
        // // Modify(true);
        // if Field.Count > 1 then
        //     if Field.FindSet() then
        //         repeat
        //             Init();
        //             "Field No." := Field."No.";
        //             if Insert(true) then;
        //         until Field.Next() = 0;

    end;
    */
}
