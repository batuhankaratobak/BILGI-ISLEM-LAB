# Domain Join

`CLIENT01`, `bklab.local` domain'ine katılmış Windows 11 istemcisidir.

## Amaç

Domain join sonrası bilgisayar şirket ortamının parçası olur. Domain kullanıcıları ile oturum açılabilir, GPO uygulanabilir ve merkezi kaynaklara erişilebilir.

## Menü

Windows 11 üzerinde kabaca:

```text
Settings > System > About > Domain or workgroup > Join a domain
```

PowerShell alternatifi:

```powershell
Add-Computer -DomainName bklab.local -Restart
```

## Doğrulama

```powershell
whoami
Get-CimInstance Win32_ComputerSystem | Select-Object Name,Domain,PartOfDomain
```

Beklenen:

```text
Domain: bklab.local
PartOfDomain: True
```

