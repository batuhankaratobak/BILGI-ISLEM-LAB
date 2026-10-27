# Group Policy

Group Policy, domain kullanıcılarına ve bilgisayarlarına merkezi ayar uygulamak için kullanılır.

## Menü

DC01 üzerinde:

```text
Server Manager > Tools > Group Policy Management
```

Önemli alanlar:

- Group Policy Objects: GPO'ların durduğu yer
- Linked OUs: GPO'nun uygulandığı OU
- Computer Configuration: bilgisayar ayarları
- User Configuration: kullanıcı ayarları
- Preferences > Windows Settings > Drive Maps: ağ sürücüsü eşleme

## Kurulan GPO'lar

- `BKLAB - Client Baseline`
- `BKLAB - User Drive Mapping`

Drive mapping ayarı:

```text
S: -> \\DC01\Company
```

Bu ayar kullanıcı oturum açtığında ortak şirket paylaşımının otomatik gelmesini sağlar.

## Doğrulama

CLIENT01 üzerinde domain kullanıcısı ile:

```powershell
gpupdate /force
gpresult /r
net use
```

