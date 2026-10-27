UPDATE glpi_users SET firstname='Deniz', realname='Yilmaz' WHERE name='Deniz.Yilmaz';
UPDATE glpi_users SET firstname='Ayse', realname='Demir' WHERE name='ayse.demir';
UPDATE glpi_users SET firstname='Mehmet', realname='Kaya' WHERE name='mehmet.kaya';
UPDATE glpi_users SET firstname='Zeynep', realname='Yilmaz' WHERE name='zeynep.yilmaz';
UPDATE glpi_users SET firstname='Elif', realname='Aydin' WHERE name='elif.aydin';

INSERT INTO glpi_itilcategories (entities_id,is_recursive,itilcategories_id,name,completename,comment,level,is_helpdeskvisible,is_incident,is_request,date_creation,date_mod)
SELECT 0,1,0,x.name,x.name,'BK LAB eğitim kategorisi',1,1,1,1,NOW(),NOW()
FROM (
 SELECT 'Hesap ve Erişim' name UNION ALL SELECT 'Donanım' UNION ALL SELECT 'Yazılım' UNION ALL
 SELECT 'Ağ' UNION ALL SELECT 'Yazıcı' UNION ALL SELECT 'Microsoft 365' UNION ALL SELECT 'VPN' UNION ALL
 SELECT 'Güvenlik' UNION ALL SELECT 'Dosya Yetkileri' UNION ALL SELECT 'Yeni Çalışan' UNION ALL SELECT 'Diğer'
) x WHERE NOT EXISTS (SELECT 1 FROM glpi_itilcategories c WHERE c.name=x.name AND c.entities_id=0);

INSERT INTO glpi_slas (name,entities_id,is_recursive,type,comment,number_time,use_ticket_calendar,definition_time,end_of_working_day,date_creation,date_mod)
SELECT x.name,0,1,1,'Sadece eğitim amaçlı SLA - üretim BK LAB SLA değeri değildir',x.minutes,0,CONCAT(x.minutes,' minute'),0,NOW(),NOW()
FROM (
 SELECT 'Critical - 15 min initial response' name,15 minutes UNION ALL
 SELECT 'High - 30 min initial response',30 UNION ALL
 SELECT 'Medium - 2 hour initial response',120 UNION ALL
 SELECT 'Low - 4 hour initial response',240
) x WHERE NOT EXISTS (SELECT 1 FROM glpi_slas s WHERE s.name=x.name AND s.entities_id=0);

INSERT INTO glpi_computers (entities_id,name,serial,otherserial,contact,comment,users_id,date_creation,date_mod,is_recursive)
SELECT 0,x.hostname,x.serial,x.assetid,x.contact,x.notes,COALESCE((SELECT id FROM glpi_users WHERE name=x.username LIMIT 1),0),NOW(),NOW(),1
FROM (
 SELECT 'CLIENT01' hostname,'LAB-LPT-001' serial,'BK-LPT-001' assetid,'Ayse Demir' contact,'HR laptop; DHCP' notes,'ayse.demir' username UNION ALL
 SELECT 'BK-LPT-002','LAB-LPT-002','BK-LPT-002','Mehmet Kaya','Sales laptop; DHCP','mehmet.kaya' UNION ALL
 SELECT 'BK-DESK-001','LAB-DESK-001','BK-DESK-001','Zeynep Yilmaz','Finance desktop; DHCP','zeynep.yilmaz' UNION ALL
 SELECT 'BK-DESK-002','LAB-DESK-002','BK-DESK-002','Elif Aydin','HR desktop; DHCP','elif.aydin'
) x WHERE NOT EXISTS (SELECT 1 FROM glpi_computers c WHERE c.otherserial=x.assetid);

INSERT INTO glpi_tickets (entities_id,name,date,date_mod,status,users_id_lastupdater,users_id_recipient,requesttypes_id,content,urgency,impact,priority,itilcategories_id,type,date_creation)
SELECT 0,x.title,NOW(),NOW(),1,
 (SELECT id FROM glpi_users WHERE name='Deniz.Yilmaz' LIMIT 1),
 (SELECT id FROM glpi_users WHERE name='Deniz.Yilmaz' LIMIT 1),
 1,x.content,x.urgency,x.impact,x.priority,
 (SELECT id FROM glpi_itilcategories WHERE name=x.category AND entities_id=0 LIMIT 1),x.tickettype,NOW()
FROM (
 SELECT 'REQ-001 - Yeni Çalışan Setup' title,'Yeni çalışan kurulumu: AD hesabı, grup üyelikleri, domain bilgisayarı, ortak klasör erişimi, yazıcı erişimi ve geçici şifre.' content,3 urgency,3 impact,3 priority,'Yeni Çalışan' category,2 tickettype UNION ALL
 SELECT 'INC-001 - İnternet Bağlantısı Yok','Ayse Demir internet olmadığını bildiriyor. ipconfig, ping, tracert ve nslookup ile teşhis et.',4,4,4,'Ağ',1 UNION ALL
 SELECT 'INC-002 - DHCP Hatası','CLIENT01 receives a 169.254.x.x address. Diagnose DHCP service, scope and lease path.',4,4,4,'Ağ',1 UNION ALL
 SELECT 'INC-003 - DNS Hatası','IP connectivity works but names do not resolve. Diagnose client DNS and DNS service.',4,4,4,'Ağ',1 UNION ALL
 SELECT 'INC-004 - Hesap Kilitlendi','Ayse Demir account is locked. Diagnose and unlock after verification.',3,3,3,'Hesap ve Erişim',1
) x WHERE NOT EXISTS (SELECT 1 FROM glpi_tickets t WHERE t.name=x.title AND t.entities_id=0);

INSERT INTO glpi_tickets_users (tickets_id,users_id,type,use_notification)
SELECT t.id,u.id,1,0 FROM glpi_tickets t JOIN glpi_users u ON u.name='ayse.demir'
WHERE t.name IN ('REQ-001 - Yeni Çalışan Setup','INC-001 - İnternet Bağlantısı Yok','INC-002 - DHCP Hatası','INC-003 - DNS Hatası','INC-004 - Hesap Kilitlendi')
AND NOT EXISTS (SELECT 1 FROM glpi_tickets_users tu WHERE tu.tickets_id=t.id AND tu.users_id=u.id AND tu.type=1);

INSERT INTO glpi_tickets_users (tickets_id,users_id,type,use_notification)
SELECT t.id,u.id,2,0 FROM glpi_tickets t JOIN glpi_users u ON u.name='Deniz.Yilmaz'
WHERE t.name IN ('REQ-001 - Yeni Çalışan Setup','INC-001 - İnternet Bağlantısı Yok','INC-002 - DHCP Hatası','INC-003 - DNS Hatası','INC-004 - Hesap Kilitlendi')
AND NOT EXISTS (SELECT 1 FROM glpi_tickets_users tu WHERE tu.tickets_id=t.id AND tu.users_id=u.id AND tu.type=2);

INSERT INTO glpi_items_tickets (itemtype,items_id,tickets_id)
SELECT 'Computer',c.id,t.id FROM glpi_computers c JOIN glpi_tickets t ON t.name='INC-001 - İnternet Bağlantısı Yok'
WHERE c.otherserial='BK-LPT-001' AND NOT EXISTS (SELECT 1 FROM glpi_items_tickets i WHERE i.itemtype='Computer' AND i.items_id=c.id AND i.tickets_id=t.id);

INSERT INTO glpi_monitors (entities_id,name,serial,otherserial,size,have_hdmi,have_displayport,comment,date_creation,date_mod,is_recursive)
SELECT 0,'BK-MON-001','LAB-MON-001','BK-MON-001',24,1,1,'BK LAB eğitim monitörü',NOW(),NOW(),1
WHERE NOT EXISTS (SELECT 1 FROM glpi_monitors WHERE otherserial='BK-MON-001');

INSERT INTO glpi_printers (entities_id,is_recursive,name,serial,otherserial,have_ethernet,comment,date_creation,date_mod)
SELECT 0,1,'BK-PRN-001','LAB-PRN-001','BK-PRN-001',1,'10.10.10.50 adresinde simüle network printer',NOW(),NOW()
WHERE NOT EXISTS (SELECT 1 FROM glpi_printers WHERE otherserial='BK-PRN-001');

INSERT INTO glpi_tickets (entities_id,name,date,date_mod,status,users_id_lastupdater,users_id_recipient,requesttypes_id,content,urgency,impact,priority,itilcategories_id,type,date_creation)
SELECT 0,x.title,NOW(),NOW(),1,
 (SELECT id FROM glpi_users WHERE name='Deniz.Yilmaz' LIMIT 1),
 (SELECT id FROM glpi_users WHERE name='Deniz.Yilmaz' LIMIT 1),1,x.content,x.urgency,x.impact,x.priority,
 (SELECT id FROM glpi_itilcategories WHERE name=x.category AND entities_id=0 LIMIT 1),x.tickettype,NOW()
FROM (
 SELECT 'INC-005 - Şifre Sıfırlama' title,'Mehmet Kaya şifresini unuttu. Geçici şifre belirle ve ilk girişte değiştirmesini zorunlu yap.' content,3 urgency,3 impact,3 priority,'Hesap ve Erişim' category,1 tickettype UNION ALL
 SELECT 'INC-006 - Paylaşımlı Klasör Erişimi','Mehmet Kaya cannot access the Sales share. Check group membership, SMB and NTFS permissions.',3,3,3,'Dosya Yetkileri',1 UNION ALL
 SELECT 'INC-007 - Güvenlik Yetkisi Olayı','Bir Sales kullanıcısı yetkisiz alana erişebiliyor. Fazla yetkiyi bul ve kaldır.',5,5,5,'Güvenlik',1 UNION ALL
 SELECT 'INC-008 - GPO Uygulanmadı','CLIENT01 şirket politikasını almıyor. gpresult, event, OU ve GPO linkini kontrol et.',3,3,3,'Yazılım',1 UNION ALL
 SELECT 'INC-009 - Yazıcı Problem','Kullanıcı BK-PRN-001 yazıcısını kullanamıyor. Ağ, IP, driver, kuyruk ve Spooler durumunu kontrol et.',3,3,3,'Yazıcı',1 UNION ALL
 SELECT 'INC-010 - Bilgisayar Yavaş','CLIENT01 is slow. Check CPU, RAM, disk, startup apps, free space and events.',3,3,3,'Donanım',1 UNION ALL
 SELECT 'INC-011 - Disk Dolu','CLIENT01 system drive is full. Identify root cause and use approved safe cleanup.',4,4,4,'Donanım',1 UNION ALL
 SELECT 'INC-012 - Windows Update Hatası','Windows Update fails. Check services, policy, disk space and event logs.',3,3,3,'Yazılım',1 UNION ALL
 SELECT 'INC-013 - VPN Erişim Talebi','Grant simulated VPN access through GG_VPN_USERS after approval.',2,2,2,'VPN',2 UNION ALL
 SELECT 'INC-014 - Şüpheli E-posta','Phishing ön incelemesi yap, kullanıcıyı yönlendir ve güvenlik eskalasyonunu simüle et. Zararlı dosya çalıştırma.',4,4,4,'Güvenlik',1 UNION ALL
 SELECT 'INC-015 - Çalışan Ayrılışı','Disable account, remove groups and VPN, review permissions, recover device and update asset.',4,4,4,'Hesap ve Erişim',2
) x WHERE NOT EXISTS (SELECT 1 FROM glpi_tickets t WHERE t.name=x.title AND t.entities_id=0);

INSERT INTO glpi_tickets_users (tickets_id,users_id,type,use_notification)
SELECT t.id,u.id,2,0 FROM glpi_tickets t JOIN glpi_users u ON u.name='Deniz.Yilmaz'
WHERE t.name REGEXP '^INC-0(0[5-9]|1[0-5])'
AND NOT EXISTS (SELECT 1 FROM glpi_tickets_users tu WHERE tu.tickets_id=t.id AND tu.users_id=u.id AND tu.type=2);

INSERT INTO glpi_items_tickets (itemtype,items_id,tickets_id)
SELECT 'Computer',c.id,t.id FROM glpi_computers c JOIN glpi_tickets t ON t.name='INC-010 - Bilgisayar Yavaş'
WHERE c.otherserial='BK-LPT-001' AND NOT EXISTS (SELECT 1 FROM glpi_items_tickets i WHERE i.itemtype='Computer' AND i.items_id=c.id AND i.tickets_id=t.id);

INSERT INTO glpi_items_tickets (itemtype,items_id,tickets_id)
SELECT 'Yazıcı',p.id,t.id FROM glpi_printers p JOIN glpi_tickets t ON t.name='INC-009 - Yazıcı Problem'
WHERE p.otherserial='BK-PRN-001' AND NOT EXISTS (SELECT 1 FROM glpi_items_tickets i WHERE i.itemtype='Yazıcı' AND i.items_id=p.id AND i.tickets_id=t.id);






