namespace Wanamics.WanaCheck;

permissionset 87160 "WanaCheck_Setup"
{
    Assignable = true;
    Permissions =
        tabledata "Check Fields Rule" = RIMD,
        table "Check Fields Rule" = X,
        tabledata "Check Fields Rule Field" = RIMD,
        table "Check Fields Rule Field" = X,
        page "Check Fields Rules" = X;
    IncludedPermissionSets = WanaCheck;
}