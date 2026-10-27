#Requires -RunAsAdministrator
param([string]$CsvPath = (Join-Path $PSScriptRoot 'bulk-users.csv'))
Import-Module ActiveDirectory
$password = Read-Host 'Temporary password for lab users' -AsSecureString
Import-Csv $CsvPath | ForEach-Object {
    if (Get-ADUser -Filter "SamAccountName -eq '$($_.SamAccountName)'" -ErrorAction SilentlyContinue) { Write-Warning "$($_.SamAccountName) exists; skipped."; return }
    New-ADUser -Name "$($_.GivenName) $($_.Surname)" -GivenName $_.GivenName -Surname $_.Surname -SamAccountName $_.SamAccountName -UserPrincipalName "$($_.SamAccountName)@bklab.local" -Department $_.Department -Path "OU=$($_.Department),OU=BKLAB,DC=bklab,DC=local" -AccountPassword $password -Enabled $true -ChangePasswordAtLogon $true
    Add-ADGroupMember ("GG_" + $_.Department.ToUpperInvariant()) $_.SamAccountName
    Add-ADGroupMember GG_SHARED_DRIVE_USERS $_.SamAccountName
}


