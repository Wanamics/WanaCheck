#if FALSE
namespace Wanamics.WanaCheck;

page 87161 "Check Fields Rule Fields"
{
    Caption = 'Check Fields Rule Fields';
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
                    // Lookup = true;
                    // trigger OnLookup(var Text: Text): Boolean
                    // var
                    //     Field: Record Field;
                    //     FieldSelection: Codeunit "Field Selection";
                    // begin
                    //     Field.SetRange(TableNo, Rec."Table No.");
                    //     Field.SetRange(Class, Field.Class::Normal);
                    //     Field.SetFilter("No.", '<%1', 2000000000); // avoid system fields
                    //     if Rec."Field No." <> 0 then
                    //         if Field.Get(Rec."Table No.", Rec."Field No.") then;
                    //     if not FieldSelection.Open(Field) then
                    //         exit;
                    //     Rec."Field No." := Field."No.";
                    //     if Field.Count > 1 then
                    //         if Field.FindSet() then
                    //             repeat
                    //                 Rec.Init();
                    //                 Rec."Field No." := Field."No.";
                    //                 if Rec.Insert(true) then;
                    //             until Field.Next() = 0;
                    //     CurrPage.Update(true);
                    // end;

                    // trigger OnValidate()
                    // begin
                    //     CurrPage.Update(true);
                    // end;
                    // trigger OnAfterLookup(Selected: RecordRef)
                    // begin
                    //     CurrPage.Update(true);
                    // end;
                }
                field("Field Name"; Rec."Field Name") { }
                field("Field Caption"; Rec."Field Caption") { }
                field("Field Filter"; Rec.Filter) { }
            }
        }
    }
}
#endif
