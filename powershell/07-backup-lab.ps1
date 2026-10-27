#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [string]$BackupTarget = 'E:',
    [string]$TestRoot = 'C:\BKLAB-Shares\BackupTest',
    [switch]$ExecuteBackup
)

$ErrorActionPreference = 'Stop'

Write-Host 'BK LAB - Backup & Recovery validation' -ForegroundColor Cyan

if ($BackupTarget -match '^[cC]:\\?$') {
    throw 'Backup target C: olamaz. Lab icin ayri bir disk veya volume kullanin.'
}

if (-not (Test-Path $BackupTarget)) {
    throw "Backup target bulunamadi: $BackupTarget. Once ayri bir lab diski hazirlayin."
}

$feature = Get-WindowsFeature Windows-Server-Backup
if (-not $feature.Installed) {
    Write-Warning 'Windows Server Backup kurulu degil.'
    Write-Host 'Kurulum: Install-WindowsFeature Windows-Server-Backup -IncludeManagementTools'
    if ($ExecuteBackup) {
        Install-WindowsFeature Windows-Server-Backup -IncludeManagementTools | Out-Host
    }
}

New-Item -ItemType Directory -Path $TestRoot -Force | Out-Null

$files = @{
    'musteri-listesi-lab.txt' = 'Sentetik BK LAB musteri listesi - gercek veri degildir.'
    'sozlesme-lab.txt'        = 'Sentetik BK LAB sozlesme dosyasi - gercek veri degildir.'
    'restore-me.txt'          = "Restore test file created at $(Get-Date -Format s)"
}

foreach ($name in $files.Keys) {
    $path = Join-Path $TestRoot $name
    if (-not (Test-Path $path)) {
        Set-Content -Path $path -Value $files[$name] -Encoding UTF8
    }
}

Write-Host "Test verisi hazir: $TestRoot"
Get-ChildItem $TestRoot | Select-Object Name,Length,LastWriteTime | Format-Table

if (-not $ExecuteBackup) {
    Write-Host ''
    Write-Host 'Dry-run tamamlandi. Backup baslatilmadi.' -ForegroundColor Yellow
    Write-Host 'Bu script mevcut VM silmez, gercek kullanici verisi kullanmaz ve yalnizca sentetik test dosyalari hazirlar.'
    Write-Host 'Gercek lab backup icin:'
    Write-Host ".\07-backup-lab.ps1 -BackupTarget '$BackupTarget' -ExecuteBackup"
    exit 0
}

$include = $TestRoot
Write-Host "Backup baslatiliyor: $include -> $BackupTarget" -ForegroundColor Cyan

& wbadmin start backup "-backupTarget:$BackupTarget" "-include:$include" -quiet

if ($LASTEXITCODE -ne 0) {
    throw "wbadmin hata kodu: $LASTEXITCODE"
}

Write-Host 'Backup tamamlandi. Kayitli versiyonlar:' -ForegroundColor Green
& wbadmin get versions "-backupTarget:$BackupTarget"

Write-Host ''
Write-Host 'Sonraki adim:' -ForegroundColor Cyan
Write-Host "1) $(Join-Path $TestRoot 'restore-me.txt') dosyasini silin."
Write-Host '2) Windows Server Backup > Recover ile geri getirin.'
Write-Host '3) Test-Path ve Get-FileHash ile dogrulayin.'
