Set-NetFirewallProfile -Enabled False


$url1 = "https://raw.githubusercontent.com/cemvarol/DC/master/ChromeInstall.ps1"
$output1 = "$env:USERPROFILE\downloads\ChromeInstall.ps1"
Invoke-WebRequest -Uri $url1 -OutFile $output1

$url2 = "https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-04/InstallDC.ps1"
$output2 = "$env:USERPROFILE\pictures\InstallDC.ps1"
Invoke-WebRequest -Uri $url2 -OutFile $output2

$url3 = "https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-04/AD-Users.ps1"
$output3 = "$env:USERPROFILE\desktop\ADusers.ps1"
Invoke-WebRequest -Uri $url3 -OutFile $output3

$url4 = "https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-04/dsa.lnk"
$output4 = "$env:USERPROFILE\desktop\Active Directory Users and Computers.lnk"
Invoke-WebRequest -Uri $url4 -OutFile $output4

Start-Sleep -s 3

Start-Process Powershell.exe -Argumentlist "-file $output1"

Start-Sleep -s 30

Start-Process Powershell.exe -Argumentlist "-file $output2"

