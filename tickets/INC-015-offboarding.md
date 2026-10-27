# INC-015 - Çalışan Ayrılışı

## Senaryo

Çalışanın şirketten ayrılması sonrası erişimlerinin kapatılması gerekir.

## Adımlar

- Hesap disable edilir.
- Oturumlar ve erişimler gözden geçirilir.
- Grup üyelikleri kaldırılır.
- Dosya/veri devri yapılır.
- Varlık iadesi kaydedilir.

## Komutlar

```powershell
Disable-ADAccount -Identity user.name
Get-ADPrincipalGroupMembership user.name
```

