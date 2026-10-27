# INC-008 - GPO Uygulanmadı

## Senaryo

CLIENT01 şirket politikasını almıyor veya `S:` sürücüsü görünmüyor.

## Kontrol

- Computer object doğru OU'da mı?
- GPO doğru OU'ya linkli mi?
- User policy mi Computer policy mi bekleniyor?
- `gpresult /r` çıktısında GPO görünüyor mu?

## Komutlar

```powershell
gpupdate /force
gpresult /r
net use
```

