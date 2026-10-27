# File Server

File Server ortak şirket klasörlerini ve departman paylaşımlarını sağlar.

## Menü

DC01 üzerinde:

```text
Server Manager > File and Storage Services > Shares
```

PowerShell de kullanılmıştır; çünkü yetki ve paylaşım çıktıları daha net kanıt verir.

## Paylaşımlar

Root: `C:\Shares`

- `Company`
- `IT`
- `HR`
- `Finance`
- `Sales`

`Company`, GPO ile `S:` sürücüsü olarak map edilir.

Departman paylaşımları grup bazlı korunur:

- `BK-IT` -> `\\DC01\IT`
- `BK-HR` -> `\\DC01\HR`
- `BK-Finance` -> `\\DC01\Finance`
- `BK-Sales` -> `\\DC01\Sales`

## Önemli Mantık

- SMB permission: ağ üzerinden erişimi kontrol eder.
- NTFS permission: disk üzerindeki klasör erişimini kontrol eder.
- İkisinin de izin vermesi gerekir.
- Yetki kişiye değil gruba verilmelidir.

## Doğrulama

```powershell
Test-Path \\DC01\IT
Test-Path \\DC01\HR
```

Beklenen: IT erişimi başarılı, HR erişimi reddedilir.

