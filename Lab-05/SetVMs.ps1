cd\
mkdir SC

$url1 = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-05/VMSetting.ps1"
$output1 = "C:\SC\VMSetting.ps1"
Invoke-WebRequest -Uri $url1 -OutFile $output1

Start-Sleep -s 3

Start-Process Powershell.exe -Argumentlist "-file $output1"






