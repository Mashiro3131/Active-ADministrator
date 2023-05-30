$GpoNames = @(
    "Your GPO Name"
    # If you want to add multiple GPO names :
    # "Your first GPO Name",
    # "Your second GPO Name"
)

$Group = "Your Group Name" # <----------

Import-Module ActiveDirectory

foreach ($GpoName in $GpoNames) {
    $Gpo = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
    if ($Gpo) {
        $GroupObject = Get-ADGroup -Identity $Group -ErrorAction SilentlyContinue
        if ($GroupObject) {
            $ExistingPermissions = Get-GPPermissions -Guid $Gpo.Id -All | Where-Object { $_.Trustee.Name -eq $Group } -ErrorAction SilentlyContinue

            $HasRequiredPermissions = $ExistingPermissions | Where-Object {
                $_.Permission -eq "GpoEditDeleteModifySecurity" -and $_.PermissionType -eq "Allow"
            }

            if (!$HasRequiredPermissions) {
                $Permissions = @{
                    TargetName       = $Group
                    TargetType       = "Group"
                    Permission       = "GpoEditDeleteModifySecurity"
                    Inherited        = $false
                }

                Set-GPPermissions -Guid $Gpo.Id -PermissionLevel $Permissions.Permission -TargetName $Group -TargetType Group

                Write-Host "The rights 'Edit settings, delete, and modify security' has been added to the group '$Group' for the GPO '$GpoName'."
            } else {
                Write-Host "The group '$Group' already has the 'Edit settings, delete, and modify security' rights for the GPO '$GpoName'."
            }
        } else {
            Write-Host "The group '$Group' hasn't been found. Please verify your group name."
        }
    } else {
        Write-Host "The GPO '$GpoName' hasn't been found. Please verify your GPO name."
    }
}