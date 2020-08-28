cd\
mkdir SC

$url1 = "https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab03/SetHost.ps1"
$output1 = "C:\SC\1-SetHost.ps1"
Invoke-WebRequest -Uri $url1 -OutFile $output1

