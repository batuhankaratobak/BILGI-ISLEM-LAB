#Requires -RunAsAdministrator
param([Parameter(Mandatory)][string]$Identity)
Import-Module ActiveDirectory
$password = Read-Host 'New temporary password' -AsSecureString
Set-ADAccountPassword $Identity -Reset -NewPassword $password -Confirm
Set-ADUser $Identity -ChangePasswordAtLogon $true


