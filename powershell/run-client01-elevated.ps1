#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$ClientIso,

    [string]$LogPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'client01-setup.log')
)

$ErrorActionPreference = 'Stop'
$createScript = Join-Path $PSScriptRoot '02-create-client01.ps1'

try {
    & $createScript -ClientIso $ClientIso *>&1 | Out-File -LiteralPath $LogPath -Encoding utf8
} catch {
    $_ | Format-List * -Force | Out-File -LiteralPath $LogPath -Encoding utf8
    exit 1
}

