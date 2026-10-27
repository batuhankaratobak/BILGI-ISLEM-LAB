# INC-012 - Windows Update Hatası

## Senaryo

Windows Update tamamlanmıyor veya hata veriyor.

## Kontrol

- İnternet/DNS çalışıyor mu?
- Update servisi çalışıyor mu?
- Disk alanı yeterli mi?
- Hata kodu nedir?

## Komutlar

```powershell
Get-Service wuauserv,bits
Get-Volume
```

