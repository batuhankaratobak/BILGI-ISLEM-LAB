#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string]$ServerIso,
    [Parameter(Mandatory)][ValidateScript({Test-Path $_ -PathType Leaf})][string]$ClientIso,
    [string]$VmRoot = 'C:\Hyper-V\BKLAB',
    [switch]$EnableNat
)
$ErrorActionPreference = 'Stop'
$switchName = 'BKLAB-LAN'
if (-not (Get-VMSwitch -Name $switchName -ErrorAction SilentlyContinue)) {
    New-VMSwitch -Name $switchName -SwitchType Internal | Out-Null
}
$adapter = "vEthernet ($switchName)"
if (-not (Get-NetIPAddress -InterfaceAlias $adapter -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object IPAddress -eq '10.10.10.1')) {
    Get-NetIPAddress -InterfaceAlias $adapter -AddressFamily IPv4 -ErrorAction SilentlyContinue | Remove-NetIPAddress -Confirm:$false
    New-NetIPAddress -InterfaceAlias $adapter -IPAddress '10.10.10.1' -PrefixLength 24 | Out-Null
}
if ($EnableNat -and -not (Get-NetNat -Name 'BKLAB-NAT' -ErrorAction SilentlyContinue)) {
    New-NetNat -Name 'BKLAB-NAT' -InternalIPInterfaceAddressPrefix '10.10.10.0/24' | Out-Null
}
New-Item -ItemType Directory -Path $VmRoot -Force | Out-Null
function New-BKWorksVM {
    param([string]$Name,[UInt64]$Memory,[UInt64]$DiskSize,[string]$Iso)
    if (Get-VM -Name $Name -ErrorAction SilentlyContinue) { Write-Warning "$Name exists; skipped."; return }
    $path = Join-Path $VmRoot $Name
    New-VM -Name $Name -Generation 2 -MemoryStartupBytes $Memory -NewVHDPath (Join-Path $path "$Name.vhdx") -NewVHDSizeBytes $DiskSize -Path $path -SwitchName $switchName | Out-Null
    Set-VM -Name $Name -ProcessorCount 2 -DynamicMemory -MemoryMinimumBytes 2GB -MemoryMaximumBytes 8GB
    Add-VMDvdDrive -VMName $Name -Path $Iso | Out-Null
    Set-VMFirmware -VMName $Name -FirstBootDevice (Get-VMDvdDrive -VMName $Name) -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows
}
New-BKWorksVM DC01 4GB 80GB $ServerIso
New-BKWorksVM CLIENT01 4GB 64GB $ClientIso
Get-VM DC01,CLIENT01 | Format-Table Name,State,Generation,ProcessorCount,MemoryStartup


