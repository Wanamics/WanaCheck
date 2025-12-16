
namespace Wanamics.WanaCheck;

using Microsoft.Projects.Resources.Resource;
using Microsoft.Projects.Project.Job;

codeunit 87164 "Check Fields Jobs"
{
    [EventSubscriber(ObjectType::Table, Database::Resource, OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnResourceUnblock(var xRec: Record Resource; var Rec: Record Resource)
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        if not xRec.Blocked or Rec.Blocked then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, database::Job, OnBeforeValidateEvent, 'Blocked', false, false)]
    local procedure OnJobUnblock(var xRec: Record Job; var Rec: Record Job)
    var
        CheckFields: Codeunit "Check Fields";
        RecRef: RecordRef;
    begin
        if (xRec.Blocked = xRec.Blocked::" ") or (Rec.Blocked <> Rec.Blocked::" ") then
            exit;
        RecRef.GetTable(Rec);
        CheckFields.ApplyTo(RecRef);
    end;
}
