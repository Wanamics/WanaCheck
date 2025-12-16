namespace Wanamics.WanaCheck;

permissionset 87160 "WanaCheck_Setup"
{
    Assignable = true;
    Permissions = tabledata "Check Fields Rule" = RIMD,
        table "Check Fields Rule" = X,
        codeunit "Check Fields" = X,
        page "Check Fields Rules" = X,
        tabledata "Check Fields Rule Field" = RIMD,
        table "Check Fields Rule Field" = X;
    // page "Check Fields Rule Fields" = X;
    IncludedPermissionSets = WanaCheck;
}