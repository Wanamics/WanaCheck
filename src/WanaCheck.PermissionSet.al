namespace Wanamics.WanaCheck;

using Wanamics.WanaCheck;
using WanaCheck.WanaCheck;

permissionset 87161 "WanaCheck"
{
    Assignable = true;
    Permissions =
        tabledata "Check Fields Rule" = R,
        table "Check Fields Rule" = X,
        tabledata "Check Fields Rule Field" = R,
        table "Check Fields Rule Field" = X,
        page "Check Fields Rules" = X,
        codeunit "Check Fields" = X,
        codeunit "Check Fields Sales" = X,
        codeunit "Check Fields Jobs" = X,
        codeunit "Check Fields Master" = X,
        codeunit "Check Fields Purchase" = X,
        page "Check Fields Factbox" = X,
        page "Check Fields Rule Card" = X,
        page "Check Fields Rule Subpage" = X;
}