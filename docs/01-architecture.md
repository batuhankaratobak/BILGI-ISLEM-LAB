# Mimari

Bu mimariyi kendi öğrenme sürecimde gerçekçi bir şirket altyapısını küçük ölçekte canlandırmak için tasarladım. Amaç, servislerin tek tek değil, birbirine bağlı şekilde nasıl çalıştığını görmekti.

Lab Hyper-V üzerinde izole bir kurumsal ağ olarak tasarlanmıştır.

```text
Windows Host
└─ Hyper-V
   └─ BKLAB-LAN (10.10.10.0/24)
      ├─ DC01 (10.10.10.10): AD DS, DNS, DHCP, GPO, File Server
      └─ CLIENT01 (DHCP): Windows 11 domain istemcisi
```

GLPI, Docker üzerinde yerel help desk sistemi olarak çalışır. Host üzerinden `http://localhost:8080`, client tarafından ise uygun lab host adresi ile erişilir.

## Amaç

Bu mimari, gerçek ev ağına dokunmadan küçük bir şirket altyapısını simüle eder. DHCP internal switch üzerinde kalır; fiziksel ağa bridge edilmez.


