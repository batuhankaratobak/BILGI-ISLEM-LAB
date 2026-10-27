# INC-007 - Güvenlik Yetkisi Olayı

## Senaryo

Kullanıcının sahip olmaması gereken bir erişime sahip olduğu bildirilir.

## Kontrol

- Kullanıcı hangi gruplarda?
- Grup hangi kaynağa yetki veriyor?
- Yetki doğrudan kullanıcıya mı verilmiş?
- Eski veya miras kalan NTFS yetkisi var mı?

## Çözüm

Gereksiz grup üyeliği veya doğrudan verilmiş yetki kaldırılır. Least privilege uygulanır.

