# Backup ve Recovery Lab

Bu bölüm BK LAB'ın Level 2 sistem yönetimi genişletmesidir.

Amaç, Hyper-V checkpoint ile gerçek backup arasındaki farkı uygulamalı olarak görmek; dosya yedeği, restore testi ve VM export/import senaryosu gerçekleştirmektir.

> Durum: Uygulanacak lab. Restore doğrulanmadan README'de "tamamlandı" olarak işaretlenmemelidir.

## Hedefler

- Windows Server Backup özelliğini kullanmak
- Ayrı bir hedef diske dosya yedeği almak
- Bir test dosyasını bilerek silmek
- Backup üzerinden dosyayı geri yüklemek
- Hyper-V VM export almak
- Export edilen VM'i test amaçlı import ederek doğrulamak
- Backup ile checkpoint arasındaki farkı açıklayabilmek
- RPO ve RTO kavramlarını temel seviyede uygulamak

## Mimari

```text
Windows Host
└─ Hyper-V
   └─ BKLAB-LAN
      ├─ DC01
      │  ├─ AD DS
      │  ├─ DNS
      │  ├─ DHCP
      │  ├─ GPO
      │  ├─ File Server
      │  └─ Windows Server Backup
      │
      └─ CLIENT01

DC01
│
├─ C:\BKLAB-Shares
│
└─ Backup
   └─ E:\  (lab için ayrılmış sanal disk)

Hyper-V Host
└─ C:\Hyper-V\BKLAB-Backups
   ├─ DC01 export
   └─ CLIENT01 export
```

## 1. Backup Hedefi

DC01'e ayrı bir sanal disk bağlanır ve Windows içinde `E:` olarak hazırlanır.

Lab kolaylığı için aynı fiziksel host üzerinde tutulabilir; ancak gerçek üretim ortamında backup'ın aynı fiziksel arıza alanında tutulmasının yeterli olmadığı özellikle not edilmelidir.

## 2. Windows Server Backup

Server Manager:

```text
Manage
> Add Roles and Features
> Features
> Windows Server Backup
```

PowerShell:

```powershell
Install-WindowsFeature Windows-Server-Backup -IncludeManagementTools
```

Kontrol:

```powershell
Get-WindowsFeature Windows-Server-Backup
```

## 3. Test Verisi

```text
C:\BKLAB-Shares\BackupTest\
├─ musteri-listesi-lab.txt
├─ sozlesme-lab.txt
└─ restore-me.txt
```

Bunlar tamamen sentetik lab dosyalarıdır.

## 4. İlk Backup

Örnek:

```powershell
wbadmin start backup `
  -backupTarget:E: `
  -include:C:\BKLAB-Shares\BackupTest `
  -quiet
```

Versiyonları kontrol et:

```powershell
wbadmin get versions -backupTarget:E:
```

## 5. Arıza Senaryosu

`restore-me.txt` bilerek silinir.

```powershell
Remove-Item C:\BKLAB-Shares\BackupTest\restore-me.txt
```

Amaç gerçek kullanıcı hatasını simüle etmektir.

## 6. Restore

Windows Server Backup konsolundan:

```text
Local Backup
> Recover
> Backup location
> Backup date
> Files and folders
> restore-me.txt
> Original location veya alternate location
```

Restore sonrası:

```powershell
Test-Path C:\BKLAB-Shares\BackupTest\restore-me.txt
Get-FileHash C:\BKLAB-Shares\BackupTest\restore-me.txt
```

Beklenen sonuç:

```text
True
```

## 7. Hyper-V VM Export

Host üzerinde:

```powershell
Export-VM -Name DC01 -Path C:\Hyper-V\BKLAB-Backups
```

Kontrol:

```powershell
Get-ChildItem C:\Hyper-V\BKLAB-Backups -Recurse
```

Bu işlem checkpoint değildir. VM'in taşınabilir bir kopyasını üretir.

## 8. Restore Testi

Üretimdeki VM'e dokunmadan export edilmiş VM:

```text
Import Virtual Machine
> Copy the virtual machine
> Generate a new unique ID
```

seçeneği ile farklı isim/izole network kullanılarak test edilir.

Aktif domain ortamında aynı DC'nin ikinci kopyasını aynı ağa bağlamak risklidir. Restore testi yapılırken test kopyası `BKLAB-LAN` dışındaki izole bir switch'te tutulmalıdır.

## Checkpoint vs Backup

```text
CHECKPOINT
Değişiklik öncesi hızlı geri dönüş
Aynı VM zincirine bağlı
Uzun süreli yedek değildir

BACKUP
Ayrı recovery kopyası
Dosya veya sistem geri yüklemek için kullanılır
Arıza sonrası kurtarma amacı taşır
```

## RPO ve RTO

RPO:
> En fazla ne kadar veri kaybını kabul edebiliriz?

Örnek: 24 saatte bir backup = teorik olarak 24 saate kadar veri kaybı riski.

RTO:
> Servisi ne kadar sürede geri çalışır hale getirmeliyiz?

Bu labda gerçek süre yerine süreç adımları ve doğrulama kayıt altına alınır.

## Kanıt Checklist

- [ ] Windows Server Backup kuruldu
- [ ] `E:` backup hedefi hazırlandı
- [ ] Sentetik test dosyaları oluşturuldu
- [ ] Backup başarıyla tamamlandı
- [ ] `wbadmin get versions` çıktısı kaydedildi
- [ ] `restore-me.txt` silindi
- [ ] Dosya backup'tan geri getirildi
- [ ] Restore sonrası `Test-Path` başarılı
- [ ] Hyper-V VM export alındı
- [ ] Export klasörü kanıtlandı
- [ ] İzole ortamda import/recovery testi yapıldı
- [ ] GLPI'de backup/restore incident kaydı oluşturuldu

## Mülakat Cümlesi

Lab tamamlandıktan sonra dürüst kullanım:

> Hyper-V tabanlı Windows Server laboratuvarında Windows Server Backup ile dosya yedekleme ve restore senaryoları uyguladım; ayrıca VM export/import üzerinden temel disaster recovery testi gerçekleştirdim.

