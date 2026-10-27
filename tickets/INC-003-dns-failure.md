# INC-003 - DNS Çözümleme Hatası

## Senaryo

Client domain controller adını çözemiyor veya domain kaynaklarına erişemiyor.

## Kontrol

- Client DNS server olarak `10.10.10.10` kullanıyor mu?
- `bklab.local` zone'u var mı?
- `dc01.bklab.local` çözümleniyor mu?

## Komutlar

```powershell
ipconfig /all
Resolve-DnsName dc01.bklab.local
nslookup dc01.bklab.local
```

