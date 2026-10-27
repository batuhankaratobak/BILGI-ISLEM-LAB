# PowerShell Akışı

PowerShell, lab kurulumunu tekrarlanabilir ve doğrulanabilir hale getirir.

## Çalıştırma Sırası

Host üzerinde yönetici PowerShell:

```powershell
powershell/01-hyperv-host.ps1
powershell/02-create-client01.ps1
powershell/03-create-dc01.ps1
```

DC01 üzerinde:

```powershell
powershell/create-groups.ps1
powershell/bulk-create-users.ps1
powershell/05-network-services.ps1
powershell/06-file-shares.ps1
```

Şifreler script içine yazılmaz; gerektiğinde güvenli şekilde prompt edilir.

## Faydalı Doğrulama Komutları

```powershell
Get-ADDomain
Get-Service ADWS,DNS,DHCPServer,Netlogon,KDC
Get-DhcpServerInDC
Get-DhcpServerv4Scope
Resolve-DnsName dc01.bklab.local
gpresult /r
dcdiag /test:DNS /q
repadmin /replsummary
```

