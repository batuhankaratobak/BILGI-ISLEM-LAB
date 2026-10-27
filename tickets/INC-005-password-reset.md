# INC-005 - Şifre Sıfırlama

## Senaryo

Kullanıcı şifresini unuttuğunu bildirir.

## Güvenlik

Kullanıcının kimliği doğrulanmadan şifre sıfırlanmaz. Şifre ticket içine yazılmaz.

## Komutlar

```powershell
Set-ADAccountPassword -Identity user.name -Reset
Set-ADUser user.name -ChangePasswordAtLogon $true
```

## Doğrulama

Kullanıcı geçici şifre ile giriş yapar ve ilk girişte yeni şifre belirler.

