# INC-010 - Bilgisayar Yavaş

## Senaryo

Kullanıcı bilgisayarın yavaş çalıştığını bildirir.

## Kontrol

- CPU/RAM/disk kullanımı yüksek mi?
- Başlangıç programları yoğun mu?
- Disk dolu mu?
- Windows Update veya antivirüs taraması çalışıyor mu?

## Komutlar

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
Get-Volume
```

