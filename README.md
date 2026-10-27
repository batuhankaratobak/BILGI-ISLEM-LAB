# BK LAB Kurumsal IT ve Help Desk Laboratuvarı

**BK LAB, kurumsal Bilgi İşlem ve Help Desk süreçlerini kendi öğrenme sürecimde uygulamalı olarak deneyimlemek için oluşturduğum Windows tabanlı bir laboratuvar projesidir.**

Bu projeyi hazırlarken amacım bir konuyu sadece okuyup geçmek değildi. Active Directory, DNS, DHCP, Group Policy, dosya yetkilendirme, help desk ticket süreçleri, envanter yönetimi ve temel PowerShell otomasyonlarını gerçekçi bir şirket senaryosu içinde kurup bozarak, test ederek ve doğrulayarak öğrenmek istedim.

Projeyi tamamladıktan sonra katıldığım teknik mülakatlarda karşıma çıkan soruların önemli bir bölümünün bu lab içinde çalıştığım konularla örtüştüğünü gördüm. Bu da benim için projenin sadece bir portfolyo çalışması değil, pratikte gerçekten karşılığı olan bir hazırlık süreci olduğunu gösterdi.

> **Lab notu:** BK LAB tamamen kurgusal bir organizasyondur. Bu depo gerçek bir şirket altyapısını, müşteri bilgisini veya üretim ortamını temsil etmez.


## Neden Bu Projeyi Yaptım?

Bu projeyi kendi eksiklerimi görmek, öğrendiğim konuları uygulamaya dökmek ve kurumsal Bilgi İşlem süreçlerini daha somut hale getirmek için hazırladım.

Teoride bildiğim konuların gerçek bir ortamda birbirine nasıl bağlandığını görmek istedim: bir kullanıcının domain hesabı nasıl açılır, bilgisayar domain'e nasıl alınır, DNS yanlışsa ne bozulur, DHCP çalışmazsa client ne yaşar, GPO neden uygulanmaz, bir kullanıcı hangi klasöre neden erişebilir veya erişemez, help desk ticket'ı nasıl ele alınır gibi soruları lab içinde tek tek deneyimledim.

Bu süreç bana sadece komut veya menü ezberletmedi. Bir sorunu parçalara ayırmayı, kanıt toplamayı, sonucu doğrulamayı ve yaptığım işi anlaşılır şekilde dokümante etmeyi öğretti.

## Genel Bakış

Bu proje Hyper-V üzerinde kurulmuş küçük bir kurumsal IT ortamını dokümante eder. Windows Server, Windows 11 domain istemcisi, Active Directory, DNS, DHCP, Group Policy, SMB dosya paylaşımı, GLPI help desk, envanter yönetimi, ticket senaryoları ve PowerShell otomasyonu birlikte kullanılmıştır.

Amaç sadece çalışan bir lab göstermek değildir. Aynı zamanda hangi yönetim menüsünün ne işe yaradığını, neden kullanıldığını ve gerçek IT iş akışında hangi probleme karşılık geldiğini anlatmaktır.

## Mimari

- Hyper-V çalışan Windows ana makine
- İç lab ağı: `BKLAB-LAN`
- Lab subnet'i: `10.10.10.0/24`
- `DC01`: Active Directory, DNS, DHCP, Group Policy ve dosya servisleri
- `CLIENT01`: Domain'e katılmış Windows 11 çalışan bilgisayarı
- GLPI: Yerel help desk ve varlık/envanter yönetimi

## Kurulan Servisler

- Active Directory domain'i: `bklab.local`
- Domain isim çözümleme için DNS
- İç lab ağı için DHCP scope
- Client baseline ve sürücü eşleme için Group Policy
- Grup bazlı yetkilendirilmiş SMB paylaşımları
- Sınırlı şifre sıfırlama yetkisi için helpdesk delegation
- GLPI ticket, kategori, SLA, varlık ve çözüm akışı
- Geri dönüş noktaları için Hyper-V checkpoint'leri

## Çalışılan Yönetim Konsolları

| Konsol | Ne için kullanıldı? |
|---|---|
| Hyper-V Manager | VM oluşturma, sanal switch, VM ayarları, checkpoint |
| Server Manager | Server rolleri kurma ve yönetim araçlarını açma |
| Active Directory Users and Computers | Kullanıcı, grup, OU, bilgisayar ve delegation yönetimi |
| Group Policy Management | GPO linkleme, drive mapping ve client ayarları |
| DNS Manager | `bklab.local` DNS zone'u ve isim çözümleme |
| DHCP Manager | DHCP yetkilendirme, scope, option ve lease yönetimi |
| File and Storage Services | SMB paylaşımı ve dosya erişim yönetimi |
| GLPI | Ticket, kullanıcı, kategori, SLA, varlık ve geçmiş yönetimi |
| PowerShell | Tekrarlanabilir kurulum ve doğrulama kanıtı |

## Bu Lab'da Hangi Menü Ne Yaptı?

### Hyper-V Manager

Hyper-V Manager ile izole lab makineleri yönetildi. `DC01` ve `CLIENT01` sanal makine olarak çalıştırıldı. Büyük değişikliklerden önce ve sonra checkpoint alındı, böylece lab bozulursa geri dönülebilir hale geldi.

Yapılanlar:

- `BKLAB-LAN` internal switch oluşturuldu.
- İki VM aynı izole ağa bağlandı.
- Windows Server ve Windows 11 ISO dosyaları VM'lere takıldı.
- VM başlatma, kapatma, bağlanma ve checkpoint işlemleri yapıldı.

### Server Manager

Server Manager, `DC01` üzerinde Windows Server rollerini kurmak ve yönetmek için kullanıldı.

Yapılanlar:

- Active Directory Domain Services kuruldu.
- DNS Server kuruldu.
- DHCP Server kuruldu.
- File Server yönetim araçları kuruldu.
- Tools menüsünden ADUC, DNS, DHCP ve Group Policy konsolları açıldı.

### Active Directory Users and Computers

Active Directory Users and Computers, domain kimlik nesnelerini yönetmek için kullanıldı.

Yapılanlar:

- `BKLAB` OU yapısı oluşturuldu.
- Departman OU'ları oluşturuldu: IT, HR, Finance, Sales.
- Lab kullanıcıları ve grupları oluşturuldu.
- `CLIENT01` doğru Computers OU'suna taşındı.
- `BK-Helpdesk` grubuna şifre sıfırlama yetkisi devredildi.

### Group Policy Management

Group Policy Management, kullanıcı ve bilgisayarlara merkezi ayar uygulamak için kullanıldı.

Yapılanlar:

- `BKLAB - Client Baseline` Computers OU'suna linklendi.
- `BKLAB - User Drive Mapping` Users OU'suna linklendi.
- `S:` sürücüsü `\\DC01\Company` paylaşımına eşlendi.
- `gpupdate /force` ve `gpresult /r` ile doğrulandı.

### DNS Manager

DNS Manager, domain isim çözümlemesini yönetir.

Yapılanlar:

- `bklab.local` DNS zone'u doğrulandı.
- `dc01.bklab.local` kaydının doğru çözüldüğü kontrol edildi.
- `dcdiag /test:DNS /q` ile DNS sağlığı doğrulandı.

### DHCP Manager

DHCP Manager, lab client'larına otomatik IP vermek için kullanıldı.

Yapılanlar:

- `DC01` Active Directory içinde yetkili DHCP sunucusu yapıldı.
- `BKLAB-LAN` scope'u oluşturuldu.
- Client IP aralığı `10.10.10.100-200` olarak ayarlandı.
- DNS option değeri `10.10.10.10` olarak verildi.
- DHCP servisinin çalıştığı doğrulandı.

### File and Storage Services

Dosya servisleri şirket ortak alanını ve departman paylaşımlarını simüle etmek için kullanıldı.

Yapılanlar:

- Ortak `Company` paylaşımı oluşturuldu.
- `S:` sürücüsü GPO ile ortak paylaşıma bağlandı.
- IT, HR, Finance ve Sales paylaşımları oluşturuldu.
- Yetkiler kişilere değil gruplara verildi.
- IT kullanıcısının `\\DC01\IT` erişimi olduğu, `\\DC01\HR` erişiminin reddedildiği doğrulandı.

### GLPI

GLPI, help desk ve varlık yönetim sistemi olarak kullanıldı.

Yapılanlar:

- Lab kullanıcıları, kategoriler, varlıklar, SLA'lar ve ticket'lar oluşturuldu.
- Ticket atama, not yazma, çözüm girme ve kapatma akışı çalışıldı.
- `INC-008 - GPO Uygulanmadı` ticket'ı OU/GPO düzeltmesi sonrası çözüldü.

## Doğrulama Kanıtları

Lab şu kontrollerle doğrulandı:

- `CLIENT01`, `bklab.local` domain'ine başarıyla katıldı.
- Kullanıcı ve bilgisayar GPO'ları `gpresult /r` ile uygulandı.
- `S:` sürücüsü otomatik olarak `\\DC01\Company` paylaşımına bağlandı.
- IT kullanıcısı `\\DC01\IT` paylaşımına erişebildi.
- Aynı IT kullanıcısının `\\DC01\HR` erişimi reddedildi.
- Helpdesk kullanıcısı Domain Admin olmadan şifre sıfırlayabildi.
- DHCP yetkilendirildi ve scope aktif hale geldi.
- DNS testi `dcdiag /test:DNS /q` ile geçti.
- `DC01` ve `CLIENT01` için final Hyper-V checkpoint'leri alındı.

## Help Desk İş Akışı

Kullanıcı bildirimi -> Ticket -> Kategori/öncelik -> Atama -> Teşhis -> Sorun giderme -> Kök neden -> Çözüm -> Doğrulama -> Kapatma.

## IT Destek Senaryoları

`tickets/` klasörü onboarding ve 15 incident egzersizi içerir. Konular: ağ bağlantısı, DHCP, DNS, hesap kilidi, şifre sıfırlama, dosya yetkisi, GPO, yazıcı, performans, disk doluluğu, Windows Update, VPN, phishing ve offboarding.

## Kanıt Ekran Görüntüleri

Kırpılmış ve redakte edilmiş doğrulama görselleri `screenshots/evidence/` klasöründedir. Kanıt setinde Active Directory yapısı, GPO doğrulaması, SMB erişim kontrolü, helpdesk delegation, GLPI ticket çözümü, DHCP/DNS sağlığı, parola politikası ve final Hyper-V checkpoint'leri bulunur.

Görsel indeksi için `screenshots/evidence/README.md` dosyasına bakın.

## Gizlilik ve Yayınlama Notları

Bu depoda gerçek şifre, lisans anahtarı, token, ISO dosyası, VM diskleri veya ilgisiz kişisel bilgi bulunmamalıdır.

Yayınlamadan önce:

- `C:\Users\<name>\...` gibi yerel Windows yolları redakte edilmelidir.
- Görünen şifre, token, anahtar ve lisans bilgileri kapatılmalıdır.
- İlgisiz tarayıcı sekmeleri ve kişisel masaüstü alanları kırpılmalıdır.
- Lab-only isimler ve sentetik kullanıcılar kullanılmalıdır.
- ISO, VM disk ve log dosyaları Git'e eklenmemelidir.


## Eğitimsel Değer

Bu simülatör, 5.000-10.000 çalışan ölçeğinde global bir şirkette karşılaşılabilecek temel IT destek ve sistem yönetimi sorularını anlamak için pratik bir çalışma alanı sağlamıştır. Gerçek şirket adı, müşteri bilgisi veya üretim ortamı paylaşılmadan; kullanıcı yönetimi, erişim yetkileri, DHCP/DNS, Group Policy, dosya paylaşımları, help desk ticket akışı ve doğrulama süreçleri uçtan uca simüle edilmiştir.

Bu çalışma, kurumsal IT destek bakış açısını güçlendirmeyi, sorunları sistematik şekilde analiz etmeyi ve teknik çıktıları profesyonelce dokümante etmeyi hedefler.

## Teknolojiler

Hyper-V, Windows Server 2022 Desktop Experience, Windows 11, AD DS, DNS, DHCP, Group Policy, File Services, GLPI, MySQL, Docker Compose, PowerShell, Git ve GitHub.

## Kazanılan Beceriler

Windows yönetimi, kullanıcı yaşam döngüsü, DNS/DHCP sorun giderme, Group Policy, least privilege yetkilendirme, ITIL tarzı ticket dokümantasyonu, varlık yönetimi, PowerShell otomasyonu ve teknik dokümantasyon.



