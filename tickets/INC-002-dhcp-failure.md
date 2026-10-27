# INC-002 - DHCP IP Alamıyor

## Senaryo

CLIENT01 otomatik IP alamıyor veya APIPA adresi alıyor.

## Kontrol

- DHCP servisi çalışıyor mu?
- Scope aktif mi?
- DHCP server AD içinde authorized mı?
- Client doğru Hyper-V switch'e bağlı mı?

## Komutlar

```powershell
Get-Service DHCPServer
Get-DhcpServerInDC
Get-DhcpServerv4Scope
ipconfig /release
ipconfig /renew
```

## Doğrulama

Client `10.10.10.100-200` aralığından IP almalıdır.

