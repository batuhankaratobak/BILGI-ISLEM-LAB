# DNS

DNS, domain ortamının isim çözümleme servisidir. Client bilgisayarlar domain controller'ı DNS üzerinden bulur.

## Menü

```text
Server Manager > Tools > DNS
```

Bakılacak yer:

```text
Forward Lookup Zones > bklab.local
```

## Amaç

`dc01.bklab.local` gibi isimler doğru IP adresine çözülmelidir. DNS yanlışsa domain join, login ve GPO işlemleri bozulabilir.

## Doğrulama

```powershell
Resolve-DnsName dc01.bklab.local
dcdiag /test:DNS /q
```

