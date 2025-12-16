namespace Wanamics.WanaCheck;

page 87164 "Check Fields Rule Subpage"
{
    ApplicationArea = All;
    Caption = 'Check Fields Rule Subpage', Locked = true;
    PageType = CardPart;
    SourceTable = "Check Fields Rule Field";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Field No."; Rec."Field No.") { Width = 6; }
                field("Field Name"; Rec."Field Name") { Width = 20; }
                field("Field Caption"; Rec."Field Caption") { Width = 20; }
                field("Filter"; Rec."Filter") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(AddFields)
            {
                Caption = 'Add Fields';
                Image = Add;
                trigger OnAction()
                begin
                    Rec.AddFields();
                end;
            }
        }
    }
}
