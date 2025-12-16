#if FALSE

namespace Wanamics.WanaCheck;

page 87162 "Check Fields Rule Filters"
{
    Caption = 'Check Fields Rule Filters';
    PageType = List;
    SourceTable = "Check Fields Rule Field";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the field on which you want to filter records in the configuration table.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CheckFields: Codeunit "Check Fields";
                    begin
                        if CheckFields.Lookup(Rec."Table No.", Rec."Field No.") then begin
                            Rec.Validate("Field No.");
                            CurrPage.Update(true);
                        end;
                    end;
                }
                field("Field Name"; Rec."Field Name") { }
                field("Field Caption"; Rec."Field Caption") { }
                field("Field Filter"; Rec.Filter) { }
            }
        }
    }
}
#endif
