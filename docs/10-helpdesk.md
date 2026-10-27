# GLPI Help Desk

GLPI, ticket ve varlık yönetimi için kullanılan help desk sistemidir.

## Erişim

Host üzerinden:

```text
http://localhost:8080
```

Lab client üzerinden:

```text
http://10.10.10.1:8080
```

## Menülerin Anlamı

- Assistance > Tickets: incident ve request kayıtları
- Assets: bilgisayar, yazıcı, monitör gibi varlıklar
- Administration > Users: kullanıcı ve teknisyen hesapları
- Setup / Categories: ticket sınıflandırması
- SLA: hedef yanıt ve çözüm süreleri
- Historical: ticket zaman çizelgesi

## Lab Akışı

Kullanıcı sorun bildirir, ticket açılır, kategori ve öncelik atanır, teknisyen çözüm notu girer, doğrulama sonrası ticket kapatılır.

Örnek: `INC-008 - GPO Uygulanmadı` ticket'ı OU/GPO düzeltmesi sonrası çözülmüştür.

GLPI ve MySQL internete açılmamalıdır.


