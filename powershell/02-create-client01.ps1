#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$ClientIso,

    [string]$VmRoot = 'C:\Hyper-V\BKLAB',

    [string]$ResultFile = (Join-Path (Split-Path -Parent $PSScriptRoot) 'client01-result.txt')
)

$ErrorActionPreference = 'Stop'
$switchName = 'BKLAB-LAN'
$vmName = 'CLIENT01'

Import-Module Hyper-V

$existingVm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
if ($existingVm) {
    throw "VM '$vmName' already exists at '$($existingVm.Path)'. No changes were made."
}

$switch = Get-VMSwitch -Name $switchName -ErrorAction SilentlyContinue
if (-not $switch) {
    $switch = New-VMSwitch -Name $switchName -SwitchType Internal
} elseif ($switch.SwitchType -ne 'Internal') {
    throw "Switch '$switchName' already exists but is not Internal. No changes were made."
}

$adapter = "vEthernet ($switchName)"
if (-not (Get-NetIPAddress -InterfaceAlias $adapter -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object IPAddress -eq '10.10.10.1')) {
    New-NetIPAddress -InterfaceAlias $adapter -IPAddress '10.10.10.1' -PrefixLength 24 | Out-Null
}

$vmPath = Join-Path $VmRoot $vmName
New-Item -ItemType Directory -Path $vmPath -Force | Out-Null
New-VM -Name $vmName -Generation 2 -MemoryStartupBytes 4GB `
    -NewVHDPath (Join-Path $vmPath "$vmName.vhdx") -NewVHDSizeBytes 64GB `
    -Path $vmPath -SwitchName $switchName | Out-Null
Set-VM -Name $vmName -ProcessorCount 2 -DynamicMemory -MemoryMinimumBytes 2GB -MemoryMaximumBytes 6GB -AutomaticCheckpointsEnabled $false
Add-VMDvdDrive -VMName $vmName -Path $ClientIso | Out-Null
$dvd = Get-VMDvdDrive -VMName $vmName
Set-VMFirmware -VMName $vmName -FirstBootDevice $dvd -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows
Set-VMKeyProtector -VMName $vmName -NewLocalKeyProtector
Enable-VMTPM -VMName $vmName

Get-VM -Name $vmName | Format-List Name,State,Generation,Path,ProcessorCount,MemoryStartup
Get-VMNetworkAdapter -VMName $vmName | Format-List VMName,SwitchName,MacAddress
'CLIENT01_CREATED_OK' | Set-Content -LiteralPath $ResultFile
Write-Host 'CLIENT01_CREATED_OK'

