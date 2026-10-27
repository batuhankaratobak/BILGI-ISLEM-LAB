# INC-006 - Paylaşımlı Klasör Erişimi

## Senaryo

Kullanıcı departman klasörüne erişemiyor veya erişmemesi gereken klasöre erişiyor.

## Kontrol

- Kullanıcı doğru departman grubunda mı?
- SMB share permission doğru mu?
- NTFS permission doğru mu?
- GPO ile map edilen sürücü doğru mu?

## Komutlar

```powershell
whoami /groups
Test-Path \\DC01\IT
Test-Path \\DC01\HR
```

