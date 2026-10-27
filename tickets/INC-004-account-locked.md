# INC-004 - Hesap Kilitlendi

## Senaryo

Kullanıcı yanlış şifre denemeleri sonrası domain hesabına giriş yapamıyor.

## Kontrol

- ADUC içinde kullanıcı hesabı kilitli mi?
- Lockout policy eşik değeri nedir?
- Kullanıcı eski şifreyi kullanan cihaz/oturum var mı?

## Komutlar

```powershell
Search-ADAccount -LockedOut
Unlock-ADAccount -Identity user.name
```

