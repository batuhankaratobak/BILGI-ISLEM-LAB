#Requires -RunAsAdministrator
param([Parameter(Mandatory)][string]$Identity)
Import-Module ActiveDirectory
Disable-ADAccount $Identity -Confirm


