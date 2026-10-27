# Windows Server 2022

`DC01`, Windows Server 2022 Standard Evaluation Desktop Experience ile kurulmuştur.

## Amaç

Bu sunucu lab'ın merkezi servislerini taşır:

- Active Directory Domain Services
- DNS Server
- DHCP Server
- Group Policy Management
- File Server

## Menü

```text
Server Manager > Manage > Add Roles and Features
```

Buradan gerekli roller kurulur. Kurulumdan sonra:

```text
Server Manager > Tools
```

menüsü ile ADUC, DNS, DHCP ve GPMC açılır.

## Temel Ayarlar

- Hostname: `DC01`
- IP: `10.10.10.10/24`
- DNS: `10.10.10.10`
- Domain: `bklab.local`

DSRM ve administrator şifreleri repo içine yazılmaz.

