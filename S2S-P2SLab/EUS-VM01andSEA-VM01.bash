A=$(az ad signed-in-user show --query userPrincipalName)
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -24}
D=$(echo "$C"str01)
E=$(echo "$C"str02)
F=$(echo "$C"eus)
G=$(echo "$C"sea)

az storage account create --name $F --resource-group EUS-Assets --kind Storage --location EastUs --sku Standard_LRS


export SUBNETID1=$(az network vnet subnet show --resource-group EUS-Assets --vnet-name EUS-VNet01A --name EUS-VNet01A-SN01 --query id -o tsv)

az vm create --resource-group EUS-Assets --name EUS-VM01 --location EastUs --image Win2019Datacenter --admin-username cem --admin-password 1q2w3e4r5t6y* --size standard_D4s_v3 --public-ip-address "EUS-VM01-Pip01" --subnet $SUBNETID1 --boot-diagnostics-storage $F --license-type Windows_Server --nsg-rule RDP --no-wait



az storage account create --name $G --resource-group SEA-Assets --kind Storage --location SoutheastAsia --sku Standard_LRS

export SUBNETID2=$(az network vnet subnet show --resource-group SEA-Assets --vnet-name SEA-VNet01A --name SEA-VNet01A-SN01 --query id -o tsv)

az vm create --resource-group SEA-Assets --name SEA-VM01 --location SoutheastAsia --image Win2019Datacenter --admin-username cem --admin-password 1q2w3e4r5t6y* --size standard_D4s_v3 --public-ip-address "SEA-VM01-Pip01" --subnet $SUBNETID2 --boot-diagnostics-storage $G --license-type Windows_Server --nsg-rule RDP











