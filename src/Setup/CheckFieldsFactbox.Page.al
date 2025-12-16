namespace Wanamics.WanaCheck;
page 87162 "Check Fields Factbox"
{
    ApplicationArea = All;
    Caption = 'Check Fields Factbox', Locked = true;
    PageType = ListPart;
    SourceTable = "Check Fields Rule Field";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Field No."; Rec."Field No.") { Visible = false; }
                field("Field Name"; Rec."Field Name") { }
                field("Filter"; Rec."Filter") { }
            }
        }
    }
}
