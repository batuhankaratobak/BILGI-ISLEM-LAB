#Requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$ServerIso,

    [string]$VmRoot = 'C:\Hyper-V\BKLAB'
)

$ErrorActionPreference = 'Stop'
$vmName = 'DC01'
$switchName = 'BKLAB-LAN'

Import-Module Hyper-V

if (Get-VM -Name $vmName -ErrorAction SilentlyContinue) {
    throw "VM '$vmName' already exists. No changes were made."
}

$switch = Get-VMSwitch -Name $switchName -ErrorAction Stop
if ($switch.SwitchType -ne 'Internal') {
    throw "Switch '$switchName' is not an Internal switch. No changes were made."
}

$vmPath = Join-Path $VmRoot $vmName
New-Item -ItemType Directory -Path $vmPath -Force | Out-Null

New-VM -Name $vmName -Generation 2 -MemoryStartupBytes 4GB `
    -NewVHDPath (Join-Path $vmPath "$vmName.vhdx") -NewVHDSizeBytes 80GB `
    -Path $vmPath -SwitchName $switchName | Out-Null

Set-VM -Name $vmName -ProcessorCount 2 -DynamicMemory `
    -MemoryMinimumBytes 2GB -MemoryMaximumBytes 6GB `
    -AutomaticCheckpointsEnabled $false

Add-VMDvdDrive -VMName $vmName -Path $ServerIso | Out-Null
$dvd = Get-VMDvdDrive -VMName $vmName
Set-VMFirmware -VMName $vmName -FirstBootDevice $dvd `
    -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows

Get-VM -Name $vmName | Format-List Name,State,Generation,Path,ProcessorCount,MemoryStartup
Get-VMNetworkAdapter -VMName $vmName | Format-List VMName,SwitchName,MacAddress
Get-VMDvdDrive -VMName $vmName | Format-List Path


