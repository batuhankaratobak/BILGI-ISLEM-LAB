# Yönetim Menüsü Rehberi

Bu rehber bir ders notu gibi değil, lab sırasında hangi menüyü neden kullandığımı sonradan hatırlamak için yazıldı. Mülakatta veya gerçek iş akışında karşıma çıkabilecek ekranları kendi deneyimim üzerinden anlamlandırmayı hedefledim.

Bu rehber BK LAB lab'ında kullanılan ana konsolları ve her birinin ne işe yaradığını açıklar.

## Hyper-V Manager

Sanal makineleri oluşturmak ve yönetmek için kullanılır.

- Virtual Machines: `DC01` ve `CLIENT01` durumunu gösterir.
- Settings: CPU, RAM, disk, ISO, network adapter, Secure Boot ve TPM ayarları.
- Virtual Switch Manager: `BKLAB-LAN` ağını oluşturur.
- Connect: VM ekranına bağlanır.
- Checkpoints: geri dönüş noktası oluşturur.

## Server Manager

Windows Server rollerini kurmak ve yönetim araçlarını açmak için kullanılır.

- Dashboard: rol ve sağlık özeti
- Local Server: hostname, IP ve sistem ayarları
- Manage > Add Roles and Features: AD DS, DNS, DHCP ve File Server kurulumu
- Tools: ADUC, DNS, DHCP ve Group Policy konsolları

## Active Directory Users and Computers

Domain kimlik nesnelerini yönetir.

- Users: kullanıcı hesapları
- Groups: yetki grupları
- Computers: domain bilgisayarları
- Organizational Units: politika ve delegasyon yapısı
- Delegate Control: Domain Admin vermeden sınırlı yetki

## Group Policy Management

Merkezi kullanıcı ve bilgisayar ayarlarını yönetir.

- Group Policy Objects: GPO'lar
- Linked OUs: GPO kapsamı
- Computer Configuration: bilgisayar ayarları
- User Configuration: kullanıcı ayarları
- Drive Maps: `S:` gibi ağ sürücüleri

## DNS Manager

Domain isim çözümlemesini yönetir.

- Forward Lookup Zones: `bklab.local` gibi zone'lar
- Host records: `dc01.bklab.local` gibi kayıtlar

## DHCP Manager

Client'lara otomatik IP dağıtır.

- Authorized servers: AD tarafından onaylı DHCP sunucuları
- Scopes: IP havuzları
- Scope Options: DNS, domain ve gateway ayarları
- Address Leases: IP alan client'lar

## File and Storage Services

Paylaşımlı klasörleri yönetir.

- SMB permission ağ erişimini kontrol eder.
- NTFS permission disk üzerindeki klasörü kontrol eder.
- Yetkiler gruplara verilmelidir.

## GLPI

Help desk ve varlık yönetimi sağlar.

- Tickets: incident ve request kayıtları
- Assets: cihaz envanteri
- Users: requester ve teknisyenler
- Categories: ticket sınıflandırması
- SLA: hedef süreler
- Historical: ticket geçmişi



