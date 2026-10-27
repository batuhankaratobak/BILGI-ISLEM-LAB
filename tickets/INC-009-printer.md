# INC-009 - Yazıcı Problemi

## Senaryo

Kullanıcı yazdırma yapamadığını bildirir.

## Kontrol

- Yazıcı ağa bağlı mı?
- Print Spooler çalışıyor mu?
- Yazıcı IP/hostname erişilebilir mi?
- Kuyrukta takılı job var mı?

## Komutlar

```powershell
Get-Service Spooler
Get-Printer
Get-PrintJob
ping 10.10.10.50
```

