# DHCP

DHCP, client bilgisayarlara otomatik IP yapılandırması verir.

## Menü

```text
Server Manager > Tools > DHCP
```

Scope yolu:

```text
DHCP > DC01.bklab.local > IPv4 > Scope [10.10.10.0] BKLAB-LAN
```

## Ayarlar

- Scope: `10.10.10.100-10.10.10.200/24`
- DNS Server: `10.10.10.10`
- Domain: `bklab.local`
- Router: NAT kullanılıyorsa `10.10.10.1`

## Menülerin Anlamı

- Address Pool: dağıtılacak IP aralığı
- Scope Options: DNS, domain ve gateway bilgileri
- Address Leases: IP alan client'lar
- Authorize: DHCP sunucusunu AD içinde yetkilendirir

## Doğrulama

```powershell
Get-DhcpServerInDC
Get-DhcpServerv4Scope
Get-DhcpServerv4Lease -ScopeId 10.10.10.0
```

CLIENT01 üzerinde:

```powershell
ipconfig /all
```

