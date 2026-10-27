#Requires -RunAsAdministrator
param([Parameter(Mandatory)][string]$Identity)
Import-Module ActiveDirectory
Get-ADUser $Identity -Properties LockedOut | Select-Object SamAccountName,LockedOut
Unlock-ADAccount $Identity -Confirm


