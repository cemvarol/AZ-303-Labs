cd\
mkdir L9

$url = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-09/Set-Lab.ps1"
$output = "C:\L9\L09.ps"
Invoke-WebRequest -Uri $url -OutFile $output1
