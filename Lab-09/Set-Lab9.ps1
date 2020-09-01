
cd\
mkdir Lab09

$url = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-09/Set-Lab.ps1"
$output = "C:\Lab09\Lab09.ps1"
Invoke-WebRequest -Uri $url -OutFile $output


Start-Process Powershell.exe -Argumentlist "-file C:\Lab09\Lab09.ps1"


