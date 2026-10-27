# Hyper-V Kurulumu

Hyper-V, lab makinelerini gerçek bilgisayardan izole şekilde çalıştırmak için kullanılır.

## Menü

```text
Start > Hyper-V Manager
```

Kullanılan alanlar:

- Virtual Switch Manager: `BKLAB-LAN` internal switch'i oluşturur.
- VM Settings: RAM, CPU, disk, ISO ve network adapter ayarlarını yönetir.
- Connect: VM konsoluna bağlanır.
- Checkpoint: geri dönüş noktası oluşturur.

## Lab VM'leri

- `DC01`: Generation 2, 2 vCPU, 4-6 GB RAM, 80 GB VHDX
- `CLIENT01`: Generation 2, 2 vCPU, 4 GB RAM, 64 GB VHDX

Kurulum scriptleri VM varsa üzerine yazmaz; böylece yanlışlıkla mevcut VM'ler silinmez.

