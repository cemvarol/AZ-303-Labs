
cd $env:USERPROFILE\downloads


$d2k = Get-ChildItem .\*.vhd

ren $d2k 2012-R2.vhd

mkdir c:\VMs

move 2012-R2.vhd c:\vms

cd c:\vms

$Gurl = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-09/GuestVM.ps1"
$Goutput = ".\GuestVM.ps1"
Invoke-WebRequest -Uri $Gurl -OutFile $Goutput

$GBurl = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-09/GuestBat.bat"
$GBoutput = ".\GuestBat.bat"
Invoke-WebRequest -Uri $GBurl -OutFile $GBoutput

Mount-VHD -Path ".\2012-R2.vhd"

Start-Sleep -s 3

copy .\GuestVM.ps1 f:\windows
copy .\GuestBat.bat "F:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"

Start-Sleep -s 3

Dismount-VHD  -Path ".\2012-R2.vhd"

Start-Sleep -s 3

cd\
 

Start-Sleep -s 3

New-VM -VHDPath .\2012-R2.vhd -Confirm -Generation 1 -MemoryStartupBytes 4GB -Name 2012-R2 -Path c:\VMs\ -Switch VMs -force -AsJob

Start-Sleep -s 3

Set-2012-R2 VApp -count 8

Start-Sleep -s 3

virtmgmt.msc


Start-VM -Name 2012-R2


$ExternalInterface="Ethernet 2"
$InternalInterface="vEthernet (VMs)"

netsh routing ip nat install

netsh routing ip nat set interface $ExternalInterface mode=full
