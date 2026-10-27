#Requires -RunAsAdministrator
param(
    [Parameter(Mandatory)][string]$GivenName,
    [Parameter(Mandatory)][string]$Surname,
    [Parameter(Mandatory)][string]$SamAccountName,
    [Parameter(Mandatory)][ValidateSet('IT','Management','Operations','Sales','Accounting','Design')][string]$Department
)
Import-Module ActiveDirectory
$password = Read-Host 'Temporary password' -AsSecureString
New-ADUser -Name "$GivenName $Surname" -GivenName $GivenName -Surname $Surname -SamAccountName $SamAccountName -UserPrincipalName "$SamAccountName@bklab.local" -Department $Department -Path "OU=$Department,OU=BKLAB,DC=bklab,DC=local" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true
Add-ADGroupMember ("GG_" + $Department.ToUpperInvariant()) $SamAccountName
Add-ADGroupMember GG_SHARED_DRIVE_USERS $SamAccountName


