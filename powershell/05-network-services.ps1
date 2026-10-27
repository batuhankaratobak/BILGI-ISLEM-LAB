#Requires -RunAsAdministrator
$ErrorActionPreference='Stop'
$zone='bklab.local'
foreach ($record in @{dc01='10.10.10.10';files='10.10.10.10';intranet='10.10.10.10'}.GetEnumerator()) {
    if (-not (Get-DnsServerResourceRecord -ZoneName $zone -Name $record.Key -RRType A -ErrorAction SilentlyContinue)) { Add-DnsServerResourceRecordA -ZoneName $zone -Name $record.Key -IPv4Address $record.Value }
}
if (-not (Get-DhcpServerv4Scope -ScopeId 10.10.10.0 -ErrorAction SilentlyContinue)) { Add-DhcpServerv4Scope -Name BKLAB-LAN -StartRange 10.10.10.100 -EndRange 10.10.10.200 -SubnetMask 255.255.255.0 -State Active }
Set-DhcpServerv4OptionValue -ScopeId 10.10.10.0 -DnsServer 10.10.10.10 -DnsDomain $zone
Write-Host 'Router option omitted; add 10.10.10.1 only after NAT verification.'


