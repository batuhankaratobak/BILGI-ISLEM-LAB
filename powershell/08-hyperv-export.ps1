#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [string[]]$VMName = @('DC01','CLIENT01'),
    [string]$BackupRoot = 'C:\Hyper-V\BKLAB-Backups',
    [switch]$ExecuteExport
)

$ErrorActionPreference = 'Stop'

New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null

if (-not $ExecuteExport) {
    Write-Host 'Dry-run modu: VM export baslatilmadi.' -ForegroundColor Yellow
    Write-Host "Export hedef kok klasoru: $BackupRoot"
    Write-Host 'Kontrol edilecek VM listesi:'
    foreach ($vm in $VMName) {
        $existing = Get-VM -Name $vm -ErrorAction SilentlyContinue
        if ($existing) {
            $existing | Select-Object Name,State,Generation,Path | Format-List
        } else {
            Write-Warning "$vm bulunamadi."
        }
    }
    Write-Host ''
    Write-Host 'Gercek export icin:'
    Write-Host ".\08-hyperv-export.ps1 -BackupRoot '$BackupRoot' -ExecuteExport"
    Write-Host ''
    Write-Host 'Guvenlik notu: Import testi yaparken DC kopyasini aktif BKLAB-LAN agina baglamayin.'
    exit 0
}

foreach ($vm in $VMName) {
    if (-not (Get-VM -Name $vm -ErrorAction SilentlyContinue)) {
        Write-Warning "$vm bulunamadi; atlandi."
        continue
    }

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $target = Join-Path $BackupRoot "$vm-$stamp"
    New-Item -ItemType Directory -Path $target -Force | Out-Null

    Write-Host "$vm export ediliyor -> $target" -ForegroundColor Cyan
    Export-VM -Name $vm -Path $target

    Write-Host "$vm export tamamlandi." -ForegroundColor Green
}

Get-ChildItem $BackupRoot -Directory |
    Select-Object Name,FullName,LastWriteTime |
    Format-Table -AutoSize

Write-Host ''
Write-Host 'Not: Export backup/recovery pratigi icindir; checkpoint ile ayni sey degildir.'
Write-Host 'Import testi yaparken domain controller kopyasini mevcut BKLAB-LAN agina ayni anda baglamayin.'
