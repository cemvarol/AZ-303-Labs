New-AzureRmResourceGroup -ResourceGroupName EUS-Assets -Location "East Us"

# Create the virtual network resources

$GWsubnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "GatewaySubnet" `
  -AddressPrefix 10.202.0.128/25
$Subnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name "EUS-VNet01A-SN01" `
  -AddressPrefix 10.202.1.0/24


  $EUSVNet01A = New-AzureRmVirtualNetwork `
  -ResourceGroupName "EUS-Assets" `
  -Name "EUS-VNet01A" `
  -Location "East Us" `
  -AddressPrefix 10.202.0.0/16 `
  -Subnet $GWsubnet, $Subnet

  
  
$RG = "EUS-Assets"
$Location = "East Us"
$GWName = "EUSGW-A"
$GWIPName = "EUSGW-APiP"
$GWIPconfName = "EUSGW-Aipconf"
$VNetName = "EUS-VNet01A"


#Store the virtual network object as a variable.
$EUSVNet01A= Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $RG

#Store the gateway subnet as a variable.
$GWsubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $EUSVNet01A 

#Request a public IP address.
$pip = New-AzureRmPublicIpAddress -Name $GWIPName  -ResourceGroupName $RG -Location $Location -AllocationMethod Dynamic

#Create the configuration for your gateway
$ipconf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName -Subnet $GWsubnet -PublicIpAddress $pip

#Create the gateway
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG -Location $Location -IpConfigurations $ipconf -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard 