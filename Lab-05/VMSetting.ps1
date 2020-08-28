$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green

Set-Service W32Time -StartupType Automatic
w32tm /config /syncfromflags:manual /manualpeerlist:"time.windows.com"
w32tm /config /reliable:yes
net start w32time

w32tm /resync /nowait

Tzutil /s "GMT Standard Time"

Set-NetFirewallProfile -Enabled False

Start-Sleep -s 3
  
$urlb = "https://github.com/cemvarol/AZ-Migration/blob/master/ChromeSetup.exe?raw=true"
$outputb = "$env:USERPROFILE\downloads\ChromeSetup.exe"
Invoke-WebRequest -Uri $urlb -OutFile $outputb

& "$env:USERPROFILE\downloads\ChromeSetup.exe"



