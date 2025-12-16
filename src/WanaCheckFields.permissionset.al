namespace Wanamics.WanaCheck;

permissionset 87161 "WanaCheck"
{
    Assignable = true;
    Permissions =
        tabledata "Check Fields Rule" = R,
        table "Check Fields Rule" = X,
        page "Check Fields Rules" = X,
        tabledata "Check Fields Rule Field" = R,
        table "Check Fields Rule Field" = X,
        // page "Check Fields Rule Fields" = X,
        codeunit "Check Fields" = X,
        codeunit "Check Fields Sales" = X;
}