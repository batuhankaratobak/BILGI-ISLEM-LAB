# REQ-001 - Yeni Çalışan Kurulumu

## Senaryo

Yeni çalışan için domain hesabı, grup üyeliği, bilgisayar erişimi ve ortak klasör erişimi hazırlanmalıdır.

## Amaç

Onboarding sürecinin düzenli ve tekrar edilebilir şekilde yapılması.

## Adımlar

- ADUC içinde doğru departman OU'sunda kullanıcı oluştur.
- Geçici güçlü şifre ver ve ilk girişte değiştirmesini zorunlu yap.
- Kullanıcıyı `BK-Employees` ve ilgili departman grubuna ekle.
- CLIENT01 üzerinde domain kullanıcı girişi test et.
- `S:` sürücüsü ve departman paylaşımı erişimini doğrula.

## Kanıt

`whoami`, `net use`, `Test-Path` ve AD grup üyeliği çıktıları.

