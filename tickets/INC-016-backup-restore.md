# INC-016 - Paylaşımlı Dosya Silindi / Backup Restore

## Senaryo

Finance departmanındaki kullanıcı ortak paylaşımda bulunan önemli bir dosyanın yanlışlıkla silindiğini bildirir.

Lab dosyası:

```text
C:\BKLAB-Shares\BackupTest\restore-me.txt
```

Gerçek kullanıcı veya şirket verisi kullanılmaz.

## Etki

- Kullanıcı dosyaya erişemiyor.
- Dosyanın yanlışlıkla silindiği düşünülüyor.
- Servisin tamamı çalışıyor; olay tek bir veri nesnesini etkiliyor.

## Kontrol Adımları

1. Dosyanın gerçekten bulunmadığını doğrula.
2. Yanlış klasör/yetki problemi olmadığını kontrol et.
3. Mevcut backup versiyonlarını listele.
4. Uygun recovery point seç.
5. Dosyayı restore et.
6. Kullanıcı erişimini doğrula.

## Komutlar

```powershell
Test-Path C:\BKLAB-Shares\BackupTest\restore-me.txt
wbadmin get versions -backupTarget:E:
```

Restore sonrası:

```powershell
Test-Path C:\BKLAB-Shares\BackupTest\restore-me.txt
Get-FileHash C:\BKLAB-Shares\BackupTest\restore-me.txt
```

## Kök Neden

Kullanıcı hatası / yanlışlıkla silme.

## Çözüm

Windows Server Backup üzerindeki uygun recovery point kullanılarak dosya geri yüklenir.

## Doğrulama

- Dosya tekrar mevcut.
- Dosya açılabiliyor.
- Kullanıcı gerekli SMB/NTFS yetkileri ile dosyaya erişebiliyor.
- Ticket çözüm notu ve kullanılan backup tarihi kaydedildi.

## Öğrenme Noktası

Backup'ın var olması tek başına yeterli değildir. Restore işlemi doğrulanmadıkça kurtarma kabiliyeti kanıtlanmış sayılmaz.
