#Requires -RunAsAdministrator
$root='C:\BKLAB-Shares'
New-Item -ItemType Directory $root -Force | Out-Null
foreach ($name in @('Public','IT','Operations','Sales','Accounting','Design')) {
    $path=Join-Path $root $name; New-Item -ItemType Directory $path -Force | Out-Null
    $group=if($name -eq 'Public'){'BKLAB\GG_SHARED_DRIVE_USERS'}else{"BKLAB\GG_$($name.ToUpperInvariant())"}
    if (-not (Get-SmbShare $name -ErrorAction SilentlyContinue)) { New-SmbShare -Name $name -Path $path -FullAccess 'BUILTIN\Administrators','BKLAB\GG_IT' -ChangeAccess $group | Out-Null }
    & icacls.exe $path /inheritance:r /grant:r 'BUILTIN\Administrators:(OI)(CI)F' 'BKLAB\GG_IT:(OI)(CI)M' "${group}:(OI)(CI)M"
}


