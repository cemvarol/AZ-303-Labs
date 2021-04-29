Set-NetFirewallProfile -Enabled False

Install-WindowsFeature Routing, RSAT-RemoteAccess, Hyper-V-Tools, Hyper-V-PowerShell

Start-Sleep -s 3

New-VMSwitch -SwitchName VMs -SwitchType Internal

Start-Sleep -s 3

Netsh int ip set address "vEthernet (VMs)" static 1.1.1.1 255.0.0.0

Start-Sleep -s 3

Install-WindowsFeature Routing -IncludeManagementTools
Install-RemoteAccess -VpnType Vpn

Start-Sleep -s 3

$ExternalInterface="Ethernet 4"
$InternalInterface="vEthernet (VMs)"

netsh routing ip nat install
netsh routing ip nat add interface $ExternalInterface
netsh routing ip nat set interface $ExternalInterface mode=full
netsh routing ip nat add interface $InternalInterface

Start-Sleep -s 3

Start-Process Powershell.exe -Argumentlist "-file C:\SC\2-VhdsNChrome.ps1"
