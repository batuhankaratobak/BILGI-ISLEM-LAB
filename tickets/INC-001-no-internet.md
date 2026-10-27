# INC-001 - İnternet Bağlantısı Yok

## Senaryo

Kullanıcı internet veya ağ kaynaklarına erişemediğini bildirir.

## Kontrol Sırası

- Fiziksel/VM network adapter bağlı mı?
- IP adresi var mı?
- Gateway var mı?
- DNS doğru mu?
- Sadece internet mi yok, yoksa domain kaynakları da mı yok?

## Komutlar

```powershell
ipconfig /all
ping 10.10.10.10
Resolve-DnsName dc01.bklab.local
```

